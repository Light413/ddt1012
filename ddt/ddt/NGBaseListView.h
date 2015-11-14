//
//  NGBaseListView.h
//  ddt
//
//  Created by gener on 15/10/15.
//  Copyright (c) 2015年 Light. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NGBaseListView;
@protocol NGBaseListDelegate <NSObject>

@required
//tablevie个数dataSourceOfBaseView 数据源为数组类型
-(NSInteger)numOfTableViewInBaseView :(NGBaseListView *)baseListView;

//获取一级列表数据源
-(NSArray*)dataSourceOfBaseView;

//获取二级列表数据源 keyValue ： 一级列表所选元素项的Id值
-(NSArray*)dataSourceOfBaseViewWithKey:(NSString *)keyValue;

/**
 *  选中操作处理
 *
 *  @param baseListView listview
 *  @param obj1         第一个列表选中的对象
 *  @param index1       第一对象的索引
 *  @param obj2         第二个列表选中的对象（如无，nil）
 *  @param index2       第二对象的索引（如无，0）
 */
-(void)baseView:(NGBaseListView *)baseListView didSelectObj:(id)obj1 atIndex:(NSIndexPath*)index1 secondObj:(id)obj2 atIndex:(NSIndexPath*)index2;

//获取列表选中的索引
-(id)baseViewGetBtnID;

@end


@interface NGBaseListView : UIView<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,assign)id<NGBaseListDelegate>delegate;

-(instancetype)initWithFrame:(CGRect)frame withDelegate  :(id)delegate;

@end
