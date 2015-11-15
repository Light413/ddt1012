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
    NSArray * _dataSource;
    NSArray * _dataSource_2;
    
    id _tableview1_selectedObj;//tableview1 选中的对象
    NSIndexPath* _tableview1_selectedIndex;//tableview1选中对象的索引
    NSIndexPath* _tableview1_selectedIndex_last;
    
    id _tableview2_selectedObj;//tableview2 选中的对象 ,若无tableview2 则为nil
    NSIndexPath* _tableview2_selectedIndex;//tableview2选中对象的索引
    UITableViewCell * _lastSelectedCell;
    
    NSMutableArray * _hasSelecetedIndexArr;
}
-(instancetype)initWithFrame:(CGRect)frame withDelegate  :(id)delegate
{
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = delegate;
        _numberTableview = [self.delegate numOfTableViewInBaseView:self];
        _dataSource = [self.delegate dataSourceOfBaseView];
        _dataSource_2 = nil;
        _tableview1_selectedObj = nil;
        _tableview2_selectedObj = nil;
        _tableview1_selectedIndex = nil;
        _tableview2_selectedIndex = nil;
        
        float width = frame.size.width * 1.0 / _numberTableview;
        for (int i=0; i < _numberTableview; i++) {
            UITableView *_tableview = [[UITableView alloc]initWithFrame:CGRectMake(width * i, 0, width, frame.size.height) style:UITableViewStylePlain];
            _tableview.delegate  =self;
            _tableview.dataSource = self;
            _tableview.tag = NGTABLEVIEWTAG  +i;
            _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
            if (_numberTableview == 2&& i==0) {
                _tableview.showsVerticalScrollIndicator = NO;
            }
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
    if ([self.delegate respondsToSelector:@selector(baseViewGetBtnID)]) {
        if (_numberTableview ==1) {
           _tableview1_selectedIndex = [self.delegate baseViewGetBtnID];
        }
        else if (_numberTableview == 2)
        {
            NSIndexPath *_t = [self.delegate baseViewGetBtnID];
            _tableview1_selectedIndex_last = [NSIndexPath indexPathForRow:_t.section inSection:0];
            _tableview2_selectedIndex = [NSIndexPath indexPathForRow:_t.row inSection:0];
        }
    }
    
    float width = frame.size.width * 1.0 / (_numberTableview == 2 ?5:_numberTableview);
    for (int i=0; i < self.subviews.count; i++) {
        UITableView *_tableview = (UITableView *)[self viewWithTag:NGTABLEVIEWTAG +i];
        _tableview.frame = CGRectMake(width * i *2, 0, width *(_numberTableview==2? i+2:1), frame.size.height);
        [_tableview reloadData];
    }
}



#pragma mark- tableview delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == 300) {
        if ([self.delegate respondsToSelector:@selector(dataSourceOfBaseView)]) {
            id _obj = [self.delegate dataSourceOfBaseView];
            if ([_obj isKindOfClass:[NSArray class]]) {
                    return ((NSArray*)_obj).count;
                }
            }
    }
    else if (tableView.tag == 301)
    {
        if (_dataSource_2) {return _dataSource_2.count;}
        else if ([self.delegate respondsToSelector:@selector(dataSourceOfBaseViewWithKey:)]) {
            _dataSource_2 = [self.delegate dataSourceOfBaseViewWithKey:[_tableview1_selectedObj objectForKey:@"ID"]];
            if ([_dataSource_2 isKindOfClass:[NSArray class]]) {
                return _dataSource_2.count;
            }
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
        NSArray *_arr = _dataSource;
        id _obj = [_arr objectAtIndex:indexPath.row];
        if (_numberTableview == 1) {
            if ([_obj isKindOfClass:[NSString class]]) {
               _title = _obj;
            }
            else if ([_obj isKindOfClass:[NSDictionary class]])
            {
                _title = [((NSDictionary*)_obj) objectForKey:@"NAME"];
            }
            if (_tableview1_selectedIndex && _tableview1_selectedIndex.row == indexPath.row) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
            else
            {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
        }
        else if (_numberTableview == 2)
        {
            _title = [((NSDictionary*)_obj) objectForKey:@"NAME"];
        
            cell.selectedBackgroundView = _numberTableview > 1?[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"btn_cell_selectedBG.jpg"]] : nil;
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
            if (_tableview1_selectedIndex_last && _tableview1_selectedIndex_last.row == indexPath.row) {
                _lastSelectedCell = cell;
                cell.backgroundView =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"btn_cell_selectedBG.jpg"]];
                //二级列表参数
                _tableview1_selectedObj =[_dataSource objectAtIndex:_tableview1_selectedIndex_last.row];
                _tableview1_selectedIndex = _tableview1_selectedIndex_last;
            }
            else
            {
              cell.backgroundView =nil;
                if (indexPath.row==0 && _tableview1_selectedIndex_last == nil) {
                  cell.backgroundView =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"btn_cell_selectedBG.jpg"]];
                _lastSelectedCell = cell;
                }
            }
            //刷新二级列表
            UITableView *_t = (UITableView *) [self viewWithTag:301];
            [_t reloadData];
        }
        
        UILabel *_lab = [[UILabel alloc]initWithFrame:CGRectMake(0, cell.frame.size.height  -1, cell.frame.size.width, 1)];
        _lab.backgroundColor = SubListViewCellNormalColor;
        [cell addSubview:_lab];
    }
    else
    {//...
        cell.backgroundColor = SubListViewCellNormalColor;
        cell.selectedBackgroundView = nil;
        NSDictionary *_dic = nil;
        if (_dataSource_2 == nil) {
            if ([self.delegate respondsToSelector:@selector(dataSourceOfBaseViewWithKey:)]) {
                _dataSource_2 = [self.delegate dataSourceOfBaseViewWithKey:[_tableview1_selectedObj objectForKey:@"ID"]];
            }
        }
        _dic = [_dataSource_2 objectAtIndex:indexPath.row];
        _title = [_dic objectForKey:@"NAME"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if ((_tableview2_selectedIndex && _tableview2_selectedIndex.row == indexPath.row && _tableview1_selectedIndex_last.row == _tableview1_selectedIndex.row)|| [self hasContaintSelectedObject:[NSNumber numberWithInteger:10 * _tableview1_selectedIndex.row + indexPath.row]]) {//...多选的问题
           cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else
            cell.accessoryType = UITableViewCellAccessoryNone;;
    }

    cell.textLabel.text = _title ? _title :@"";
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (tableView.tag == 300) {
        _tableview1_selectedObj =[_dataSource objectAtIndex:indexPath.row];
        _tableview1_selectedIndex = indexPath;
        
        if (_numberTableview == 1) {
            if ([self.delegate respondsToSelector:@selector(baseView:didSelectObj:atIndex:secondObj:atIndex:)]) {
                [self.delegate baseView:self didSelectObj:_tableview1_selectedObj atIndex:_tableview1_selectedIndex secondObj:nil atIndex:nil];
            }
        }
        else
        {
            _dataSource_2 = nil;
            _lastSelectedCell.backgroundView = nil;
            //刷新二级列表
            UITableView *_t = (UITableView *) [self viewWithTag:301];
            [_t reloadData];
        }
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        _tableview2_selectedObj = [_dataSource_2 objectAtIndex:indexPath.row];
        _tableview2_selectedIndex = indexPath;
        if ([self.delegate respondsToSelector:@selector(baseView:didSelectObj:atIndex:secondObj:atIndex:)]) {
            [self.delegate baseView:self didSelectObj:_tableview1_selectedObj atIndex:_tableview1_selectedIndex secondObj:_tableview2_selectedObj atIndex:_tableview2_selectedIndex];
        }
        
        
        //...
        if (_hasSelecetedIndexArr == nil) {
            _hasSelecetedIndexArr = [[NSMutableArray alloc]init];
        }
        
        NSInteger num = _tableview1_selectedIndex.row * 10 + _tableview2_selectedIndex.row;
//        _tableview1_selectedIndex = nil;
        _tableview2_selectedIndex = nil;
        NSNumber *numobj = [NSNumber numberWithInteger:num];
        if ([self hasContaintSelectedObject:numobj]) {
            [_hasSelecetedIndexArr removeObject:numobj];
        }
        else
        [_hasSelecetedIndexArr addObject:numobj];
        
        UITableView *_t = (UITableView *) [self viewWithTag:301];
        [_t reloadData];
        NSLog(@"...%@",_hasSelecetedIndexArr);
    }
}


//只记录索引，不涉及具体对象(2个列表的情况，二级列表的选择判断)
-(BOOL)hasContaintSelectedObject :(NSNumber*)num
{
    if (_hasSelecetedIndexArr == nil) {
        return NO;
    }
    for (int i =0; i<_hasSelecetedIndexArr.count; i++) {
        id obj = [_hasSelecetedIndexArr objectAtIndex:i];
        if ([num integerValue] == [obj integerValue]) {
            return YES;
        }
    }
    
    return NO;
}



//-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
////    cell.accessoryType = UITableViewCellAccessoryNone;
//}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
