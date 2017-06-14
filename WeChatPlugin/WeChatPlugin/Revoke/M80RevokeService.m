//
//  M80RevokeService.m
//  WeChatPlugin
//
//  Created by amao on 2017/6/9.
//  Copyright © 2017年 xiangwangfeng. All rights reserved.
//

#import "M80RevokeService.h"
#import "M80NotificationManager.h"
#import "M80Dispatch.h"
#import "M80WeChat.h"

@interface M80RevokeService ()
@property (nonatomic,strong)    M80NotificationManager *notificationManager;
@end

@implementation M80RevokeService

- (instancetype)init
{
    if (self = [super init])
    {
        _notificationManager = [[M80NotificationManager alloc] init];
    }
    return self;
}

- (void)receiveRevokedMessage:(NSString *)msg
{
    dispatch_block_t block = ^(){
        [self revoke:msg];
    };
    M80MainAsync(block);
}


#pragma mark - misc
- (void)revoke:(NSString *)msg
{
    //=。= 根本不解析 xml...
    NSString *title = @"撤回通知";
    NSString *session = [self session:msg];
    if ([session length])
    {
        if ([session rangeOfString:@"@chatroom"].location != NSNotFound)
        {
            NSString *teamName = [[M80WeChat shared] teamNameById:session];
            if ([teamName length])
            {
                title = teamName;
            }
            else
            {
                title = @"群内撤回通知";
            }
        }
    }
    NSString *content = [self revokeTip:msg];
    [self fireNotification:title
                   content:content];
}

- (NSString *)content:(NSString *)msg
               prefix:(NSString *)prefix
               suffix:(NSString *)suffix
{
    NSString *result = nil;
    NSRange begin = [msg rangeOfString:prefix];
    NSRange end = [msg rangeOfString:suffix];
    
    if (begin.location != NSNotFound && end.location != NSNotFound && end.location > begin.location)
    {
        NSRange subRange = NSMakeRange(begin.location + begin.length,end.location - begin.location - begin.length);
        result = [msg substringWithRange:subRange];
    }
    return result;
}


- (NSString *)session:(NSString *)msg
{
    return [self content:msg
                  prefix:@"<session>"
                  suffix:@"</session>"];
}

- (NSString *)revokeTip:(NSString *)msg
{
    return [self content:msg
                  prefix:@"<replacemsg><![CDATA["
                  suffix:@"]]></replacemsg>"];
}




- (void)fireNotification:(NSString *)title
                 content:(NSString *)content
{
    NSString *notificationTitle     = title;
    NSString *notificationContent   = [NSString stringWithFormat:@"%@，快去看看吧",content];
    [_notificationManager fire:notificationTitle
                       content:notificationContent];
}

@end
