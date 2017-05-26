//
//  main.m
//  WeChatPlugin
//
//  Created by amao on 2017/5/26.
//  Copyright © 2017年 xiangwangfeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import <objc/message.h>
#import <Cocoa/Cocoa.h>
#import "Aspects.h"
#import "M80MessageHandler.h"

static void injection() {

    {
        Class cls = NSClassFromString(@"MessageService");
        SEL sel = NSSelectorFromString(@"onRevokeMsg:");
        
        id block = ^(id<AspectInfo> info,NSString *msg) {
            NSLog(@"Plugin revoke %@",msg);
            [[M80MessageHandler sharedHandler] receiveRevokedMessage:msg];
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
    
    
    {
        Class cls = NSClassFromString(@"MMChatMessageDataSource");
        SEL sel = NSSelectorFromString(@"onAddMsg:msgData:");
        
        id block = ^(id<AspectInfo> info,NSString *sessionId,id data) {
            
            NSLog(@"Plugin recv session %@ %@",sessionId,data);
            [[M80MessageHandler sharedHandler] receiveNormalMessage:sessionId
                                                            msgData:data];
    
        };
        
        NSError *error = nil;
        [cls aspect_hookSelector:sel
                     withOptions:AspectPositionAfter
                      usingBlock:block
                           error:&error];
        if (error)
        {
            NSLog(@"hook %@ failed error %@",NSStringFromSelector(sel),error);
        }
    }

    
    
}


__attribute__((constructor))
static void initializer(void) {
    NSLog(@"inject plugin begin");
    injection();
    NSLog(@"inject plugin end");
}
