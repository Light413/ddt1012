//
//  DDT_SYS_CONSTIST.h
//  ddt
//
//  Created by gener on 15/7/5.
//  Copyright (c) 2015年 Light. All rights reserved.
//

#ifndef ddt_DDT_SYS_CONSTIST_h
#define ddt_DDT_SYS_CONSTIST_h

#define CurrentDeviceIsIpadOrIphone [UIDevice currentDevice].userInterfaceIdiom

#define CurrentScreenFrame [UIScreen mainScreen].bounds
#define CurrentScreenWidth [[UIScreen mainScreen] bounds].size.width
#define CurrentScreenHeight [[UIScreen mainScreen] bounds].size.height

//当前的系统版本号
#define CurrentIOSVersion [[[UIDevice currentDevice] systemVersion] floatValue]

//系统级别为ios8
#define IOS8LEVEL CurrentIOSVersion >= 8.0f
//系统级别为ios7
#define IOS7LEVEL ((CurrentIOSVersion >= 7.0f) && !IOS8LEVEL)

#define IOS7LATER CurrentIOSVersion >= 7.0f

//bar默认颜色
#define BarDefaultColor [UIColor colorWithRed:0.278 green:0.545 blue:0.788 alpha:1]
#define btnDefaultColor  [UIColor colorWithRed:0.169 green:0.373 blue:0.549 alpha:1]


#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]


//当前定位城市名称
#define CURRENT_LOCATION_CITY   @"CURRENT_LOCATION_CITY"//定位当前城市名
#define CURRENT_LOCATION_LOG    @"CURRENT_LOCATION_LOG"//定位当前经度
#define CURRENT_LOCATION_LAT    @"CURRENT_LOCATION_LAT"//定位当前纬度

#define umengkey  @"563c50f8e0f55a9272003d67"

//通知
#define QIAN_DAO_SUCCESS_NOTI   @"QIAN_DAO_SUCCESS_NOTI"//签到成功通知

//签到积分
#define QIAN_DAO_JIFEN_KEY  @"QIAN_DAO_JIFEN_KEY"


#endif
