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
    self.titleLab.text = @"会议标题减肥的风格货到付款过";
    self.dataLab.text = @"2015-09-09 09:34";
    self.addressLab.text = @"人民路一号口方式将开放的发动机可放大缸发动机开工恢复到开会地址";
    self.smLab.text = @"会议主题内容--腾讯科技讯（乐天）11月6日消息，海淀法院网站今日公布消息，海淀法院受理北京京东叁佰陆拾度电子商务有限公司、北京京东世纪信息技术有限公司起诉浙江天猫网络有限公司、天津猫超电子商务有限公司不正当竞争案。\
    　　事情的缘由是，京东公司认为“天猫”投放广告宣称“当日达当日用”、“轻松购物当日达”等系片面宣传，属误导消费者以获得不正当竞争优势，故将天猫商城的运营商、天猫超市华北站的商品经营者诉至法院。";
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
            return 60;
            break;
        case 1:
            return 80;
            break;
        case 2:
        {
          CGSize _size=  [ToolsClass calculateSizeForText:self.smLab.text :CGSizeMake(CurrentScreenWidth - 20, 999) font:[UIFont systemFontOfSize:13]];
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
