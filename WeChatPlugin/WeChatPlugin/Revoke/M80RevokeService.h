//
//  M80RevokeService.h
//  WeChatPlugin
//
//  Created by amao on 2017/6/9.
//  Copyright © 2017年 xiangwangfeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface M80RevokeService : NSObject
- (void)receiveRevokedMessage:(id)msgData;
@end
