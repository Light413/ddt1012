//
//  MenuOfMyCenterModel.m
//  ddt
//
//  Created by allen on 15/11/22.
//  Copyright © 2015年 Light. All rights reserved.
//

#import "MenuOfMyCenterModel.h"

@implementation MenuOfMyCenterModel
@synthesize cs_ch;
@synthesize cs_type;
@synthesize cs_xb;
@synthesize cs_age;
@synthesize cs_dkje;
@synthesize cs_dkqx;//
@synthesize yw_type;
@synthesize yw_quyu;
@synthesize zxqk;
@synthesize jifen;
@synthesize bz;
@synthesize frompf;//信誉评分
@synthesize see;//browse count
@synthesize tjsj;//time
@synthesize fmobile;//mobile

- (MenuOfMyCenterModel *)initWithDictionary:(NSDictionary *)dic{
    if (self = [super init]) {
        cs_ch = [dic objectForKey:@"cs_ch"];
        NSString *type = [NSString stringWithFormat:@"%@",[dic objectForKey:@"cs_type"]];
        if ([type isEqual:@"1"]) {
            cs_type = @"上班";
        }else if ([type isEqual:@"2"]){
            cs_type = @"个体";
        }else if ([type isEqual:@"3"]){
            cs_type = @"企业";
        }
        cs_xb = [dic objectForKey:@"cs_xb"];
        cs_age = [dic objectForKey:@"cs_age"];
        cs_dkje = [dic objectForKey:@"cs_dkje"];
        cs_dkqx = [dic objectForKey:@"cs_dkqx"];
        yw_quyu = [dic objectForKey:@"yw_quyu"];
        yw_type = [dic objectForKey:@"yw_type"];
        zxqk = [NSString stringWithFormat:@"%@",[dic objectForKey:@"zxqk"]];
        if ([zxqk isEqual:@"1"]) {
            zxqk = @"正常";
        }else{
            zxqk = @"白户";//有待确认修改
        }
        jifen =[NSString stringWithFormat:@"%@",[dic objectForKey:@"jifen"]];
        bz = [dic objectForKey:@"bz"];
        frompf = [NSString stringWithFormat:@"%@",[dic objectForKey:@"frompf"]];
        see = [NSString stringWithFormat:@"%@",[dic objectForKey:@"see"]];
        tjsj = [dic objectForKey:@"tjsj"];
        fmobile = [NSString stringWithFormat:@"%@",[dic objectForKey:@"fmobile"]];
    }
    return self;
}
@end
