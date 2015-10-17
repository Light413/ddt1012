//
//  NGXMLDataModel.m
//  ddt
//
//  Created by wyg on 15/10/17.
//  Copyright © 2015年 Light. All rights reserved.
//

#import "NGXMLDataModel.h"

//创建基础数据表
@implementation NGXMLDataModel

+(NSString *)getTableName
{
    return @"t_basedata";
}

+(NSDictionary *)getTableMapping
{
    return @{@"name":@"name",
             @"key":@"key",
             @"level":@"level"
             };
}

@end


//创建城市数据表
@implementation NGXMLCityModel

+(NSString *)getTableName
{
    return @"t_city";
}

+(NSDictionary *)getTableMapping
{
    return @{@"ID":@"ID",
             @"CityName":@"CityName",
             @"PID":@"PID",
             @"ZipCode":@"ZipCode"
             };
}

@end

//创建区域数据表
@implementation NGXMLAreaModel

+(NSString *)getTableName
{
    return @"t_area";
}

+(NSDictionary *)getTableMapping
{
    return @{@"ID":@"ID",
             @"DistrictName":@"DistrictName",
             @"CID":@"CID"
             };
}

@end

