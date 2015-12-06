//
//  NGSecondListCell.m
//  ddt
//
//  Created by gener on 15/10/20.
//  Copyright © 2015年 Light. All rights reserved.
//

#import "NGSecondListCell.h"
@implementation NGSecondListCell

- (void)awakeFromNib {
    // Initialization code
    self.lab_phone.textColor = [UIColor colorWithRed:0.906 green:0.824 blue:0.404 alpha:1];
    self.img_avatar .layer.cornerRadius = 27.5;
    self.img_avatar.layer.masksToBounds = YES;
}


-(void)setCellWith:(NSDictionary*)dic withOptionIndex:(NSInteger)index
{
    NSString * pic =[dic objectForKey:@"pic"];
    if (pic && pic.length > 11 ) {
        NSString * url = [NSString stringWithFormat:@"%@%@",NSLocalizedString(@"url_get_avatar", @""),pic];
         [self.img_avatar setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"cell_avatar_default"]];
    }
    else
    {
        self.img_avatar.image =[UIImage imageNamed:@"cell_avatar_default"];
    }
    
    self.lab_name.text = [dic objectForKey:@"xm"];
    self.lab_phone.text = [dic objectForKey:@"mobile"];
    self.lab_type.text = [dic objectForKey:@"yewu"];
    self.lab_detail.text = [dic objectForKey:@"word"];
    
    if (index ==3) {
        self.btn_fujin.hidden = YES;
    }
    else if (index == 1)
    {
        self.btn_fujin.hidden = NO;
        NSString * _title = @"无位置";
        NSString *_dis = [dic objectForKey:@"distance"]?[dic objectForKey:@"distance"]:@"";
        NSString *mylog = [[NSUserDefaults standardUserDefaults] objectForKey:CURRENT_LOCATION_LOG];
        NSString *mylat = [[NSUserDefaults standardUserDefaults]objectForKey:CURRENT_LOCATION_LAT];
        if (![_dis isEqualToString:@""] && mylog &&mylat) {
            NSArray *_arr  =[_dis componentsSeparatedByString:@","];
            CLLocation *_location1= [[CLLocation alloc]initWithLatitude:[mylat doubleValue] longitude:[mylog doubleValue]];
            CLLocation *_location2= [[CLLocation alloc]initWithLatitude:[_arr[1] doubleValue] longitude:[_arr[0] doubleValue]];
            
            double _s = [_location1 distanceFromLocation:_location2] / 1000;
             _title = [NSString stringWithFormat:@"%.1fkm",_s];
        }

        [self.btn_fujin setTitle:_title];
    }
    
    UIButton * love = (UIButton *)[self viewWithTag:301];
    love.selected = [[dic objectForKey:@"isbook"]boolValue];
}



- (IBAction)cellBtnAction:(UIButton *)sender {
    if (sender.tag == 301) {
        sender.selected = !sender.selected;
    }
    
    _btnClickBlock(sender.tag);
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
