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
#import "M80Plugin.h"

static void hookApp()
{
    Class cls = NSClassFromString(@"AppDelegate");
    SEL sel = NSSelectorFromString(@"applicationDidFinishLaunching:");
    
    id block = ^(id<AspectInfo> info,id arg) {
        NSLog(@"Plugin launch %@",arg);
        [[M80Plugin shared] tryToAutoLogin];
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

static void hookMsg()
{
    Class cls = NSClassFromString(@"MMChatMessageDataSource");
    SEL sel = NSSelectorFromString(@"onAddMsg:msgData:");
    
    id block = ^(id<AspectInfo> info,NSString *sessionId,id data) {
        
        NSLog(@"Plugin recv session %@ %@",sessionId,data);
        [[M80Plugin shared]  receiveNormalMessage:sessionId
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

static void hookRevoke()
{
    Class cls = NSClassFromString(@"MessageService");
    SEL sel = NSSelectorFromString(@"onRevokeMsg:");
    
    id block = ^(id<AspectInfo> info,NSString *msg) {
        NSLog(@"Plugin revoke %@",msg);
        [[M80Plugin shared]  receiveRevokedMessage:msg];
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

static void injection() {

    //hookApp();
    hookMsg();
    hookRevoke();

    
}


__attribute__((constructor))
static void initializer(void) {
    NSLog(@"inject plugin begin");
    injection();
    NSLog(@"inject plugin end");
}
