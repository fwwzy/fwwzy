//
//  RLeftSlideVC.m
//  Hema
//
//  Created by LarryRodic on 15/10/8.
//  Copyright (c) 2015年 Hemaapp. All rights reserved.
//

#import "RLeftSlideVC.h"
#import "MMDrawerController.h"
#import "LeftSlideViewController.h"
#import "RRootTBC.h"
#import "RMoreFunctionVC.h"
#import "REFrostedViewController.h"

@interface RLeftSlideVC ()

@end

@implementation RLeftSlideVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadSet];
}
-(void)loadSet
{
    [self forbidPullRefresh];
    [self reSetTableViewFrame:CGRectMake(0, 0, UI_View_Width, UI_View_Height+64)];
    
    //三级导航或QQ侧滑设置
    self.view.backgroundColor = BB_White_Color;
    
    HemaButton *myBtn = [HemaButton buttonWithType:UIButtonTypeCustom];
    [myBtn setFrame:CGRectMake(40, (UI_View_Height+64-40)/2, UI_View_Width-70-80, 40)];
    [HemaFunction addbordertoView:myBtn radius:4.0 width:1.0 color:BB_Blue_Color];
    [myBtn setTitle:@"切换" forState:UIControlStateNormal];
    [myBtn setBackgroundColor:BB_White_Color];
    [myBtn setTitleColor:BB_Orange_Color forState:UIControlStateNormal];
    [myBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [myBtn addTarget:self action:@selector(changePressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:myBtn];
}
#pragma mark- 自定义
#pragma mark 事件
-(void)changePressed:(id)sender
{
    //三级导航
    if ([[HemaFunction xfuncGetAppdelegate].window.rootViewController isKindOfClass:[MMDrawerController class]])
    {
        MMDrawerController *drawerController = (MMDrawerController*)[HemaFunction xfuncGetAppdelegate].window.rootViewController;
        [drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
        
        RRootTBC *root = (RRootTBC*)drawerController.centerViewController;
        [root liSelectIndex:3];
        LCPanNavigationController *nav = [root.viewControllers objectAtIndex:root.selectedIndex];
        
        RMoreFunctionVC *myVC = [[RMoreFunctionVC alloc]init];
        [nav pushViewController:myVC animated:NO];
    }
    //QQ侧滑
    if ([[HemaFunction xfuncGetAppdelegate].window.rootViewController isKindOfClass:[LeftSlideViewController class]])
    {
        LeftSlideViewController *leftSlideVC = (LeftSlideViewController*)[HemaFunction xfuncGetAppdelegate].window.rootViewController;
        [leftSlideVC closeLeftView];
        
        RRootTBC *root = (RRootTBC*)leftSlideVC.mainVC;
        [root liSelectIndex:3];
        LCPanNavigationController *nav = [root.viewControllers objectAtIndex:root.selectedIndex];
        
        RMoreFunctionVC *myVC = [[RMoreFunctionVC alloc]init];
        [nav pushViewController:myVC animated:NO];
    }
    //侧滑菜单
    if ([[HemaFunction xfuncGetAppdelegate].window.rootViewController isKindOfClass:[REFrostedViewController class]])
    {
        REFrostedViewController *leftSlideVC = (REFrostedViewController*)[HemaFunction xfuncGetAppdelegate].window.rootViewController;
        [leftSlideVC hideMenuViewController];
    }
}
@end
