//
//  M80Util.h
//  WeChatPlugin
//
//  Created by amao on 2017/6/15.
//  Copyright © 2017年 xiangwangfeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface M80Util : NSObject
+ (NSString *)documentDir;
+ (BOOL)isLargerOrEqualVersion:(NSString *)version;
@end
