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
@property(nonatomic,copy)NSString *content;
@property(nonatomic,copy)NSString *fee;
@property(nonatomic,copy)NSString *isbook;
@property(nonatomic,copy)NSString *mobile;
@property(nonatomic,copy)NSString *pic;
@property(nonatomic,copy)NSString *quyu;//区域
@property(nonatomic,copy)NSString *say;
@property(nonatomic,copy)NSString *see;
@property(nonatomic,copy)NSString *uid;
@property(nonatomic,copy)NSString *word;
@property(nonatomic,copy)NSString *xb;
@property(nonatomic,copy)NSString *xm;
@property(nonatomic,copy)NSString *yewu;//


//@property(nonatomic,copy)NSString *;
//@property(nonatomic,copy)NSString *;
//@property(nonatomic,copy)NSString *;
- (TonghangSCModel *)initWithDictionary:(NSDictionary *)dic;

@end
