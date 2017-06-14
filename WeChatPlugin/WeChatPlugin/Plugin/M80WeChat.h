//
//  M80WeChat.h
//  WeChatPlugin
//
//  Created by amao on 2017/6/14.
//  Copyright © 2017年 xiangwangfeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "M80WeChatHeader.h"

@interface M80WeChat : NSObject
+ (instancetype)shared;

- (NSString *)teamNameById:(NSString *)teamId;

- (void)sendMessage:(NSString *)content
          toSession:(NSString *)sessionId;
@end
