//
//  RTwoVideoPlayVC.m
//  Hema
//
//  Created by geyang on 15/11/16.
//  Copyright © 2015年 Hemaapp. All rights reserved.
//

#import "RTwoVideoPlayVC.h"
#import "JZVideoPlayerView.h"

@interface RTwoVideoPlayVC ()<JZPlayerViewDelegate>
@property(nonatomic,strong)JZVideoPlayerView *jzPlayer;
@end

@implementation RTwoVideoPlayVC

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    LCPanNavigationController *nav = (LCPanNavigationController*)self.navigationController;
    [nav.panGestureRecognizer setEnabled:NO];
    
    [self.navigationController setNavigationBarHidden:YES];
}
-(void)viewWillDisappear:(BOOL)animated
{
    LCPanNavigationController *nav = (LCPanNavigationController*)self.navigationController;
    [nav.panGestureRecognizer setEnabled:YES];
    
    [self.navigationController setNavigationBarHidden:NO];
    [super viewWillDisappear:animated];
}
-(void)loadSet
{
    NSLog(@"视频地址：%@",_urlStr);
    
    NSURL *url = [NSURL URLWithString:_urlStr?_urlStr:@"http://www.hm5m.com/download/1.mp4"];
    _jzPlayer = [[JZVideoPlayerView alloc] initWithFrame:CGRectMake(0, 0, UI_View_Width, UI_View_Width*(9.0/16.0)) contentURL:url];
    _jzPlayer.delegate = self;
    [self.view addSubview:_jzPlayer];
    
    [_jzPlayer play];
    
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onDeviceOrientationChange)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil
     ];
}
#pragma mark- 方法
//屏幕旋转
- (void)onDeviceOrientationChange
{
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    UIInterfaceOrientation interfaceOrientation = (UIInterfaceOrientation)orientation;
    switch (interfaceOrientation)
    {
        case UIInterfaceOrientationPortraitUpsideDown:
        {
            NSLog(@"第3个旋转方向---电池栏在下");
        }
            break;
        case UIInterfaceOrientationPortrait:
        {
            NSLog(@"第0个旋转方向---电池栏在上");
        }
            break;
        case UIInterfaceOrientationLandscapeLeft:
        {
            NSLog(@"第2个旋转方向---电池栏在右");
        }
            break;
        case UIInterfaceOrientationLandscapeRight:
        {
            NSLog(@"第1个旋转方向---电池栏在左");
        }
            break;
        default:
            break;
    }
}
#pragma mark- JZPlayerViewDelegate
//强制横屏、自己写吧
-(void)playerViewZoomButtonClicked:(JZVideoPlayerView *)view
{
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)])
    {
        if (UIDeviceOrientationIsLandscape([[UIDevice currentDevice] orientation]))
        {
            
        }else
        {
            
        }
    }
}
//返回按钮
-(void)JZOnBackBtn
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
