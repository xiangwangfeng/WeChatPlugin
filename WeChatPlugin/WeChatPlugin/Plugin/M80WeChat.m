//
//  M80WeChat.m
//  WeChatPlugin
//
//  Created by amao on 2017/6/14.
//  Copyright © 2017年 xiangwangfeng. All rights reserved.
//

#import "M80WeChat.h"
#import <objc/runtime.h>


@implementation M80WeChat
+ (instancetype)shared
{
    static M80WeChat *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[M80WeChat alloc] init];
    });
    return instance;
}

- (NSString *)teamNameById:(NSString *)teamId
{
    GroupStorage *storage = [[objc_getClass("MMServiceCenter") defaultCenter] getService:objc_getClass("GroupStorage")];
    WCContactData *data = [storage GetGroupContact:teamId];
    NSString *nickname = [data m_nsNickName];
    return [nickname isKindOfClass:[NSString class]] ? nickname : nil;
}


- (void)sendMessage:(NSString *)content
          toSession:(NSString *)sessionId
{
    ContactStorage *contactStorage = [[objc_getClass("MMServiceCenter") defaultCenter] getService:objc_getClass("ContactStorage")];
    WCContactData *selfContact = [contactStorage GetSelfContact];
    MessageService *service = [[objc_getClass("MMServiceCenter") defaultCenter] getService:objc_getClass("MessageService")];
    [service SendTextMessage:selfContact.m_nsNickName
                   toUsrName:sessionId
                     msgText:content
                  atUserList:nil];
}
@end
