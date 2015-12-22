//
//  AllVC.m
//  BiaoBiao
//
//  Created by 平川嘉恒 on 14-4-24.
//  Copyright (c) 2014年 平川嘉恒. All rights reserved.
//

#import "AllVC.h"

@interface AllVC ()

@end

@implementation AllVC

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationLanguageChanged object:nil];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.navigationController.viewControllers.count == 1)
    {
        [self.navigationController.navigationBar setBarTintColor:Nav_Color];
        [self.navigationController.navigationBar setTranslucent:NO];
    }
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadAll];
    if (!isPullRefresh)
    {
        [self loadData];
        [self loadSet];
    }
}
-(void)loadAll
{
    self.edgesForExtendedLayout= UIRectEdgeNone;
    self.view.backgroundColor = BB_Back_Color_Here;
    
    if (self.navigationController.viewControllers.count > 1)
    {
        [self.navigationItem setLeftItemWithTarget:self action:@selector(leftbtnPressed:) image:BackImgName];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveLanguageChangedNotification:)
                                                 name:kNotificationLanguageChanged
                                               object:nil];
}
-(void)loadSet
{
    
}
-(void)loadData
{
    
}
#pragma mark- 自定义
#pragma mark 事件
-(void)leftbtnPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark 方法
//配置多语言，父类继承
-(void)configureViewFromLocalisation
{
    
}
#pragma mark- 多语言切换通知
- (void) receiveLanguageChangedNotification:(NSNotification *) notification
{
    if ([notification.name isEqualToString:kNotificationLanguageChanged])
    {
        [self configureViewFromLocalisation];
    }
}
@end
