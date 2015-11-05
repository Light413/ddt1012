//
//  NSString+ToJson.m
//  ddt
//
//  Created by gener on 15/11/5.
//  Copyright © 2015年 Light. All rights reserved.
//

#import "NSString+ToJson.h"

@implementation NSString (ToJson)

+(NSString*)jsonStringFromDictionary:(NSDictionary *)dic
{
    if (!dic) {
        return @"no data";
    }
    
    NSArray *_keyarr = [dic allKeys];
    NSMutableString *_string = [[NSMutableString alloc]initWithFormat:@"{"];
    for (int i=0; i < _keyarr.count; i++) {
        NSString *_key = [_keyarr objectAtIndex:i];
        NSString *_str = [NSString stringWithFormat:@"\"%@\":\"%@\"",_key,[dic objectForKey:_key]];
        [_string appendString:_str];
        if ( i < _keyarr.count - 1) {
            [_string appendString:@","];
        }
    }
    [_string appendString:@"}"];
    
    return _string;
}


@end
