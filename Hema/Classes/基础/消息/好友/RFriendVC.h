//
//  RFriendVC.h
//  Hema
//
//  Created by LarryRodic on 15/10/8.
//  Copyright (c) 2015年 Hemaapp. All rights reserved.
//

#import "PullRefreshPlainVC.h"

@interface RFriendVC : PullRefreshPlainVC
@property(nonatomic,copy)NSString *keyword;//搜索自己的好友

//调取列表
- (void)requestGetFriendList;
@end
