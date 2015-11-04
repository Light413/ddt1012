//
//  HttpRequestManager.h
//  ddt
//
//  Created by wyg on 15/11/4.
//  Copyright © 2015年 Light. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RequestTaskHandle.h"


@interface HttpRequestManager : NSObject


/**
 *  post请求操作
 *
 *  @param task task
 *
 *  @return op
 */
+(AFHTTPRequestOperation*)doPostOperationWithTask:(RequestTaskHandle*)task;




@end
