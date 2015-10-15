//
//  NGBaseListView.m
//  ddt
//
//  Created by gener on 15/10/15.
//  Copyright (c) 2015年 Light. All rights reserved.
//

#import "NGBaseListView.h"
#define NGTABLEVIEWTAG  300

#define SubListViewCellNormalColor [UIColor colorWithRed:0.957 green:0.957 blue:0.957 alpha:1]


@implementation NGBaseListView
{
    NSInteger _numberTableview;
}
-(instancetype)initWithFrame:(CGRect)frame withDelegate  :(id)delegate
{
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = delegate;
        _numberTableview = [self.delegate numOfTableViewInBaseView:self];
        
        float width = frame.size.width * 1.0 / _numberTableview;
        for (int i=0; i < _numberTableview; i++) {
            UITableView *_tableview = [[UITableView alloc]initWithFrame:CGRectMake(width * i, 0, width, frame.size.height) style:UITableViewStylePlain];
            _tableview.delegate  =self;
            _tableview.dataSource = self;
            _tableview.tag = NGTABLEVIEWTAG  +i;
            _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
            [self addSubview:_tableview];
        }
    }
    return self;
}


-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    float width = frame.size.width * 1.0 / _numberTableview;
    for (int i=0; i < self.subviews.count; i++) {
        UITableView *_tableview = (UITableView *)[self viewWithTag:NGTABLEVIEWTAG +i];
        _tableview.frame = CGRectMake(width * i, 0, width, frame.size.height);
        [_tableview reloadData];
    }
}



#pragma mark- tableview delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self.delegate respondsToSelector:@selector(dataSourceOfBaseView)]) {
        return [self.delegate dataSourceOfBaseView].count;
    }
    return  0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellReuseIdentifier"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellReuseIdentifier"];
        cell.textLabel.font = [UIFont systemFontOfSize:13];
    }
    
    for (id _obj in cell.subviews) {
        if ([_obj isKindOfClass:[UILabel class]]) {
            [((UILabel*)_obj) removeFromSuperview];
        }
    }
    
    if (tableView.tag == 300) {
        UILabel *_lab = [[UILabel alloc]initWithFrame:CGRectMake(0, cell.frame.size.height  -1, cell.frame.size.width, 1)];
        _lab.backgroundColor = SubListViewCellNormalColor;
        [cell addSubview:_lab];
        
    }
    else
    {
        cell.backgroundColor = SubListViewCellNormalColor;
    }

    NSArray *_arr =[self.delegate dataSourceOfBaseView];
    NSString *_title = [_arr objectAtIndex:indexPath.row];
    cell.textLabel.text = _title ? _title :@"";
    cell.selectedBackgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"btn_cell_selectedBG.jpg"]];
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
//        [_tableView setSeparatorInset:UIEdgeInsetsZero];
//    }
//    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
//        [_tableView setLayoutMargins:UIEdgeInsetsZero];
//    }
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(baseView:didSelectRowAtIndex:)]) {
          [self.delegate baseView:self didSelectRowAtIndex:indexPath.row];
    }
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
