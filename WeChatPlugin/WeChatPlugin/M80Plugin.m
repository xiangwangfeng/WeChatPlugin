//
//  M80Plugin.m
//  WeChatPlugin
//
//  Created by amao on 2017/5/26.
//  Copyright © 2017年 xiangwangfeng. All rights reserved.
//

#import "M80Plugin.h"
#import "M80NotificationManager.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import <Cocoa/Cocoa.h>
#import "M80PluginHeader.h"

void M80MainAsync(dispatch_block_t block)
{
    if ([NSThread isMainThread])
    {
        block();
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), block);
    }
}



@interface M80Plugin ()
@property (nonatomic,strong)    M80NotificationManager *notificationManager;
@end

@implementation M80Plugin
+ (instancetype)shared
{
    static M80Plugin *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance =[[M80Plugin alloc] init];
    });
    return instance;
}

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
            NSString *groupName = [self groupNameById:session];
            if ([groupName length])
            {
                title = groupName;
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



- (NSString *)groupNameById:(NSString *)groupId
{
    GroupStorage *storage = [[M80Class(MMServiceCenter) defaultCenter] getService:M80Class(GroupStorage)];
    WCContactData *data = [storage GetGroupContact:groupId];
    NSString *nickname = [data m_nsNickName];
    return [nickname isKindOfClass:[NSString class]] ? nickname : nil;
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

