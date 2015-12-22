//
//  HemaManager.h
//  Hema
//
//  Created by LarryRodic on 15/10/5.
//  Copyright (c) 2015年 Hemaapp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HemaManager : NSObject
@property(nonatomic,strong)NSMutableArray *rootArr;//window的rootViewController的集合
@property(nonatomic,strong)NSMutableDictionary* pushDic;//从推送打开软件，收到的消息保存
@property(nonatomic,strong)NSMutableDictionary* myInfor;//保存登录后的用户信息
@property(nonatomic,strong)NSMutableDictionary *myInitInfor;//系统初始化
@property(nonatomic,strong)NSMutableDictionary *fromDic;//注册信息的保存
@property(nonatomic,copy)NSString *userToken;//登录令牌

//消息屏蔽的信息存储
@property(nonatomic,strong)NSMutableArray *memberArr;//成员
@property(nonatomic,strong)NSMutableArray *groupArr;//群组

+(id)sharedManager;
-(void)resSetRootArr:(id)root;//重设rootArr
@end
