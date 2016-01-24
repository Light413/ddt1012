//
//  NGItemDetailVC.h
//  ddt
//
//  Created by wyg on 15/10/18.
//  Copyright © 2015年 Light. All rights reserved.
//

#import "NGBaseTableVC.h"

@interface NGItemsDetailVC : NGBaseTableVC

@property(nonatomic,retain)NSDictionary *superdic;//上级传递的参数
@property(nonatomic,copy)NSString *optional_info;//附加信息(可选)

@property(nonatomic,assign)NSInteger vcType;//1：itemdetail 2:person-in 3:gongsi-in

@end
