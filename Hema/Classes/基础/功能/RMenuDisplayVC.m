//
//  RMenuDisplayVC.m
//  Hema
//
//  Created by LarryRodic on 15/11/22.
//  Copyright © 2015年 Hemaapp. All rights reserved.
//

#import "RMenuDisplayVC.h"

#import "QBPopupMenu.h"
#import "QBPlasticPopupMenu.h"
#import "DWBubbleMenuButton.h"
#import "REFrostedViewController.h"
#import "AMPopTip.h"
#import "KGModal.h"
#import "KLCPopup.h"
#import "TSMessage.h"
#import "ASValueTrackingSlider.h"
#import "ASProgressPopUpView.h"
#import "LDProgressView.h"
#import "MDRadialProgressLabel.h"
#import "MDRadialProgressTheme.h"
#import "MDRadialProgressView.h"
#import "RTLabel.h"
#import "TOWebViewController.h"
#import "STTweetLabel.h"

@interface RMenuDisplayVC ()<ASValueTrackingSliderDataSource,ASProgressPopUpViewDataSource,RTLabelDelegate,STLinkProtocol>
@property(nonatomic,strong)UIScrollView *myScrollView;
@property(nonatomic,strong)AMPopTip *popTip;
@end

@implementation RMenuDisplayVC

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
    [self.navigationItem setNewTitle:@"菜单样式"];
    [self.navigationItem setRightItemWithTarget:self action:@selector(rightbtnPressed:) image:@"shareBig.png"];
    
    //如果是侧滑菜单
    if ([[HemaFunction xfuncGetAppdelegate].window.rootViewController isKindOfClass:[REFrostedViewController class]])
    {
        [self.view addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognized:)]];
        [self.navigationItem setLeftItemWithTarget:self action:@selector(leftbtnPressed:) title:@"回去"];
    }
    
    _myScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, UI_View_Width, UI_View_Height)];
    [self.view addSubview:_myScrollView];
    
    [self initButtons];
    [self initPopTip];
    [self initASSliders];
    [self initASProgress];
    [self initLDProgress];
    [self initMDRadial];
    [self initRTLable];
    [self initSTLable];
    [self initDWMenu];
    [KGModal sharedInstance].closeButtonLocation = KGModalCloseButtonLocationRight;
    
    UIView *lastView = (UIView*)_myScrollView.subviews.lastObject;
    [_myScrollView setContentSize:CGSizeMake(UI_View_Width, CGRectGetMaxY(lastView.frame)+70)];
}
//创建button
-(void)initButtons
{
    NSMutableArray *listArr = [[NSMutableArray alloc]initWithObjects:
                               @"QBPopupMenu",@"QBPlasticMenu",@"AMPopTip",@"KGModal",@"KLCPopup",
                               @"TSMessage",nil];
    for (int i = 0; i<listArr.count; i++)
    {
        HemaButton *clickBtn = [HemaButton buttonWithType:UIButtonTypeCustom];
        [clickBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [clickBtn setTitleColor:BB_White_Color forState:UIControlStateNormal];
        [clickBtn setTitle:listArr[i] forState:UIControlStateNormal];
        clickBtn.btnRow = i;
        [clickBtn setFrame:CGRectMake(UI_View_Width/3*(i%3)+10, 60*(i/3)+20, UI_View_Width/3-20, 40)];
        [clickBtn setBackgroundColor:RGB_UI_COLOR(244, 122, 117)];
        [HemaFunction addbordertoView:clickBtn radius:20 width:0 color:[UIColor clearColor]];
        clickBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
        [clickBtn addTarget:self action:@selector(clickPressed:) forControlEvents:UIControlEventTouchUpInside];
        [_myScrollView addSubview:clickBtn];
    }
}
//创建popTip
-(void)initPopTip
{
    [[AMPopTip appearance] setFont:[UIFont fontWithName:@"Avenir-Medium" size:12]];
    
    _popTip = [AMPopTip popTip];
    _popTip.shouldDismissOnTap = YES;
    _popTip.edgeMargin = 5;
    _popTip.offset = 2;
    _popTip.edgeInsets = UIEdgeInsetsMake(0, 10, 0, 10);
    _popTip.tapHandler = ^{
        NSLog(@"点击!");
    };
    _popTip.dismissHandler = ^{
        NSLog(@"消失!");
    };
}
//创建ASSliders
-(void)initASSliders
{
    UIView *lastView = (UIView*)_myScrollView.subviews.lastObject;
    
    //第一种
    ASValueTrackingSlider *oneSlider = [[ASValueTrackingSlider alloc]initWithFrame:CGRectMake(10, lastView.bottom+20, UI_View_Width-20, 30)];
    oneSlider.maximumValue = 255.0;
    oneSlider.popUpViewCornerRadius = 0.0;
    [oneSlider setMaxFractionDigitsDisplayed:0];
    oneSlider.popUpViewColor = [UIColor colorWithHue:0.55 saturation:0.8 brightness:0.9 alpha:0.7];
    oneSlider.font = [UIFont fontWithName:@"GillSans-Bold" size:22];
    oneSlider.textColor = [UIColor colorWithHue:0.55 saturation:1.0 brightness:0.5 alpha:1];
    [_myScrollView addSubview:oneSlider];
    
    //第二种
    ASValueTrackingSlider *twoSlider = [[ASValueTrackingSlider alloc]initWithFrame:CGRectMake(10, oneSlider.bottom+20, UI_View_Width-20, 30)];
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterPercentStyle];
    [twoSlider setNumberFormatter:formatter];
    twoSlider.font = [UIFont fontWithName:@"Futura-CondensedExtraBold" size:26];
    twoSlider.popUpViewAnimatedColors = @[[UIColor purpleColor], [UIColor redColor], [UIColor orangeColor]];
    [_myScrollView addSubview:twoSlider];
    
    //第三种
    ASValueTrackingSlider *threeSlider = [[ASValueTrackingSlider alloc]initWithFrame:CGRectMake(10, twoSlider.bottom+20, UI_View_Width-20, 30)];
    
    NSNumberFormatter *tempFormatter = [[NSNumberFormatter alloc] init];
    [tempFormatter setPositiveSuffix:@"°C"];
    [tempFormatter setNegativeSuffix:@"°C"];
    
    threeSlider.dataSource = self;
    [threeSlider setNumberFormatter:tempFormatter];
    threeSlider.minimumValue = -20.0;
    threeSlider.maximumValue = 60.0;
    threeSlider.popUpViewCornerRadius = 16.0;
    
    threeSlider.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:26];
    threeSlider.textColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    
    UIColor *coldBlue = [UIColor colorWithHue:0.6 saturation:0.7 brightness:1.0 alpha:1.0];
    UIColor *blue = [UIColor colorWithHue:0.55 saturation:0.75 brightness:1.0 alpha:1.0];
    UIColor *green = [UIColor colorWithHue:0.3 saturation:0.65 brightness:0.8 alpha:1.0];
    UIColor *yellow = [UIColor colorWithHue:0.15 saturation:0.9 brightness:0.9 alpha:1.0];
    UIColor *red = [UIColor colorWithHue:0.0 saturation:0.8 brightness:1.0 alpha:1.0];
    
    [threeSlider setPopUpViewAnimatedColors:@[coldBlue, blue, green, yellow, red]
                               withPositions:@[@-20, @0, @5, @25, @60]];
    [_myScrollView addSubview:threeSlider];
}
//创建ASSliders
-(void)initASProgress
{
    UIView *lastView = (UIView*)_myScrollView.subviews.lastObject;
    
    //第一种
    ASProgressPopUpView *oneProgress = [[ASProgressPopUpView alloc]initWithFrame:CGRectMake(10, lastView.bottom+50, UI_View_Width-20, 2)];
    oneProgress.font = [UIFont fontWithName:@"Futura-CondensedExtraBold" size:16];
    oneProgress.popUpViewAnimatedColors = @[[UIColor redColor], [UIColor orangeColor], [UIColor greenColor]];
    oneProgress.dataSource = self;
    [oneProgress setProgress:0.5 animated:YES];
    [oneProgress showPopUpViewAnimated:YES];
    [_myScrollView addSubview:oneProgress];
    
    //第二种
    ASProgressPopUpView *twoProgress = [[ASProgressPopUpView alloc]initWithFrame:CGRectMake(10, oneProgress.bottom+50, UI_View_Width-20, 2)];
    twoProgress.popUpViewCornerRadius = 12.0;
    twoProgress.font = [UIFont fontWithName:@"Futura-CondensedExtraBold" size:14];
    [twoProgress setProgress:0.8 animated:YES];
    [twoProgress showPopUpViewAnimated:YES];
    [_myScrollView addSubview:twoProgress];
}
//创建LDProgress
-(void)initLDProgress
{
    UIView *lastView = (UIView*)_myScrollView.subviews.lastObject;
    
    //第一种
    LDProgressView *oneProgress = [[LDProgressView alloc] initWithFrame:CGRectMake(10, lastView.bottom+50, UI_View_Width-20, 22)];
    oneProgress.progress = 0.40;
    [_myScrollView addSubview:oneProgress];
    
    //第二种
    LDProgressView *twoProgress = [[LDProgressView alloc] initWithFrame:CGRectMake(10, oneProgress.bottom+50, UI_View_Width-20, 22)];
    twoProgress.progress = 0.80;
    twoProgress.color = BB_Blue_Color;
    twoProgress.flat = @YES;
    twoProgress.animate = @YES;
    [_myScrollView addSubview:twoProgress];
    
    //第三种
    LDProgressView *thirdProgress = [[LDProgressView alloc] initWithFrame:CGRectMake(10, twoProgress.bottom+50, UI_View_Width-20, 22)];
    thirdProgress.progress = 0.20;
    thirdProgress.color = BB_Orange_Color;
    thirdProgress.animate = @YES;
    thirdProgress.type = LDProgressGradient;
    thirdProgress.background = [thirdProgress.color colorWithAlphaComponent:0.8];
    [_myScrollView addSubview:thirdProgress];
    
    //第四种
    LDProgressView *fourProgress = [[LDProgressView alloc] initWithFrame:CGRectMake(10, thirdProgress.bottom+50, UI_View_Width-20, 22)];
    fourProgress.progress = 0.60;
    fourProgress.showText = @NO;
    fourProgress.borderRadius = @5;
    fourProgress.type = LDProgressSolid;
    [_myScrollView addSubview:fourProgress];
    
    //第五种
    LDProgressView *fiveProgress = [[LDProgressView alloc] initWithFrame:CGRectMake(10, fourProgress.bottom+50, UI_View_Width-20, 22)];
    fiveProgress.progress = 1.00;
    fiveProgress.borderRadius = @0;
    fiveProgress.type = LDProgressStripes;
    fiveProgress.color = BB_Red_Color;
    [_myScrollView addSubview:fiveProgress];
    
    //第六种
    LDProgressView *sixProgress = [[LDProgressView alloc] initWithFrame:CGRectMake(10, fiveProgress.bottom+50, UI_View_Width-20, 22)];
    sixProgress.progress = 0.40;
    sixProgress.color = [UIColor purpleColor];
    sixProgress.flat = @YES;
    sixProgress.animate = @YES;
    sixProgress.showStroke = @NO;
    sixProgress.progressInset = @4;
    sixProgress.showBackground = @NO;
    sixProgress.outerStrokeWidth = @3;
    sixProgress.type = LDProgressSolid;
    [sixProgress overrideProgressText:@"Cool!"];
    [_myScrollView addSubview:sixProgress];
}
//创建MDRadial
-(void)initMDRadial
{
    UIView *lastView = (UIView*)_myScrollView.subviews.lastObject;
    
    float middleX = (UI_View_Width-270)/4;
    
    //第一种
    MDRadialProgressView *oneRadial = [[MDRadialProgressView alloc]initWithFrame:CGRectMake(10, lastView.bottom+50, 50, 50)];
    oneRadial.progressTotal = 7;
    oneRadial.progressCounter = 4;
    oneRadial.theme.sliceDividerHidden = YES;
    [_myScrollView addSubview:oneRadial];
    
    //第二种
    MDRadialProgressView *twoRadial = [[MDRadialProgressView alloc]initWithFrame:CGRectMake(oneRadial.right+middleX, lastView.bottom+50, 50, 50)];
    twoRadial.progressTotal = 7;
    twoRadial.progressCounter = 4;
    twoRadial.theme.sliceDividerHidden = YES;
    [twoRadial setIsIndeterminateProgress:YES];
    [_myScrollView addSubview:twoRadial];
    
    //第三种
    MDRadialProgressTheme *newTheme = [[MDRadialProgressTheme alloc] init];
    newTheme.completedColor =RGB_UI_COLOR(90, 212, 39);
    newTheme.incompletedColor = RGB_UI_COLOR(164, 231, 134);
    newTheme.centerColor = [UIColor clearColor];
    newTheme.centerColor = RGB_UI_COLOR(224, 248, 216);
    newTheme.sliceDividerHidden = YES;
    newTheme.labelColor = BB_Blake_Color;
    newTheme.labelShadowColor = BB_White_Color;
    
    MDRadialProgressView *threeRadial = [[MDRadialProgressView alloc] initWithFrame:CGRectMake(twoRadial.right+middleX, lastView.bottom+50, 50, 50) andTheme:newTheme];
    threeRadial.progressTotal = 4;
    threeRadial.progressCounter = 1;
    [_myScrollView addSubview:threeRadial];
    
    //第四种
    MDRadialProgressView *fourRadial = [[MDRadialProgressView alloc]initWithFrame:CGRectMake(threeRadial.right+middleX, lastView.bottom+50, 50, 50)];
    fourRadial.progressTotal = 5;
    fourRadial.progressCounter = 3;
    fourRadial.theme.thickness = 15;
    fourRadial.theme.incompletedColor = [UIColor clearColor];
    fourRadial.theme.completedColor = [UIColor orangeColor];
    fourRadial.theme.sliceDividerHidden = YES;
    fourRadial.label.hidden = YES;
    [_myScrollView addSubview:fourRadial];
    
    //第五种
    MDRadialProgressView *fiveRadial = [[MDRadialProgressView alloc]initWithFrame:CGRectMake(fourRadial.right+middleX, lastView.bottom+50, 50, 50)];
    fiveRadial.progressTotal = 5;
    fiveRadial.progressCounter = 4;
    fiveRadial.theme.completedColor = RGB_UI_COLOR(247, 247, 247);
    fiveRadial.theme.incompletedColor = BB_Blake_Color;
    fiveRadial.theme.thickness = 10;
    fiveRadial.theme.sliceDividerHidden = YES;
    fiveRadial.theme.centerColor = fiveRadial.theme.completedColor;
    [_myScrollView addSubview:fiveRadial];
    
    //第六种
    MDRadialProgressView *sixRadial = [[MDRadialProgressView alloc]initWithFrame:CGRectMake(10, oneRadial.bottom+50, 50, 50)];
    sixRadial.progressTotal = 10;
    sixRadial.progressCounter = 3;
    sixRadial.clockwise = NO;
    sixRadial.theme.completedColor = RGB_UI_COLOR(90, 200, 251);
    sixRadial.theme.incompletedColor = RGB_UI_COLOR(82, 237, 199);
    sixRadial.theme.thickness = 30;
    sixRadial.theme.sliceDividerHidden = NO;
    sixRadial.theme.sliceDividerColor = BB_White_Color;
    sixRadial.theme.sliceDividerThickness = 2;
    sixRadial.label.hidden = YES;
    [_myScrollView addSubview:sixRadial];
    
    //第七种
    MDRadialProgressView *sevenRadial = [[MDRadialProgressView alloc]initWithFrame:CGRectMake(sixRadial.right+middleX, oneRadial.bottom+50, 50, 50)];
    sevenRadial.progressTotal = 10;
    sevenRadial.progressCounter = 3;
    sevenRadial.startingSlice = 3;
    sevenRadial.theme.sliceDividerHidden = NO;
    sevenRadial.theme.sliceDividerThickness = 1;
    sevenRadial.theme.labelColor = BB_Blue_Color;
    sevenRadial.theme.labelShadowColor = [UIColor clearColor];
    [_myScrollView addSubview:sevenRadial];
    
    //第八种
    MDRadialProgressView *eightRadial = [[MDRadialProgressView alloc]initWithFrame:CGRectMake(sevenRadial.right+middleX, oneRadial.bottom+50, 50, 50)];
    eightRadial.startingSlice = 5;
    eightRadial.progressTotal = 20;
    eightRadial.progressCounter = 9;
    eightRadial.startingSlice = 3;
    eightRadial.clockwise = YES;
    eightRadial.theme.thickness = 70;
    eightRadial.theme.completedColor = [UIColor brownColor];
    eightRadial.theme.sliceDividerThickness = 0;
    [_myScrollView addSubview:eightRadial];
    
    //第九种
    MDRadialProgressView *nineRadial = [[MDRadialProgressView alloc]initWithFrame:CGRectMake(eightRadial.right+middleX, oneRadial.bottom+50, 50, 50)];
    nineRadial.progressTotal = 10;
    nineRadial.progressCounter = 0;
    nineRadial.theme.incompletedColor = [UIColor clearColor];
    nineRadial.theme.centerColor = BB_White_Color;
    nineRadial.theme.sliceDividerColor = BB_Gray_Color;
    nineRadial.theme.sliceDividerThickness = 2;
    nineRadial.theme.sliceDividerHidden = NO;
    nineRadial.label.hidden = YES;
    [_myScrollView addSubview:nineRadial];
    
    //第十种
    MDRadialProgressView *tenRadial = [[MDRadialProgressView alloc]initWithFrame:CGRectMake(nineRadial.right+middleX, oneRadial.bottom+50, 50, 50)];
    tenRadial.progressTotal = 10;
    tenRadial.progressCounter = 0;
    tenRadial.label.hidden = YES;
    tenRadial.clockwise = YES;
    tenRadial.theme.centerColor = BB_Orange_Color;
    tenRadial.theme.thickness = 10;
    tenRadial.theme.sliceDividerHidden = YES;
    tenRadial.theme.completedColor = BB_Blue_Color;
    tenRadial.theme.incompletedColor = BB_Gray_Color;
    tenRadial.theme.sliceDividerThickness = 0;
    tenRadial.theme.drawIncompleteArcIfNoProgress = YES;
    [_myScrollView addSubview:tenRadial];
}
//创建RTLable
-(void)initRTLable
{
    UIView *lastView = (UIView*)_myScrollView.subviews.lastObject;
    
    NSMutableString *myStr = [[NSMutableString alloc]initWithString:@"<p align=justify><b>八</b>声<i>甘州</i></p>\n"];
    [myStr appendString:@"<p align=right><font face='HelveticaNeue-CondensedBold' size=20 kern=10><u color=blue>张炎</u></font><uu color=red>(宋)</uu></p>\n"];
    [myStr appendString:@"<p align=left indent=20><a href='http://www.baidu.com'>记玉关踏雪事清游，寒气脆貂裘。</a><a href='http://www.cocoachina.com/industry/20131204/7468.html'>傍枯林古道，长河饮马，此意悠悠。</a><a href='http://bbs.hupu.com/all-nba'>短梦依然江表，老泪洒西州。</a><a href='https://github.com/honcheng/RTLabel'>一字无题外，落叶都愁。</a></p>\n"];
    [myStr appendString:@"<p align=left indent=20><font face='HelveticaNeue-CondensedBold' size=20 color='#adaa00'>载取白云归去，问谁留楚佩，弄影中洲？</font><font face=AmericanTypewriter size=16 color=purple>折芦花赠远，零落一身秋。</font><font face=Futura size=14 color='#dd1100'>向寻常、野桥流水，待招来，不是旧沙鸥。</font><font face='HelveticaNeue-CondensedBold' size=20 stroke=1>空怀感，有斜阳处，却怕登楼。</font></p>"];
    
    RTLabel *oneLabel = [[RTLabel alloc] initWithFrame:CGRectMake(10,lastView.bottom+50,UI_View_Width-20,100)];
    [oneLabel setParagraphReplacement:@""];
    [oneLabel setText:myStr];
    oneLabel.delegate = self;
    [oneLabel setHeight:[oneLabel optimumSize].height+5];
    [_myScrollView addSubview:oneLabel];
}
//创建STLable
-(void)initSTLable
{
    UIView *lastView = (UIView*)_myScrollView.subviews.lastObject;
    
    STTweetLabel *oneLabel = [[STTweetLabel alloc] initWithFrame:CGRectMake(10,lastView.bottom+20,UI_View_Width-20,100)];
    [oneLabel setText:@"@可可依依，你猜谁那么聪明呢？是 @可可 还是@依依 敬请查询 http://www.baidu.com #中国梦 "];
    oneLabel.delegate = self;
    oneLabel.numberOfLines = 0;
    oneLabel.font = [UIFont systemFontOfSize:14];
    [_myScrollView addSubview:oneLabel];
    
    CGSize mySize = [HemaFunction getSizeWithStrNo:oneLabel.text width:oneLabel.width font:14];
    [oneLabel setHeight:mySize.height];
}
//创建DWBubbleMenuButton菜单
-(void)initDWMenu
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.f, 0.f, 50.f, 50.f)];
    label.text = @"点击";
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = BB_White_Color;
    label.textAlignment = NSTextAlignmentCenter;
    label.layer.cornerRadius = label.frame.size.height / 2.f;
    label.backgroundColor = [UIColor colorWithRed:0.f green:0.f blue:0.f alpha:0.5f];
    label.clipsToBounds = YES;
    
    DWBubbleMenuButton *upMenuView = [[DWBubbleMenuButton alloc] initWithFrame:CGRectMake(UI_View_Width-label.width-20, UI_View_Height-label.height-20, label.width, label.height) expansionDirection:DirectionUp];
    upMenuView.homeButtonView = label;
    
    NSMutableArray *buttonsMutable = [[NSMutableArray alloc] init];
    int i = 0;
    for (NSString *title in @[@"A", @"B", @"C", @"D", @"E", @"F"])
    {
        HemaButton *menuBtn = [HemaButton buttonWithType:UIButtonTypeSystem];
        [menuBtn setTitleColor:BB_White_Color forState:UIControlStateNormal];
        [menuBtn setTitle:title forState:UIControlStateNormal];
        menuBtn.frame = CGRectMake(0.f, 0.f, 30.f, 30.f);
        menuBtn.layer.cornerRadius = menuBtn.height / 2.f;
        menuBtn.backgroundColor = [UIColor colorWithRed:0.f green:0.f blue:0.f alpha:0.5f];
        menuBtn.clipsToBounds = YES;
        menuBtn.btnRow = i++;
        [buttonsMutable addObject:menuBtn];
    }
    [upMenuView addButtons:buttonsMutable];
    
    [self.view addSubview:upMenuView];
}
#pragma mark- 自定义
#pragma mark 事件
-(void)leftbtnPressed:(id)sender
{
    if ([[HemaFunction xfuncGetAppdelegate].window.rootViewController isKindOfClass:[REFrostedViewController class]])
    {
        [[HemaFunction xfuncGetAppdelegate] gotoRoot];
    }else
    {
        [super leftbtnPressed:sender];
    }
}
-(void)rightbtnPressed:(id)sender
{
    if ([[HemaFunction xfuncGetAppdelegate].window.rootViewController isKindOfClass:[REFrostedViewController class]])
    {
        [self.view endEditing:YES];
        [self.frostedViewController.view endEditing:YES];
        [self.frostedViewController presentMenuViewController];
    }else
    {
        [UIWindow showToastMessage:@"请去其他模块点击“侧滑菜单”，然后再点击此右导航！"];
    }
}
//侧滑菜单的手势
- (void)panGestureRecognized:(UIPanGestureRecognizer *)sender
{
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    [self.frostedViewController panGestureRecognized:sender];
}
-(void)clickPressed:(HemaButton*)sender
{
    switch (sender.btnRow)
    {
        case 0:
        {
            QBPopupMenuItem *item1 = [QBPopupMenuItem itemWithTitle:@"剪切" target:self action:nil];
            QBPopupMenuItem *item2 = [QBPopupMenuItem itemWithTitle:@"复制" target:self action:nil];
            QBPopupMenuItem *item3 = [QBPopupMenuItem itemWithTitle:@"删除" target:self action:nil];
            QBPopupMenuItem *item4 = [QBPopupMenuItem itemWithImage:[UIImage imageNamed:@"clip"] target:self action:nil];
            QBPopupMenuItem *item5 = [QBPopupMenuItem itemWithTitle:@"丢弃" image:[UIImage imageNamed:@"trash"] target:self action:nil];
            NSArray *items = @[item1, item2, item3, item4, item5];
            
            QBPopupMenu *popupMenu = [[QBPopupMenu alloc] initWithItems:items];
            popupMenu.highlightedColor = [BB_Blue_Color colorWithAlphaComponent:0.8];
            [popupMenu showInView:_myScrollView targetRect:CGRectMake(sender.left, sender.top-_myScrollView.contentOffset.y, sender.width, sender.height) animated:YES];
            
            break;
        }
        case 1:
        {
            QBPopupMenuItem *item1 = [QBPopupMenuItem itemWithTitle:@"剪切" target:self action:nil];
            QBPopupMenuItem *item2 = [QBPopupMenuItem itemWithTitle:@"复制" target:self action:nil];
            QBPopupMenuItem *item3 = [QBPopupMenuItem itemWithTitle:@"删除" target:self action:nil];
            QBPopupMenuItem *item4 = [QBPopupMenuItem itemWithImage:[UIImage imageNamed:@"clip"] target:self action:nil];
            QBPopupMenuItem *item5 = [QBPopupMenuItem itemWithTitle:@"丢弃" image:[UIImage imageNamed:@"trash"] target:self action:nil];
            NSArray *items = @[item1, item2, item3, item4, item5];
            
            QBPlasticPopupMenu *plasticPopupMenu = [[QBPlasticPopupMenu alloc] initWithItems:items];
            plasticPopupMenu.height = 40;
            [plasticPopupMenu showInView:_myScrollView targetRect:CGRectMake(sender.left, sender.top-_myScrollView.contentOffset.y, sender.width, sender.height) animated:YES];
            
            break;
        }
        case 2:
        {
            [_popTip hide];
            if ([_popTip isVisible])
            {
                return;
            }
            _popTip.popoverColor = BB_Blue_Color;
            [_popTip showText:@"仰天大笑出门去\n我辈岂是蓬蒿人" direction:AMPopTipDirectionDown maxWidth:200 inView:_myScrollView fromFrame:sender.frame];
            break;
        }
        case 3:
        {
            UIView *myView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 280, 300)];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, myView.width-20, myView.height)];
            label.text = @"莫听穿林打叶声，何妨吟啸且徐行。竹杖芒鞋轻胜马，谁怕？一蓑烟雨任平生。料峭春风吹酒醒，微冷，山头斜照却相迎。回首向来萧瑟处，归去，也无风雨也无晴。";
            label.font = [UIFont systemFontOfSize:16];
            label.textColor = BB_White_Color;
            label.numberOfLines = 0;
            label.adjustsFontSizeToFitWidth = YES;
            label.textAlignment = NSTextAlignmentCenter;
            [myView addSubview:label];
            
            [[KGModal sharedInstance] showWithContentView:myView andAnimated:YES];
            break;
        }
        case 4:
        {
            UIView *myView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 280, 300)];
            [myView setBackgroundColor:BB_Blue_Color];
            [HemaFunction addbordertoView:myView radius:12 width:1 color:BB_Blue_Color];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, myView.width-20, myView.height-60)];
            label.text = @"伫倚危楼风细细。望极春愁，黯黯生天际。草色烟光残照里。无言谁会凭阑意。拟把疏狂图一醉。对酒当歌，强乐还无味。衣带渐宽终不悔。为伊消得人憔悴。";
            label.font = [UIFont systemFontOfSize:16];
            label.textColor = BB_White_Color;
            label.numberOfLines = 0;
            label.adjustsFontSizeToFitWidth = YES;
            label.textAlignment = NSTextAlignmentCenter;
            [myView addSubview:label];
            
            HemaButton *closeBtn = [HemaButton buttonWithType:UIButtonTypeCustom];
            [closeBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
            [closeBtn setTitle:@"关闭" forState:UIControlStateNormal];
            [closeBtn setFrame:CGRectMake((myView.width-75)/2, myView.height-60, 75, 30)];
            [closeBtn setBackgroundColor:RGB_UI_COLOR(244, 122, 117)];
            [HemaFunction addbordertoView:closeBtn radius:15 width:0 color:[UIColor clearColor]];
            [myView addSubview:closeBtn];
            
            KLCPopupLayout layout = KLCPopupLayoutMake(KLCPopupHorizontalLayoutCenter,KLCPopupVerticalLayoutCenter);
            KLCPopup* popup = [KLCPopup popupWithContentView:myView
                                                    showType:KLCPopupShowTypeFadeIn
                                                 dismissType:KLCPopupDismissTypeFadeOut
                                                    maskType:KLCPopupMaskTypeDimmed
                                    dismissOnBackgroundTouch:NO
                                       dismissOnContentTouch:NO];
            [popup showWithLayout:layout];
            
            [closeBtn addTapGestureRecognizer:^(UITapGestureRecognizer* recognizer, NSString* gestureId)
             {
                 [myView dismissPresentingPopup];
             }];
            
            break;
        }
        case 5:
        {
            [TSMessage showNotificationInViewController:self
                                                  title:@"夜雨寄北"
                                               subtitle:@"君问归期未有期，巴山夜雨涨秋池。何当共剪西窗烛，却话巴山夜雨时。"
                                                  image:nil
                                                   type:TSMessageNotificationTypeMessage
                                               duration:TSMessageNotificationDurationAutomatic
                                               callback:nil
                                            buttonTitle:@"说明"
                                         buttonCallback:^{
                                             [TSMessage showNotificationWithTitle:@"《夜雨寄北》是晚唐诗人李商隐身居异乡巴蜀，写给远在长安的妻子（或友人）的一首抒情七言绝句，是诗人给对方的复信。诗的开头两句以问答和对眼前环境的抒写，阐发了孤寂的情怀和对妻子深深的怀念。后两句即设想来日重逢谈心的欢悦，反衬今夜的孤寂。这首诗即兴写来，写出了诗人刹那间情感的曲折变化。语言朴实，在遣词、造句上看不出修饰的痕迹。与李商隐的大部分诗词表现出来的的辞藻华美，用典精巧，长于象征、暗示的风格不同，这首诗却质朴、自然，同样也具有“寄托深而措辞婉”的艺术特色。"
                                                        type:TSMessageNotificationTypeSuccess];
                                         }
                                             atPosition:TSMessageNotificationPositionTop
                                   canBeDismissedByUser:YES];
            break;
        }
        default:
            break;
    }
}
#pragma mark - ASValueTrackingSliderDataSource
- (NSString *)slider:(ASValueTrackingSlider *)slider stringForValue:(float)value;
{
    value = roundf(value);
    NSString *s;
    if (value < -10.0)
    {
        s = @"❄️庆祝吧⛄️";
    }else if(value > 29.0 && value < 50.0)
    {
        s = [NSString stringWithFormat:@"😎 %@ 😎", [slider.numberFormatter stringFromNumber:@(value)]];
    }else if(value >= 50.0)
    {
        s = @"我在哈啤~";
    }
    return s;
}
#pragma mark - ASProgressPopUpView dataSource
- (NSString *)progressView:(ASProgressPopUpView *)progressView stringForProgress:(float)progress
{
    NSString *s;
    if (progress < 0.2)
    {
        s = @"开始咯";
    }else if(progress > 0.4 && progress < 0.6)
    {
        s = @"大约一半";
    }else if(progress > 0.75 && progress < 1.0)
    {
        s = @"快到头啦";
    }else if(progress >= 1.0)
    {
        s = @"完成喽";
    }
    return s;
}
- (BOOL)progressViewShouldPreCalculatePopUpViewSize:(ASProgressPopUpView *)progressView
{
    return NO;
}
#pragma mark - RTLabelDelegate
- (void)rtLabel:(id)rtLabel didSelectLinkWithURL:(NSURL*)url
{
    TOWebViewController *webViewController = [[TOWebViewController alloc] initWithURL:url];
    webViewController.isAdjust = YES;
    [self.navigationController pushViewController:webViewController animated:YES];
}
#pragma mark - STLinkProtocol
- (void)twitterAccountClicked:(NSString *)link
{
    [UIWindow showToastMessage:link];
}
- (void)twitterHashtagClicked:(NSString *)link
{
    [UIWindow showToastMessage:link];
}
- (void)websiteClicked:(NSString *)link
{
    TOWebViewController *webViewController = [[TOWebViewController alloc] initWithURL:[NSURL URLWithString:link]];
    webViewController.isAdjust = YES;
    [self.navigationController pushViewController:webViewController animated:YES];
}
@end
