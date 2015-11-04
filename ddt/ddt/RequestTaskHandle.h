//
//  RequestTaskHandle.h
//  ddt
//
//  Created by wyg on 15/11/4.
//  Copyright © 2015年 Light. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AFHTTPRequestOperation;

typedef  void(^HttpResponseSuccessBlock)(AFHTTPRequestOperation *operation, id responseObject);

typedef  void(^HttpResponseFaileBlock)(AFHTTPRequestOperation *operation, id responseObject);


@interface RequestTaskHandle : NSObject

@property(nonatomic,copy)NSString * requestUrl;

@property(nonatomic,retain)NSDictionary * disParm;

@property(nonatomic,copy) HttpResponseSuccessBlock responseSuccessblock;

@property(nonatomic,copy) HttpResponseFaileBlock responseFaileBlock;


/**
 *  创建一个请求对象的数据体
 *
 *  @param url            地址
 *  @param parms         参数
 *  @param succeessBlock 成功响应
 *  @param faileBlock    失败响应
 *
 *  @return obj
 */

+(RequestTaskHandle*)taskWithUrl:(NSString *)url parms : (NSDictionary *)parms andSuccess:(HttpResponseSuccessBlock)succeessBlock faileBlock : (HttpResponseFaileBlock)faileBlock;


@end
