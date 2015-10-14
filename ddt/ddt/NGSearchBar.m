//
//  NGSearchBar.m
//  ddt
//
//  Created by gener on 15/10/14.
//  Copyright (c) 2015年 Light. All rights reserved.
//

#import "NGSearchBar.h"

@implementation NGSearchBar
{
    UITextField *_tf;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame]) {
        _tf = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _tf.delegate  =self;
        _tf.clearsOnBeginEditing = YES;
//        _tf.clearButtonMode = UITextFieldViewModeAlways;
        _tf.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _tf.layer.borderWidth = 1;
        _tf.font  =[UIFont systemFontOfSize:13];
        _tf.returnKeyType = UIReturnKeySearch;
        
        UIButton *_btn = [UIButton buttonWithType:UIButtonTypeCustom];
        _btn.frame = CGRectMake(0, 0, 35, 15);
        [_btn setImageEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 10)];
        [_btn setImage:[UIImage imageNamed:@"search_icon"] forState:UIControlStateNormal];
        [_btn addTarget:self action:@selector(searchBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        _tf.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,10, 5)];
        _tf.leftViewMode = UITextFieldViewModeAlways;
        _tf.rightView =_btn ;
        _tf.rightViewMode = UITextFieldViewModeAlways;
        
       [self addSubview:_tf]; 
    }
    return self;
}

//search action
-(void)searchBtnAction:(UIButton*)btn
{
    if ([self.delegate respondsToSelector:@selector(searchBarDidBeginSearch:withStr:)]) {
        [self.delegate performSelector:@selector(searchBarDidBeginSearch:withStr:) withObject:self withObject:self.text];
    }
}

#pragma mark -set/get 方法
-(void)setPlaceholder:(NSString *)placeholder
{
    _tf.placeholder = placeholder;
}

-(NSString *)text
{
    return _tf.text;
}


#pragma mark - textfield delegate
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [textField setText:@""];
    if ([self.delegate respondsToSelector:@selector(searchBarWillBeginSearch:)]) {
        [self.delegate performSelector:@selector(searchBarWillBeginSearch:) withObject:self];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if ([self.delegate respondsToSelector:@selector(searchBarDidBeginSearch:withStr:)]) {
        [self.delegate performSelector:@selector(searchBarDidBeginSearch:withStr:) withObject:self withObject:textField.text];
    }
    return YES;
}

//-(BOOL)textFieldShouldClear:(UITextField *)textField
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/




@end
