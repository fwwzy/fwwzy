//
//  RMoreFunctionVC.m
//  Hema
//
//  Created by LarryRodic on 15/10/7.
//  Copyright (c) 2015年 Hemaapp. All rights reserved.
//

#import "RExtendFunctionVC.h"

#import "STPopup.h"
#import "MMPinView.h"
#import "MMDateView.h"

#import "ITRAirSideMenu.h"
#import "RRootTBC.h"
#import "RLeftSlideVC.h"
#import "RShowWorldMapVC.h"
#import "RShowChinaMapVC.h"
#import "LGShowListVC.h"
#import "LGCollectionListVC.h"
#import "DKNightVersion.h"
#import "RLanguageChangeVC.h"
#import "ZPTradeView.h"
#import "RBlueDeviceListVC.h"
#import "LeftSlideViewController.h"
#import "RChangeThemeVC.h"
#import "PPTranslator.h"
#import "RActivityTrackingVC.h"
#import "RSphereTagVC.h"
#import "Utility.h"
#import "TYAlertVC.h"
#import "SettingModelView.h"
#import "UIView+TYAlertView.h"
#import "JCAlertView.h"
#import "LSPaoMaView.h"
#import "TYAlertController.h"
#import "DMPasscode.h"
#import "REFrostedViewController.h"
#import "RMenuDisplayVC.h"

@interface RExtendFunctionVC ()<ITRAirSideMenuDelegate>
@property(nonatomic,strong)NSMutableArray *listArr;
@end

@implementation RExtendFunctionVC

