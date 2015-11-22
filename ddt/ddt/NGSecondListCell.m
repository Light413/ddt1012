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
    self.img_avatar.image = [UIImage imageNamed:@"cell_avatar_default"];
    
    self.lab_name.text = [dic objectForKey:@"xm"];
    self.lab_phone.text = [dic objectForKey:@"mobile"];
    self.lab_type.text = [dic objectForKey:@"yewu"];
    self.lab_detail.text = [dic objectForKey:@"word"];
    
    if (index ==1) {
        self.btn_fujin.hidden = YES;
    }
    else if (index == 3)
    {
        self.btn_fujin.hidden = NO;
    }
    
    UIButton * love = (UIButton *)[self viewWithTag:301];
    love.selected = [[dic objectForKey:@"isbook"]boolValue];
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
