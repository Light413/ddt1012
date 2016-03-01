//
//  NGZhaoPinCell.m
//  ddt
//
//  Created by wyg on 15/11/26.
//  Copyright © 2015年 Light. All rights reserved.
//

#import "NGZhaoPinCell.h"

@implementation NGZhaoPinCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setCellWith:(NSDictionary*)dic
{
    self.nameLab.text = [dic objectForKey:@"work"]?[dic objectForKey:@"work"]:@"";
    self.typeLab.text = [dic objectForKey:@"wtype"]?[dic objectForKey:@"wtype"]:@"";
    self.areaLab.text = [dic objectForKey:@"quyu"]?[dic objectForKey:@"quyu"]:@"";
    self.gsLab.text = [dic objectForKey:@"company"]?[dic objectForKey:@"company"]:@"";
    self.numLab.text = [dic objectForKey:@"num"]?[dic objectForKey:@"num"]:@"";
    self.wageLab.text = [dic objectForKey:@"money"]?[dic objectForKey:@"money"]:@"";
}


- (IBAction)btnAction:(UIButton*)sender {

    _btnClickBlock(sender.tag);
}



@end
