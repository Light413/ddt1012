//
//  ToolsClass.h
//  ddt
//
//  Created by wyg on 15/10/25.
//  Copyright © 2015年 Light. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ToolsClass : NSObject

/**
 *  计算字符串内容大小
 *
 *  @param text 字符内容
 *  @param size 指定大小
 *  @param font 字体
 *
 *  @return 计算大小
 */
+ (CGSize)calculateSizeForText:(NSString*)text :(CGSize)size font:(UIFont *)font;

@end
