//
//  NGJieDanListCell.h
//  ddt
//
//  Created by wyg on 15/11/10.
//  Copyright © 2015年 Light. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NGJieDanListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *workTypeLab;//上班族

@property (weak, nonatomic) IBOutlet UILabel *ageLab;//年龄
@property (weak, nonatomic) IBOutlet UILabel *jineLab;//金额

@property (weak, nonatomic) IBOutlet UILabel *dateLab;//日期


@property (weak, nonatomic) IBOutlet UILabel *detailLab;
@property (weak, nonatomic) IBOutlet UILabel *jifenLab;

@property (weak, nonatomic) IBOutlet UIImageView *icon_statue;//单子状态icon


-(void)setCellWith:(NSDictionary*)dic ;

@end
