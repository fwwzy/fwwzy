//
//  RMyChatVC.h
//  Hema
//
//  Created by LarryRodic on 15/10/10.
//  Copyright (c) 2015年 Hemaapp. All rights reserved.
//

#import "PullRefreshChatVC.h"

@interface RMyChatVC : PullRefreshChatVC
@property(nonatomic,assign)BOOL isChatGroup;//是否群聊
@property(nonatomic,strong)NSMutableDictionary *dataSource;//对方信息 如果是群聊 则是群资料信息 id nickname avatar 这三个 单聊 client_id要转成id nickname 群聊 id name
- (instancetype)initWithChatter:(NSString *)p_chatter;//创建要调取这个
@end
