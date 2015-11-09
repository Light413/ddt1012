//
//  NGSecondListCell.m
//  ddt
//
//  Created by gener on 15/10/20.
//  Copyright © 2015年 Light. All rights reserved.
//

#import "NGSecondListCell.h"

@implementation NGSecondListCell

- (void)awakeFromNib {
    // Initialization code
    self.lab_phone.textColor = [UIColor colorWithRed:0.906 green:0.824 blue:0.404 alpha:1];
}


-(void)setCellWith:(NSDictionary*)dic withOptionIndex:(NSInteger)index
{
    self.img_avatar.image = [UIImage imageNamed:[dic objectForKey:@"1"]];
    self.lab_name.text = [dic objectForKey:@"2"];
    self.lab_phone.text = [dic objectForKey:@"3"];
    self.lab_type.text = [dic objectForKey:@"4"];
    self.lab_detail.text = [dic objectForKey:@"5"];
    
    if (index ==1) {
        self.btn_fujin.hidden = YES;
    }
    else if (index == 3)
    {
        self.btn_fujin.hidden = NO;
    }
}



- (IBAction)cellBtnAction:(UIButton *)sender {
    if (sender.tag == 301) {
        sender.selected = !sender.selected;
    }
    
    _btnClickBlock(sender.tag);
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
