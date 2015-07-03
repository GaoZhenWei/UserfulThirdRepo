//
//  NSDate+dateWithString.h
//  TaoXue
//
//  Created by 高振伟 on 14-5-11.
//  Copyright (c) 2014年 BIT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (dateWithString)

// 将字符串以一定的时间格式转换成NSDate
+ (NSDate *)dateWithString:(NSString *)string;

// 将NSDate以一定的时间格式转换成字符串
+ (NSString *)stringWithDate:(NSDate *)dateTime;

// 将NSDate转换成字符串距离现在的 分钟／小时／天／月／年
+ (NSString *)getDateString:(NSDate *)time;

@end
