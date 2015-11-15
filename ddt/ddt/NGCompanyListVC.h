//
//  NGCompanyListVC.h
//  ddt
//
//  Created by wyg on 15/11/10.
//  Copyright © 2015年 Light. All rights reserved.
//

#import "NGBaseVC.h"
//控制器类型Id
//typedef NS_ENUM(NSInteger , NGVCTypeId)
//{
//    NGVCTypeId_0,//NONE,DEFAULT
//    NGVCTypeId_1,
//    NGVCTypeId_2,
//    NGVCTypeId_3,
//    NGVCTypeId_4,
//    NGVCTypeId_5,
//    NGVCTypeId_6
//};

@interface NGCompanyListVC : NGBaseVC

@property(nonatomic,assign)NSInteger vcType;//判断当前VC属于那一个页面 2:表示从搜索进入

@property(nonatomic,copy) NSString * searchKey;//搜索关键字

@property(nonatomic,copy)NSString * selectedArea;//选择的区域，默认为空

@property(nonatomic,copy)NSString * selectedType;//选择的业务类型，默认为空

@end
