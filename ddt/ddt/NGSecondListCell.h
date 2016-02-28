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
@property (weak, nonatomic) IBOutlet UILabel *lab_gs;
@property (weak, nonatomic) IBOutlet UILabel *lab_yewu;
@property (weak, nonatomic) IBOutlet UILabel *sexLab;
@property (weak, nonatomic) IBOutlet UILabel *disLab;

@property(nonatomic,copy)void(^btnClickBlock)(NSInteger);


-(void)setCellWith:(NSDictionary*)dic withOptionIndex:(NSInteger)index;

@end
