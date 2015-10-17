//
//  NGXMLReader.h
//  ddt
//
//  Created by wyg on 15/10/17.
//  Copyright © 2015年 Light. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NGXMLReader : NSObject<NSXMLParserDelegate>

+(instancetype)share;


/**
 *  xml数据解析
 */
+(void)parser;


/**
 *  应用程序每次启动时判断数据是否解析过
 *
 *  @return bool
 */
+(BOOL)hasAlreadyParserSuccess;


/**
 *   获取全部城市数据，每个元素为字典类型－key：为城市ID obj ： 城市名称
 *
 *  @return arr
 */
+(NSArray*)getAllCities;

/**
 *  获取指定城市下的所有区域
 *
 *  @param strid 城市ID,值不能为nill
 *
 *  @return 所有区域数据（每个元素为字典类型－key：ID obj ：名称）
 */
+(NSArray*)getAllAreaWithCityID:(NSString*)strid;


/**
 *  根据城市名称获取城市编码
 *
 *  @param name 城市名称，值不能为nill
 *
 *  @return 城市编码
 */
+(NSString*)getIDWithCityName:(NSString*)name;






@end










