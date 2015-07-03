//
//  NSDate+dateWithString.m
//  TaoXue
//
//  Created by 高振伟 on 14-5-11.
//  Copyright (c) 2014年 BIT. All rights reserved.
//

#import "NSDate+dateWithString.h"

@implementation NSDate (dateWithString)

+ (NSDate *)dateWithString:(NSString *)string
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    NSDate *date = [dateFormatter dateFromString:string];
    return date;
}

#define YEAR (3600*24*365)
#define MONTH (3600*24*30)
#define DAY (3600*24)
#define HOUR (3600)
#define MINUTE (60)

+ (NSString *)getDateString:(NSDate *)time
{
    NSInteger interval = [[NSDate date] timeIntervalSinceDate:time];
    interval = (interval > 0) ? interval : 0;
    
    NSArray *timeString = @[@"%d年前", @"%d个月前", @"%d天前", @"%d小时前", @"%d分钟前"];
    NSUInteger _time[5] = {YEAR, MONTH, DAY, HOUR, MINUTE};
    
    for (int i = 0; i < 5; i++) {
        if (interval / _time[i]) {
            return [NSString stringWithFormat:timeString[i], interval / _time[i]];
        }
    }
    
    return @"刚才";
}

@end
