//
//  RInforVC.h
//  Hema
//
//  Created by LarryRodic on 15/10/7.
//  Copyright (c) 2015年 Hemaapp. All rights reserved.
//

#import "PullRefreshGroupVC.h"

@interface RInforVC : PullRefreshGroupVC
@property(nonatomic,copy)NSString *userId;//用户的主键
@property(nonatomic,assign)BOOL isRegister;//是否是注册进来的
@end