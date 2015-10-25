//
//  NGCompanyDetailVC.m
//  ddt
//
//  Created by wyg on 15/10/24.
//  Copyright © 2015年 Light. All rights reserved.
//

#import "NGCompanyDetailVC.h"

#define Font    [UIFont systemFontOfSize:13]
#define Size    CGSizeMake(CurrentScreenWidth - 50, 1000)

@interface NGCompanyDetailVC ()
{
    NSString *_s1;
    NSString *_s2;
    NSString *_s3;
    NSString *_s4;
    NSString *_s5;
}
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *nameDetailLab;
@property (weak, nonatomic) IBOutlet UILabel *addrLab;
@property (weak, nonatomic) IBOutlet UILabel *addrDetailLab;
@property (weak, nonatomic) IBOutlet UILabel *areaLab;
@property (weak, nonatomic) IBOutlet UILabel *areaDetailLab;
@property (weak, nonatomic) IBOutlet UILabel *taskLab;
@property (weak, nonatomic) IBOutlet UILabel *taskDetailLab;

@end

@implementation NGCompanyDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bg_credit"]];
    self.tableView.tableFooterView = [[UIView alloc]init];
    _s1 = @"信和郑州公司";
    _s2 = @"内存泄漏形象的比喻是操作系统可提供给所有";
    _s3 = @"所以“内存泄漏”是从操作系统的角度来看的。这里的存储空间并不是指物理内存，而是指虚拟内存大小，这个虚拟内存大小取决于磁盘交换区设定的大小";
    _s4 = @"vdsfdsfdfsdfdf";
    _s5 = @"发生内存泄漏的代码只会被执行一次，或者由于算法上的缺陷，导致总会有一块且仅一块内存发生泄漏。比如，在类的构造函数中分配内存，在析构函数中却没有释放该内存，所以内存泄漏只会发生一次。";
    
    [self initSubviews];
}

-(void)initSubviews
{
    UIFont *titleFont = [UIFont boldSystemFontOfSize:13];
    _nameLab.font = [UIFont boldSystemFontOfSize:15];;
   _nameLab.textColor = [UIColor colorWithRed:0.875 green:0.718 blue:0.329 alpha:1];
    _areaLab.font = titleFont;
    _taskLab.font = titleFont;
    _addrLab.font =titleFont;
 
    
    _nameLab.text = _s1;
    _nameDetailLab.text = _s2;
    _addrDetailLab.text = _s3;
    _areaDetailLab.text = _s4;
    _taskDetailLab.text  = _s5;
    
    [self.tableView reloadData];
}


-(void)awakeFromNib
{

    self.hidesBottomBarWhenPushed = YES;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#define heightValue 60

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float _h= 30.0;
    switch (indexPath.row) {
        case 0:
        {
            CGFloat _f = [ToolsClass calculateSizeForText:_s2 :Size font:Font].height;
           _h = _h + _f ;
            
        }break;
        case 1:
        {
            _h += [ToolsClass calculateSizeForText:_s3 :Size font:Font].height;
            
        }break;
        case 2:
        {
            _h += [ToolsClass calculateSizeForText:_s4 :Size font:Font].height;
        }break;
        case 3:
        {
            _h += [ToolsClass calculateSizeForText:_s5 :Size font:Font].height;
            
        }break;
            
        default:return 0;
            break;
    }
    
    return _h > heightValue ? _h : heightValue;
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
