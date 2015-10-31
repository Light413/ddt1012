//
//  DTCompanyListCell.m
//  ddt
//
//  Created by wyg on 15/10/24.
//  Copyright © 2015年 Light. All rights reserved.
//

#import "DTCompanyListCell.h"

@implementation DTCompanyListCell

- (void)awakeFromNib {
    // Initialization code
    self.name.font = [UIFont boldSystemFontOfSize:14];
}

-(void)setCellWith:(NSDictionary*)dic
{
    self.name.text = [dic objectForKey:@"1"];
    self.distructionLab.text = [dic objectForKey:@"2"];
    self.detailLab.text = [dic objectForKey:@"3"];
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{

}

- (IBAction)cellBtnAction:(UIButton *)sender {
    if (sender.tag == 302) {
        sender.selected = !sender.selected;
    }
    
    _btnClickBlock(sender.tag);
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
