//
//  UIViewController+CustomBackButton.m
//  TaoXue
//
//  Created by zhang on 14-5-7.
//  Copyright (c) 2014年 BIT. All rights reserved.
//

#import "UIViewController+CustomBackButton.h"

@implementation UIViewController (CustomBackButton)

// 设置返回按钮的文字，如果设置了自定义图片则会禁掉自带的右滑返回手势
- (void)setCustomBackButton
{
    
    // 设置自定义返回图片，禁掉自带的右滑返回手势
//    self.navigationItem.hidesBackButton = YES;
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStyleBordered target:self action:@selector(customBackButtonBack:)];
    
    // 设置backBarButtonItem的返回文字为空，只显示返回按钮图片
//    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleBordered target:self action:nil];
//    self.navigationItem.backBarButtonItem = backBarButton;
    
    // 设置backBarButtonItem的返回文字
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:nil];
    self.navigationItem.backBarButtonItem = backBarButton;
    
}

- (void)customBackButtonBack:(UIBarButtonItem *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
