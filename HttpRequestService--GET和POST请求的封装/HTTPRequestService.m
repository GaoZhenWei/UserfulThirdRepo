//
//  HTTPRequestService.m
//  TaoXue
//
//  Created by 高振伟 on 14-5-4.
//  Copyright (c) 2014年 BIT. All rights reserved.
//

#import "HTTPRequestService.h"
#import "LocalCache.h"

@implementation HTTPRequestService

+ (NSURLRequest *)POSTRequestWith:(NSString *)url
                          params:(NSDictionary *)params
{
    
    // the boundary string : a random string, that will not repeat in post data, to separate post data fields.
    NSString *BoundaryConstant = @"----------V2ymHFg03ehbqgZCaKO6jy";
    
    // string constant for the post parameter 'file'. My server uses this name: `file`. Your's may differ
    //    NSString* FileParamConstant = @"images";
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setCachePolicy:NSURLRequestUseProtocolCachePolicy];
    [request setHTTPShouldHandleCookies:NO];
    [request setTimeoutInterval:15];
    [request setHTTPMethod:@"POST"];
    
    // set Content-Type in HTTP header
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", BoundaryConstant];
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    // post body
    NSMutableData *body = [NSMutableData data];
    
    NSArray *allkeys = [params allKeys];
    for (NSUInteger i = 0; i < [params count]; i++) {
        NSString *key = [allkeys objectAtIndex:i];
        id object = [params objectForKey:key];
        
        if ([object isKindOfClass:[NSArray class]]) {
            for (NSUInteger i = 0; i < [object count]; i++) {
                // 判断所传输数据是否为图片
                if ([[object objectAtIndex:i] isKindOfClass:[UIImage class]]) {
                    
                    UIImage *image = [object objectAtIndex:i];
                    NSString *filename = [NSString stringWithFormat:@"image-%lu", (unsigned long)i];
                    
                    if (UIImageJPEGRepresentation(image, 1.0)) {
                        NSData *data = UIImageJPEGRepresentation(image, 1.0);
                        
                        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
                        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", key, filename] dataUsingEncoding:NSUTF8StringEncoding]];
                        [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
                        [body appendData:data];
                        [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
                    }
                } else {
//                    NSString *filename = [NSString stringWithFormat:@"object-%d", i];
                    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
                    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", key] dataUsingEncoding:NSUTF8StringEncoding]];
                    id value = [object objectAtIndex:i];
                    if ([value isKindOfClass:[NSNumber class]]) {
                        value = [value stringValue];
                    }
                    [body appendData:[[NSString stringWithFormat:@"%@\r\n",value] dataUsingEncoding:NSUTF8StringEncoding]];
                }
                
            }
        } else {
            
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", key] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"%@\r\n", object] dataUsingEncoding:NSUTF8StringEncoding]];
            
        }
        
    }
    
    // end of body
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // setting the body of the post to the reqeust
    [request setHTTPBody:body];
    
    // set the content-length
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[body length]];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    // set URL
    [request setURL:[NSURL URLWithString:url]];
    
    return request;
}

+ (NSURLRequest *)GETRequestWith:(NSString *)url
                          params:(NSDictionary *)params
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setCachePolicy:NSURLRequestUseProtocolCachePolicy];
    [request setHTTPShouldHandleCookies:NO];
    [request setTimeoutInterval:15];
    [request setHTTPMethod:@"GET"];
    
    // add parameters
    if (params && [params count] > 0) {
        NSMutableString *urlMutableStr = [url mutableCopy];
        [urlMutableStr appendString:@"?"];

        NSArray *allkeys = [params allKeys];
        for (NSUInteger i = 0; i < [params count] - 1; i++) {
            NSString *key = [allkeys objectAtIndex:i];
            NSString *value = [params objectForKey:key];
            
            [urlMutableStr appendFormat:@"%@=%@&", key, value];
        }
        
        NSString *lastParam = [params objectForKey:[allkeys lastObject]];
        [urlMutableStr appendFormat:@"%@=%@", [allkeys lastObject], lastParam];
        
        url = [urlMutableStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    
    // set url
    [request setURL:[NSURL URLWithString:url]];
    
    return request;
}

+ (void)requestWithURL:(NSString *)urlstring
                            params:(NSDictionary *)params
                        HTTPMethod:(NSString *)HTTPMethod
                     completeBlock:(CompleteLoadBlock)block
{
    [HTTPRequestService requestWithURL:urlstring
                                params:params
                            HTTPMethod:HTTPMethod
                         completeBlock:block
                           failedBlock:nil];
}

+ (void)requestWithURL:(NSString *)urlstring
                params:(NSDictionary *)params
            HTTPMethod:(NSString *)HTTPMethod
         completeBlock:(CompleteLoadBlock)block
           failedBlock:(FailedBlock)failBlock
{
    [HTTPRequestService requestWithURL:urlstring
                               baseUrl:BASE_URL
                                params:params
                            HTTPMethod:HTTPMethod
                         completeBlock:block
                           failedBlock:failBlock];
}

+ (void)requestWithURL:(NSString *)urlstring
               baseUrl:(NSString *)baseUrl
                params:(NSDictionary *)params
            HTTPMethod:(NSString *)HTTPMethod
         completeBlock:(CompleteLoadBlock)block
           failedBlock:(FailedBlock)failBlock
{
    // set url string
    urlstring = [baseUrl stringByAppendingString:urlstring];
    
    // add parameter to request
    NSURLRequest *request = nil;
    if ([HTTPMethod isEqualToString:@"POST"]) {
        request = [HTTPRequestService POSTRequestWith:urlstring params:params];
    } else if ([HTTPMethod isEqualToString:@"GET"]) {
        request = [HTTPRequestService GETRequestWith:urlstring params:params];
    }
    
    if (!request) return;
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES; //显示网络链接
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
        completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO; //隐藏
            
            if (!connectionError) {
                // save to local cache
                id result = [NSJSONSerialization JSONObjectWithData:data
                                                            options:NSJSONReadingMutableContainers
                                                              error:nil];
                // 当结果是合法的JSON对象时
                if (result) {
                    [LocalCache storeCacheForRequest:request withData:data];
                    
                    if (block) block(result);
                    return ;
                }
            }
            
            [SimpleAlertView alertWith:@"网络错误"];
            if (failBlock)  failBlock();
        }];
}

+ (void)successToRequestWithURL:(NSString *)urlstring params:(NSDictionary *)params completeBlock:(CompleteBlock2)block
{
    
    [HTTPRequestService requestWithURL:urlstring
                                params:params
                            HTTPMethod:@"POST"
                         completeBlock:^(NSDictionary *result) {
                             BOOL success;
                             int status = [[result objectForKey:@"status"] intValue];
                             if (status == 0) {
                                 success = YES;
                             } else {
                                 success = NO;
                             }
                             
                             if (block != nil) {
                                 block(success);
                             }
                         }];
    
}

@end
