//
//  RGroupAddVC.h
//  Hema
//
//  Created by LarryRodic on 15/10/11.
//  Copyright (c) 2015年 Hemaapp. All rights reserved.
//

#import "PullRefreshGroupVC.h"

@protocol RGroupAddDelegate;
@interface RGroupAddVC : PullRefreshGroupVC
@property(nonatomic,assign)NSObject<RGroupAddDelegate>* delegate;
@property(nonatomic,strong)NSMutableArray *dataHave;//已经在群里的
@end

//返回时调用
@protocol RGroupAddDelegate <NSObject>
@required

@optional
-(void)RGroupAddOK:(NSMutableArray*)backArr;
@end