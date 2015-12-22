//
//  RVideoPlayFullVC.m
//  Hema
//
//  Created by LarryRodic on 15/10/20.
//  Copyright (c) 2015年 Hemaapp. All rights reserved.
//

#import "RVideoPlayFullVC.h"
#import "RVideoPlayVC.h"

@interface RVideoPlayFullVC ()<RVideoPlayDelegate>
@property(nonatomic,strong)RVideoPlayVC *movieVC;
@end

@implementation RVideoPlayFullVC
@synthesize movieVC;
@synthesize dataSource;
@synthesize isLocal;

-(void)dealloc
{
    if (movieVC.player)
    {
        [movieVC.player removeTimeObserver:movieVC.timeObserver];
        [movieVC.player replaceCurrentItemWithPlayerItem:nil];
        [[movieVC class] cancelPreviousPerformRequestsWithTarget:movieVC];
        movieVC.timeObserver = nil;
        movieVC.player = nil;
    }
    movieVC = nil;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [super viewWillDisappear:animated];
}
-(void)loadSet
{
    self.view.backgroundColor = BB_Back_Color_Here;
    
    if (isLocal)
    {
        NSURL *url = [NSURL URLWithString:[dataSource objectForKey:@"videourl"]];
        
        self.movieVC = [[RVideoPlayVC alloc]initWithURL:url movieTitle:@"播放视频" movieSize:@""];
    }else
    {
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/playlist.m3u8",[dataSource objectForKey:@"videourl"]]];
        
        NSString *videosize = @"";
        if (![HemaFunction xfunc_check_strEmpty:[dataSource objectForKey:@"videosize"]])
        {
            videosize = [NSString stringWithFormat:@"%@M",[dataSource objectForKey:@"videosize"]];
        }
        self.movieVC = [[RVideoPlayVC alloc]initWithURL:url movieTitle:[dataSource objectForKey:@"name"] movieSize:videosize];
    }
    self.movieVC.delegate = self;
    [self.movieVC.view setFrame:CGRectMake(0, 0, UI_View_Width, AllViewHeight)];
    [self.movieVC.view setClipsToBounds:YES];
    [self.view addSubview:self.movieVC.view];
    
    //全屏
    [self RVideoPlayFull];
}
-(void)loadData
{
    
}
#pragma mark- 自定义
#pragma mark 事件
-(void)leftBtnPressed:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - 视频委托
//返回
-(void)RVideoPlayBack
{
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [self leftBtnPressed:nil];
}
//全屏
-(void)RVideoPlayFull
{
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    [movieVC.view setFrame:CGRectMake(-(UI_View_Height+64-UI_View_Width)/2.0, (UI_View_Height+64-UI_View_Width)/2.0, UI_View_Height+64, UI_View_Width)];
    [movieVC fullChange];
    
    self.movieVC.view.transform = CGAffineTransformMakeRotation(M_PI/2);
}
//视频播放结束
-(void)RVideoPlayOver
{
    [self RVideoPlayBack];
}
@end
