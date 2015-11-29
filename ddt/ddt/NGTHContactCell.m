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
    self.titlaLab.font = [UIFont boldSystemFontOfSize:14];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)setCellWith:(NSDictionary*)dic
{
    NSString *title = [dic objectForKey:@"m_title"]?[dic objectForKey:@"m_title"]:@"未指定";
    self.titlaLab.text = [NSString stringWithFormat:@"会议主题:%@",title];
    
    NSString *addr = [dic objectForKey:@"m_address"]?[dic objectForKey:@"m_address"]:@"未指定";
    self.addressLab.text = [NSString stringWithFormat:@"地点:%@",addr];
    
    NSString *date = [dic objectForKey:@"m_time"]?[dic objectForKey:@"m_time"]:@"待定";
    self.dateLab.text = [NSString stringWithFormat:@"日期:%@",date];
}

@end
