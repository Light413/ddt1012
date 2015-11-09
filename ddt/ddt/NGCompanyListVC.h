//
//  NGCompanyListVC.h
//  ddt
//
//  Created by wyg on 15/11/10.
//  Copyright © 2015年 Light. All rights reserved.
//

#import "NGBaseVC.h"
//控制器类型Id
typedef NS_ENUM(NSInteger , NGVCTypeId)
{
    NGVCTypeId_0,//NONE,DEFAULT
    NGVCTypeId_1,
    NGVCTypeId_2,
    NGVCTypeId_3,
    NGVCTypeId_4,
    NGVCTypeId_5,
    NGVCTypeId_6
};

@interface NGCompanyListVC : NGBaseVC

@property(nonatomic,assign)NGVCTypeId vcType;//判断当前VC属于那一个页面

@end
