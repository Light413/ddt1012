//
//  DTComDataManger.m
//  ddt
//
//  Created by wyg on 15/10/24.
//  Copyright © 2015年 Light. All rights reserved.
//

#import "DTComDataManger.h"

static NSString *gwlx = @"gwlx";//岗位类型
static NSString *zgxl = @"zgxl";//最高学历
static NSString *gzjy = @"gzjy";//工作经验
static NSString *qwxz = @"qwxz";//期望薪资
static NSString *sex = @"sex";//性别

@implementation DTComDataManger
{
    NSDictionary *_dic;
}

-(instancetype)init
{
    self = [super init];
    if (self) {
        NSString*path = [[NSBundle mainBundle]pathForResource:@"common_data" ofType:@"plist"];
        _dic = [[NSDictionary alloc]initWithContentsOfFile:path];
    }
    
    return self;
}


+(instancetype)share
{
    static DTComDataManger *_obj = nil;
    static dispatch_once_t once;
    
    dispatch_once(&once, ^{
        _obj = [[DTComDataManger alloc]init];
    });
    
    return _obj;
}


-(NSArray*)getDataWith:(NSString*)key
{
    NSArray *_arr = nil;
    _arr = [_dic objectForKey:key];
    return _arr;
}


+(NSArray*)getData_gwlx
{
    return [[self share]getDataWith:gwlx];
}

+(NSArray*)getData_zgxl
{
    return [[self share]getDataWith:zgxl];
}
+(NSArray*)getData_gzjy
{
    return [[self share]getDataWith:gzjy];
}
+(NSArray*)getData_qwxz
{
    return [[self share]getDataWith:qwxz];
}

+(NSArray*)getData_sex
{
    return [[self share]getDataWith:sex];
}

@end



