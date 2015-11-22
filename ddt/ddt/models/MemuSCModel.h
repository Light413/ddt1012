//
//  MemuSCModel.h
//  ddt
//
//  Created by Jia on 15/11/21.
//  Copyright © 2015年 Light. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MemuSCModel : NSObject
@property(nonatomic,copy)NSString *persionId;//
@property(nonatomic,copy)NSString *cs_ch;
@property(nonatomic,copy)NSString *cs_type;
@property(nonatomic,copy)NSString *cs_xb;
@property(nonatomic,copy)NSString *cs_age;
@property(nonatomic,copy)NSString *cs_dkje;
@property(nonatomic,copy)NSString *cs_dkqx;
@property(nonatomic,copy)NSString *yw_type;
@property(nonatomic,copy)NSString *yw_quye;
@property(nonatomic,copy)NSString *zxqk;
@property(nonatomic,copy)NSString *jifen;
@property(nonatomic,copy)NSString *bz;
- (MemuSCModel *)initWithDictionary:(NSDictionary *)dic;
@end
