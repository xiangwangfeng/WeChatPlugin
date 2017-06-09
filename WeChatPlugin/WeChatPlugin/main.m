//
//  main.m
//  WeChatPlugin
//
//  Created by amao on 2017/5/26.
//  Copyright © 2017年 xiangwangfeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "M80Plugin.h"


__attribute__((constructor))
static void initializer(void) {
    NSLog(@"plugin begin");
    [[M80Plugin shared] start];
    NSLog(@"plugin end");
}
