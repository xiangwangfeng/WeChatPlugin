//
//  M80Util.m
//  WeChatPlugin
//
//  Created by amao on 2017/6/15.
//  Copyright © 2017年 xiangwangfeng. All rights reserved.
//

#import "M80Util.h"

@implementation M80Util
+ (NSString *)documentDir
{
    static NSString *dir = nil;
    if (dir == nil)
    {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
        dir = [[paths firstObject] stringByAppendingPathComponent:@"M80WeChatPlugin"];
        if (![[NSFileManager defaultManager] fileExistsAtPath:dir])
        {
            [[NSFileManager defaultManager] createDirectoryAtPath:dir
                                      withIntermediateDirectories:YES
                                                       attributes:nil
                                                            error:nil];
        }
    }
    return dir;
}
@end