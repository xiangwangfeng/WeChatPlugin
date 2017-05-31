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

    hookRevoke();

    
}


__attribute__((constructor))
static void initializer(void) {
    NSLog(@"inject plugin begin");
    injection();
    NSLog(@"inject plugin end");
}
