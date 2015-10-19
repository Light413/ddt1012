//
//  LPickerView.h
//  pickerView
//
//  Created by gener on 15/9/28.
//  Copyright © 2015年 Light. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol pickViewDelegate <NSObject>
@required
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;
- ( NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component;

@optional
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component;
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component;

@end

@interface LPickerView : UIView<UIPickerViewDelegate,UIPickerViewDataSource>

//代理
@property(nonatomic,assign)id<pickViewDelegate>delegate;

/**
 *  创建视图
 *
 *  @param delegate 代理参数
 *
 *  @return 视图对象
 */
-(instancetype)initWithDelegate:(id)delegate;

/**
 *  显示视图
 *
 *  @param superView 父视图的View
 */
-(void)showIn:(id)superView;

@end
