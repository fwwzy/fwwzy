//
//  ROneVideoPlayVC.m
//  Hema
//
//  Created by geyang on 15/10/28.
//  Copyright © 2015年 Hemaapp. All rights reserved.
//

#import "ROneVideoPlayVC.h"
#import "KrVideoPlayerController.h"

@interface ROneVideoPlayVC ()
@property(nonatomic,strong)KrVideoPlayerController *playVC;
@property(nonatomic,strong)HemaButton *backBtn;
@end

@implementation ROneVideoPlayVC

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
    //状态栏背景颜色
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UI_View_Width, 20)];
    [topView setBackgroundColor:[UIColor blackColor]];
    [self.view addSubview:topView];
    
    NSLog(@"视频地址：%@",_urlStr);
    
    //播放器
    NSURL *url = [NSURL URLWithString:_urlStr?_urlStr:@"http://www.hm5m.com/download/1.mp4"];
    if (_isLocal)
    {
        url = [[NSURL alloc]initFileURLWithPath:_urlStr?_urlStr:@"http://www.hm5m.com/download/1.mp4"];
    }
    [self addVideoPlayerWithURL:url];
    
    //返回按钮
    _backBtn = [HemaButton buttonWithType:UIButtonTypeCustom];
    [_backBtn setFrame:CGRectMake(10, 30, 44, 44)];
    [_backBtn setBackgroundImage:[UIImage imageNamed:@"R小视频返回.png"] forState:UIControlStateNormal];
    [_backBtn setBackgroundImage:[UIImage imageNamed:@"R小视频返回高亮.png"] forState:UIControlStateHighlighted];
    [_backBtn addTarget:self action:@selector(leftbtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_backBtn];
}
#pragma mark- 自定义
#pragma mark 事件
-(void)leftbtnPressed:(id)sender
{
    [_playVC stop];
    [_playVC.view removeFromSuperview];
    _playVC = nil;
    [super leftbtnPressed:nil];
}
#pragma mark 方法
//添加播放器
- (void)addVideoPlayerWithURL:(NSURL *)url
{
    if (!_playVC)
    {
        _playVC = [[KrVideoPlayerController alloc] initWithFrame:CGRectMake(0, 20, UI_View_Width, UI_View_Width*(9.0/16.0))];
        __weak typeof(self)weakSelf = self;
        [_playVC setDimissCompleteBlock:^{
            weakSelf.playVC = nil;
        }];
        [_playVC setWillBackOrientationPortrait:^{
            [weakSelf toolbarHidden:NO];
        }];
        [_playVC setWillChangeToFullscreenMode:^{
            [weakSelf toolbarHidden:YES];
        }];
        [self.view addSubview:_playVC.view];
    }
    _playVC.contentURL = url;
}
//全屏时隐藏电池栏
- (void)toolbarHidden:(BOOL)Bool
{
    [[UIApplication sharedApplication] setStatusBarHidden:Bool withAnimation:UIStatusBarAnimationFade];
    
    if (Bool)
    {
        [_backBtn setHidden:YES];
    }else
    {
        [_backBtn setHidden:NO];
    }
}
@end
