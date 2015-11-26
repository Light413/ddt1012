//
//  BaiDuLocationManger.h
//  ddt
//
//  Created by gener on 15/11/24.
//  Copyright © 2015年 Light. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CLLocation;

typedef void(^SUCCESSBLOCK)(CLLocation * location);
typedef void(^FAILLBLOCK)(NSError *error);

@interface BaiDuLocationManger : NSObject<BMKLocationServiceDelegate>

@property(nonatomic,copy)SUCCESSBLOCK succeessBlock;

@property(nonatomic,copy)FAILLBLOCK faillBlock;

+(instancetype)share;

//获取位置
-(void)getLocationWithSuccessBlock:(SUCCESSBLOCK)successBlock andFailBlock:(FAILLBLOCK)failBlock;

@end
