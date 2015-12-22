//
//  RVideoPlayFullVC.h
//  Hema
//
//  Created by LarryRodic on 15/10/20.
//  Copyright (c) 2015年 Hemaapp. All rights reserved.
//

#import "AllVC.h"

@interface RVideoPlayFullVC : AllVC
@property(nonatomic,strong)NSMutableDictionary *dataSource;
@property(nonatomic,assign)BOOL isLocal;//是否本地
@end

/*
 调用方法
 RVideoPlayFullVC *video = [[RVideoPlayFullVC alloc]init];
 video.isLocal = YES;
 video.dataSource = [[NSMutableDictionary alloc]initWithObjectsAndKeys:[temDic objectForKey:@"videourl"],@"videourl", nil];//这可扩展
 LCPanNavigationController *nav = [[LCPanNavigationController alloc]initWithRootViewController:video];
 [self presentViewController:nav animated:YES completion:nil];
*/