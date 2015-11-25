//
//  NGJieDanListCell.m
//  ddt
//
//  Created by wyg on 15/11/10.
//  Copyright © 2015年 Light. All rights reserved.
//

#import "NGJieDanListCell.h"
#import <CoreText/CoreText.h>

@implementation NGJieDanListCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)setCellWith:(NSDictionary*)dic
{
    NSString *name = [dic objectForKey:@"cs_ch"]?[dic objectForKey:@"cs_ch"]:@"";
    NSString *task = [NSString stringWithFormat:@"%@ %@ 贷款%@ %@",[dic objectForKey:@"cs_age"]?[dic objectForKey:@"cs_age"]:@"",[dic objectForKey:@"cs_type"]?[dic objectForKey:@"cs_type"]:@"",[dic objectForKey:@"cs_dkqx"]?[dic objectForKey:@"cs_dkqx"]:@"",[dic objectForKey:@"cs_dkje"]?[dic objectForKey:@"cs_dkje"]:@""];
    NSString *detail = [dic objectForKey:@"bz"]?[dic objectForKey:@"bz"]:@"";
    
    NSString *des = [NSString stringWithFormat:@"%@ %@ \n\n%@",name,task,detail];
    
    self.nameLab.text = des;
    self.jifenLab.text = [NSString stringWithFormat:@"需要%@个积分",[dic objectForKey:@"jifen"]?[dic objectForKey:@"jifen"]:@"0"];
    
    NSMutableAttributedString *mutableAttributedString_attrs = [[NSMutableAttributedString alloc] initWithString:self.nameLab.text];
    [mutableAttributedString_attrs beginEditing];

    NSRange rang = NSMakeRange(0, name.length);
    //kCTForegroundColorAttributeName - NSForegroundColorAttributeName
    [mutableAttributedString_attrs addAttribute:(NSString *)NSForegroundColorAttributeName
                                          value:(id)[UIColor blackColor]
                                          range:rang];
    //kCTFontAttributeName - NSFontAttributeName
    [mutableAttributedString_attrs addAttribute:(NSString *)kCTFontAttributeName
                                          value:[UIFont boldSystemFontOfSize:14]
                                          range:rang];
    
    NSRange rang1 = NSMakeRange(rang.location + rang.length+1, task.length);
    [mutableAttributedString_attrs addAttribute:(NSString *)NSForegroundColorAttributeName
                                          value:(id)[UIColor colorWithRed:0.475 green:0.659 blue:0.773 alpha:1]
                                          range:rang1];
    [mutableAttributedString_attrs addAttribute:(NSString *)kCTFontAttributeName
                                          value:[UIFont systemFontOfSize:14]
                                          range:rang1];

    NSRange rang2 = NSMakeRange(rang1.location + rang1.length+3, detail.length);
    [mutableAttributedString_attrs addAttribute:(NSString *)NSForegroundColorAttributeName
                                          value:(id)[UIColor darkGrayColor]
                                          range:rang2];
    [mutableAttributedString_attrs addAttribute:(NSString *)kCTFontAttributeName
                                          value:[UIFont systemFontOfSize:13]
                                          range:rang2];
    [mutableAttributedString_attrs endEditing];
    self.nameLab.attributedText  =[mutableAttributedString_attrs copy];
}


@end
