//
//  TonghangSCModel.m
//  ddt
//
//  Created by allen on 15/12/2.
//  Copyright © 2015年 Light. All rights reserved.
//

#import "TonghangSCModel.h"

@implementation TonghangSCModel
@synthesize commany;
@synthesize quyu;
@synthesize content;

@synthesize address;
@synthesize yewu;
@synthesize word;
@synthesize fromu;
@synthesize lxr;
- (TonghangSCModel *)initWithDictionary:(NSDictionary *)dic{
    if (self = [super init]) {
        commany = [dic objectForKey:@"company"];
        quyu = [dic objectForKey:@"quyu"];
        content = [dic objectForKey:@"content"];
        address = [dic objectForKey:@"lxdh"];
        yewu = [dic objectForKey:@"yewu"];
        word = [dic objectForKey:@"word"];
        fromu = [dic objectForKey:@"fromu"];
        lxr = [dic objectForKey:@"lxr"];
    }
    return self;
}
@end
