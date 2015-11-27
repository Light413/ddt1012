//
//  NGZhaoPinCell.m
//  ddt
//
//  Created by wyg on 15/11/26.
//  Copyright © 2015年 Light. All rights reserved.
//

#import "NGZhaoPinCell.h"

@implementation NGZhaoPinCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setCellWith:(NSDictionary*)dic
{
    NSString*name = [dic objectForKey:@"xm"]?[dic objectForKey:@"xm"]:@"";
    NSString*sex = [dic objectForKey:@"xb"]?[dic objectForKey:@"xb"]:@"";
    NSString*age = [NSString stringWithFormat:@"%@岁",[dic objectForKey:@"age"]?[dic objectForKey:@"age"]:@""];
    NSString*workold =[NSString stringWithFormat:@"工作时间:%@",[dic objectForKey:@"old"]?[dic objectForKey:@"old"]:@""] ;
    NSString*xueli = [NSString stringWithFormat:@"学历:%@",[dic objectForKey:@"xl"]?[dic objectForKey:@"xl"]:@""];
    NSString*zhiwei = [NSString stringWithFormat:@"职位:%@",[dic objectForKey:@"work"]?[dic objectForKey:@"work"]:@"任意"];
    NSString*gongzi = [NSString stringWithFormat:@"期望工资:%@",[dic objectForKey:@"money"]?[dic objectForKey:@"money"]:@""];
    NSString*content = [NSString stringWithFormat:@"自评:%@",[dic objectForKey:@"content"]?[dic objectForKey:@"content"]:@"暂无评论"];

    NSString *total = [NSString stringWithFormat:@"%@ %@ %@ %@ %@",name,sex,age,workold,xueli];
   
    self.nameLab.text = total;
    self.zhiweiLab.text = zhiwei;
    self.gongziLab.text =gongzi;
    self.contentLab.text = content;
}


- (IBAction)btnAction:(UIButton*)sender {
    if (sender.tag == 300) {
        //call
    }
    else if (sender.tag == 301)
    {
        //msg
    }
    
    _btnClickBlock(sender.tag);
}



@end
