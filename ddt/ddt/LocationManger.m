//
//  LocationManger.m
//  ddt
//
//  Created by gener on 15/10/8.
//  Copyright (c) 2015年 Light. All rights reserved.
//

#import "LocationManger.h"

@implementation LocationManger
{
    CLLocationManager *_manger;
    
}

+(instancetype)shareManger
{
    static dispatch_once_t once;
    static LocationManger *_defaulatM= nil;
    
    dispatch_once(&once, ^{
        _defaulatM = [[LocationManger alloc]init];
    });
    return _defaulatM;
}

-(instancetype)init
{
    if(self == [super init])
    {
        _manger = [[CLLocationManager alloc]init];
    }
    return self;
}

-(void)startLocation
{

    if([CLLocationManager locationServicesEnabled])
    {
//        CLAuthorizationStatus statue = [CLLocationManager authorizationStatus];
//        if (statue == kCLAuthorizationStatusDenied) {
//            [SVProgressHUD showInfoWithStatus:@"请在[设置-隐私-定位服务]中允许访问位置信息"];return;
//        }
        
        _manger.delegate =self;
        _manger.distanceFilter = 10.0;
        _manger.desiredAccuracy =kCLLocationAccuracyBest;
       
        if([_manger respondsToSelector:@selector(requestAlwaysAuthorization)])
        {
            [_manger requestAlwaysAuthorization];
        }
        
        [_manger startUpdatingLocation];
    }
    else
    {
        NSLog(@"请打开定位服务");
    }
}

-(void)stopLocation
{
    [_manger stopUpdatingLocation];
}

-(void)getLocationWithSuccessBlock:(SUCCESSBLOCK)successBlock andFailBlock:(FAILLBLOCK)failBlock
{
    self.succeessBlock = successBlock;
    self.faillBlock = failBlock;
    
    [self startLocation];
}

-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{

}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
   __block NSString *cityname;
    CLGeocoder *geo = [[CLGeocoder alloc]init];
    [geo reverseGeocodeLocation:[locations lastObject] completionHandler:^(NSArray *placemarks, NSError *error) {
        for (CLPlacemark *place in placemarks) {
//            NSLog(@"name,%@",place.name);                       // 位置名
//            NSLog(@"thoroughfare,%@",place.thoroughfare);       // 街道
//            NSLog(@"subThoroughfare,%@",place.subThoroughfare); // 子街道
//            NSLog(@"locality,%@",place.locality);               // 市
//            NSLog(@"subLocality,%@",place.subLocality);         // 区
//            NSLog(@"country,%@",place.country);                 // 国家
            cityname = place.locality;
        }

       _succeessBlock(cityname);
        [self stopLocation];
    }];
    
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    _faillBlock(error);
    [self stopLocation];
}


@end
