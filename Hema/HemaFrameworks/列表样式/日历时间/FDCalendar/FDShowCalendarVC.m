//
//  FDShowCalendarVC.m
//  Hema
//
//  Created by LarryRodic on 15/10/17.
//  Copyright (c) 2015年 Hemaapp. All rights reserved.
//

#import "FDShowCalendarVC.h"
#import "FDCalendar.h"

@interface FDShowCalendarVC ()

@end

@implementation FDShowCalendarVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadSet];
}
-(void)loadSet
{
    [self.navigationItem setNewTitle:@"日历展示"];
    [self.navigationItem setRightItemWithTarget:self action:@selector(rightbtnPressed:) title:@"提示"];
    
    //第一种
    FDCalendar *calendar = [[FDCalendar alloc] initWithCurrentDate:[NSDate date]];
    CGRect frame = calendar.frame;
    frame.origin.y = 20;
    calendar.frame = frame;
    [self.view addSubview:calendar];
}
#pragma mark- 自定义
#pragma mark 事件
-(void)rightbtnPressed:(id)sender
{
    NSArray *items =
    @[MMItemMake(@"确定", MMItemTypeNormal, nil)];
    
    MMAlertView *alertView = [[MMAlertView alloc] initWithTitle:@"日历"
                                                         detail:@"更多日历样式请去\ncode.cocoachina.com下载"
                                                          items:items];
    alertView.attachedView = self.view;
    [alertView show];
}
@end
