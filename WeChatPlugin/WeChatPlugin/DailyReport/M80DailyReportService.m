//
//  M80DailyReportService.m
//  WeChatPlugin
//
//  Created by amao on 2017/6/15.
//  Copyright © 2017年 xiangwangfeng. All rights reserved.
//

#import "M80DailyReportService.h"
#import "M80Util.h"
#import "M80WeChat.h"

@implementation M80DailyReportService
- (void)report
{
    NSString *filepath = [self configPath];
    NSDictionary *info = [NSDictionary dictionaryWithContentsOfFile:filepath];
    NSString *sessionId = info[@"sessionId"]; //微信号
    NSDate *date = info[@"date"];
    NSString *text = info[@"text"];
    NSLog(@"path %@ session %@ text %@ date %@",filepath,sessionId,text,date);
    if (sessionId && text && [self shouldReport:date])
    {
        
        [[M80WeChat shared] sendMessage:text
                              toSession:sessionId];
        
        NSLog(@"send text %@ to sessionId %@",text,sessionId);
        
        NSDictionary *saveInfo = @{@"date" : [NSDate date],
                                   @"sessionId" : sessionId,
                                   @"text" : text};
        [saveInfo writeToFile:filepath
                   atomically:YES];
    }
    
}

- (NSString *)configPath
{
    return [[M80Util documentDir] stringByAppendingPathComponent:@"daily.plist"];
}

- (BOOL)shouldReport:(NSDate *)date
{
    BOOL should = date == nil;
    if (date)
    {
        NSDate *now = [NSDate date];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *reportComponents = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
        NSDateComponents *nowComponents = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:now];
        should = reportComponents.year != nowComponents.year || reportComponents.month != nowComponents.month || reportComponents.day != nowComponents.day;
    }
    return should;
}
@end
