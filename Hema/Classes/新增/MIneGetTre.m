//
//  MIneGetTre.m
//  Hema
//
//  Created by Lsy on 16/1/8.
//  Copyright © 2016年 Hemaapp. All rights reserved.
//

#import "MIneGetTre.h"
#import "MineGetTreAll.h"
#import "MineGetTreing.h"
#import "MineGetTreed.h"
#import "SCNavTabBarController.h"

@interface MIneGetTre ()

@end

@implementation MIneGetTre

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
}

-(void)loadSet{
    [self.navigationItem setNewTitle:@"夺宝记录"];
    //左按钮
    [self.navigationItem setLeftItemWithTarget:self action:@selector(leftbtnPressed:) image:@"lg_back"];
    
    MineGetTreAll *oneViewController = [[MineGetTreAll alloc] init];
    oneViewController.title = @"全部";
    
    
    MineGetTreing *twoViewController = [[MineGetTreing alloc] init];
    twoViewController.title = @"进行中";
    
    
    MineGetTreed *threeViewController = [[MineGetTreed alloc] init];
    threeViewController.title = @"已揭晓";
    
    
    SCNavTabBarController *navTabBarController = [[SCNavTabBarController alloc] init];
    navTabBarController.subViewControllers = @[oneViewController, twoViewController, threeViewController];
//    navTabBarController.showArrowButton = YES;
    navTabBarController.navTabBarLineColor = BB_Red_Color;
    [navTabBarController addParentController:self];
}
-(void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;
}


@end
