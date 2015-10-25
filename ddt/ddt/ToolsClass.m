//
//  ToolsClass.m
//  ddt
//
//  Created by wyg on 15/10/25.
//  Copyright © 2015年 Light. All rights reserved.
//

#import "ToolsClass.h"

@implementation ToolsClass
-(instancetype)init
{
    if (self == [super init]) {
        
    }
    return self;
}



+ (CGSize)calculateSizeForText:(NSString*)text :(CGSize)size font:(UIFont *)font {
    CGSize tmpsize = CGSizeZero;
//    font = [UIFont systemFontOfSize:12];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
        NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy};
        
        tmpsize = [text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    }
    else {
        tmpsize = [text sizeWithFont:font
                   constrainedToSize:size
                       lineBreakMode:NSLineBreakByWordWrapping];
    }
    
    return CGSizeMake(ceil(tmpsize.width), ceil(tmpsize.height));
}



@end
