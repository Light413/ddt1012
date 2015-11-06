//
//  NGTHContactCell.h
//  ddt
//
//  Created by wyg on 15/11/6.
//  Copyright © 2015年 Light. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NGTHContactCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titlaLab;
@property (weak, nonatomic) IBOutlet UILabel *addressLab;
@property (weak, nonatomic) IBOutlet UILabel *dateLab;



-(void)setCellWith:(NSDictionary*)dic;

@end
