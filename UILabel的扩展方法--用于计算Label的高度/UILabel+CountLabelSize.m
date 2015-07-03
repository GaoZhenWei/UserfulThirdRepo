//
//  UILabel+CountLabelSize.m
//  ProductPush
//
//  Created by gzw on 15-6-27.
//  Copyright (c) 2015年 BIT-高振伟. All rights reserved.
//

#import "UILabel+CountLabelSize.h"

@implementation UILabel (CountLabelSize)

// 根据限定的size动态计算Label的高度
- (CGSize)boundingRectWithSize:(CGSize)size
{
    NSDictionary *attribute = @{NSFontAttributeName: self.font};
    
    CGSize labelSize = [self.text boundingRectWithSize:size options:(NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) attributes:attribute context:nil].size;
    
    return labelSize;
}

@end
