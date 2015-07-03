//
//  HTTPRequestService.h
//  TaoXue
//
//  Created by 高振伟 on 14-5-4.
//  Copyright (c) 2014年 BIT. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^CompleteLoadBlock) (id result);
typedef void(^CompleteBlock2) (BOOL success);
typedef void(^FailedBlock) (void);

@interface HTTPRequestService : NSObject

// 获取指定URL的POST方式的请求
+ (NSURLRequest *)POSTRequestWith:(NSString *)url
                           params:(NSDictionary *)params;

// 获取指定URL的GET方式的请求
+ (NSURLRequest *)GETRequestWith:(NSString *)url
                          params:(NSDictionary *)params;

+ (void)requestWithURL:(NSString *)urlstring
                            params:(NSDictionary *)params
                        HTTPMethod:(NSString *)HTTPMethod
                     completeBlock:(CompleteLoadBlock)block;

+ (void)requestWithURL:(NSString *)urlstring
                            params:(NSDictionary *)params
                        HTTPMethod:(NSString *)HTTPMethod
                     completeBlock:(CompleteLoadBlock)block
                       failedBlock:(FailedBlock)failBlock;

+ (void)requestWithURL:(NSString *)urlstring
               baseUrl:(NSString *)baseUrl
                params:(NSDictionary *)params
            HTTPMethod:(NSString *)HTTPMethod
         completeBlock:(CompleteLoadBlock)block
           failedBlock:(FailedBlock)failBlock;


+ (void)successToRequestWithURL:(NSString *)urlstring params:(NSDictionary *)params completeBlock:(CompleteBlock2)block;

@end
