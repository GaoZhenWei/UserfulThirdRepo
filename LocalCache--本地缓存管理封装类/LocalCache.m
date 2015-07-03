//
//  LocalCache.m
//  TaoXue
//
//  Created by zhang on 14/10/22.
//  Copyright (c) 2014年 BIT. All rights reserved.
//

#import "LocalCache.h"
#import "MD5.h"

@implementation LocalCache

#define KEY_URL @"url"
#define KEY_EXPIRED @"expire"
#define KEY_DATA @"data"

#define EXPIRE_INTERVAL (30*60) // 30分钟

+ (LocalCache *)loadFromDefault:(NSString *)name
{
    NSDictionary *defaultCache = [LocalCache defaultCache];
    
    NSDictionary *data = [defaultCache objectForKey:name];
    if (data) {
        return [LocalCache initFromDictionary:data];
    }
    
    return nil;
}

+ (void)storeToDefault:(NSString *)name data:(id)data
{
    NSDate *expireDate = [NSDate dateWithTimeIntervalSinceNow:EXPIRE_INTERVAL];
    [LocalCache storeToDefault:name data:data expire:expireDate];
}

+ (void)storeToDefault:(NSString *)name data:(id)data expire:(NSDate *)expired
{
    NSMutableDictionary *defaultCache = [LocalCache defaultCache];
    NSDictionary *cacheData = @{KEY_URL: @"",
                                KEY_DATA: data,
                                KEY_EXPIRED: expired};
    
    [defaultCache setObject:cacheData forKey:name];
    
    
    NSString *documentDirectory = [LocalCache documentDirectory];
    // file path
    NSString *filePath = [documentDirectory stringByAppendingPathComponent:@"defaultCache.plist"];

    [defaultCache writeToFile:filePath atomically:YES];
}

+ (NSMutableDictionary *)defaultCache
{
    NSMutableDictionary *cache = nil;
    
    NSString *documentDirectory = [LocalCache documentDirectory];
    // file path
    NSString *filePath = [documentDirectory stringByAppendingPathComponent:@"defaultCache.plist"];
    
    cache = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
    if (!cache) {
        cache = [NSMutableDictionary dictionary];
    }
    
    return cache;
}

- (BOOL)isExpired
{
    if ([self.expireDate compare:[NSDate date]] == NSOrderedDescending) {
        return NO;
    }
    
    return YES;
}

// 将指定url的数据写入缓存，并赋予默认的过期时间
+ (void)storeCacheForRequest:(NSURLRequest *)request withData:(id)data
{
    // 生成默认时间
    NSDate *expireDate = [NSDate dateWithTimeIntervalSinceNow:EXPIRE_INTERVAL];
    [LocalCache storeCacheForRequest:request withData:data expired:expireDate];
}

+ (NSString *)documentDirectory
{
    // 获取文件夹路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    
    return [path stringByAppendingPathComponent:@"LocalCache"];
}

// 将指定url的数据写入缓存，并赋予过期时间
+ (void)storeCacheForRequest:(NSURLRequest *)request withData:(id)data expired:(NSDate *)expired
{
    NSString *documentDirectory = [LocalCache documentDirectory];

    // 创建文件夹
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:documentDirectory]) {
        [fileManager createDirectoryAtPath:documentDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    // set unique file name
    NSString *filename = [MD5 MD5FromString:request.URL.description];
    NSString *filePath = [documentDirectory stringByAppendingPathComponent:filename];
    
    NSMutableDictionary *cache = [[NSMutableDictionary alloc] init];
    
    // set url
    [cache setObject:request.URL.description forKey:KEY_URL];
    
    // set expire date
    [cache setObject:expired forKey:KEY_EXPIRED];
    
    // set items array in json
    [cache setObject:data forKey:KEY_DATA];
    
    // write to file
    [cache writeToFile:filePath atomically:YES];
}

+ (LocalCache *)initFromDictionary:(NSDictionary *)cachedData
{
    LocalCache *cache = [[LocalCache alloc] init];
    // load url
    cache.urlString = [cachedData objectForKey:KEY_URL];
    
    // load expire date
    cache.expireDate = [cachedData objectForKey:KEY_EXPIRED];
    
    // load data
    cache.data = [cachedData objectForKey:KEY_DATA];
    
    return cache;
}

// 返回指定url（包括参数）的缓存数据，若缓存不存在，返回nil
+ (LocalCache *)loadFromRequest:(NSURLRequest *)request
{
    LocalCache *cache = nil;
    
    // 获取文件夹路径
    NSString *documentDirectory = [LocalCache documentDirectory];
    
    // set unique file name
    NSString *filename = [MD5 MD5FromString:request.URL.description];
    NSString *filePath = [documentDirectory stringByAppendingPathComponent:filename];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    // 读取数据
    if ([fileManager fileExistsAtPath:filePath]) {
        NSDictionary *cachedData = [NSDictionary dictionaryWithContentsOfFile:filePath];
        
        cache = [LocalCache initFromDictionary:cachedData];
    }
    
    return cache;
}

// 返回当前缓存所占的总空间大小，单位为Byte
+ (NSUInteger)currentCacheSize
{
    NSUInteger size = 0;
    
    NSString *documentDirectory = [LocalCache documentDirectory];
    NSArray *cachedFiles = [[NSFileManager defaultManager] subpathsAtPath:documentDirectory];
    
    for (NSString *fileName in cachedFiles) {
        NSString *filePath = [documentDirectory stringByAppendingPathComponent:fileName];
        NSDictionary *fileDic = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
        size += [fileDic fileSize];
    }
    
    return size;
}

// 清空所有缓存
+ (void)emptyStorage
{
    NSString *documentDirectory = [LocalCache documentDirectory];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    [fileManager removeItemAtPath:documentDirectory error:nil];
}

@end
