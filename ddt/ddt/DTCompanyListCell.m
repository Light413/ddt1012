//
//  DTCompanyListCell.m
//  ddt
//
//  Created by wyg on 15/10/24.
//  Copyright © 2015年 Light. All rights reserved.
//

#import "DTCompanyListCell.h"
#import <CoreText/CoreText.h>

@implementation DTCompanyListCell

- (void)awakeFromNib {
    // Initialization code
    self.name.font = [UIFont systemFontOfSize:13];
//    self.name.textColor = [UIColor lightGrayColor];
//    self.distructionLab.font = [UIFont systemFontOfSize:13];
    self.detailLab.font = [UIFont systemFontOfSize:13];
}

-(void)setCellWith:(NSDictionary*)dic
{
    NSString * name = [NSString stringWithFormat:@"%@ %@",[dic objectForKey:@"company"]?[NSString stringWithFormat:@"%@ -",[dic objectForKey:@"company"]]:@"",[dic objectForKey:@"4"]];
    self.name.text = name;
    self.detailLab.text = [dic objectForKey:@"word"];
    
    NSMutableAttributedString *mutableAttributedString_attrs = [[NSMutableAttributedString alloc] initWithString:self.name.text];
    [mutableAttributedString_attrs beginEditing];
    
//    [mutableAttributedString_attrs addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInt:NSUnderlineStyleThick] range:NSMakeRange(0, 2)];
//    [mutableAttributedString_attrs addAttribute:NSBaselineOffsetAttributeName value:[NSNumber numberWithFloat:20.0] range:NSMakeRange(2, 1)];
    NSString * _s  =[dic objectForKey:@"company"];
    NSRange rang = NSMakeRange(0, _s.length);
    
    [mutableAttributedString_attrs addAttribute:NSForegroundColorAttributeName
                        value:(id)[UIColor blackColor].CGColor
                        range:rang];
    [mutableAttributedString_attrs addAttribute:NSFontAttributeName
                                          value:[UIFont boldSystemFontOfSize:14]
                                          range:rang];
    
     [mutableAttributedString_attrs endEditing];
    self.name.attributedText  =[mutableAttributedString_attrs copy];
    
    self.btn_love.selected = [[dic objectForKey:@"isbook"]boolValue];
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{

}

- (IBAction)cellBtnAction:(UIButton *)sender {
    if (sender.tag == 302) {
        sender.selected = !sender.selected;
    }
    
    _btnClickBlock(sender.selected);
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
