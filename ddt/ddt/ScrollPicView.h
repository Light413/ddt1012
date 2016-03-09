//
//  ScrollPicView.h
//  ddt
//
//  Created by wyg on 16/3/6.
//  Copyright © 2016年 Light. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TopClickDelegate <NSObject>

-(void)clickPicWithUrl : (NSString *)url ;


@end


@interface ScrollPicView : UIView

@property(nonatomic,assign)id <TopClickDelegate>delegate;

-(instancetype)initWithFrame:(CGRect)frame withData:(NSArray*)arr;

@end
