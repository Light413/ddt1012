//
//  MyCollectionViewController.h
//  ddt
//
//  Created by allen on 15/10/21.
//  Copyright © 2015年 Light. All rights reserved.
//

#import "NGBaseVC.h"

//控制器类型(和搜索控制器复用)
typedef NS_ENUM(NSInteger,VcTypeValue)
{
    VcTypeValue_0,//default
    VcTypeValue_1,// collection
    VcTypeValue_2,//search result
};



@interface MyCollectionViewController : NGBaseVC
{
//    MJRefreshHeader *_anheader;
//    MJRefreshFooter *_footer;
}

@property(nonatomic,assign)VcTypeValue vcType;





@end
