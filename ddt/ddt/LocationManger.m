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
        BMKGeoCodeSearch *_searcher;
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
        
        _searcher =[[BMKGeoCodeSearch alloc]init];
        _searcher.delegate = self;
    }
    return self;
}

-(void)startLocation
{
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

bool _b = NO;

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    if (_b == NO) {
        _b =YES;
        
        //发起反向地理编码检索
        CLLocationCoordinate2D pt = (CLLocationCoordinate2D){39.915, 116.404};
        BMKReverseGeoCodeOption *reverseGeoCodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
        reverseGeoCodeSearchOption.reverseGeoPoint = pt;
        BOOL flag = [_searcher reverseGeoCode:reverseGeoCodeSearchOption];
        if(flag)
        {
            NSLog(@"反geo检索发送成功");
        }
        else
        {
            NSLog(@"反geo检索发送失败");
        }
    }

    

  /* __block NSString *cityname;
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
   */ 
}


//接收反向地理编码结果
-(void) onGetReverseGeocodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
    
  if (error == BMK_SEARCH_NO_ERROR) {
     
  }
  else {
      NSLog(@"抱歉，未找到结果");
  }
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    _faillBlock(error);
    [self stopLocation];
}


@end
