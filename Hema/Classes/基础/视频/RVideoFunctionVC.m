//
//  RVideoFunctionVC.m
//  Hema
//
//  Created by geyang on 15/11/5.
//  Copyright © 2015年 Hemaapp. All rights reserved.
//

#import "RVideoFunctionVC.h"
#import "WechatShortVideoController.h"
#import "RVideoCaptureVC.h"
#import "ROneVideoPlayVC.h"
#import "RTwoVideoPlayVC.h"
#import "RDownloadListVC.h"
#import "RPhotoEditVC.h"
#import "RScanCodeVC.h"
#import "ARShowVC.h"
#import "CameraSessionView.h"
#import "RChartListVC.h"
#import "RDrawBoardVC.h"
#import "RSmilePhotoDetectVC.h"
#import "RICarouseVC.h"
#import "RCreateCodeVC.h"
#import "RPhotoBeautyHomeVC.h"
#import "JxbPlayer.h"
#import "TYAlertController.h"
#import "UIView+TYAlertView.h"
#import "AVPlayerViewController.h"
#import "Player.h"

@interface RVideoFunctionVC ()<WechatShortVideoDelegate,CACameraSessionDelegate>
@property(nonatomic,strong)NSMutableArray *listArr;
@property(nonatomic,strong)CameraSessionView *cameraView;
@end

@implementation RVideoFunctionVC

