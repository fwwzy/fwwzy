//
//  TabBarController.m
//  Hema
//
//  Created by MsTail on 15/12/23.
//  Copyright © 2015年 Hemaapp. All rights reserved.
//

#import "TabBarController.h"
#import "LCPanNavigationController.h"
#import "HomePageVC.h"
#import "ShopCartVC.h"
#import "NewPublishVC.h"
#import "MineVC.h"

@interface TabBarController ()
@property(nonatomic,strong)NSMutableArray *imgViewList;//按钮图片列表
@end

@implementation TabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSet];
}

-(void)loadSet {
    
    HomePageVC *homePageVC = [[HomePageVC alloc] init];
    LCPanNavigationController *homePageNav = [[LCPanNavigationController alloc] initWithRootViewController:homePageVC];
    homePageNav.tabBarItem.tag = 0;
    
    NewPublishVC *newPublishVC = [[NewPublishVC alloc] init];
    LCPanNavigationController *newPublishNav = [[LCPanNavigationController alloc] initWithRootViewController:newPublishVC];
    newPublishNav.tabBarItem.tag = 1;
    
    ShopCartVC *shopCartVC = [[ShopCartVC alloc] init];
    LCPanNavigationController *shopCartNav = [[LCPanNavigationController alloc] initWithRootViewController:shopCartVC];
    shopCartNav.tabBarItem.tag = 2;
    
    MineVC *mineVC = [[MineVC alloc] init];
    LCPanNavigationController *mineNav = [[LCPanNavigationController alloc] initWithRootViewController:mineVC];
    mineNav.tabBarItem.tag = 3;
    
    NSMutableArray *list = [[NSMutableArray alloc] initWithObjects:homePageNav,newPublishNav,shopCartNav,mineNav, nil];
    self.viewControllers = list;
    
    float width = UI_View_Width/4;
    float height = self.tabBar.frame.size.height;
    
    for (int i = 0; i < 4; i++) {
        
        //背景图片
        UIImageView *myImgView = [[UIImageView alloc] init];
        myImgView.contentMode = UIViewContentModeScaleAspectFit;
        [self.tabBar addSubview:myImgView];
        
        //按钮
        UIButton* myBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [myBtn addTarget:self action:@selector(bottomBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.tabBar addSubview:myBtn];
        myBtn.tag = i;
        
        //添加图片
        [myImgView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"R底部栏未选中%d.png",i]]];
        [myImgView setHighlightedImage:[UIImage imageNamed:[NSString stringWithFormat:@"R底部栏选中%d.png",i]]];
        [myImgView setFrame:CGRectMake(width*i, 0, width, height)];
        [_imgViewList addObject:myImgView];
        [myBtn setFrame:myImgView.frame];
    }
    
    //设置颜色
    [self.tabBar setBackgroundImage:[UIImage mm_imageWithColor:RGB_UI_COLOR(52, 55, 62) Size:self.tabBar.frame.size]];
    [self.tabBar setShadowImage:[UIImage mm_imageWithColor:[UIColor clearColor] Size:CGSizeMake(UI_View_Width, 0.7)]];
}

#pragma mark- 自定义
#pragma mark 事件
//按钮点击
-(void)bottomBtnPressed:(UIButton*)sender
{
    [self liSelectIndex:(int)sender.tag];
}

#pragma mark 方法
//实现切换
- (void)liSelectIndex:(int)index
{
    NSLog(@"点击：%d",index);
    self.selectedIndex = index;
    for(UIImageView *imgView in _imgViewList)
    {
        [imgView setHighlighted:NO];
    }
    UIImageView *imgView = [_imgViewList objectAtIndex:index];
    [imgView setHighlighted:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
