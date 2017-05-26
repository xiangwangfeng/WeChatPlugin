//
//  M80NotificationManager.h
//  WeChatPlugin
//
//  Created by amao on 2017/5/26.
//  Copyright © 2017年 xiangwangfeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface M80NotificationManager : NSObject<NSUserNotificationCenterDelegate>
@property (nonatomic,weak)  id<NSUserNotificationCenterDelegate> delegate;

- (void)fire:(NSString *)title
     content:(NSString *)content;
@end
