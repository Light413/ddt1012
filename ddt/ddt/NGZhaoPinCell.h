//
//  NGZhaoPinCell.h
//  ddt
//
//  Created by wyg on 15/11/26.
//  Copyright © 2015年 Light. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NGZhaoPinCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *zhiweiLab;
@property (weak, nonatomic) IBOutlet UILabel *gongziLab;
@property (weak, nonatomic) IBOutlet UILabel *contentLab;

@property(nonatomic,copy)void(^btnClickBlock)(NSInteger tag);

-(void)setCellWith:(NSDictionary*)dic;

@end
