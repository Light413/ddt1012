//
//  BaiDuLocationManger.m
//  ddt
//
//  Created by gener on 15/11/24.
//  Copyright © 2015年 Light. All rights reserved.
//

#import "BaiDuLocationManger.h"


@implementation BaiDuLocationManger
{
    BMKLocationService * _locationService;
//    BMKGeoCodeSearch *_searcher;
}

-(instancetype)init
{
    if (self == [super init]) {
        _locationService = [[BMKLocationService alloc]init];
        _locationService.delegate = self;
        _locationService.distanceFilter = 10.0;
        _locationService.desiredAccuracy = kCLLocationAccuracyBest;
        
//        _searcher =[[BMKGeoCodeSearch alloc]init];
//        _searcher.delegate = self;
    }
    return self;
}
+(instancetype)share
{
    static dispatch_once_t once;
    static BaiDuLocationManger * _b = nil;
    dispatch_once(&once, ^{
        _b = [[BaiDuLocationManger alloc]init];
    });
    
    return _b;
}


-(void)getLocationWithSuccessBlock:(SUCCESSBLOCKB)successBlock andFailBlock:(FAILLBLOCKB)failBlock
{
    _succeessBlock = successBlock;
    _faillBlock = failBlock;
    
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
      [_locationService startUserLocationService];
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

//delegate
-(void)willStartLocatingUser
{
    NSLog(@"willStartLocatingUser");
}

bool _b = NO;
-(void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    NSLog(@"didUpdateBMKUserLocation");
    
//    _succeessBlock(userLocation.location);
//    [_locationService stopUserLocationService];
    
    if (_b == NO) {
        _b =YES;
        
        //发起反向地理编码检索
        BMKGeoCodeSearch* _searcher =[[BMKGeoCodeSearch alloc]init];
        _searcher.delegate = self;
        
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
}

-(void)didFailToLocateUserWithError:(NSError *)error
{
    NSLog(@"didFailToLocateUserWithError");
    _faillBlock(error);
     [_locationService stopUserLocationService];
}


//接收反向地理编码结果
-(void) onGetReverseGeocodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
    
    if (error == BMK_SEARCH_NO_ERROR) {
        NSLog(@"反向地理编码结果");
    }
    else {
        NSLog(@"抱歉，未找到结果");
    }
}


@end
