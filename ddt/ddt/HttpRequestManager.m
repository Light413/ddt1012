//
//  HttpRequestManager.m
//  ddt
//
//  Created by wyg on 15/11/4.
//  Copyright © 2015年 Light. All rights reserved.
//

#import "HttpRequestManager.h"
#import <UIKit+AFNetworking.h>

#define DEFAULT_CONCURRENT_OPERATION_COUNT 6
#define DEFAULT_HTTPREQUESR_TIMEOUT 60


@interface HttpRequestManager ()
{
    
    dispatch_group_t taskGroup;//任务组
    dispatch_queue_t taskQueue;//任务队列
    AFHTTPRequestOperationManager *httpRequestManager;//http统一管理对象
    
}
@property(nonatomic) NSOperationQueue *concurrentQueue; //异步执行队列

@end


@implementation HttpRequestManager


-(instancetype)init
{
    if (self == [super init]) {
        taskGroup = dispatch_group_create();
        taskQueue = dispatch_queue_create("com.dyt.httpManager", DISPATCH_QUEUE_SERIAL);
        self.concurrentQueue = [[NSOperationQueue alloc]init];
        self.concurrentQueue.maxConcurrentOperationCount = DEFAULT_CONCURRENT_OPERATION_COUNT;
        
        //设置服务器地址
        [self buildAddress];
    }
    return self;
}


+(instancetype)shareManger
{
    static dispatch_once_t once;
    static HttpRequestManager * _singonManager = nil;
    dispatch_once(&once, ^{
        _singonManager = [[HttpRequestManager alloc]init];
        [[AFNetworkActivityIndicatorManager sharedManager]setEnabled:YES];
    });
    
    return _singonManager;
}

//操作初始化
-(void)buildAddress
{
    NSString *_basestr = NSLocalizedString(@"base_url", @"");
    NSURL *_baseurl = [NSURL URLWithString:_basestr];
    httpRequestManager = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:_baseurl];
    
    AFHTTPRequestSerializer * requestSerializer = [AFHTTPRequestSerializer serializer];
    [requestSerializer setValue:@"dyt" forHTTPHeaderField:@"Phone-Type"];
    requestSerializer.networkServiceType = NSURLNetworkServiceTypeBackground;
    requestSerializer.timeoutInterval = DEFAULT_HTTPREQUESR_TIMEOUT;
    
    httpRequestManager.requestSerializer = requestSerializer;
    httpRequestManager.operationQueue = self.concurrentQueue;
    
    //数据响应格式
    [httpRequestManager setResponseSerializer:[AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingMutableContainers]];
}


#pragma mark -- post op
//post请求操作实例方法
-(AFHTTPRequestOperation *)requestPostOperationWithTas:(RequestTaskHandle *)task
{
    if (!task ) {
        return nil;
    }
    
    NSLog(@"---url : %@",task.requestUrl);
    
    AFHTTPRequestOperation * _op = [httpRequestManager POST:task.requestUrl parameters:task.disParm success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [[AFNetworkActivityIndicatorManager sharedManager]decrementActivityCount];
            if (task && task.responseSuccessblock) {
                task.responseSuccessblock(operation,responseObject);
            }
        });
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error post requset : %@",[error localizedDescription]);
        dispatch_async(dispatch_get_main_queue(), ^{
            [[AFNetworkActivityIndicatorManager sharedManager]decrementActivityCount];
            if (task && task.responseFaileBlock) {
                task.responseFaileBlock(operation,error);
            }
        });
    }];
    
    _op.completionGroup = taskGroup;
    _op.completionQueue = taskQueue;
    return _op;
}

//post请求操作类方法
+(AFHTTPRequestOperation*)doPostOperationWithTask:(RequestTaskHandle*)task
{
//    if (![AFNetworkReachabilityManager sharedManager].isReachable) {
//        [SVProgressHUD showInfoWithStatus:@"无法连接网络,请检查系统设置"];
////        return nil;
//    }
   return [[HttpRequestManager shareManger] requestPostOperationWithTas:task];
}


//post 请求+上传文件
-(AFHTTPRequestOperation*)requestPostOperationWithTask:(RequestTaskHandle*)task constructingBodyWithBlock:(void(^)(id<AFMultipartFormData>))formData
{
    if (!task ) {
        return nil;
    }
    
    NSLog(@"---url : %@",task.requestUrl);
    
    AFHTTPRequestOperation *_op = [httpRequestManager POST:task.requestUrl parameters:task.disParm constructingBodyWithBlock:formData success:^(AFHTTPRequestOperation *operation, id responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[AFNetworkActivityIndicatorManager sharedManager]decrementActivityCount];
            if (task && task.responseSuccessblock) {
                task.responseSuccessblock(operation,responseObject);
            }
        });
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error post requset : %@",[error localizedDescription]);
        dispatch_async(dispatch_get_main_queue(), ^{
            [[AFNetworkActivityIndicatorManager sharedManager]decrementActivityCount];
            if (task && task.responseFaileBlock) {
                task.responseFaileBlock(operation,error);
            }
        });
    }];
    
    _op.completionGroup = taskGroup;
    _op.completionQueue = taskQueue;
    return _op;
}

+(AFHTTPRequestOperation*)doPostOperationWithTask:(RequestTaskHandle*)task constructingBodyWithBlock:(void(^)(id<AFMultipartFormData>))formData
{
    return [[HttpRequestManager shareManger]requestPostOperationWithTask:task constructingBodyWithBlock:formData];
}


@end







