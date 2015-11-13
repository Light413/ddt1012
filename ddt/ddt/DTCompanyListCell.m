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
    self.name.font = [UIFont systemFontOfSize:14];
    self.distructionLab.font = [UIFont systemFontOfSize:13];
    self.detailLab.font = [UIFont systemFontOfSize:13];
}

-(void)setCellWith:(NSDictionary*)dic
{
    self.name.text = [dic objectForKey:@"company"];
    self.distructionLab.text = [dic objectForKey:@"4"];
    self.detailLab.text = [dic objectForKey:@"word"];
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
