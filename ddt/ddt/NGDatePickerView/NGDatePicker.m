//
//  NGDatePicker.m
//  ddt
//
//  Created by huishuyi on 15/10/31.
//  Copyright © 2015年 Light. All rights reserved.
//

#import "NGDatePicker.h"

@implementation NGDatePicker
{
    UIView *_bgView;
    UIView *_maskView;
    UIDatePicker *datePicker;
    UILabel *dateLabel;
}

-(instancetype)initWithDelegate:(id)delegate{
    if (self = [super init]) {
        _Degelate = delegate;
         [self initViews];
    }
    return self;
}
-(void)initViews{
    _maskView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, CurrentScreenWidth, CurrentScreenHeight)];
    _maskView.backgroundColor = [UIColor blackColor];
    _maskView.alpha = .3;
    
    _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CurrentScreenWidth, 280)];
    _bgView.backgroundColor = [UIColor whiteColor];
    _bgView.layer.cornerRadius = 2;
    _bgView.layer.masksToBounds = YES;
    
    UIButton*_btnCancel = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btnCancel addTarget:self action:@selector(btncancel:) forControlEvents:UIControlEventTouchUpInside];
    _btnCancel.frame = CGRectMake(0, 0, 60, 35);
    [_btnCancel setTitle:@"取消" forState:UIControlStateNormal];
    [_btnCancel setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    _btnCancel.titleLabel.font = [UIFont systemFontOfSize:15];
    [_bgView addSubview:_btnCancel];
    UIButton*_btnok = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btnok addTarget:self action:@selector(btnok:) forControlEvents:UIControlEventTouchUpInside];
    _btnok.frame = CGRectMake(CurrentScreenWidth - 60, 0, 60, 35);
    [_btnok setTitle:@"确定" forState:UIControlStateNormal];
    [_btnok setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    _btnok.titleLabel.font = [UIFont systemFontOfSize:15];
    [_bgView addSubview:_btnok];
    datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 35, CurrentScreenWidth, 216)];
    datePicker.datePickerMode = UIDatePickerModeDate;
    datePicker.locale = [[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"];
    [datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
    [_bgView addSubview:datePicker];
}
-(void)btncancel:(UIButton*)btn
{
    [self hideself];
}
-(void)btnok:(UIButton*)btn
{
    if ([_Degelate respondsToSelector:@selector(showBtnDate:)]) {
        [_Degelate performSelector:@selector(showBtnDate:) withObject:dateLabel.text];
    }
    [self hideself];
}
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
-(void)down
{
    CGRect fram = _bgView.frame;
    fram.origin.y = CurrentScreenHeight;
    _bgView.frame = fram;
}
-(void)up
{
    CGRect fram = _bgView.frame;
    fram.origin.y = CurrentScreenHeight - fram.size.height;
    _bgView.frame = fram;
}
-(void)showIn:(id)superView
{
    [self addSubview:_maskView];
    [self addSubview:_bgView];
    
    //    UIWindow *_w = [[UIApplication sharedApplication]keyWindow];
    //    [_w addSubview:_maskView];
    //    [_w addSubview:_bgView];
    
    if ([superView isKindOfClass:[UIViewController class]]) {
        [((UIViewController*)superView).view addSubview:self];
    }
    else if ([superView isKindOfClass:[UIView class]])
    {
        [(UIView*)superView addSubview:self];
    }
    [self down];
    
    [UIView animateWithDuration:0.5 animations:^{
        [self up];
    }];
}
-(void)initView{
    _maskView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, CurrentScreenWidth, CurrentScreenHeight)];
    _maskView.backgroundColor = [UIColor blackColor];
    _maskView.alpha = 0.3;
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(disappear)];
//    [_maskView addGestureRecognizer:tap];
    //_bgView = [[UIView alloc]initWithFrame:CGRectMake((CurrentScreenWidth -CurrentScreenHeight/2)/2, CurrentScreenHeight/4, CurrentScreenHeight/2, CurrentScreenHeight/2)];
    _bgView = [[UIView alloc]initWithFrame:CGRectMake(20, (CurrentScreenHeight-(CurrentScreenWidth-40))/2, CurrentScreenWidth-40, CurrentScreenWidth-40)];
    _bgView.backgroundColor = [UIColor whiteColor];
    //[_maskView addSubview:_bgView];
    
    dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, _bgView.width, 40)];
    dateLabel.textAlignment = NSTextAlignmentLeft;
    dateLabel.font = [UIFont systemFontOfSize:14];
    [_bgView addSubview:dateLabel];
    UIImageView *midline = [[UIImageView alloc]initWithFrame:CGRectMake(0, dateLabel.bottom, _bgView.width, 1)];
    midline.backgroundColor = [UIColor lightGrayColor];
    [_bgView addSubview:midline];
    
    datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, midline.bottom, _bgView.width, _bgView.height-80)];
    datePicker.datePickerMode = UIDatePickerModeDate;
    datePicker.locale = [[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"];
    [datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
    [_bgView addSubview:datePicker];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(0, datePicker.bottom, _bgView.width/2, 40);
    [cancelBtn addTarget:self action:@selector(cancelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    
    UIButton *okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    okBtn.frame = CGRectMake(cancelBtn.right, datePicker.bottom, _bgView.width/2, 40);
    [okBtn addTarget:self action:@selector(okBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [okBtn setTitle:@"确认" forState:UIControlStateNormal];
    [okBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [_bgView addSubview:cancelBtn];
    [_bgView addSubview:okBtn];
    
}
-(void)cancelBtnClick:(UIButton *)btn{
    [_maskView removeFromSuperview];
    [self removeFromSuperview];
}
-(void)okBtnClick:(UIButton *)btn{
    if ([_Degelate respondsToSelector:@selector(showBtnDate:)]) {
        [_Degelate performSelector:@selector(showBtnDate:) withObject:dateLabel.text];
    }
    [_maskView removeFromSuperview];
    [self removeFromSuperview];
}
-(void)disappear{
    [_maskView removeFromSuperview];
    [self removeFromSuperview];
}
-(void)dateChanged:(UIDatePicker *)control{
    NSDate *_date = control.date;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [dateFormatter stringFromDate:_date];
    dateLabel.text = dateString;
}
//-(void)showIn:(id)superView
//{
//    
//    [self addSubview:_bgView];
//    [self addSubview:_maskView];
//    if ([superView isKindOfClass:[UIViewController class]]) {
//        [((UIViewController*)superView).view addSubview:self];
//    }
//    else if ([superView isKindOfClass:[UIView class]])
//    {
//        [(UIView*)superView addSubview:self];
//    }
//}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
