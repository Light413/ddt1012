//
//  MenuTableViewCell.m
//  ddt
//
//  Created by huishuyi on 15/11/1.
//  Copyright © 2015年 Light. All rights reserved.
//
#import "MenuTableViewCell.h"

@implementation MenuTableViewCell
@synthesize nameLabel;
@synthesize personalLabel;
@synthesize infoLabel;
@synthesize jifenLabel;
-(void)showDataFromModel:(MenuOfMyCenterModel *)model{
    nameLabel.text = model.cs_ch;
    [nameLabel sizeToFit];
    personalLabel.text = [NSString stringWithFormat:@"%@,%@,%@,%@,%@",model.cs_age,model.cs_type,model.yw_type,model.cs_dkqx,model.cs_dkje];
    infoLabel.text = model.bz;
    jifenLabel.text = [NSString stringWithFormat:@"需要%@个积分",model.jifen];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
