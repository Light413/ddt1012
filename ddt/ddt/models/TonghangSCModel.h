//
//  TonghangSCModel.h
//  ddt
//
//  Created by allen on 15/12/2.
//  Copyright © 2015年 Light. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TonghangSCModel : NSObject
@property(nonatomic,copy)NSString *commany;//公司名字
@property(nonatomic,copy)NSString *quyu;//业务
@property(nonatomic,copy)NSString *content;
@property(nonatomic,copy)NSString *see;
@property(nonatomic,copy)NSString *address;
@property(nonatomic,copy)NSString *yewu;//
@property(nonatomic,copy)NSString *word;
@property(nonatomic,copy)NSString *fromu;
@property(nonatomic,copy)NSString *lxr;
@property(nonatomic,copy)NSString *xm;
//@property(nonatomic,copy)NSString *;
//@property(nonatomic,copy)NSString *;
//@property(nonatomic,copy)NSString *;
- (TonghangSCModel *)initWithDictionary:(NSDictionary *)dic;

@end
