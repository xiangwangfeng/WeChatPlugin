//
//  M80NotificationManager.m
//  WeChatPlugin
//
//  Created by amao on 2017/5/26.
//  Copyright © 2017年 xiangwangfeng. All rights reserved.
//

#import "M80NotificationManager.h"

#define M80NotificationPrefix   (@"m80_wechat_revoke")

@implementation M80NotificationManager
- (instancetype)init
{
    if (self = [super init])
    {
    }
    return self;
}


- (BOOL)userNotificationCenter:(NSUserNotificationCenter *)center shouldPresentNotification:(NSUserNotification *)notification
{
    if ([notification.identifier hasPrefix:M80NotificationPrefix])
    {
        return YES;
    }
    if (_delegate && [_delegate respondsToSelector:@selector(userNotificationCenter:shouldPresentNotification:)]) {
        
        return [_delegate userNotificationCenter:center
                       shouldPresentNotification:notification];
    }
    return YES;
}

- (void)userNotificationCenter:(NSUserNotificationCenter *)center didDeliverNotification:(NSUserNotification *)notification
{
    if (_delegate && [_delegate respondsToSelector:@selector(userNotificationCenter:didDeliverNotification:)]) {
        [_delegate userNotificationCenter:center
                   didDeliverNotification:notification];
    }
}

- (void)userNotificationCenter:(NSUserNotificationCenter *)center didActivateNotification:(nonnull NSUserNotification *)notification
{
    if (_delegate && [_delegate respondsToSelector:@selector(userNotificationCenter:didActivateNotification:)]) {
        [_delegate userNotificationCenter:center
                  didActivateNotification:notification];
    }
}

#pragma mark - api
- (void)fire:(NSString *)title
     content:(NSString *)content
{
    NSUserNotification *userNotification = [[NSUserNotification alloc] init];
    userNotification.title = title;
    userNotification.informativeText = content;
    userNotification.identifier = [NSString stringWithFormat:@"%@_%@",M80NotificationPrefix,[[NSUUID UUID] UUIDString]];
    
    NSUserNotificationCenter *center = [NSUserNotificationCenter defaultUserNotificationCenter];
    
    if (center.delegate != self)
    {
        self.delegate = center.delegate;
        center.delegate = self;
    }
    [center deliverNotification:userNotification];
}

@end

