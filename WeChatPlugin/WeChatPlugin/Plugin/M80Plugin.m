//
//  M80Plugin.m
//  WeChatPlugin
//
//  Created by amao on 2017/5/26.
//  Copyright © 2017年 xiangwangfeng. All rights reserved.
//

#import "M80Plugin.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import <Cocoa/Cocoa.h>
#import "Aspects.h"
#import "M80RevokeService.h"




@interface M80Plugin ()
@property (nonatomic,strong)    M80RevokeService *revokeService;

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
        _revokeService = [[M80RevokeService alloc] init];

    }
    return self;
}

- (void)start
{
    [self hookRevokeMsg];
}

- (void)hookRevokeMsg
{
    Class cls = NSClassFromString(@"MessageService");
    SEL sel = NSSelectorFromString(@"onRevokeMsg:");
    
    id block = ^(id<AspectInfo> info,NSString *msg) {
        NSLog(@"Plugin revoke %@",msg);
        [self.revokeService receiveRevokedMessage:msg];
    };
    
    NSError *error = nil;
    [cls aspect_hookSelector:sel
                 withOptions:AspectPositionInstead
                  usingBlock:block
                       error:&error];
    if (error)
    {
        NSLog(@"hook %@ failed error %@",NSStringFromSelector(sel),error);
    }
}



@end

