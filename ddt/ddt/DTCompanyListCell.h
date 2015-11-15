//
//  DTCompanyListCell.h
//  ddt
//
//  Created by wyg on 15/10/24.
//  Copyright © 2015年 Light. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DTCompanyListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *detailLab;
@property (weak, nonatomic) IBOutlet UILabel *distructionLab;
@property (weak, nonatomic) IBOutlet UIButton *btn_love;//是否收藏

@property(nonatomic,copy)void(^btnClickBlock)(BOOL);


-(void)setCellWith:(NSDictionary*)dic;

@end
