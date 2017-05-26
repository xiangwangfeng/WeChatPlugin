//
//  M80MessageHandler.m
//  WeChatPlugin
//
//  Created by amao on 2017/5/26.
//  Copyright © 2017年 xiangwangfeng. All rights reserved.
//

#import "M80MessageHandler.h"
#import "M80MessageCache.h"
#import "M80NotificationManager.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import <Cocoa/Cocoa.h>

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



@interface M80MessageHandler ()
@property (nonatomic,strong)    M80MessageCache *messageCache;
@property (nonatomic,strong)    M80NotificationManager *notificationManager;
@end

@implementation M80MessageHandler
+ (instancetype)sharedHandler
{
    static M80MessageHandler *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance =[[M80MessageHandler alloc] init];
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
    id MMServiceCenter = ((id (*)(id, SEL, id))objc_msgSend)(objc_getClass("MMServiceCenter"), @selector(defaultCenter),nil);
    id contactStorage = ((id (*)(id, SEL, id))objc_msgSend)(MMServiceCenter, @selector(getService:),objc_getClass("ContactStorage"));
    id contact = ((id (*)(id, SEL, NSString *))objc_msgSend)(contactStorage, @selector(GetContact:),userId);
    Ivar nicknameIvar = class_getInstanceVariable(objc_getClass("WCContactData"), "m_nsNickName");
    id nickname = object_getIvar(contact, nicknameIvar);
    return [nickname isKindOfClass:[NSString class]] ? nickname : nil;
}

- (NSString *)groupNameById:(NSString *)groupId
{
    id MMServiceCenter = ((id (*)(id, SEL, id))objc_msgSend)(objc_getClass("MMServiceCenter"), @selector(defaultCenter),nil);
    id groupStorage = ((id (*)(id, SEL, id))objc_msgSend)(MMServiceCenter, @selector(getService:),objc_getClass("GroupStorage"));
    id group = ((id (*)(id, SEL, NSString *))objc_msgSend)(groupStorage, @selector(GetGroupContact:),groupId);
    Ivar nicknameIvar = class_getInstanceVariable(objc_getClass("WCContactData"), "m_nsNickName");
    id groupName = object_getIvar(group, nicknameIvar);
    return [groupName isKindOfClass:[NSString class]] ? groupName : nil;

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