-(void)loadSet
{
    [self.navigationItem setNewTitle:@"其他模块"];
    [SystemFunction setTableSeparatorInset:self.mytable left:10];
    [self forbidPullRefresh];
}
-(void)loadData
{
    _listArr = [[NSMutableArray alloc]initWithObjects:
                @"ST弹出视图",@"MM弹出视图",@"ITR抽屉式侧滑导航",@"全球地图选择",@"中国地图选择",
                @"LG弹出视图",@"LG绘图",@"夜间模式切换",@"多语言切换",@"支付密码输入",@"蓝牙对接",
                @"QQ侧滑导航",@"更换主题",@"汉字转拼音和首字母",@"运动跟踪检测",@"标签云",@"TY弹出视图",
                @"JC弹出视图",@"跑马灯",@"验证解锁",@"侧滑菜单",nil];
}
#pragma mark- 自定义
#pragma mark 事件

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
        cell.nightBackgroundColor = BB_Gray_Color;
        
        //夜间模式
        [DKNightVersionManager addClassToSet:cell.class];
        
        //左侧
        UILabel *labLeft = [[UILabel alloc]init];
        labLeft.backgroundColor = [UIColor clearColor];
        labLeft.textAlignment = NSTextAlignmentLeft;
        labLeft.font = [UIFont systemFontOfSize:15];
        labLeft.tag = 10;
        labLeft.frame = CGRectMake(10, 0, UI_View_Width-50, 55);
        labLeft.textColor = BB_Blake_Color;
        labLeft.nightTextColor = BB_White_Color;
        [cell.contentView addSubview:labLeft];
    }
    UILabel *labLeft = (UILabel*)[cell viewWithTag:10];
    labLeft.text = [_listArr objectAtIndex:indexPath.row];
    [labLeft setText:[NSString stringWithFormat:@"%@--%d个字符",labLeft.text,labLeft.text.wordsCount]];
    
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
    
    //ST弹出视图，通过contentSizeInPopup与style来区分各种类型，具体请参考STPopupController中的属性设置
    if (0 == indexPath.row)
    {
        AllVC *myVC = [[AllVC alloc]init];
        myVC.title = @"HemaDemo";
        myVC.contentSizeInPopup = CGSizeMake([UIScreen mainScreen].bounds.size.width, 150);
        
        SettingModelView *settingModelView = [SettingModelView createViewFromNib];
        [settingModelView setFrame:CGRectMake(0, 0, UI_View_Width, 150)];
        [myVC.view addSubview:settingModelView];
        
        STPopupController *popupController = [[STPopupController alloc] initWithRootViewController:myVC];
        popupController.style = STPopupStyleBottomSheet;
        [popupController presentInViewController:self];
    }
    //MM弹出视图，一共几种可以处理
    if (1 == indexPath.row)
    {
        MMPopupItemHandler block = ^(NSInteger index)
        {
            MMPopupBlock completeBlock = ^(MMPopupView *popupView)
            {
                NSLog(@"视图弹出");
            };
            //正常弹框
            if (index == 0)
            {
                [[[MMAlertView alloc] initWithConfirmTitle:@"弹框" detail:@"你选择的是第一种样式"] showWithBlock:completeBlock];
            }
            //输入框
            if (index == 1)
            {
                [[[MMAlertView alloc] initWithInputTitle:@"弹框" detail:@"你选择的是第二种样式" placeholder:@"请留下您的大名" handler:^(NSString *text)
                  {
                      NSLog(@"输入:%@",text);
                  }]
                 showWithBlock:completeBlock];
            }
            //底部选择框
            if (index == 2)
            {
                MMPopupItemHandler sheetblock = ^(NSInteger index)
                {
                    NSLog(@"第几个：%d",(int)index);
                };
                NSArray *items =
                @[MMItemMake(@"正常", MMItemTypeNormal, sheetblock),
                  MMItemMake(@"高亮", MMItemTypeHighlight, sheetblock),
                  MMItemMake(@"不可用", MMItemTypeDisabled, sheetblock)];
                
                [[[MMSheetView alloc] initWithTitle:@"底部选择框"
                                              items:items] showWithBlock:completeBlock];
            }
            //时间筛选框
            if (index == 3)
            {
                MMDateView *dateView = [MMDateView new];
                [dateView showWithBlock:completeBlock];
            }
        };
        
        NSArray *items =
        @[MMItemMake(@"正常弹框", MMItemTypeNormal, block),
          MMItemMake(@"输入框", MMItemTypeNormal, block),
          MMItemMake(@"底部选择框", MMItemTypeHighlight, block),
          MMItemMake(@"时间筛选框", MMItemTypeNormal, block),
          MMItemMake(@"取消", MMItemTypeNormal, block)];
        
        MMAlertView *alertView = [[MMAlertView alloc] initWithTitle:@"选择样式"
                                                             detail:@"点击下面的按钮选取要弹出的样式"
                                                              items:items];
        alertView.attachedView = self.view;
        [alertView show];
    }
    //ITR抽屉式侧滑导航
    if (2 == indexPath.row)
    {
        RRootTBC * root = [[RRootTBC alloc] init];
        RLeftSlideVC *left = [[RLeftSlideVC alloc] init];
        
        ITRAirSideMenu *menu = [[ITRAirSideMenu alloc]initWithContentViewController:root leftMenuViewController:left];
        menu.delegate = self;
        menu.backgroundImage = [UIImage imageNamed:@"1242*2208.png"];
        
        //设置各种属性，自己研究去，内容更改请关注ITRAirSideMenu类
        menu.contentViewShadowColor = [UIColor blackColor];
        menu.contentViewShadowOffset = CGSizeMake(0, 0);
        menu.contentViewShadowOpacity = 0.6;
        menu.contentViewShadowRadius = 12;
        menu.contentViewShadowEnabled = YES;
        
        menu.contentViewScaleValue = 0.9f;
        menu.contentViewRotatingAngle = 20.0f;
        menu.contentViewTranslateX = 100;
        
        menu.menuViewRotatingAngle = 10.0f;
        menu.menuViewTranslateX = 30.0f;
        
        [HemaFunction xfuncGetAppdelegate].window.rootViewController = menu;
        [[HemaManager sharedManager]resSetRootArr:menu];
    }
    //全球地图选择
    if (3 == indexPath.row)
    {
        RShowWorldMapVC *myVC = [[RShowWorldMapVC alloc]init];
        [self.navigationController pushViewController:myVC animated:YES];
    }
    //中国地图选择
    if (4 == indexPath.row)
    {
        RShowChinaMapVC *myVC = [[RShowChinaMapVC alloc]init];
        [self.navigationController pushViewController:myVC animated:YES];
    }
    //LG弹出视图
    if (5 == indexPath.row)
    {
        LGShowListVC *myVC = [[LGShowListVC alloc]init];
        [self.navigationController pushViewController:myVC animated:YES];
    }
    //LG绘图
    if (6 == indexPath.row)
    {
        LGCollectionListVC *myVC = [[LGCollectionListVC alloc]init];
        [self.navigationController pushViewController:myVC animated:YES];
    }
    //夜间模式
    if (7 == indexPath.row)
    {
        //夜间的，每个控件都要设置夜间的颜色，需要做此功能的注意下。
        if ([DKNightVersionManager currentThemeVersion] == DKThemeVersionNight)
        {
            [DKNightVersionManager dawnComing];
        }else
        {
            [DKNightVersionManager nightFalling];
        }
    }
    //多语言切换
    if (8 == indexPath.row)
    {
        RLanguageChangeVC *myVC = [[RLanguageChangeVC alloc]init];
        [self.navigationController pushViewController:myVC animated:YES];
    }
    //支付密码输入
    if (9 == indexPath.row)
    {
        ZPTradeView *view = [[ZPTradeView alloc] initWithFrame:self.view.frame];
        view.finish = ^(NSString *password)
        {
            NSLog(@"输入的密码：%@",password);
        };
        [view show];
    }
    //蓝牙对接
    if (10 == indexPath.row)
    {
        RBlueDeviceListVC *myVC = [[RBlueDeviceListVC alloc]init];
        [self.navigationController pushViewController:myVC animated:YES];
    }
    //QQ侧滑导航
    if (11 == indexPath.row)
    {
        RRootTBC * root = [[RRootTBC alloc] init];
        RLeftSlideVC *left = [[RLeftSlideVC alloc] init];
        LeftSlideViewController *leftSlideVC = [[LeftSlideViewController alloc] initWithLeftView:left andMainView:root];
        [HemaFunction xfuncGetAppdelegate].window.rootViewController = leftSlideVC;
        [[HemaManager sharedManager]resSetRootArr:leftSlideVC];
    }
    //更换主题
    if (12 == indexPath.row)
    {
        RChangeThemeVC *myVC = [[RChangeThemeVC alloc]init];
        [self.navigationController pushViewController:myVC animated:YES];
    }
    //汉字转拼音和首字母
    if (13 == indexPath.row)
    {
        NSString *myStr = @"收拾起大地山河一担装，四大皆空相。历尽了渺渺程途，漠漠平林，叠叠高山，滚滚长江。但见那寒云惨雾和愁织，受不尽苦雨凄风带怨长。雄城壮，看江山无恙，谁识我一瓢一笠到襄阳？";
        NSString *detail = [NSString stringWithFormat:@"%@\n%@",[myStr translatorToPinYinFirstAscii],[Utility getPinyinFromChinese:myStr]];
        [[[MMAlertView alloc] initWithConfirmTitle:myStr detail:detail] showWithBlock:nil];
    }
    //运动跟踪检测
    if (14 == indexPath.row)
    {
        RActivityTrackingVC *myVC = [[RActivityTrackingVC alloc]init];
        [self.navigationController pushViewController:myVC animated:YES];
    }
    //标签云
    if (15 == indexPath.row)
    {
        RSphereTagVC *myVC = [[RSphereTagVC alloc]init];
        [self.navigationController pushViewController:myVC animated:YES];
    }
    //TY弹出视图
    if (16 == indexPath.row)
    {
        TYAlertVC *myVC = [[TYAlertVC alloc]init];
        [self.navigationController pushViewController:myVC animated:YES];
    }
    //JC弹出视图
    if (17 == indexPath.row)
    {
        [JCAlertView showOneButtonWithTitle:@"你个傻X" Message:@"让你点你就点呀？" ButtonType:JCAlertViewButtonTypeDefault ButtonTitle:@"是呀" Click:^{
            
        }];
        
        [JCAlertView showMultipleButtonsWithTitle:@"人生自古谁无死" Message:@"下一句是啥来着？" Click:^(NSInteger index)
         {
             
         } Buttons:@{@(JCAlertViewButtonTypeDefault):@"留取丹心照汗青"},@{@(JCAlertViewButtonTypeCancel):@"早死晚死都得死"},@{@(JCAlertViewButtonTypeWarn):@"死亡不要紧，只要主义真"}, nil];
        
        [JCAlertView showTwoButtonsWithTitle:@"朋友" Message:@"感觉不是太好用呀，还想看么？" ButtonType:JCAlertViewButtonTypeCancel ButtonTitle:@"再见" Click:^{
            
        }ButtonType:JCAlertViewButtonTypeDefault ButtonTitle:@"好的" Click:^{
            
        }];
    }
    //跑马灯
    if (18 == indexPath.row)
    {
        NSString* text = @"世有璞玉，镂而为玺。纳入私藏，欲以万史。仅此二代，转移风水。可怜当初，如今竖子。千百风雨，或悲或喜。一旦失之，白板而已。哀哉荆山，刖足不止。抱泣顽石，自比贞士。吁戏不见，英雄馀几。各将私心，垢污卞氏。笑称传国，国乃自己。不如怀抱，深山云里。";
        LSPaoMaView* paomav = [[LSPaoMaView alloc] initWithFrame:CGRectMake(20, 0, UI_View_Width-40, 44) title:text];
        
        TYAlertController *alertController = [TYAlertController alertControllerWithAlertView:paomav preferredStyle:TYAlertControllerStyleAlert];
        alertController.backgoundTapDismissEnable = YES;
        [self presentViewController:alertController animated:YES completion:nil];
    }
    //验证解锁
    if (19 == indexPath.row)
    {
        UIView *myView = [[UIView alloc]init];
        [myView setBackgroundColor:BB_White_Color];
        [myView setFrame:CGRectMake(0, 0, UI_View_Width, 240)];
        
        BOOL passcodeSet = [DMPasscode isPasscodeSet];
        for (int i = 0; i<3; i++)
        {
            HemaButton *closeBtn = [HemaButton buttonWithType:UIButtonTypeCustom];
            [closeBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
            [closeBtn setTitle:(i == 0)?@"设置":((i == 1)?@"验证":@"移除") forState:UIControlStateNormal];
            [closeBtn setFrame:CGRectMake((UI_View_Width-100)/2, 80*i+20, 100, 40)];
            [closeBtn setBackgroundColor:RGB_UI_COLOR(244, 122, 117)];
            [HemaFunction addbordertoView:closeBtn radius:20 width:0 color:[UIColor clearColor]];
            [myView addSubview:closeBtn];
            
            if (i != 0)
            {
                [closeBtn setEnabled:passcodeSet];
                if (!passcodeSet)
                {
                    [closeBtn setBackgroundColor:BB_Blake_Color];
                }
            }
            
            [closeBtn addTapGestureRecognizer:^(UITapGestureRecognizer* recognizer, NSString* gestureId)
             {
                 [myView hideView];
                 
                 //设置
                 if (i == 0)
                 {
                     [DMPasscode setupPasscodeInViewController:self completion:^(BOOL success)
                      {
                          if (success)
                          {
                              [UIWindow showToastMessage:@"设置成功"];
                          }else
                          {
                              [UIWindow showToastMessage:@"设置失败"];
                          }
                      }];
                 }
                 //验证
                 if (i == 1)
                 {
                     [DMPasscode showPasscodeInViewController:self completion:^(BOOL success)
                     {
                         if (success)
                         {
                             [UIWindow showToastMessage:@"验证成功"];
                         }else
                         {
                             [UIWindow showToastMessage:@"验证失败"];
                         }
                     }];
                 }
                 //移除
                 if (i == 2)
                 {
                     [DMPasscode removePasscode];
                     [UIWindow showToastMessage:@"移除成功"];
                 }
             }];
        }
        
        TYAlertController *alertController = [TYAlertController alertControllerWithAlertView:myView preferredStyle:TYAlertControllerStyleActionSheet];
        alertController.backgoundTapDismissEnable = YES;
        [self presentViewController:alertController animated:YES completion:nil];
    }
    //侧滑菜单
    if (20 == indexPath.row)
    {
        RMenuDisplayVC * myVC = [[RMenuDisplayVC alloc] init];
        LCPanNavigationController *nav = [[LCPanNavigationController alloc]initWithRootViewController:myVC];
        RLeftSlideVC *left = [[RLeftSlideVC alloc] init];
        
        REFrostedViewController *frostedViewController = [[REFrostedViewController alloc] initWithContentViewController:nav menuViewController:left];
        frostedViewController.direction = REFrostedViewControllerDirectionLeft;
        frostedViewController.liveBlurBackgroundStyle = REFrostedViewControllerLiveBackgroundStyleLight;
        frostedViewController.liveBlur = YES;
        [HemaFunction xfuncGetAppdelegate].window.rootViewController = frostedViewController;
        [[HemaManager sharedManager]resSetRootArr:frostedViewController];
    }
}
@end
