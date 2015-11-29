//
//  NGContactDetaillVC.m
//  ddt
//
//  Created by wyg on 15/10/25.
//  Copyright © 2015年 Light. All rights reserved.
//

#import "NGContactDetaillVC.h"

@interface NGContactDetaillVC ()
@property (weak, nonatomic) IBOutlet UILabel *titleLab;//会议标题
@property (weak, nonatomic) IBOutlet UILabel *dataLab;//日期
@property (weak, nonatomic) IBOutlet UILabel *addressLab;//地址
@property (weak, nonatomic) IBOutlet UILabel *smLab;//会议说明

@end

@implementation NGContactDetaillVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSubviews];
}


-(void)initSubviews
{
    if (self.dic) {
        self.titleLab.text = [self.dic objectForKey:@"m_title"]?[self.dic objectForKey:@"m_title"]:@"无标题";
        self.dataLab.text = [self.dic objectForKey:@"m_time"]?[self.dic objectForKey:@"m_time"]:@"待定";
        self.addressLab.text = [self.dic objectForKey:@"m_address"]?[self.dic objectForKey:@"m_address"]:@"待定";
        self.smLab.text = [self.dic objectForKey:@"content"]?[self.dic objectForKey:@"content"]:@"暂无内容";
    }
    else
    {
        self.titleLab.text = @"测试数据";
        self.dataLab.text = @"2015-09-09 09:34";
        self.addressLab.text = @"北京海淀区上地十街10号百度大厦";
        self.smLab.text = @"hao123---百度（baidu.com）旗下网站，创建于1999年5月，是中国最早的上网导航站点，经过10余年的发展，已成为亿万用户上网的第一站、中文上网导航的第一品牌";
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
            return 60;
            break;
        case 1:
        {
            CGSize _size=  [ToolsClass calculateSizeForText:self.addressLab.text :CGSizeMake(CurrentScreenWidth - 20, 999) font:[UIFont systemFontOfSize:14]];
            self.smLab.height = _size.height;
            
            return _size.height > 80 ? _size.height+30 : 80;
        }
            return 80;
            break;
        case 2:
        {
          CGSize _size=  [ToolsClass calculateSizeForText:self.smLab.text :CGSizeMake(CurrentScreenWidth - 20, 999) font:[UIFont systemFontOfSize:14]];
            self.smLab.height = _size.height;
            
            return _size.height > 80 ? _size.height+30 : 80;
        }
            break;
        default:return 0;
            break;
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
