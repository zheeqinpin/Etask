//
//  NSString+TimeInterval.m
//  GlowForum
//
//  Created by zwj on 15/8/26.
//  Copyright (c) 2015年 SJTU. All rights reserved.
//

#import "NSString+TimeInterval.h"

#define MONTH 2592000
#define DAY 86400
#define HOUR 3600
#define MINUTE 60

@implementation NSString (TimeInterval)

- (NSString *) calculateUpLoadTime {
    NSString *timeString = [NSString alloc];
    
    NSNumber *createdTime = @([self integerValue]);
    int intCreated = [createdTime intValue];
    int now = [[NSDate date] timeIntervalSince1970];
    
    int ago = now - intCreated;
    if (ago > MONTH * 2) {
        int intMon = ago/MONTH;
        timeString = [NSString stringWithFormat:@" • %d months ago", intMon];
    }else if (ago < MONTH * 2 && ago > MONTH) {
        timeString = [NSString stringWithFormat:@" • 1 month ago"];
    }else if (ago < MONTH && ago > DAY *2) {
        int intDay = ago/DAY;
        timeString = [NSString stringWithFormat:@" • %d days ago", intDay];
    }else if (ago < DAY *2 && ago > DAY) {
        timeString = [NSString stringWithFormat:@" • 1 day ago"];
    }else if (ago < DAY && ago > HOUR *2) {
        int intHour = ago/HOUR;
        timeString = [NSString stringWithFormat:@" • %d hours ago", intHour];
    }else {
        timeString = [NSString stringWithFormat:@" • within 1 hour"];
    }
    return timeString;
}

@end
