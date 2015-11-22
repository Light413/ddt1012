//
//  MyScTableViewCell.m
//  ddt
//
//  Created by allenhzhang on 10/20/15.
//  Copyright (c) 2015 Light. All rights reserved.
//

#import "MyScTableViewCell.h"
#import "CommanySCModel.h"
@implementation MyScTableViewCell
@synthesize commanyNameLabel;
@synthesize yewuLabel;
@synthesize quyuLabel;
- (void)awakeFromNib {
    // Initialization code
}
-(void)showDataFromModel:(CommanySCModel *)model{
    yewuLabel.text = model.yewu;
    quyuLabel.text = model.quyu;
    commanyNameLabel.text = model.commany;
    [commanyNameLabel sizeToFit];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
