//
//  RScanCodeVC.m
//  Hema
//
//  Created by geyang on 15/11/4.
//  Copyright © 2015年 Hemaapp. All rights reserved.
//

#import "RScanCodeVC.h"
#import "ZBarSDK.h"
#import "TOWebViewController.h"

@interface RScanCodeVC ()<ZBarReaderViewDelegate,ZBarReaderDelegate>
{
    NSTimer *myTime;
}
@property(nonatomic,strong)ZBarReaderView *readerView;
@property(nonatomic,strong)UIImageView *scanImgView;//扫描中间上下滑动的view
@end

@implementation RScanCodeVC
@synthesize readerView;
@synthesize scanImgView;

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [readerView start];
    
    myTime = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(timeSet:) userInfo:nil repeats:YES];
    
    LCPanNavigationController *nav = (LCPanNavigationController*)self.navigationController;
    [nav.panGestureRecognizer setEnabled:NO];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [readerView stop];
    [myTime invalidate];
    
    LCPanNavigationController *nav = (LCPanNavigationController*)self.navigationController;
    [nav.panGestureRecognizer setEnabled:YES];
    
    [super viewWillDisappear:animated];
}
-(void)loadSet
{
    [self.navigationItem setNewTitle:@"二维码扫描"];
    
    readerView = [[ZBarReaderView alloc]init];
    readerView.frame = CGRectMake(0, 0, UI_View_Width, UI_View_Height+64);
    readerView.readerDelegate = self;
    //关闭闪光灯
    readerView.torchMode = 0;
    //扫描区域
    CGRect scanMaskRect = CGRectMake(50, 44, UI_View_Width-100, UI_View_Width-100);
    
    //处理模拟器
    if (TARGET_IPHONE_SIMULATOR)
    {
        ZBarCameraSimulator *cameraSimulator
        = [[ZBarCameraSimulator alloc]initWithViewController:self];
        cameraSimulator.readerView = readerView;
    }
    [self.view addSubview:readerView];
    
    //扫描区域计算
    readerView.scanCrop = [self getScanCrop:scanMaskRect readerViewBounds:readerView.frame];
    readerView.tracksSymbols = NO;
    readerView.trackingColor = BB_Red_Color;
    [readerView start];
    //扫描中间框
    UIImageView *scanView = [[UIImageView alloc]init];
    [scanView setImage:[UIImage imageNamed:@"R扫描中间框.png"]];
    [scanView setFrame:CGRectMake(50, 44, UI_View_Width-100, UI_View_Width-100)];
    [self.view addSubview:scanView];
    
    //底部
    UIView *downView = [[UIView alloc]init];
    [downView setFrame:CGRectMake(0, UI_View_Height-130, UI_View_Width, 130)];
    [downView setAlpha:0.5];
    [downView setBackgroundColor:[UIColor blackColor]];
    [self.view addSubview:downView];
    
    //相册
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setFrame:CGRectMake(77, UI_View_Height-115, 57, 57)];
    [leftBtn setImage:[UIImage imageNamed:@"R扫描相册.png"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(gotoPic:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:leftBtn];
    
    UILabel *labLeft = [[UILabel alloc]init];
    labLeft.backgroundColor = [UIColor clearColor];
    labLeft.textAlignment = NSTextAlignmentCenter;
    labLeft.font = [UIFont systemFontOfSize:14];
    labLeft.textColor = BB_White_Color;
    labLeft.text = @"相册";
    labLeft.frame = CGRectMake(77, UI_View_Height-47, 57, 16);
    [self.view addSubview:labLeft];
    
    //开灯
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setFrame:CGRectMake(UI_View_Width-134, UI_View_Height-115, 57, 57)];
    [rightBtn setImage:[UIImage imageNamed:@"R扫描开灯.png"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(openLight:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rightBtn];
    
    UILabel *labRight = [[UILabel alloc]init];
    labRight.backgroundColor = [UIColor clearColor];
    labRight.textAlignment = NSTextAlignmentCenter;
    labRight.font = [UIFont systemFontOfSize:14];
    labRight.textColor = BB_White_Color;
    labRight.text = @"开灯";
    labRight.frame = CGRectMake(UI_View_Width-134, UI_View_Height-47, 57, 16);
    [self.view addSubview:labRight];
    
    //上下滑动框
    self.scanImgView = [[UIImageView alloc]init];
    [scanImgView setFrame:CGRectMake(66, 54, UI_View_Width-132, 8)];
    [scanImgView setImage:[UIImage imageNamed:@"R扫描上下长条.png"]];
    [self.view addSubview:scanImgView];
}
#pragma mark- 自定义
#pragma mark 事件
//定时器
-(void)timeSet:(NSTimer*)sender
{
    [scanImgView setFrame:CGRectMake(66, 54, UI_View_Width-132, 8)];
    
    [UIView animateWithDuration:2 animations:^{
        [scanImgView setFrame:CGRectMake(66, UI_View_Width-76, UI_View_Width-132, 8)];
    }completion:^(BOOL finished)
     {
         
     }];
}
//去相册
-(void)gotoPic:(id)sender
{
    RZbarReaderVC *reader = [RZbarReaderVC new];
    reader.allowsEditing = NO;
    reader.showsHelpOnFail = NO;
    reader.readerDelegate = self;
    reader.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:reader animated:YES completion:nil];
}
//开灯
-(void)openLight:(id)sender
{
    if (readerView.torchMode == 1)
    {
        readerView.torchMode = 0;
    }else
    {
        readerView.torchMode = 1;
    }
}
#pragma mark 方法
//设置可扫描区的scanCrop的方法
- (CGRect)getScanCrop:(CGRect)rect readerViewBounds:(CGRect)rvBounds
{
    CGFloat x,y,width,height;
    x = rect.origin.y / rvBounds.size.height;
    y = 1 - (rect.origin.x + rect.size.width) / rvBounds.size.width;
    width = (rect.origin.y + rect.size.height) / rvBounds.size.height;
    height = 1 - rect.origin.x / rvBounds.size.width;
    return CGRectMake(x, y, width, height);
}
//扫描弹框
-(void)showAlert:(NSString*)myStr
{
    NSString *str = @"[a-zA-z]+://[^\\s]*";
    NSPredicate * pred      = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", str];
    BOOL isMatch            = [pred evaluateWithObject:myStr];
    
    if (isMatch)
    {
        TOWebViewController *webViewController = [[TOWebViewController alloc] initWithURL:[NSURL URLWithString:myStr]];
        webViewController.titleStr = @"扫描页面";
        webViewController.isAdjust = YES;
        [self.navigationController pushViewController:webViewController animated:YES];
    }else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"扫描结果" message:myStr delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        alert.tag = 999;
        alert.delegate = self;
        
        if (myTime)
        {
            [myTime invalidate];myTime = nil;
        }
    }
    [self.readerView stop];
}
#pragma mark- UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(999 == alertView.tag&&0 == buttonIndex)
    {
        [self.readerView start];
        myTime = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(timeSet:) userInfo:nil repeats:YES];
    }
}
#pragma mark - 扫描委托
- (void)readerView:(ZBarReaderView *)readerView didReadSymbols:(ZBarSymbolSet *)symbols fromImage:(UIImage *)image
{
    for (ZBarSymbol *symbol in symbols)
    {
        NSLog(@"摄像头：%@",symbol.data);
        
        [self showAlert:symbol.data];
        break;
    }
}
- (void) imagePickerController: (UIImagePickerController*) reader
 didFinishPickingMediaWithInfo: (NSDictionary*) info
{
    [reader dismissViewControllerAnimated:YES completion:nil];
    
    id<NSFastEnumeration> results = [info objectForKey: ZBarReaderControllerResults];
    ZBarSymbol *symbol = nil;
    for(symbol in results)
        break;
    
    NSLog(@"相册：%@", symbol.data);
    
    [self showAlert:symbol.data];
}
- (void) readerControllerDidFailToRead: (ZBarReaderController*) reader
                             withRetry: (BOOL) retry
{
    [reader dismissViewControllerAnimated:YES completion:nil];
    
    [self showAlert:@"未发现二维码"];
}
@end
