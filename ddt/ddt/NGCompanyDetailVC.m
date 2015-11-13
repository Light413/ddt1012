//
//  NGCompanyDetailVC.m
//  ddt
//
//  Created by wyg on 15/10/24.
//  Copyright © 2015年 Light. All rights reserved.
//

#import "NGCompanyDetailVC.h"

#define Font    [UIFont systemFontOfSize:15]
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
    _s1 = [_companyInfoDic objectForKey:@"company"];
    _s2 = [_companyInfoDic objectForKey:@"yewu"];
    _s3 =[_companyInfoDic objectForKey:@"address"];
    _s4 =[_companyInfoDic objectForKey:@"quyu"];
    _s5 = [_companyInfoDic objectForKey:@"content"];
    
    [self initSubviews];
}

-(void)initSubviews
{
    UIFont *titleFont = [UIFont boldSystemFontOfSize:15];
    _nameLab.font = [UIFont boldSystemFontOfSize:16];;
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
