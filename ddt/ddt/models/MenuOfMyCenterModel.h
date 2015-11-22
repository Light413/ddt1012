//
//  MenuOfMyCenterModel.h
//  ddt
//
//  Created by Jia on 15/11/22.
//  Copyright © 2015年 Light. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MenuOfMyCenterModel : NSObject
@property(nonatomic,copy)NSString *cs_ch;
@property(nonatomic,copy)NSString *cs_type;
@property(nonatomic,copy)NSString *cs_xb;
@property(nonatomic,copy)NSString *cs_age;
@property(nonatomic,copy)NSString *cs_dkje;
@property(nonatomic,copy)NSString *cs_dkqx;//
@property(nonatomic,copy)NSString *yw_type;
@property(nonatomic,copy)NSString *yw_quyu;
@property(nonatomic,copy)NSString *zxqk;
@property(nonatomic,copy)NSString *jifen;
@property(nonatomic,copy)NSString *bz;
@property(nonatomic,copy)NSString *frompf;//信誉评分
@property(nonatomic,copy)NSString *see;//browse count
@property(nonatomic,copy)NSString *tjsj;//time
@property(nonatomic,copy)NSString *fmobile;//mobile
- (MenuOfMyCenterModel *)initWithDictionary:(NSDictionary *)dic;
@end
