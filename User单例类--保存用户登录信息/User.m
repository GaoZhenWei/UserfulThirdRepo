//
//  User.m
//  ProductPush
//
//  Created by gzw on 15-6-20.
//  Copyright (c) 2015年 BIT-高振伟. All rights reserved.
//

#import "User.h"

static User *_instance = nil;

@implementation User

+ (instancetype)currentUser
{
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init] ;
        
        [User getUserInfo];
    }) ;
    
    return _instance;
}

+ (void)getUserInfo
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    NSString *filePath = [path stringByAppendingPathComponent:@"UserInfo.plist"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:filePath]) {
        NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:filePath];
        _instance.userName = [dic objectForKey:@"userName"];
        _instance.password = [dic objectForKey:@"password"];
        _instance.autoLogin = [[dic objectForKey:@"autoLogin"] boolValue];
        _instance.savePassword = [[dic objectForKey:@"savePassword"] boolValue];
        _instance.url_link = @"";
        
    } else {
        _instance.userName = @"";
        _instance.password = @"";
        _instance.autoLogin = NO;
        _instance.savePassword = YES;
        _instance.url_link = @"";
    }
}

+ (void)saveCurrentUser
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    NSString *filePath = [path stringByAppendingPathComponent:@"UserInfo.plist"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:filePath]) {
        [fileManager createFileAtPath:filePath contents:nil attributes:nil];
    }
    
    NSDictionary *dic = @{@"userName": _instance.userName,
                          @"password": _instance.password,
                          @"autoLogin": [NSNumber numberWithBool:_instance.isAutoLogin],
                          @"savePassword": [NSNumber numberWithBool:_instance.isSavePassword]
                        };
    
    [dic writeToFile:filePath atomically:YES];
}

@end
