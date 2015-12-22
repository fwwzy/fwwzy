//
//  RRootTBC.m
//  Hema
//
//  Created by LarryRodic on 15/10/5.
//  Copyright (c) 2015年 Hemaapp. All rights reserved.
//

#import "RRootTBC.h"
#import "LCPanNavigationController.h"

//项目调配
#import "RHomeVC.h"
#import "RNormalListVC.h"
#import "RSettingVC.h"
#import "RNewsVC.h"
#import "RPublishBlogVC.h"
#import "BFSystemSound.h"
#import "RPhotoBeautyHomeVC.h"

@interface RRootTBC ()
@property(nonatomic,strong)NSMutableArray *imgViewList;//按钮图片列表
@end

@implementation RRootTBC

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadSet];
}
-(void)loadSet
{
    //设置字体颜色
    UIColor *titleNormalColor = [UIColor blackColor];
    UIColor *titleSelectedColor = [UIColor orangeColor];
    
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       titleNormalColor, NSForegroundColorAttributeName,
                                                       nil] forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       titleSelectedColor, NSForegroundColorAttributeName,
                                                       nil] forState:UIControlStateSelected];
    
    //首页
    RHomeVC *oneVC = [[RHomeVC alloc] init];
    LCPanNavigationController *firstNav = [[LCPanNavigationController alloc] initWithRootViewController:oneVC];
    firstNav.tabBarItem.tag = 0;
    firstNav.tabBarItem.title = @"首页";
    firstNav.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, -1);
    firstNav.tabBarItem.image = [[UIImage imageNamed:@"首页_黑.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    firstNav.tabBarItem.selectedImage = [[UIImage imageNamed:@"首页_on.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    //消息
    RNewsVC *twoVC = [[RNewsVC alloc] init];
    LCPanNavigationController *secondNav = [[LCPanNavigationController alloc] initWithRootViewController:twoVC];
    secondNav.tabBarItem.tag = 1;
    secondNav.tabBarItem.title = @"发现";
    secondNav.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, -1);
    secondNav.tabBarItem.image = [[UIImage imageNamed:@"发现_黑.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    secondNav.tabBarItem.selectedImage = [[UIImage imageNamed:@"发现_on.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    //美图
    RPhotoBeautyHomeVC *threeVC = [[RPhotoBeautyHomeVC alloc] init];
    LCPanNavigationController *thirdNav = [[LCPanNavigationController alloc] initWithRootViewController:threeVC];
    thirdNav.tabBarItem.tag = 2;
    thirdNav.tabBarItem.title = @"VIP";
    thirdNav.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, -1);
    thirdNav.tabBarItem.image = [[UIImage imageNamed:@"VIP_黑.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    thirdNav.tabBarItem.selectedImage = [[UIImage imageNamed:@"VIP_on.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    //个人
    RSettingVC *foreVC = [[RSettingVC alloc] init];
    LCPanNavigationController *fourthNav = [[LCPanNavigationController alloc] initWithRootViewController:foreVC];
    fourthNav.tabBarItem.tag = 3;
    fourthNav.tabBarItem.title = @"我的";
    fourthNav.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, -1);
    fourthNav.tabBarItem.image = [[UIImage imageNamed:@"我的_黑.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    fourthNav.tabBarItem.selectedImage = [[UIImage imageNamed:@"我的_on.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    NSMutableArray *list = [[NSMutableArray alloc] initWithObjects:firstNav,secondNav,thirdNav,fourthNav, nil];
    self.viewControllers = list;
    
    /*
    //设置图片与按钮
    _imgViewList = [[NSMutableArray alloc]init];
    
    float width = UI_View_Width/5;
    float height = self.tabBar.frame.size.height;
    
    for (int i = 0; i<5; i++)
    {
        //背景图片
        UIImageView *myImgView = [[UIImageView alloc] init];
        myImgView.contentMode = UIViewContentModeScaleAspectFit;
        [self.tabBar addSubview:myImgView];
        
        //按钮
        UIButton* myBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [myBtn addTarget:self action:@selector(bottomBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.tabBar addSubview:myBtn];
        
        if (i != 2)
        {
            [myImgView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"R底部栏未选中%d.png",i]]];
            [myImgView setHighlightedImage:[UIImage imageNamed:[NSString stringWithFormat:@"R底部栏选中%d.png",i]]];
            [myImgView setFrame:CGRectMake(width*i, 0, width, height)];
            [_imgViewList addObject:myImgView];
            
            if (i < 2)
            {
                myBtn.tag = i;
            }else
            {
                 myBtn.tag = i-1;
            }
        }else
        {
            [myImgView setImage:[UIImage imageNamed:@"R底部栏发布按钮.png"]];
            [myImgView setFrame:CGRectMake(width*i, -10.5, width, height+11)];
            myBtn.tag = 10;
        }
        [myBtn setFrame:myImgView.frame];
    }
    */
    [self liSelectIndex:0];
    
    //设置颜色
    [self.tabBar setTintColor:RGB_UI_COLOR(247, 247, 247)];
    //[self.tabBar setBackgroundImage:[UIImage mm_imageWithColor:RGB_UI_COLOR(52, 55, 62) Size:self.tabBar.frame.size]];
    [self.tabBar setShadowImage:[UIImage mm_imageWithColor:[UIColor clearColor] Size:CGSizeMake(UI_View_Width, 0.7)]];
}
#pragma mark- 自定义
#pragma mark 事件
//按钮点击
-(void)bottomBtnPressed:(UIButton*)sender
{
    if (sender.tag == 10)
    {
        [self publishBlog];
        return;
    }
    [self liSelectIndex:(int)sender.tag];
}
#pragma mark 方法
//实现切换
- (void)liSelectIndex:(int)index
{
    NSLog(@"点击：%d",index);
    self.selectedIndex = index;
    /*
    for(UIImageView *imgView in _imgViewList)
    {
        [imgView setHighlighted:NO];
    }
    UIImageView *imgView = [_imgViewList objectAtIndex:index];
    [imgView setHighlighted:YES];
     */
}
//发布帖子
-(void)publishBlog
{
    [BFSystemSound playSystemSound:AudioIDShake];
    
    RPublishBlogVC *myVC = [[RPublishBlogVC alloc]init];
    myVC.publishBlogOK = ^(RPublishBlogVC *publishVC)
    {
        NSLog(@"帖子发布完成");
    };
    LCPanNavigationController *nav = [[LCPanNavigationController alloc]initWithRootViewController:myVC];
    [self presentViewController:nav animated:YES completion:nil];
}
@end
