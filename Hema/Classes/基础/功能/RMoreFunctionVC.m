//
//  RMoreFunctionVC.m
//  Hema
//
//  Created by LarryRodic on 15/10/7.
//  Copyright (c) 2015年 Hemaapp. All rights reserved.
//

#import "RMoreFunctionVC.h"
#import "RExtendFunctionVC.h"
#import "RGeoMapShowVC.h"
#import "RNormalFunctionVC.h"
#import "RVideoFunctionVC.h"
#import "HCSStarRatingView.h"
#import "RExpandFunctionVC.h"

#import "BFTouchID.h"
#import "SYSSPasteboardView.h"
#import "HemaLongGR.h"
#import "RSelectLocationVC.h"
#import "RPublishBlogVC.h"
#import "BFSystemSound.h"

@interface RMoreFunctionVC ()
@property(nonatomic,strong)NSMutableArray *listArr;///<列表数组
@end

@implementation RMoreFunctionVC

-(void)loadSet
{
    [self.navigationItem setNewTitle:@"功能分类"];
    [self.navigationItem setRightItemWithTarget:self action:@selector(rightbtnPressed:) image:@"R聊天右导航设置按钮.png"];
    
    //设置边线位移 只有位移等于10时才这样设置 大于10 可以直接[self.mytable setSeparatorInset:UIEdgeInsetsMake(0, x, 0, 0)];
    [SystemFunction setTableSeparatorInset:self.mytable left:10];
    
    [self forbidPullRefresh];
    
    //底部
    UILabel *labDown = [[UILabel alloc]init];
    labDown.backgroundColor = [UIColor clearColor];
    labDown.textAlignment = NSTextAlignmentCenter;
    labDown.font = [UIFont systemFontOfSize:15];
    labDown.text = @"长按列表试试";
    labDown.frame = CGRectMake(0, UI_View_Height-50, UI_View_Width, 50);
    labDown.textColor = BB_Blake_Color;
    [self.view addSubview:labDown];
}
-(void)loadData
{
    _listArr = [[NSMutableArray alloc]initWithObjects:
                @"基础模块",@"音视图模块",@"地图模块",@"其他模块",@"类库扩展模块",nil];
}
#pragma mark- 自定义
#pragma mark 事件
-(void)rightbtnPressed:(id)sender
{
    [BFSystemSound playSystemSound:AudioIDShake];
    
    RPublishBlogVC *myVC = [[RPublishBlogVC alloc]init];
    myVC.publishBlogOK = ^(RPublishBlogVC *publishVC)
    {
        NSLog(@"帖子发布完成");
    };
    LCPanNavigationController *nav = [[LCPanNavigationController alloc]initWithRootViewController:myVC];
    [self presentViewController:nav animated:YES completion:nil];
}
//评价星级
-(void)didChangeValue:(HCSStarRatingView*)sender
{
    NSLog(@"评分：%.1f", sender.value);
}
//长按手势
-(void)longPressed:(HemaLongGR*)sender
{
    if(sender.state == UIGestureRecognizerStateBegan)
    {
        UITableViewCell *cell = (UITableViewCell *)[self.mytable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:sender.touchRow inSection:0]];
        SYSSPasteboardView* paste = [SYSSPasteboardView shareInstance];
        //复制
        [paste setPasteCopyBlock:^{
            [UIPasteboard generalPasteboard].string = [_listArr objectAtIndex:sender.touchRow];
            [UIWindow showToastMessage:@"已复制~ \n您可以粘贴给你的小伙伴啦！！！"];
        }];
        ///举报
        [paste setPasteReportBlock:^{
            [Utility popMessage:@"感谢您的举报，你走吧~"];
        }];
        //删除
        [paste setPasteDeleteBlock:^{
            [UIWindow showToastMessage:@"可不允许你私自删除呵~"];
        }];
        [paste showMenuWithView:cell inView:self.mytable];
    }
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
        labLeft.frame = CGRectMake(10, 0, 150, 55);
        labLeft.textColor = BB_Blake_Color;
        labLeft.userInteractionEnabled = YES;
        [cell.contentView addSubview:labLeft];
        
        //评分
        HCSStarRatingView *starRatingView = [[HCSStarRatingView alloc] initWithFrame:CGRectZero];
        starRatingView.maximumValue = 5;
        starRatingView.minimumValue = 0;
        starRatingView.allowsHalfStars = YES;
        starRatingView.spacing = 5;
        starRatingView.tag = 11;
        starRatingView.tintColor = [UIColor redColor];
        [starRatingView addTarget:self action:@selector(didChangeValue:) forControlEvents:UIControlEventValueChanged];
        [cell.contentView addSubview:starRatingView];
        
        //长按
        HemaLongGR *myLong = [[HemaLongGR alloc]initWithTarget:self action:@selector(longPressed:)];
        myLong.minimumPressDuration = 0.5;
        [cell.contentView addGestureRecognizer:myLong];
    }
    UILabel *labLeft = (UILabel*)[cell viewWithTag:10];
    labLeft.text = [_listArr objectAtIndex:indexPath.row];
    
    HCSStarRatingView *starRatingView = (HCSStarRatingView*)[cell viewWithTag:11];
    
    if (0 == indexPath.row)
        starRatingView.value = 4;
    if (1 == indexPath.row)
        starRatingView.value = 4.5;
    if (2 == indexPath.row)
        starRatingView.value = 3;
    if (3 == indexPath.row)
        starRatingView.value = 1.5;
    if (4 == indexPath.row)
        starRatingView.value = 5;
    
    CGSize leftSize = [HemaFunction getSizeWithStrNo:labLeft.text width:200 font:15];
    [labLeft setFrame:CGRectMake(10, 0, leftSize.width, 55)];
    [starRatingView setFrame:CGRectMake(10+leftSize.width+10, 0, 100, 55)];
    
    //如无需点击效果，可进行以下设置
    [starRatingView setUserInteractionEnabled:NO];
    
    //手势
    HemaLongGR *myLong = (HemaLongGR*)[cell.contentView.gestureRecognizers lastObject];
    myLong.touchRow = indexPath.row;
    
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
    
    //基础模块
    if (0 == indexPath.row)
    {
        RNormalFunctionVC *myVC = [[RNormalFunctionVC alloc]init];
        [self.navigationController pushViewController:myVC animated:YES];
    }
    //音视图模块
    if (1 == indexPath.row)
    {
        RVideoFunctionVC *myVC = [[RVideoFunctionVC alloc]init];
        [self.navigationController pushViewController:myVC animated:YES];
    }
    //地图模块
    if (2 == indexPath.row)
    {
        MMPopupItemHandler sheetblock = ^(NSInteger index)
        {
            float tolat = 36.547901;
            float tolng = 104.258354;
            
            if (index == 0)
            {
                RGeoMapShowVC *myVC = [[RGeoMapShowVC alloc]init];
                [self.navigationController pushViewController:myVC animated:YES];
            }
            if (index == 1)
            {
                RSelectLocationVC *myVC = [[RSelectLocationVC alloc]init];
                myVC.keytype = 1;
                myVC.confirmCoordinate = ^(CGFloat lat,CGFloat lng,NSString *address)
                {
                    [HemaFunction openIntervalHUD:[NSString stringWithFormat:@"你选择的地点：%@",address]];
                };
                [self.navigationController pushViewController:myVC animated:YES];
            }
            if (index == 2)
            {
                NSString *string = [NSString stringWithFormat:@"http://maps.apple.com/maps?saddr=%f,%f&daddr=%f,%f",[HemaFunction xfuncGetAppdelegate].myCoordinate.latitude,[HemaFunction xfuncGetAppdelegate].myCoordinate.longitude,tolat,tolng];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:string]];
            }
            if (index == 3)
            {
                NSString *stringURL = [NSString stringWithFormat:@"qqmap://map/routeplan?type=drive&&fromcoord=%f,%f&tocoord=%f,%f&policy=1",[HemaFunction xfuncGetAppdelegate].myCoordinate.latitude,[HemaFunction xfuncGetAppdelegate].myCoordinate.longitude,tolat,tolng];
                NSURL *mapUrl = [NSURL URLWithString:[stringURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                if ([[UIApplication sharedApplication] canOpenURL:mapUrl])
                {
                    [[UIApplication sharedApplication] openURL:mapUrl];
                }else
                {
                    [UIWindow showToastMessage:@"请安装腾讯地图"];
                }
            }
            if (index == 4)
            {
                NSString *stringURL = [NSString stringWithFormat:@"baidumap://map/geocoder?location=%f,%f&coord_type=gcj02&src=%@",tolat,tolng,@"HemaDemo"];
                NSURL *mapUrl = [NSURL URLWithString:[stringURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                if ([[UIApplication sharedApplication] canOpenURL:mapUrl])
                {
                    [[UIApplication sharedApplication] openURL:mapUrl];
                }else
                {
                    [UIWindow showToastMessage:@"请安装百度地图"];
                }
            }
            if (index == 5)
            {
                NSString *stringURL = [NSString stringWithFormat:@"iosamap://navi?sourceApplication=%@&backScheme=%@&poiname=%@&lat=%f&lon=%f&dev=1&style=2",@"河马Demo", @"HemaDemo", @"终点",tolat,tolng];
                NSURL *mapUrl = [NSURL URLWithString:[stringURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                if ([[UIApplication sharedApplication] canOpenURL:mapUrl])
                {
                    [[UIApplication sharedApplication] openURL:mapUrl];
                }else
                {
                    [UIWindow showToastMessage:@"请安装高德地图"];
                }
            }
        };
        NSArray *items =
        @[MMItemMake(@"路线规划", MMItemTypeHighlight, sheetblock),
          MMItemMake(@"地址选择与搜索", MMItemTypeHighlight, sheetblock),
          MMItemMake(@"系统地图导航", MMItemTypeNormal, sheetblock),
          MMItemMake(@"腾讯地图导航", MMItemTypeNormal, sheetblock),
          MMItemMake(@"百度地图导航", MMItemTypeNormal, sheetblock),
          MMItemMake(@"高德地图导航", MMItemTypeNormal, sheetblock)];
        
        [[[MMSheetView alloc] initWithTitle:@"地图模块"
                                      items:items] showWithBlock:nil];
    }
    //其他模块
    if (3 == indexPath.row)
    {
        RExtendFunctionVC *myVC = [[RExtendFunctionVC alloc]init];
        [self.navigationController pushViewController:myVC animated:YES];
    }
    //类库扩展模块
    if (4 == indexPath.row)
    {
        RExpandFunctionVC *myVC = [[RExpandFunctionVC alloc]init];
        [self.navigationController pushViewController:myVC animated:YES];
    }
}
@end
