//
//  RequestTaskHandle.m
//  ddt
//
//  Created by wyg on 15/11/4.
//  Copyright © 2015年 Light. All rights reserved.
//

#import "RequestTaskHandle.h"

@implementation RequestTaskHandle

+(RequestTaskHandle *)taskWithUrl:(NSString *)url parms:(NSDictionary *)parms andSuccess:(HttpResponseSuccessBlock)succeessBlock faileBlock:(HttpResponseFaileBlock)faileBlock
{
    RequestTaskHandle *_handle = [[RequestTaskHandle alloc]init];
    
    _handle.requestUrl = url;
    _handle.disParm = parms;
    _handle.responseSuccessblock = succeessBlock;
    _handle.responseFaileBlock = faileBlock;
    return _handle;
}


@end
