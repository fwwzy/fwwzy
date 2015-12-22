//
//  RPublishBlogVC.h
//  Hema
//
//  Created by LarryRodic on 15/10/18.
//  Copyright (c) 2015年 Hemaapp. All rights reserved.
//

#import "PullRefreshGroupVC.h"

@interface RPublishBlogVC : PullRefreshGroupVC
@property(nonatomic,strong)void(^publishBlogOK)(RPublishBlogVC *publishVC);//发布完成block回调
@end
 