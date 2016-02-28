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
//    self.jifenLab.textColor = BarDefaultColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)setCellWith:(NSDictionary*)dic
{
    NSString *name = [dic objectForKey:@"cs_ch"]?[dic objectForKey:@"cs_ch"]:@"";
    NSString *detail = [dic objectForKey:@"bz"]?[dic objectForKey:@"bz"]:@"";
    NSString *zt = [dic objectForKey:@"zt"]?[dic objectForKey:@"zt"]:@"";
    
    self.nameLab.text = name;
    self.workTypeLab.text = (
    {
      NSString *_typestr = [dic objectForKey:@"cs_type"]?[dic objectForKey:@"cs_type"]:@"0";
        NSString * _s;
        switch ([_typestr integerValue]) {
            case 1: _s = @"上班族"; break;
            case 2: _s = @"个体"; break;
            case 3: _s = @"企业"; break;
            default: break;
        }
        _s;
    } );
    
    self.ageLab.text = [dic objectForKey:@"cs_age"]?[dic objectForKey:@"cs_age"]:@"";
    self.jineLab.text = [dic objectForKey:@"cs_dkje"]?[dic objectForKey:@"cs_dkje"]:@"";
    self.dateLab.text = [dic objectForKey:@"cs_dkqx"]?[dic objectForKey:@"cs_dkqx"]:@"";
    self.detailLab.text = detail;
    self.jifenLab.text = [NSString stringWithFormat:@"%@积分",[dic objectForKey:@"jifen"]?[dic objectForKey:@"jifen"]:@"0"];
   
    NSString *iconname = @"icon_bill_state0";
    switch ([zt integerValue]) {
        case 0:iconname = @"icon_bill_state0";break;
        case 1:iconname = @"icon_bill_state1";break;
        case 2:iconname = @"icon_bill_state2";break;
        default:
            break;
    }
    
    self.icon_statue.image = [UIImage imageNamed:iconname];
    
//    NSMutableAttributedString *mutableAttributedString_attrs = [[NSMutableAttributedString alloc] initWithString:self.nameLab.text];
//    [mutableAttributedString_attrs beginEditing];
//
//    NSRange rang = NSMakeRange(0, name.length);
//    //kCTForegroundColorAttributeName - NSForegroundColorAttributeName
//    [mutableAttributedString_attrs addAttribute:(NSString *)NSForegroundColorAttributeName
//                                          value:(id)[UIColor blackColor]
//                                          range:rang];
//    //kCTFontAttributeName - NSFontAttributeName
//    [mutableAttributedString_attrs addAttribute:(NSString *)kCTFontAttributeName
//                                          value:[UIFont boldSystemFontOfSize:14]
//                                          range:rang];
//    
//    NSRange rang1 = NSMakeRange(rang.location + rang.length+1, task.length);
//    [mutableAttributedString_attrs addAttribute:(NSString *)NSForegroundColorAttributeName
//                                          value:(id)[UIColor blackColor]
//                                          range:rang1];//colorWithRed:0.475 green:0.659 blue:0.773 alpha:1
//    [mutableAttributedString_attrs addAttribute:(NSString *)kCTFontAttributeName
//                                          value:[UIFont boldSystemFontOfSize:14]
//                                          range:rang1];
//
//    NSRange rang2 = NSMakeRange(rang1.location + rang1.length+2, detail.length);
//    [mutableAttributedString_attrs addAttribute:(NSString *)NSForegroundColorAttributeName
//                                          value:(id)[UIColor darkGrayColor]
//                                          range:rang2];
//    [mutableAttributedString_attrs addAttribute:(NSString *)kCTFontAttributeName
//                                          value:[UIFont systemFontOfSize:13]
//                                          range:rang2];
//    [mutableAttributedString_attrs endEditing];
//    self.nameLab.attributedText  =[mutableAttributedString_attrs copy];
}


@end
