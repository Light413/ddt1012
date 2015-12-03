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
@synthesize content;
@synthesize fee;
@synthesize isbook;
@synthesize pic;
@synthesize quyu;
@synthesize say;
@synthesize see;
@synthesize uid;
@synthesize word;
@synthesize xb;
@synthesize xm;
@synthesize yewu;
@synthesize mobile;
- (TonghangSCModel *)initWithDictionary:(NSDictionary *)dic{
    if (self = [super init]) {
        commany = [dic objectForKey:@"company"];
        content = [dic objectForKey:@"content"];
        fee = [NSString stringWithFormat:@"%@",[dic objectForKey:@"fee"]];
        isbook = [NSString stringWithFormat:@"%@",[dic objectForKey:@"isbook"]];
        pic = [dic objectForKey:@"pic"];
        quyu = [dic objectForKey:@"quyu"];
        say = [NSString stringWithFormat:@"%@",[dic objectForKey:@"say"]];
        see = [NSString stringWithFormat:@"%@",[dic objectForKey:@"see"]];
        uid = [NSString stringWithFormat:@"%@",[dic objectForKey:@"uid"]];
        word = [dic objectForKey:@"word"];
        xb = [dic objectForKey:@"xb"];
        xm = [dic objectForKey:@"xm"];
        yewu = [dic objectForKey:@"yewu"];
        mobile = [dic objectForKey:@"mobile"];
    }
    
    return self;
}
@end
