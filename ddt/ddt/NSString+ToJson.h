//
//  NSString+ToJson.h
//  ddt
//
//  Created by gener on 15/11/5.
//  Copyright © 2015年 Light. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (ToJson)

/**
 *  转换成json字符串
 *
 *  @param dic 字典参数
 *
 *  @return json字符串
 */
+(NSString*)jsonStringFromDictionary:(NSDictionary *)dic;

@end
