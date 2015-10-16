//
//  MySharetools.m
//  ddt
//
//  Created by allen on 15/10/15.
//  Copyright (c) 2015年 Light. All rights reserved.
//

#import "MySharetools.h"

@implementation MySharetools
static MySharetools *instance = nil;
+(MySharetools *)shared{
    @synchronized(self){
        if (!instance) {
            instance = [[MySharetools alloc]init];
        }
    }
    return instance;
}
-(id)getViewControllerWithIdentifier:(NSString *)Identifier andstoryboardName:(NSString *)storyboardname{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardname bundle:nil];
    id ViewController = [storyboard instantiateViewControllerWithIdentifier:Identifier];
    return ViewController;
}
@end
