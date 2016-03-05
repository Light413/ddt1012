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
    //设置头像
    NSString *imageFile = [NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg",[[MySharetools shared]getPhoneNumber]]];
    UIImage *_ig = [[UIImage alloc]initWithContentsOfFile:imageFile];
    if (_ig) {
      [icon_img setImage:_ig];
    }
    else
    {
        if (imgurl) {
            [icon_img setImageWithURL:[NSURL URLWithString:imgurl] placeholderImage:[UIImage imageNamed:@"head_noregist"]];
        }
        else
            [icon_img setImage:[UIImage imageNamed:@"head_noregist"]];
    }

    
    name.text = names ? names : @"---";
    
    //积分
     NSInteger oldaddjifen =[[NSUserDefaults standardUserDefaults]objectForKey:QIAN_DAO_JIFEN_KEY]? [[[NSUserDefaults standardUserDefaults]objectForKey:QIAN_DAO_JIFEN_KEY] integerValue] :0;
    
    NSInteger total = [(jifens ? jifens :@"0") integerValue] + oldaddjifen;
    jifen.text = [NSString stringWithFormat:@"%ld",total];
    
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
