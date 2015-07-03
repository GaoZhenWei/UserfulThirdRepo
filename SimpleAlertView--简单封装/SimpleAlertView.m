//
//  SimpleAlertView.m
//  TaoXue
//
//  Created by zhang on 14/10/22.
//  Copyright (c) 2014年 BIT. All rights reserved.
//

#import "SimpleAlertView.h"

static SimpleAlertView *instance = nil;

@implementation SimpleAlertView

+ (instancetype)defaultAlertView
{
    if (!instance) {
        instance = [[SimpleAlertView alloc] init];
    }
    
    return instance;
}

+ (void)alertWith:(NSString *)message
{
    // 禁止同时弹出多个alertview
    if (![[SimpleAlertView defaultAlertView] isAlerting]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"⚠"
                                                        message:message
                                                       delegate:[SimpleAlertView defaultAlertView]
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        
        // set alerting true
        [[SimpleAlertView defaultAlertView] setAlerting:YES];
    }
}

+ (void)alertWith:(NSString *)message title:(NSString *)title
{
    if (![[SimpleAlertView defaultAlertView] isAlerting]) {
        if (!title || [title isEqualToString:@""]) {
            title = @"⚠";
        }
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:[SimpleAlertView defaultAlertView]
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        
        // set alerting true
        [[SimpleAlertView defaultAlertView] setAlerting:YES];
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    self.alerting = NO;
}

@end
