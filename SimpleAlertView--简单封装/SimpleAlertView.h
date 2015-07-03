//
//  SimpleAlertView.h
//  TaoXue
//
//  Created by zhang on 14/10/22.
//  Copyright (c) 2014年 BIT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SimpleAlertView : UIAlertView <UIAlertViewDelegate>

+ (void)alertWith:(NSString *)message;

+ (void)alertWith:(NSString *)message title:(NSString *)title;

@property (nonatomic, getter=isAlerting) BOOL alerting;

@end
