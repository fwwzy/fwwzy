//
//  HemaManager.m
//  Hema
//
//  Created by LarryRodic on 15/10/5.
//  Copyright (c) 2015年 Hemaapp. All rights reserved.
//

#import "HemaManager.h"

static HemaManager *sharedMyManager = nil;
@implementation HemaManager

#pragma mark 单例模式
+ (id)sharedManager
{
    @synchronized(self)
    {
        if(sharedMyManager == nil)
            sharedMyManager = [[super allocWithZone:NULL] init];
    }
    return sharedMyManager;
}
+ (id)allocWithZone:(NSZone *)zone
{
    return [self sharedManager];
}
- (id)copyWithZone:(NSZone *)zone
{
    return self;
}
- (id)init
{
    if (self = [super init])
    {
        _fromDic = [[NSMutableDictionary alloc]init];
        _rootArr = [[NSMutableArray alloc]init];
    }
    return self;
}
-(void)resSetRootArr:(id)root
{
    [_rootArr addObject:root];
    if (_rootArr.count > 1)
    {
        id lastRoot = [_rootArr objectAtIndex:0];
        lastRoot = nil;
    }
}
@end
