//
//  M80MessageCache.h
//  WeChatPlugin
//
//  Created by amao on 2017/5/26.
//  Copyright © 2017年 xiangwangfeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface M80MessageCache : NSObject
- (void)receiveNormalMessage:(NSString *)session
                     msgData:(id)msgData;

- (NSString *)userIdByMessageId:(NSString *)messageId;
@end
