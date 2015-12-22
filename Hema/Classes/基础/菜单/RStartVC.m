//
//  RStartVC.m
//  Hema
//
//  Created by LarryRodic on 15/10/6.
//  Copyright (c) 2015年 Hemaapp. All rights reserved.
//
#define PAGENUM 4

#import "RStartVC.h"

@interface RStartVC ()
@property(nonatomic,strong)UIScrollView *imageScrollView;
@end

@implementation RStartVC

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadSet];
}
-(void)loadSet
{
    _imageScrollView = [[UIScrollView alloc]init];
    _imageScrollView.frame = CGRectMake(0, 0, UI_View_Width, UI_View_Height+64);
    _imageScrollView.bounces = NO;
    _imageScrollView.contentSize = CGSizeMake(PAGENUM * UI_View_Width, _imageScrollView.frame.size.height);
    _imageScrollView.pagingEnabled = YES;
    _imageScrollView.showsHorizontalScrollIndicator = NO;
    _imageScrollView.clipsToBounds = YES;
    [self.view addSubview:_imageScrollView];
    
    for (int i = 0; i < PAGENUM; i++)
    {
        NSString * fileName = [NSString stringWithFormat:@"引导页-4-0%d.png",i+1];
        if (!HM_ISIPHONE4)
        {
            fileName = [NSString stringWithFormat:@"引导页-5-0%d.png",i+1];
        }
        UIButton *imageButton = [[UIButton alloc] initWithFrame:CGRectMake(i * UI_View_Width,  0.0f, UI_View_Width, UI_View_Height+64)];
        [imageButton setBackgroundImage:[UIImage imageNamed:fileName] forState:UIControlStateNormal];
        [imageButton setBackgroundImage:[UIImage imageNamed:fileName] forState:UIControlStateHighlighted];
        imageButton.tag = 900 + i;
        [_imageScrollView addSubview:imageButton];
    }
    
    UIButton *enterBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    enterBtn1.tag = 4;
    [enterBtn1 addTarget:self action:@selector(gotoHome:) forControlEvents:UIControlEventTouchUpInside];
    enterBtn1.frame = CGRectMake((UI_View_Width-64)/2+UI_View_Width*(PAGENUM-1), UI_View_Height+64-200, 64, 200);
    [_imageScrollView addSubview:enterBtn1];
}
-(void)gotoHome:(UIButton*)sender
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    
    //自动登录时
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:BB_XCONST_ISAUTO_LOGIN] isEqualToString:@"yes"]&&![HemaFunction xfuncGetAppdelegate].isLogin)
    {
        [[HemaFunction xfuncGetAppdelegate]requestLogin];
    }else
    {
        [[HemaFunction xfuncGetAppdelegate]gotoRoot];
    }
}
@end
