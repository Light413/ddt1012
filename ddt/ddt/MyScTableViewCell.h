//
//  MyScTableViewCell.h
//  ddt
//
//  Created by allenhzhang on 10/20/15.
//  Copyright (c) 2015 Light. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommanySCModel.h"
@interface MyScTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *commanyNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *yewuLabel;
@property (weak, nonatomic) IBOutlet UILabel *quyuLabel;
-(void)showDataFromModel:(CommanySCModel *)model;
@end
