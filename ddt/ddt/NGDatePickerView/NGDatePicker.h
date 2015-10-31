//
//  NGDatePicker.h
//  ddt
//
//  Created by huishuyi on 15/10/31.
//  Copyright © 2015年 Light. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol datePickerDelegate <NSObject>
-(void)showBtnDate:(NSString *)dateString;

@end
@interface NGDatePicker : UIView
@property(nonatomic,weak)id<datePickerDelegate>Degelate;
-(instancetype)initWithDelegate:(id)delegate;
-(void)showIn:(id)superView;
@end
