//
//  UIButton+setBtnArg.h
//  ddt
//
//  Created by gener on 15/10/20.
//  Copyright © 2015年 Light. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (setBtnArg)

@property(nonatomic,copy)NSString *title;//btn 标题
@property(nonatomic,copy)id ID;//btn ID


-(void)setNormalTitle :(NSString*)title andID :(id)valueID;//设置btn的title和Id

@end
