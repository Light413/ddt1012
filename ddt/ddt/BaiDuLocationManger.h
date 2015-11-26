//
//  BaiDuLocationManger.h
//  ddt
//
//  Created by gener on 15/11/24.
//  Copyright © 2015年 Light. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BaiduMapAPI_Search/BMKGeocodeSearch.h>

@class CLLocation;

typedef void(^SUCCESSBLOCKB)(CLLocation * location);
typedef void(^FAILLBLOCKB)(NSError *error);

@interface BaiDuLocationManger : NSObject<BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate>

@property(nonatomic,copy)SUCCESSBLOCKB succeessBlock;

@property(nonatomic,copy)FAILLBLOCKB faillBlock;

+(instancetype)share;

//获取位置
-(void)getLocationWithSuccessBlock:(SUCCESSBLOCKB)successBlock andFailBlock:(FAILLBLOCKB)failBlock;

@end
