//
//  NGWebView.h
//  ddt
//
//  Created by wyg on 15/11/7.
//  Copyright © 2015年 Light. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NGWebView : UIView<UIWebViewDelegate>

/**
 *  创建webview
 *
 *  @param frame frame
 *  @param url   url string
 *
 *  @return self
 */
-(instancetype)initWithFrame:(CGRect)frame withUrl:(NSString *)url;

@end
