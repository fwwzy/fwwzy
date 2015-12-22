//
//  ShareFunction.h
//  Hema
//
//  Created by LarryRodic on 15/10/7.
//  Copyright (c) 2015年 Hemaapp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShareFunction : NSObject
+(void)initializePlat;//分享平台配置
+(id<ISSContent>)getContent:(NSInteger)keytype dataDic:(NSMutableDictionary*)dataDic myVC:(UIViewController*)myVC;//分享的内容
+(void)yourShare:(ShareType)shareType content:(id<ISSContent>)content;//自定义分享
+(void)share:(NSInteger)keytype dataDic:(NSMutableDictionary*)dataDic myVC:(UIViewController*)myVC;//默认分享 keytype 1 软件本身 2 帖子
@end
