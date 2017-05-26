//
//  M80MessageCache.m
//  WeChatPlugin
//
//  Created by amao on 2017/5/26.
//  Copyright © 2017年 xiangwangfeng. All rights reserved.
//

#import "M80MessageCache.h"
#import "M80PluginHeader.h"



@interface M80MessageCache ()
@property (nonatomic,strong)    NSMutableDictionary *messageIds;
@end

@implementation M80MessageCache

- (instancetype)init
{
    if (self = [super init])
    {
        _messageIds = @{}.mutableCopy;
    }
    return self;
}

- (void)receiveNormalMessage:(NSString *)session
                     msgData:(id)msgData
{
    if ([msgData isKindOfClass:M80Class(MessageData)])
    {
        MessageData* message = (MessageData *)msgData;
        NSString *username = [message fromUsrName];
        long long serverId = [message mesSvrID];
        
        if (username && serverId > 0)
        {
            NSString *key = [NSString stringWithFormat:@"%lld",serverId];
            _messageIds[key] = username;
        }
    }
    

}

- (NSString *)userIdByMessageId:(NSString *)messageId
{
    return [messageId length] ? _messageIds[messageId] : nil;
}
@end
