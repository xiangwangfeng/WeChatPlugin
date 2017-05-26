//
//  M80Plugin.h
//  WeChatPlugin
//
//  Created by amao on 2017/5/26.
//  Copyright © 2017年 xiangwangfeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface M80Plugin : NSObject
+ (instancetype)shared;
- (void)receiveRevokedMessage:(NSString *)msg;
- (void)receiveNormalMessage:(NSString *)session
                     msgData:(id)msgData;
- (void)tryToAutoLogin;
@end
