//
//  M80Plugin.m
//  WeChatPlugin
//
//  Created by amao on 2017/5/26.
//  Copyright © 2017年 xiangwangfeng. All rights reserved.
//

#import "M80Plugin.h"
#import "M80MessageCache.h"
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
@property (nonatomic,strong)    M80MessageCache *messageCache;
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
        _messageCache = [[M80MessageCache alloc] init];
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


- (void)receiveNormalMessage:(NSString *)session
                     msgData:(id)msgData
{
    
    M80MainAsync(^{
        [_messageCache receiveNormalMessage:session
                                    msgData:msgData];
    });
}

- (void)tryToAutoLogin
{
    AccountService *service = [[M80Class(MMServiceCenter) defaultCenter] getService:M80Class(AccountService)];
    if ([service canAutoAuth])
    {
        [service AutoAuth];
    }

}


#pragma mark - misc
- (void)revoke:(NSString *)msg
{
    NSString *groupName = nil;
    NSString *nickname = nil;
    
    NSString *session = [self session:msg];
    NSString *messageId = [self msgId:msg];
    
    if ([session length] && [messageId length])
    {
        NSString *fromId = [_messageCache userIdByMessageId:messageId];
        if (fromId)
        {
            nickname = [self nicknameById:fromId];
        }
        
        if ([session rangeOfString:@"@chatroom"].location != NSNotFound)
        {
            groupName = [self groupNameById:session];
        }
    }
    [self fireNotification:groupName
                  nickname:nickname];
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

- (NSString *)msgId:(NSString *)msg
{
    return [self content:msg
                  prefix:@"<newmsgid>"
                  suffix:@"</newmsgid>"];
}

- (NSString *)session:(NSString *)msg
{
    return [self content:msg
                  prefix:@"<session>"
                  suffix:@"</session>"];
}

- (NSString *)nicknameById:(NSString *)userId
{
    ContactStorage *storage = [[M80Class(MMServiceCenter) defaultCenter] getService:M80Class(ContactStorage)];
    WCContactData *data = [storage GetContact:userId];
    NSString *nickname = [data m_nsNickName];
    return [nickname isKindOfClass:[NSString class]] ? nickname : nil;
}

- (NSString *)groupNameById:(NSString *)groupId
{
    GroupStorage *storage = [[M80Class(MMServiceCenter) defaultCenter] getService:M80Class(GroupStorage)];
    WCContactData *data = [storage GetGroupContact:groupId];
    NSString *nickname = [data m_nsNickName];
    return [nickname isKindOfClass:[NSString class]] ? nickname : nil;
}


- (void)fireNotification:(NSString *)title
                nickname:(NSString *)nickname
{
    NSString *notificationTitle = [title length] ? title : @"撤回通知";
    NSString *content = [NSString stringWithFormat:@"%@撤回了一条消息，快去看看吧",[nickname length] ? nickname : @"有人"];
    [_notificationManager fire:notificationTitle
                       content:content];
}

@end

