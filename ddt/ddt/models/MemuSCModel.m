//
//  MemuSCModel.m
//  ddt
//
//  Created by Jia on 15/11/21.
//  Copyright © 2015年 Light. All rights reserved.
//
#import "MemuSCModel.h"

@implementation MemuSCModel
@synthesize persionId;
@synthesize cs_age;
@synthesize cs_ch;
@synthesize cs_dkje;
@synthesize cs_dkqx;
@synthesize cs_type;
@synthesize cs_xb;
@synthesize yw_quye;
@synthesize yw_type;
@synthesize zxqk;
@synthesize jifen;
@synthesize bz;

- (MemuSCModel *)initWithDictionary:(NSDictionary *)dic{
    if (self =[super init]) {
        persionId = [NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]];
        cs_age = [NSString stringWithFormat:@"%@",[dic objectForKey:@"cs_age"]];
        cs_ch = [NSString stringWithFormat:@"%@",[dic objectForKey:@"cs_ch"]];
        cs_dkje = [NSString stringWithFormat:@"%@",[dic objectForKey:@"cs_dkje"]];
        cs_dkqx = [NSString stringWithFormat:@"%@",[dic objectForKey:@"cs_dkqx"]];
        cs_type = [NSString stringWithFormat:@"%@",[dic objectForKey:@"cs_type"]];
        cs_xb = [NSString stringWithFormat:@"%@",[dic objectForKey:@"cs_xb"]];
        
        
    }
    return self;
}
@end
