//
//  TonghangTableViewCell.m
//  ddt
//
//  Created by allen on 15/10/21.
//  Copyright © 2015年 Light. All rights reserved.
//

#import "TonghangTableViewCell.h"

@implementation TonghangTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.userIconBtn.layer.masksToBounds = YES;
    self.userIconBtn.layer.cornerRadius = 30;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)showDataFromModel:(TonghangSCModel *)model{
    [self.userIconBtn setBackgroundImageForState:UIControlStateNormal withURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.123dyt.com/mydyt/upload/pic%@",model.pic]] placeholderImage:[UIImage imageNamed:@"head_noregist"]];
    self.userNameLabel.text = model.xm;
    self.titleLabel.text = model.yewu;
    self.commanyNameLabel.text = model.commany;
    self.phoneNumberLabel.text = model.mobile;
}
- (IBAction)messageBtnClick:(id)sender {
    //UIButton *btn = (UIButton *)sender;
    self.btnmessageClickBlock();
}
- (IBAction)phoneCallClick:(id)sender {
   // UIButton *btn = (UIButton *)sender;
    self.btnClickBlock();
}
@end
