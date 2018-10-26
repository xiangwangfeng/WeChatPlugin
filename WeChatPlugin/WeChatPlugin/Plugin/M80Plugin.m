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
#import "M80DailyReportService.h"
#import "M80Util.h"




@interface M80Plugin ()
@property (nonatomic,strong)    M80RevokeService *revokeService;
@property (nonatomic,strong)    M80DailyReportService *reportService;

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
        _reportService = [[M80DailyReportService alloc] init];

    }
    return self;
}

- (void)start
{
    [self hookRevokeMsg];
    [self hookAuthOK];
    [self addListeners];
}

- (void)hookRevokeMsg
{
    Class cls = NSClassFromString(@"MessageService");
    SEL sel = NSSelectorFromString(@"onRevokeMsg:");
    
    id block = ^(id<AspectInfo> info,id msg) {
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
        NSLog(@"hook %@ %@ failed error %@",NSStringFromClass(cls),NSStringFromSelector(sel),error);
    }
}

- (void)hookAuthOK
{
    Class cls = NSClassFromString(@"MMMainWindowController");
    SEL sel = NSSelectorFromString(@"onAuthOK");

    id block = ^(id<AspectInfo> info) {
        NSLog(@"Plugin auth OK");
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.reportService report];
        });
        
    };
    
    NSError *error = nil;
    [cls aspect_hookSelector:sel
                 withOptions:AspectPositionAfter
                  usingBlock:block
                       error:&error];
    if (error)
    {
        NSLog(@"hook %@ %@ failed error %@",NSStringFromClass(cls),NSStringFromSelector(sel),error);
    }
}

- (void)addListeners
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onAppFinishLaunching:)
                                                 name:NSApplicationDidFinishLaunchingNotification
                                               object:nil];
}

- (void)onAppFinishLaunching:(NSNotification *)aNotification
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSMenu *helpMenu = [[NSApplication sharedApplication] helpMenu];
        {
            NSMenuItem *item = [[NSMenuItem alloc] initWithTitle:@"打开插件目录"
                                                          action:@selector(onOpenPluginDir:)
                                                   keyEquivalent:@"o"];
            item.target = self;
            [item setEnabled:YES];
            [helpMenu addItem:item];
            [helpMenu setAutoenablesItems:NO];
        }
    });
}

- (void)onOpenPluginDir:(NSMenuItem *)menuItem
{
    [[NSWorkspace sharedWorkspace] openFile:[M80Util documentDir]];
}

@end

