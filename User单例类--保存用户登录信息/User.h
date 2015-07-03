//
//  User.h
//  ProductPush
//
//  Created by gzw on 15-6-20.
//  Copyright (c) 2015年 BIT-高振伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, getter=isAutoLogin) BOOL autoLogin;
@property (nonatomic, getter = isSavePassword) BOOL savePassword;

@property (nonatomic, strong) NSString *url_link;

+ (instancetype)currentUser;

+ (void)saveCurrentUser;

@end
