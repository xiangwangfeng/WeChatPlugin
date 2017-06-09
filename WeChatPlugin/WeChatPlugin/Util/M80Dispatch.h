//
//  M80Dispatch.h
//  WeChatPlugin
//
//  Created by amao on 2017/6/9.
//  Copyright © 2017年 xiangwangfeng. All rights reserved.
//

#ifndef M80Dispatch_h
#define M80Dispatch_h

static void M80MainAsync(dispatch_block_t block)
{
    if ([NSThread isMainThread])
    {
        block();
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), block);
    }
}



#endif /* M80Dispatch_h */
