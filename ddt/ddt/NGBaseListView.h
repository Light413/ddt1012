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
//tablevie 个数 为1 ：dataSourceOfBaseView 数据源为数组类型  2：dataSourceOfBaseView 为字典类型
-(NSInteger)numOfTableViewInBaseView :(NGBaseListView *)baseListView;

-(id)dataSourceOfBaseView;

-(void)baseView:(NGBaseListView *)baseListView didSelectObj:(id)obj1 secondObj:(id)obj2;

@end


@interface NGBaseListView : UIView<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,assign)id<NGBaseListDelegate>delegate;

-(instancetype)initWithFrame:(CGRect)frame withDelegate  :(id)delegate;

@end
