//
//  RDrawBoardVC.m
//  Hema
//
//  Created by LarryRodic on 15/10/25.
//  Copyright © 2015年 Hemaapp. All rights reserved.
//

#import "RDrawBoardVC.h"
#import "LQview.h"

@interface RDrawBoardVC ()
@property(nonatomic,strong)UIView *downView;//控制视图
@property(nonatomic,strong)LQview *lqview;//画板
@property(nonatomic,strong)UIView *colorView;//颜色视图
@property(nonatomic,strong)UIView *widthView;//线宽视图
@property(nonatomic,strong)NSMutableArray *color;//所有颜色选择数据
@end

@implementation RDrawBoardVC

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    LCPanNavigationController *nav = (LCPanNavigationController*)self.navigationController;
    [nav.panGestureRecognizer setEnabled:NO];
}
-(void)viewWillDisappear:(BOOL)animated
{
    LCPanNavigationController *nav = (LCPanNavigationController*)self.navigationController;
    [nav.panGestureRecognizer setEnabled:YES];
    [super viewWillDisappear:animated];
}
-(void)loadSet
{
    [self.navigationItem setNewTitle:@"画板"];
    [self.navigationItem setRightItemWithTarget:self action:@selector(rightbtnPressed:) title:@"保存"];
    
    //画板
    [self createLPView];
    
    //底部控制
    _downView = [[UIView alloc] initWithFrame:CGRectMake(0, UI_View_Height-80, UI_View_Width, 80)];
    [HemaFunction dropShadowWithOffset:CGSizeMake(-1, -1) radius:1.0f color:BB_lineColor opacity:1 view:_downView];
    _downView.backgroundColor = BB_Back_Color_Here_Bar;
    [self.view addSubview:_downView];
    
    CGFloat buttonW = UI_View_Width / 5.0;
    CGFloat buttonH = 35;
    CGFloat buttonY = 0;
    NSArray *arr = @[@"颜色",@"线宽",@"橡皮",@"撤销",@"清屏"];
    for (int i = 0; i < 5; i ++)
    {
        CGFloat buttonX = buttonW * i;
        HemaButton *button = [HemaButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
        [button setTitle:arr[i] forState:UIControlStateNormal];
        [button setTitleColor:BB_Blue_Color forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage mm_imageWithColor:BB_Orange_Color Size:button.frame.size] forState:UIControlStateHighlighted];
        button.btnRow = i;
        [button addTarget:self action:@selector(topButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_downView addSubview:button];
    }
}
-(void)loadData
{
    _color = [[NSMutableArray alloc]init];
    for (int i = 0; i < 10; i ++)
    {
        UIColor *color = [[UIColor alloc] initWithRed:arc4random_uniform(10) * .1 green:arc4random_uniform(10) * .1 blue:arc4random_uniform(10) * .1 alpha:1];
        [_color addObject:color];
    }
}
#pragma mark- 自定义
#pragma mark 事件
//保存图片
-(void)rightbtnPressed:(id)sender
{
    UIImage *myImage = [HemaFunction captureView:_lqview];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImageWriteToSavedPhotosAlbum(myImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    });
}
//保存图片反馈
-(void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if(error)
    {
        [HemaFunction openIntervalHUD:@"保存失败"];
    }else
    {
        [HemaFunction openIntervalHUDOK:@"成功保存到相册"];
    }
}
//顶部按钮的切换事件处理
-(void)topButtonAction:(HemaButton*)sender
{
    switch (sender.btnRow)
    {
        case 0:     //选择颜色
            [self creatColorBtn];
            [_colorView setHidden:NO];
            [_widthView setHidden:YES];
            break;
        case 1:     //选择线宽
            [self creatWithbtn];
            [_colorView setHidden:YES];
            [_widthView setHidden:NO];
            break;
        case 2:     //橡皮
            [self creatWithbtn];
            [_colorView setHidden:YES];
            [_widthView setHidden:NO];
            [_lqview rubLine];
            break;
        case 3:     //撤销
            [_colorView setHidden:YES];
            [_widthView setHidden:YES];
            [self.lqview revoke];
            break;
        case 4:     //清屏
            [_colorView setHidden:YES];
            [_widthView setHidden:YES];
            [self createLPView];
            break;
        default:
            break;
    }
}
//颜色点击
-(void)colorButtonAction:(HemaButton*)sender
{
    _lqview.colorLine = sender.backgroundColor;
}
//线宽点击
-(void)widthButtonAction:(HemaButton*)sender
{
    _lqview.widthLine = [[sender titleForState:UIControlStateNormal] integerValue];
}
#pragma mark 方法
//创建画板
-(void)createLPView
{
    UIColor *colorLine = [UIColor blackColor];
    NSInteger widthLine = 1;
    if (_lqview)
    {
        colorLine = _lqview.colorLine;
        widthLine = _lqview.widthLine;
        [_lqview removeFromSuperview];_lqview = nil;
    }
    _lqview = [[LQview alloc] initWithFrame:CGRectMake(0, 0, UI_View_Width, UI_View_Height-100)];
    _lqview.backgroundColor = BB_Back_Color_Here;
    _lqview.colorLine = colorLine;
    _lqview.widthLine = widthLine;
    [self.view addSubview:_lqview];
}
//创建所有的颜色选择按钮
-(void)creatColorBtn
{
    if (!_colorView)
    {
        _colorView = [[UIView alloc] initWithFrame:CGRectMake(0, 10 + 35, UI_View_Width, 45)];
        [_downView addSubview:_colorView];
        CGFloat buttonW = UI_View_Width / 10.0;
        CGFloat buttonH = 45;
        CGFloat buttonY = 0;
        
        for (int i = 0; i < 10; i ++)
        {
            CGFloat buttonX = buttonW * i;
            HemaButton *button = [HemaButton buttonWithType:UIButtonTypeCustom];
            [button setBackgroundColor:_color[i]];
            button.btnRow = i;
            [button addTarget:self action:@selector(colorButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            button.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
            [_colorView addSubview:button];
        }
    }
}
//创建所有线宽选择按钮
-(void)creatWithbtn
{
    if (!_widthView)
    {
        _widthView = [[UIView alloc] initWithFrame:CGRectMake(0, 10 + 35, UI_View_Width, 45)];
        [_downView addSubview:_widthView];
        
        CGFloat buttonW = UI_View_Width / 7.0;
        CGFloat buttonH = 45;
        CGFloat buttonY = 0;
        NSArray *arr = @[@"1",@"3",@"5",@"8",@"10",@"15",@"20"];
        for (int i = 0; i < 7; i ++)
        {
            CGFloat buttonX = buttonW * i;
            HemaButton *button = [HemaButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
            [button setTitle:arr[i] forState:UIControlStateNormal];
            [button setTitleColor:BB_Blue_Color forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage mm_imageWithColor:BB_Orange_Color Size:button.frame.size] forState:UIControlStateHighlighted];
            button.btnRow = i;
            [button addTarget:self action:@selector(widthButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            [_widthView addSubview:button];
        }
    }
}
@end
