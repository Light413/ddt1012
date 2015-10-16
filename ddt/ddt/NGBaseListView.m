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
    id _dataSource;
    
    id _tableview1_selectedObj;//tableview1 选中的对象
    id _tableview2_selectedObj;//tableview2 选中的对象 ,若无tableview2 则为nil
}
-(instancetype)initWithFrame:(CGRect)frame withDelegate  :(id)delegate
{
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = delegate;
        _numberTableview = [self.delegate numOfTableViewInBaseView:self];
        _dataSource = [self.delegate dataSourceOfBaseView];
        _tableview1_selectedObj = nil;
        _tableview2_selectedObj = nil;
        
        float width = frame.size.width * 1.0 / _numberTableview;
        for (int i=0; i < _numberTableview; i++) {
            UITableView *_tableview = [[UITableView alloc]initWithFrame:CGRectMake(width * i, 0, width, frame.size.height) style:UITableViewStylePlain];
            _tableview.delegate  =self;
            _tableview.dataSource = self;
            _tableview.tag = NGTABLEVIEWTAG  +i;
            _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
            if (i == 1) {
                _tableview.backgroundView = nil;
                _tableview.backgroundColor = SubListViewCellNormalColor;
            }
            [self addSubview:_tableview];
        }
    }
    return self;
}

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    float width = frame.size.width * 1.0 / (_numberTableview == 2 ?5:_numberTableview);
    for (int i=0; i < self.subviews.count; i++) {
        UITableView *_tableview = (UITableView *)[self viewWithTag:NGTABLEVIEWTAG +i];
        _tableview.frame = CGRectMake(width * i *2, 0, width *(i+2), frame.size.height);
        [_tableview reloadData];
    }
}



#pragma mark- tableview delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self.delegate respondsToSelector:@selector(dataSourceOfBaseView)]) {
        id _obj = [self.delegate dataSourceOfBaseView];
        if (tableView.tag == 300) {
            if ([_obj isKindOfClass:[NSArray class]]) {
                return ((NSArray*)_obj).count;
            }
            else if([_obj isKindOfClass:[NSDictionary class]])
            {
                return [((NSDictionary*)_obj) allKeys].count;
            }
        }
        else if (tableView.tag == 301)
        {
            return [[((NSDictionary*)_obj) objectForKey:_tableview1_selectedObj] count];
        }
    }
    return  0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *_title;
    
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
        if (_numberTableview == 1) {
            NSArray *_arr = (NSArray*)_dataSource;
            _title = [_arr objectAtIndex:indexPath.row];
        }
        else if (_numberTableview == 2)
        {
            NSDictionary *_dic = (NSDictionary*)_dataSource;
            _title = [[_dic allKeys] objectAtIndex:indexPath.row];
        }
        
        UILabel *_lab = [[UILabel alloc]initWithFrame:CGRectMake(0, cell.frame.size.height  -1, cell.frame.size.width, 1)];
        _lab.backgroundColor = SubListViewCellNormalColor;
        [cell addSubview:_lab];
        cell.selectedBackgroundView = _numberTableview > 1?[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"btn_cell_selectedBG.jpg"]] : nil;
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    else
    {
        cell.backgroundColor = SubListViewCellNormalColor;
        cell.selectedBackgroundView = nil;
        NSDictionary *_dic = (NSDictionary*)_dataSource;
        NSArray *_arr1 = [_dic objectForKey:_tableview1_selectedObj];
        _title = [_arr1 objectAtIndex:indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.textLabel.text = _title ? _title :@"";
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *_selectStr = nil;
   UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (tableView.tag == 300) {
        if (_numberTableview == 1) {
            _selectStr = cell.textLabel.text;
            if ([self.delegate respondsToSelector:@selector(baseView:didSelectObj:secondObj:)]) {
                [self.delegate baseView:self didSelectObj:_selectStr secondObj:_tableview2_selectedObj];
            }
        }
        else
        {
            _tableview1_selectedObj =cell.textLabel.text;
              UITableView *_t = (UITableView *) [self viewWithTag:301];
            [_t reloadData];
        }
    }
    else
    {
        _selectStr = cell.textLabel.text;
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        _tableview2_selectedObj = _selectStr;
        if ([self.delegate respondsToSelector:@selector(baseView:didSelectObj:secondObj:)]) {
            [self.delegate baseView:self didSelectObj:_tableview1_selectedObj secondObj:_tableview2_selectedObj];
        }
    }
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryNone;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
