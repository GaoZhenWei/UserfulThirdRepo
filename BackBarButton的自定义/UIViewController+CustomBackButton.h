//
//  UIViewController+CustomBackButton.h
//  TaoXue
//
//  Created by zhang on 14-5-7.
//  Copyright (c) 2014年 BIT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (CustomBackButton)

// 设置返回按钮的文字，如果设置了自定义图片则会禁掉自带的右滑返回手势
- (void)setCustomBackButton;

- (void)customBackButtonBack:(UIBarButtonItem *)sender;

@end
