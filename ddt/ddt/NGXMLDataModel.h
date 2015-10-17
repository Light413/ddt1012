//
//  NGXMLDataModel.h
//  ddt
//
//  Created by wyg on 15/10/17.
//  Copyright © 2015年 Light. All rights reserved.
//

#import "NGXMLBaseModel.h"

@interface NGXMLDataModel : NGXMLBaseModel

@property(nonatomic,copy)NSString *name;//名称
@property(nonatomic,copy)NSString *key;//key 编码
@property(nonatomic,copy)NSString *level;//所属级别
@end

// <City ID="160" CityName="濮阳市" PID="16" ZipCode="457000">濮阳市</City>
@interface NGXMLCityModel : NGXMLBaseModel

@property(nonatomic,copy)NSString *ID;//城市编码
@property(nonatomic,copy)NSString *CityName;//名称
@property(nonatomic,copy)NSString *PID;//所属省份编码
@property(nonatomic,copy)NSString *ZipCode;//邮政编码
@end

// <District ID="1496" DistrictName="光山县" CID="166">光山县</District>
@interface NGXMLAreaModel : NGXMLBaseModel
@property(nonatomic,copy)NSString *ID;//区域编码
@property(nonatomic,copy)NSString *DistrictName;//名称
@property(nonatomic,copy)NSString *CID;//所属城市编码

@end