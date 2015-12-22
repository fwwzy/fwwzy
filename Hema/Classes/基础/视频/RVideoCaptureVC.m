//
//  RVideoCaptureVC.m
//  Hema
//
//  Created by geyang on 15/11/5.
//  Copyright © 2015年 Hemaapp. All rights reserved.
//

#import "RVideoCaptureVC.h"
#import "AVCaptureManager.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "HemaTapGR.h"

@interface RVideoCaptureVC ()<AVCaptureManagerDelegate>
@property(nonatomic,strong)AVCaptureManager *captureManager;
@property(nonatomic,strong)HemaButton *okBtn;//点击按钮
@end

@implementation RVideoCaptureVC
@synthesize okBtn;

-(void)loadSet
{
    [self.navigationItem setNewTitle:@"视频录制"];
    [self.view setBackgroundColor:[UIColor blackColor]];
    
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UI_View_Width, UI_View_Width)];
    [self.view addSubview:backView];
    
    _captureManager = [[AVCaptureManager alloc] initWithPreviewView:backView];
    _captureManager.delegate = self;
    
    okBtn = [HemaButton buttonWithType:UIButtonTypeCustom];
    [okBtn setFrame:CGRectMake((UI_View_Width-160)/2, (UI_View_Height-UI_View_Width-160)/2+UI_View_Width, 160, 160)];
    [HemaFunction addbordertoView:okBtn radius:80 width:1 color:[UIColor cyanColor]];
    [okBtn setTitle:@"点击录制" forState:UIControlStateNormal];
    [okBtn setTitleColor:[UIColor cyanColor] forState:UIControlStateNormal];
    [okBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [okBtn addTarget:self action:@selector(okPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:okBtn];
    
    HemaTapGR *tapGesture = [[HemaTapGR alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    tapGesture.numberOfTapsRequired = 2;
    [backView addGestureRecognizer:tapGesture];
}
#pragma mark- 自定义
#pragma mark 事件
-(void)okPressed:(id)sender
{
    if (_captureManager.isRecording)
    {
        [_captureManager stopRecording];
        [okBtn setTitle:@"点击录制" forState:UIControlStateNormal];
    }else
    {
        [_captureManager startRecording];
        [okBtn setTitle:@"点击停止" forState:UIControlStateNormal];
    }
}
//双击
-(void)handleDoubleTap:(id)sender
{
    [_captureManager toggleContentsGravity];
}
#pragma mark 方法
//保存视频
- (void)saveRecordedFile:(NSURL *)recordedFile
{
    waitMB = [HemaFunction openHUD:@"正在保存"];
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        ALAssetsLibrary *assetLibrary = [[ALAssetsLibrary alloc] init];
        [assetLibrary writeVideoAtPathToSavedPhotosAlbum:recordedFile
                                         completionBlock:
         ^(NSURL *assetURL, NSError *error) {
             dispatch_async(dispatch_get_main_queue(), ^{
                 [HemaFunction closeHUD:waitMB];
                 if (error != nil)
                 {
                     NSLog(@"保存失败:%@",[error localizedDescription]);
                 }else
                 {
                     NSLog(@"保存成功");
                     [HemaFunction openIntervalHUDOK:@"保存成功"];
                 }
             });
         }];
    });
}
#pragma mark - AVCaptureManagerDeleagte
- (void)didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL error:(NSError *)error
{
    if (error)
    {
        NSLog(@"错误:%@", error);
        return;
    }
    [self saveRecordedFile:outputFileURL];
}
@end
