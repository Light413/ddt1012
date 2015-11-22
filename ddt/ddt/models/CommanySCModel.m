//
//  CommanySCModel.m
//  ddt
//
//  Created by Jia on 15/11/21.
//  Copyright © 2015年 Light. All rights reserved.
//
#import "CommanySCModel.h"

@implementation CommanySCModel
@synthesize commany;
@synthesize quyu;
@synthesize content;
@synthesize lxdh;
@synthesize address;
@synthesize yewu;
@synthesize word;
@synthesize fromu;
@synthesize lxr;
- (CommanySCModel *)initWithDictionary:(NSDictionary *)dic{
    if (self = [super init]) {
        commany = [dic objectForKey:@"company"];
        quyu = [dic objectForKey:@"quyu"];
        content = [dic objectForKey:@"content"];
        lxdh = [dic objectForKey:@"lxdh"];
        address = [dic objectForKey:@"lxdh"];
        yewu = [dic objectForKey:@"yewu"];
        word = [dic objectForKey:@"word"];
        fromu = [dic objectForKey:@"fromu"];
        lxr = [dic objectForKey:@"lxr"];
    }
    return self;
}
@end
