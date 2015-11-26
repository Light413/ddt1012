//
//  LocationManger.h
//  ddt
//
//  Created by gener on 15/10/8.
//  Copyright (c) 2015年 Light. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#import <BaiduMapAPI_Search/BMKGeocodeSearch.h>

typedef void(^SUCCESSBLOCK)(NSString*str);
typedef void(^FAILLBLOCK)(NSError *error);

@interface LocationManger : NSObject<CLLocationManagerDelegate,BMKGeoCodeSearchDelegate>

@property(nonatomic,copy)SUCCESSBLOCK succeessBlock;

@property(nonatomic,copy)FAILLBLOCK faillBlock;

+(instancetype)shareManger;

//获取位置
-(void)getLocationWithSuccessBlock:(SUCCESSBLOCK)successBlock andFailBlock:(FAILLBLOCK)failBlock;

@end
