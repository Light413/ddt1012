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
    BOOL _hasSuccessLocation;//成功定位一次
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
        _hasSuccessLocation = NO;
    }
    return self;
}

-(void)startLocation
{
    _hasSuccessLocation = NO;
    
    UIAlertView *_alertView= nil;
    if([CLLocationManager locationServicesEnabled])
    {
        CLAuthorizationStatus statue = [CLLocationManager authorizationStatus];
        if (statue == kCLAuthorizationStatusDenied) {
            [SVProgressHUD dismiss];
            if (_alertView == nil) {
                _alertView = [[UIAlertView alloc]initWithTitle:nil message:@"" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            }
            _alertView.message =@"请在[设置-隐私-定位服务]中允许访问位置信息";
            [_alertView show];return;
        }
        
        _manger.delegate =self;
        _manger.distanceFilter = 500.0;
        _manger.desiredAccuracy =kCLLocationAccuracyKilometer;
       
        if([_manger respondsToSelector:@selector(requestAlwaysAuthorization)])
        {
            [_manger requestAlwaysAuthorization];
        }
        
        [_manger startUpdatingLocation];
    }
    else
    {
        [SVProgressHUD dismiss];
        if (_alertView == nil) {
            _alertView = [[UIAlertView alloc]initWithTitle:nil message:@"" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        }
        _alertView.message =@"请在[设置-隐私]中打开定位服务";
        [_alertView show];;
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

//bool _b = NO;

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    //保存经纬度信息
    CLLocation * _loc = [locations lastObject];
    double log = _loc.coordinate.longitude;
    double lat = _loc.coordinate.latitude;
    [[NSUserDefaults standardUserDefaults]setObject:@(lat) forKey:CURRENT_LOCATION_LAT];
    [[NSUserDefaults standardUserDefaults]setObject:@(log) forKey:CURRENT_LOCATION_LOG];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    NSLog(@"+++++++jingdu : %f weidu  :%f",log,lat);
    
   __block NSString *cityname;
    CLGeocoder *geo = [[CLGeocoder alloc]init];
    [geo reverseGeocodeLocation:_loc completionHandler:^(NSArray *placemarks, NSError *error) {
        for (CLPlacemark *place in placemarks) {
//            NSLog(@"name,%@",place.name);                       // 位置名
//            NSLog(@"thoroughfare,%@",place.thoroughfare);       // 街道
//            NSLog(@"subThoroughfare,%@",place.subThoroughfare); // 子街道
//            NSLog(@"locality,%@",place.locality);               // 市
//            NSLog(@"subLocality,%@",place.subLocality);         // 区
//            NSLog(@"country,%@",place.country);                 // 国家
            cityname = place.locality;
        }
        if (_hasSuccessLocation == NO) {
            _hasSuccessLocation = YES;
            _succeessBlock(cityname);
            [self stopLocation];
        }
    }];
    
    [self stopLocation];
}


-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [self stopLocation];
    _faillBlock(error);
}


@end
