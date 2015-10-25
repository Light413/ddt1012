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

//选择方法 obj1:选择一级列表对象 obj2：选择二级列表对象（无耳机列表为nil）
-(void)baseView:(NGBaseListView *)baseListView didSelectObj:(id)obj1 secondObj:(id)obj2;

@end


@interface NGBaseListView : UIView<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,assign)id<NGBaseListDelegate>delegate;

-(instancetype)initWithFrame:(CGRect)frame withDelegate  :(id)delegate;

@end
