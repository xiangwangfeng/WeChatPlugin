//
//  M80WeChatHeader.h
//  WeChatPlugin
//
//  Created by amao on 2017/5/26.
//  Copyright © 2017年 xiangwangfeng. All rights reserved.
//

#ifndef M80PluginHeader_h
#define M80PluginHeader_h


@interface WCContactData : NSObject
- (NSString *)m_nsNickName;
@end




@interface MMServiceCenter : NSObject
+ (id)defaultCenter;
- (id)getService:(Class)arg1;
@end


@interface MMService : NSObject
@end

@interface GroupStorage : MMService
- (WCContactData *)GetGroupContact:(NSString *)groupId;
@end

@interface ContactStorage : MMService
- (WCContactData *)GetSelfContact;
@end


@interface MessageService : MMService
- (void)OnSyncBatchAddMsgs:(NSArray *)arg1 isFirstSync:(BOOL)arg2;
- (id)SendTextMessage:(id)arg1 toUsrName:(id)arg2 msgText:(id)arg3 atUserList:(id)arg4;
@end

#endif /* M80PluginHeader_h */
