//
//  CommanySCModel.h
//  ddt
//
//  Created by Jia on 15/11/21.
//  Copyright © 2015年 Light. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommanySCModel : NSObject
@property(nonatomic,copy)NSString *commany;
@property(nonatomic,copy)NSString *quyu;
@property(nonatomic,copy)NSString *content;
@property(nonatomic,copy)NSString *lxdh;
@property(nonatomic,copy)NSString *address;
@property(nonatomic,copy)NSString *yewu;//
@property(nonatomic,copy)NSString *word;
@property(nonatomic,copy)NSString *fromu;
@property(nonatomic,copy)NSString *lxr;
//@property(nonatomic,copy)NSString *;
//@property(nonatomic,copy)NSString *;
//@property(nonatomic,copy)NSString *;
//@property(nonatomic,copy)NSString *;
- (CommanySCModel *)initWithDictionary:(NSDictionary *)dic;

@end
