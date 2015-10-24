//
//  DTComDataManger.h
//  ddt
//
//  Created by wyg on 15/10/24.
//  Copyright © 2015年 Light. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DTComDataManger : NSObject

//岗位类型
+(NSArray*)getData_gwlx;


//最高学历
+(NSArray*)getData_zgxl;


//工作经验
+(NSArray*)getData_gzjy;


//期望薪资
+(NSArray*)getData_qwxz;


//性别
+(NSArray*)getData_sex;

@end
