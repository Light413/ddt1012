//
//  NGSecondListCell.h
//  ddt
//
//  Created by gener on 15/10/20.
//  Copyright © 2015年 Light. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NGSecondListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *img_avatar;
@property (weak, nonatomic) IBOutlet UILabel *lab_name;
@property (weak, nonatomic) IBOutlet UILabel *lab_phone;
@property (weak, nonatomic) IBOutlet UILabel *lab_type;
@property (weak, nonatomic) IBOutlet UILabel *lab_detail;
@property (weak, nonatomic) IBOutlet UIButton *btn_fujin;

@property(nonatomic,copy)void(^btnClickBlock)(NSInteger);


-(void)setCellWith:(NSDictionary*)dic withOptionIndex:(NSInteger)index;

@end
