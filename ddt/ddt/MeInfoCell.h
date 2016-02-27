//
//  MeInfoCell.h
//  ddt
//
//  Created by wyg on 16/2/27.
//  Copyright © 2016年 Light. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MeInfoCell : UITableViewCell

@property(nonatomic,copy) void(^tapIconBlock)(UIImageView *img);

-(void)setCell:(NSString*)imgurl name:(NSString*)name jifen:(NSString*)jifen liulan :(NSString*)liulan comm :(NSString *)comm;

@end
