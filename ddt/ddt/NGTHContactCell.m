//
//  NGTHContactCell.m
//  ddt
//
//  Created by wyg on 15/11/6.
//  Copyright © 2015年 Light. All rights reserved.
//

#import "NGTHContactCell.h"

@implementation NGTHContactCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)setCellWith:(NSDictionary*)dic
{
    self.titlaLab.text = [dic objectForKey:@"1"];
    self.addressLab.text = [dic objectForKey:@"2"];
    self.dateLab.text = [dic objectForKey:@"3"];
}

@end
