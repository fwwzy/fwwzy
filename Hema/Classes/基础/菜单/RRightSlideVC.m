//
//  RRightSlideVC.m
//  Hema
//
//  Created by LarryRodic on 15/10/8.
//  Copyright (c) 2015年 Hemaapp. All rights reserved.
//

#import "RRightSlideVC.h"

@interface RRightSlideVC ()

@end

@implementation RRightSlideVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadSet];
}
-(void)loadSet
{
    [self forbidPullRefresh];
    [self reSetTableViewFrame:CGRectMake(0, 0, UI_View_Width, UI_View_Height+64)];
    
    self.view.backgroundColor = BB_Blake_Color;
}
@end
