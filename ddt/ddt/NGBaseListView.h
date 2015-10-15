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
//tablevie 个数
-(NSInteger)numOfTableViewInBaseView :(NGBaseListView *)baseListView;

-(NSArray*)dataSourceOfBaseView;

-(void)baseView:(NGBaseListView *)baseListView didSelectRowAtIndex:(NSInteger)index;

@end


@interface NGBaseListView : UIView<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,assign)id<NGBaseListDelegate>delegate;

-(instancetype)initWithFrame:(CGRect)frame withDelegate  :(id)delegate;

@end
