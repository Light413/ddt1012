//
//  LPickerView.m
//  pickerView
//
//  Created by gener on 15/9/28.
//  Copyright © 2015年 Light. All rights reserved.
//

#import "LPickerView.h"
#define ScreenWidth [[UIScreen mainScreen]bounds].size.width
#define ScreenHeight [[UIScreen mainScreen]bounds].size.height

@implementation LPickerView
{
    UIView *_bgView;
    UIView *_maskView;
    
    UIPickerView *_pickView;
    NSInteger _selectRow;
    NSInteger _selectCompent;
}

-(instancetype)initWithDelegate:(id)delegate
{
   if (self == [super init])
   {
       self.frame = [[UIScreen mainScreen]bounds];
       _selectCompent = 0;
       _selectRow =0;
       _delegate = delegate;
       [self initBgView];
   }
    return self;
}

-(void)initBgView
{
    _maskView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    _maskView.backgroundColor = [UIColor blackColor];
    _maskView.alpha = .3;
//    _maskView.userInteractionEnabled  =NO;
    
    _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 240)];
    _bgView.backgroundColor = [UIColor whiteColor];
    _bgView.layer.cornerRadius = 2;
    _bgView.layer.masksToBounds = YES;
    
    UIButton*_btnCancel = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btnCancel addTarget:self action:@selector(btncancel:) forControlEvents:UIControlEventTouchUpInside];
    _btnCancel.frame = CGRectMake(0, 0, 60, 35);
    [_btnCancel setTitle:@"取消" forState:UIControlStateNormal];
    [_btnCancel setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    _btnCancel.titleLabel.font = [UIFont systemFontOfSize:18];
    [_bgView addSubview:_btnCancel];
    UIButton*_btnok = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btnok addTarget:self action:@selector(btnok:) forControlEvents:UIControlEventTouchUpInside];
    _btnok.frame = CGRectMake(ScreenWidth - 60, 0, 60, 35);
    [_btnok setTitle:@"确定" forState:UIControlStateNormal];
    [_btnok setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    _btnok.titleLabel.font = [UIFont systemFontOfSize:18];
    [_bgView addSubview:_btnok];
    
    _pickView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 35, ScreenWidth, 216)];
    _pickView.delegate =self;
    _pickView.dataSource = self;
    [_bgView addSubview:_pickView];
    [_pickView reloadAllComponents];
}

/**
 *  btn action
 *
 *  @param btn <#btn description#>
 */
-(void)btncancel:(UIButton*)btn
{
    if ([self.delegate respondsToSelector:@selector(pickerViewCanecelClick)]) {
        [self.delegate pickerViewCanecelClick];
    }
    [self hideself];
}
-(void)btnok:(UIButton*)btn
{
    [_delegate pickerView:_pickView didSelectRow:_selectRow inComponent:_selectCompent];
    [self hideself];
}

/**
 *  上下平移操作
 */
-(void)down
{
    CGRect fram = _bgView.frame;
    fram.origin.y = ScreenHeight;
    _bgView.frame = fram;
}
-(void)up
{
    CGRect fram = _bgView.frame;
    fram.origin.y = ScreenHeight - fram.size.height;
    _bgView.frame = fram;
}

/**
 *  视图显示和消退
 */
-(void)hideself
{
    [UIView animateWithDuration:.5 animations:^{
         _maskView.alpha = 0;
        [self down];
    } completion:^(BOOL finished) {
//        [_maskView removeFromSuperview];
//        [_bgView removeFromSuperview];
        [self removeFromSuperview];
    }];
}

-(void)showIn:(id)superView
{
//    [self addSubview:_maskView];
//    [self addSubview:_bgView];

    UIWindow *_w = [[UIApplication sharedApplication]keyWindow];
    [_w addSubview:_maskView];
    [_w addSubview:_bgView];
        [self down];
    if ([superView isKindOfClass:[UIViewController class]]) {
        [((UIViewController*)superView).view addSubview:self];
    }
    else if ([superView isKindOfClass:[UIView class]])
    {
        [(UIView*)superView addSubview:self];
    }

    
    [UIView animateWithDuration:0.5 animations:^{
        [self up];
    }];
}

#pragma mark -pickerview delegate
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if ([_delegate respondsToSelector:@selector(numberOfComponentsInPickerView:)]) {
       return [_delegate numberOfComponentsInPickerView:pickerView];
    }
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [_delegate pickerView:pickerView numberOfRowsInComponent:component];
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [_delegate pickerView:pickerView titleForRow:row forComponent:component];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    _selectCompent = component;
    _selectRow = row;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 44;
}

//-(NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
//{
//    
////    NSAttributedString *_s= [[NSAttributedString alloc]initWithString:<#(nonnull NSString *)#> attributes:<#(nullable NSDictionary<NSString *,id> *)#>];
//}
@end

