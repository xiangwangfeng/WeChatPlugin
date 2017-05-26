//
//  M80PluginHeader.h
//  WeChatPlugin
//
//  Created by amao on 2017/5/26.
//  Copyright © 2017年 xiangwangfeng. All rights reserved.
//

#ifndef M80PluginHeader_h
#define M80PluginHeader_h


#define M80Class(classname) objc_getClass(#classname)

@interface MessageData : NSObject
- (NSString *)fromUsrName;
- (long long)mesSvrID;
- (Class)class;
@end

@interface WCContactData : NSObject
- (NSString *)m_nsNickName;
@end


@interface MMServiceCenter : NSObject
+ (id)defaultCenter;
- (id)getService:(Class)arg1;
@end


@interface MMService : NSObject
@end


@interface ContactStorage : MMService
- (WCContactData *)GetContact:(NSString *)userId;
@end


@interface GroupStorage : MMService
- (WCContactData *)GetGroupContact:(NSString *)groupId;
@end

@interface AccountService : MMService
- (BOOL)canAutoAuth;
- (void)AutoAuth;
@end


#endif /* M80PluginHeader_h */
