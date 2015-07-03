//
//  UILabel+CountLabelSize.h
//  ProductPush
//
//  Created by gzw on 15-6-27.
//  Copyright (c) 2015年 BIT-高振伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (CountLabelSize)

// 根据限定的size动态计算Label的高度
- (CGSize)boundingRectWithSize:(CGSize)size;

@end
