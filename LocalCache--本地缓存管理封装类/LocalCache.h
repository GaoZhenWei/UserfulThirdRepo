//
//  LocalCache.h
//  TaoXue
//
//  Created by zhang on 14/10/22.
//  Copyright (c) 2014年 BIT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocalCache : NSObject

// 对应的url，包含get的参数信息
@property (strong, nonatomic) NSString *urlString;
// 缓存的数据，必须是支持writeToFile的类型，如nsdate，nsdata，nsdictionnary等
@property (strong, nonatomic) id data;
// 缓存数据的过期时间
@property (strong, nonatomic) NSDate *expireDate;

- (BOOL)isExpired;

// 将指定url的数据写入缓存，并赋予默认的过期时间
+ (void)storeCacheForRequest:(NSURLRequest *)request withData:(id)data;

// 将指定url的数据写入缓存，并赋予过期时间
+ (void)storeCacheForRequest:(NSURLRequest *)request withData:(id)data expired:(NSDate *)expired;

// 返回指定url（包括参数）的缓存数据，若缓存不存在，返回nil
+ (LocalCache *)loadFromRequest:(NSURLRequest *)request;

// 返回当前缓存所占的总空间大小，单位为Byte
+ (NSUInteger)currentCacheSize;

// 清空所有缓存
+ (void)emptyStorage;

// 默认的缓存，类型为一个dictionary，用于保存某些临时数据，如账号，密码等
// 可以看作浏览器的Cookie一般使用
+ (LocalCache *)loadFromDefault:(NSString *)name;

+ (void)storeToDefault:(NSString *)name data:(id)data;

+ (void)storeToDefault:(NSString *)name data:(id)data expire:(NSDate *)expired;

@end