-(void)loadSet
{
    [self.navigationItem setNewTitle:@"音视图功能"];
    [SystemFunction setTableSeparatorInset:self.mytable left:10];
    [self forbidPullRefresh];
}
-(void)loadData
{
    _listArr = [[NSMutableArray alloc]initWithObjects:
                @"视频录制",@"视频播放",@"视频下载",@"图片裁剪",
                @"二维码扫描",@"相机人脸识别",@"图像人脸识别",@"定制照相",@"走势图绘制",
                @"画板",@"旋转视图",@"二维码生成",@"美图",@"音频播放",nil];
}
#pragma mark- WechatShortVideoDelegate
-(void)finishWechatShortVideoCapture:(NSURL *)filePath
{
    NSLog(@"视频录制路径：%@", filePath);
}
#pragma mark- CACameraSessionDelegate
-(void)didCaptureImage:(UIImage *)image
{
    NSLog(@"生成图片");
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    
    [UIView animateWithDuration:0.3 animations:^{
        [_cameraView setFrame:CGRectMake(0, UI_View_Height+64, UI_View_Width, UI_View_Height+64)];
    }completion:^(BOOL finished)
     {
         [_cameraView removeFromSuperview];
     }];
    [HemaFunction openIntervalHUDOK:@"已保存在相册"];
}
-(void)didCaptureImageWithData:(NSData *)imageData
{
    
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error) [[[UIAlertView alloc] initWithTitle:@"错误!" message:@"图片不能保存" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
}
#pragma mark- TableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _listArr.count;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"all";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.backgroundColor = BB_White_Color;
        
        //左侧
        UILabel *labLeft = [[UILabel alloc]init];
        labLeft.backgroundColor = [UIColor clearColor];
        labLeft.textAlignment = NSTextAlignmentLeft;
        labLeft.font = [UIFont systemFontOfSize:15];
        labLeft.tag = 10;
        labLeft.frame = CGRectMake(10, 0, UI_View_Width-50, 55);
        labLeft.textColor = BB_Blake_Color;
        [cell.contentView addSubview:labLeft];
    }
    UILabel *labLeft = (UILabel*)[cell viewWithTag:10];
    labLeft.text = [_listArr objectAtIndex:indexPath.row];
    
    return cell;
}
#pragma mark- TableView delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 7;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *) indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    //视频录制
    if (0 == indexPath.row)
    {
        MMPopupItemHandler sheetblock = ^(NSInteger index)
        {
            if (index == 0)
            {
                if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
                {
                    WechatShortVideoController *myVC = [[WechatShortVideoController alloc] init];
                    myVC.delegate = self;
                    [self presentViewController:myVC animated:YES completion:^{}];
                }else
                {
                    [HemaFunction openIntervalHUD:@"不支持8.0以下系统"];
                }
            }
            if (index == 1)
            {
                RVideoCaptureVC *myVC = [[RVideoCaptureVC alloc]init];
                [self.navigationController pushViewController:myVC animated:YES];
            }
        };
        NSArray *items =
        @[MMItemMake(@"WechatShortVideoController", MMItemTypeNormal, sheetblock),
          MMItemMake(@"RVideoCaptureVC", MMItemTypeNormal, sheetblock)];
        
        [[[MMSheetView alloc] initWithTitle:@"视频录制类型"
                                      items:items] showWithBlock:nil];
    }
    //视频播放
    if (1 == indexPath.row)
    {
        MMPopupItemHandler sheetblock = ^(NSInteger index)
        {
            if (index == 0)
            {
                ROneVideoPlayVC *myVC = [[ROneVideoPlayVC alloc]init];
                [self.navigationController pushViewController:myVC animated:YES];
            }
            if (index == 1)
            {
                RTwoVideoPlayVC *myVC = [[RTwoVideoPlayVC alloc]init];
                [self.navigationController pushViewController:myVC animated:YES];
            }
            if (index == 2)
            {
                UIView *myView = [[UIView alloc]init];
                [myView setBackgroundColor:BB_White_Color];
                [myView setFrame:CGRectMake(0, 0, UI_View_Width, UI_View_Width*9/16)];
                
                Player *player = [[Player alloc]initWithFrame:CGRectMake(0, 0, UI_View_Width, UI_View_Width*9/16) URL:@"http://baobab.cdn.wandoujia.com/14463059939521445330477778425364388_x264.mp4"];
                [myView addSubview:player];
                player.PlayerBack = ^(Player *player)
                {
                    [player.moviePlayer stop];player.moviePlayer = nil;
                    [myView hideView];
                };
                
                TYAlertController *alertController = [TYAlertController alertControllerWithAlertView:myView preferredStyle:TYAlertControllerStyleAlert];
                alertController.backgoundTapDismissEnable = NO;
                [self presentViewController:alertController animated:YES completion:nil];
            }
            if (index == 3)
            {
                AVPlayerViewController *player2 = [[AVPlayerViewController alloc]init];
                player2.url = [NSURL URLWithString:@"http://baobab.cdn.wandoujia.com/14463059939521445330477778425364388_x264.mp4"];
                [self presentViewController:player2 animated:YES completion:nil];
            }
        };
        NSArray *items =
        @[MMItemMake(@"ROneVideoPlayVC----推荐", MMItemTypeHighlight, sheetblock),
          MMItemMake(@"RTwoVideoPlayVC", MMItemTypeNormal, sheetblock),
          MMItemMake(@"Player", MMItemTypeNormal, sheetblock),
          MMItemMake(@"AVPlayerViewController", MMItemTypeNormal, sheetblock)];
        
        [[[MMSheetView alloc] initWithTitle:@"视频播放类型"
                                      items:items] showWithBlock:nil];
    }
    //视频下载
    if (2 == indexPath.row)
    {
        RDownloadListVC *myVC = [[RDownloadListVC alloc]init];
        [self.navigationController pushViewController:myVC animated:YES];
    }
    //图片裁剪
    if (3 == indexPath.row)
    {
        RPhotoEditVC *myVC = [[RPhotoEditVC alloc]init];
        [self.navigationController pushViewController:myVC animated:YES];
    }
    //二维码扫描
    if (4 == indexPath.row)
    {
        RScanCodeVC *myVC = [[RScanCodeVC alloc]init];
        [self.navigationController pushViewController:myVC animated:YES];
    }
    //相机人脸识别
    if (5 == indexPath.row)
    {
        ARShowVC *myVC = [[ARShowVC alloc]init];
        [self.navigationController pushViewController:myVC animated:YES];
    }
    //图像人脸识别
    if (6 == indexPath.row)
    {
        RSmilePhotoDetectVC *myVC = [[RSmilePhotoDetectVC alloc]init];
        [self.navigationController pushViewController:myVC animated:YES];
    }
    //定制照相
    if (7 == indexPath.row)
    {
        _cameraView = [[CameraSessionView alloc] initWithFrame:CGRectMake(0, UI_View_Height+64, UI_View_Width, UI_View_Height+64)];
        _cameraView.delegate = self;
        
        CATransition *applicationLoadViewIn =[CATransition animation];
        [applicationLoadViewIn setDuration:0.6];
        [applicationLoadViewIn setType:kCATransitionReveal];
        [applicationLoadViewIn setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
        [[_cameraView layer]addAnimation:applicationLoadViewIn forKey:kCATransitionReveal];
        
        [[HemaFunction xfuncGetAppdelegate].window addSubview:_cameraView];
        
        [UIView animateWithDuration:0.3 animations:^{
            [_cameraView setFrame:CGRectMake(0, 0, UI_View_Width, UI_View_Height+64)];
        }completion:^(BOOL finished)
         {
             
         }];
    }
    //走势图绘制
    if (8 == indexPath.row)
    {
        RChartListVC *myVC = [[RChartListVC alloc]init];
        [self.navigationController pushViewController:myVC animated:YES];
    }
    //画板
    if (9 == indexPath.row)
    {
        RDrawBoardVC *myVC = [[RDrawBoardVC alloc]init];
        [self.navigationController pushViewController:myVC animated:YES];
    }
    //旋转视图
    if (10 == indexPath.row)
    {
        RICarouseVC *myVC = [[RICarouseVC alloc]init];
        [self.navigationController pushViewController:myVC animated:YES];
    }
    //二维码生成
    if (11 == indexPath.row)
    {
        RCreateCodeVC *myVC = [[RCreateCodeVC alloc]init];
        [self.navigationController pushViewController:myVC animated:YES];
    }
    //美图
    if (12 == indexPath.row)
    {
        RPhotoBeautyHomeVC *myVC = [[RPhotoBeautyHomeVC alloc]init];
        [self.navigationController pushViewController:myVC animated:YES];
    }
    //音频播放
    if (13 == indexPath.row)
    {
        UIView *myView = [[UIView alloc]init];
        [myView setBackgroundColor:BB_White_Color];
        [myView setFrame:CGRectMake(0, 0, UI_View_Width, 240)];
        
        JxbPlayer* jxb = [[JxbPlayer alloc] initWithMainColor:[UIColor redColor] frame:CGRectMake(0, 70, UI_View_Width, 100)];
        jxb.itemUrl = @"http://123.57.81.236/ceshi.mp3";
        jxb.tag = 10;
        [myView addSubview:jxb];
        
        HemaButton *closeBtn = [HemaButton buttonWithType:UIButtonTypeCustom];
        [closeBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [closeBtn setTitle:@"关闭" forState:UIControlStateNormal];
        [closeBtn setFrame:CGRectMake((UI_View_Width-75)/2, 180, 75, 30)];
        [closeBtn setBackgroundColor:RGB_UI_COLOR(244, 122, 117)];
        [HemaFunction addbordertoView:closeBtn radius:15 width:0 color:[UIColor clearColor]];
        [myView addSubview:closeBtn];
        
        [closeBtn addTapGestureRecognizer:^(UITapGestureRecognizer* recognizer, NSString* gestureId)
        {
            JxbPlayer* jxb = (JxbPlayer*)[myView viewWithTag:10];
            [jxb stop];jxb = nil;
            [myView hideView];
        }];
        
        TYAlertController *alertController = [TYAlertController alertControllerWithAlertView:myView preferredStyle:TYAlertControllerStyleActionSheet];
        alertController.backgoundTapDismissEnable = NO;
        [self presentViewController:alertController animated:YES completion:nil];
    }
}
@end
