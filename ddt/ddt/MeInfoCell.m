//
//  MeInfoCell.m
//  ddt
//
//  Created by wyg on 16/2/27.
//  Copyright © 2016年 Light. All rights reserved.
//

#import "MeInfoCell.h"

@implementation MeInfoCell
{

    __weak IBOutlet UIImageView *icon_img;
    __weak IBOutlet UILabel *name;
    __weak IBOutlet UILabel *jifen;
    __weak IBOutlet UILabel *liulab;
    __weak IBOutlet UILabel *comm;
}

- (void)awakeFromNib {
    // Initialization code
    icon_img.layer.cornerRadius = 45;
    icon_img.layer.masksToBounds = YES;
    [icon_img addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)]];
}

-(void)setCell:(NSString*)imgurl name:(NSString*)names jifen:(NSString*)jifens liulan :(NSString*)liulans comm :(NSString *)comms
{
    if (imgurl) {
         [icon_img setImageWithURL:[NSURL URLWithString:imgurl] placeholderImage:[UIImage imageNamed:@"head_noregist"]];
    }
    else
    [icon_img setImage:[UIImage imageNamed:@"head_noregist"]];
    
    name.text = names ? names : @"---";
    jifen.text = jifens ? jifens :@"0";
    liulab.text = liulans ? liulans  :@"0";
    comm.text = comms ? comms :@"0";
    
}

-(void)tapAction
{
    _tapIconBlock(icon_img);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
