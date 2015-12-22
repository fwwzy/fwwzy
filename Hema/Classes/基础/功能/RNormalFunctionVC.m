//
//  RNormalFunctionVC.m
//  Hema
//
//  Created by geyang on 15/11/5.
//  Copyright © 2015年 Hemaapp. All rights reserved.
//

#import "RNormalFunctionVC.h"
#import "RChangPasswordVC.h"
#import "RColectionListVC.h"
#import "RMyAccountVC.h"
#import "RMessageVC.h"
#import "JRSegmentViewController.h"
#import "FDShowCalendarVC.h"
#import "BlurCommentView.h"
#import "RMoreSelectItemVC.h"
#import "E_ScrollViewController.h"
#import "WXViewController.h"
#import "RNavBarShowHideVC.h"
#import "EPUBParser.h"
#import "EPUBReadMainViewController.h"
#import "RMenuDisplayVC.h"
#import "RNormalListVC.h"

@interface RNormalFunctionVC ()
@property(nonatomic,strong)NSMutableArray *listArr;
@property(nonatomic,strong)EPUBParser *epubParser;///<epub解析器，成员变量或全局
@end

@implementation RNormalFunctionVC

-(void)loadSet
{
    [self.navigationItem setNewTitle:@"基础功能"];
    [SystemFunction setTableSeparatorInset:self.mytable left:10];
    [self forbidPullRefresh];
    
    //如果是电子书阅读器软件，可把这个写在appdelegate里面
    _epubParser=[[EPUBParser alloc] init];
}
-(void)loadData
{
    _listArr = [[NSMutableArray alloc]initWithObjects:
                @"重设密码",@"瀑布流展示",@"账户管理",@"系统通知",@"固定选项卡切换",
                @"日历展示",@"跟帖回复",@"多级类型筛选",@"电子书阅读器",@"朋友圈",@"导航隐藏与显示",@"菜单样式",@"列表样式",nil];
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
    
    //重设密码
    if (0 == indexPath.row)
    {
        RChangPasswordVC *myVC = [[RChangPasswordVC alloc]init];
        myVC.keytype = 1;
        [self.navigationController pushViewController:myVC animated:YES];
    }
    //瀑布流展示
    if (1 == indexPath.row)
    {
        RColectionListVC *myVC = [[RColectionListVC alloc]init];
        [self.navigationController pushViewController:myVC animated:YES];
    }
    //账户管理
    if (2 == indexPath.row)
    {
        RMyAccountVC *myVC = [[RMyAccountVC alloc]init];
        [self.navigationController pushViewController:myVC animated:YES];
    }
    //系统通知
    if (3 == indexPath.row)
    {
        RMessageVC *myVC = [[RMessageVC alloc]init];
        [self.navigationController pushViewController:myVC animated:YES];
    }
    //固定选项卡切换
    if (4 == indexPath.row)
    {
        RColectionListVC *firstVC = [[RColectionListVC alloc] init];
        RMyAccountVC *secondVC = [[RMyAccountVC alloc] init];
        RMessageVC *thirdVC = [[RMessageVC alloc] init];
        
        //新建页面继承JRSegmentViewController 在此页面处理主要逻辑。如无其他逻辑，请废弃此页面直接调用JRSegmentViewController
        
        JRSegmentViewController *vc = [[JRSegmentViewController alloc] init];
        vc.segmentBgColor = BB_Orange_Color;
        vc.indicatorViewColor = [UIColor whiteColor];
        
        [vc setItemWidth:60];
        [vc setViewControllers:@[firstVC, secondVC, thirdVC]];
        [vc setTitles:@[@"瀑布流", @"账户", @"通知"]];
        
        [self.navigationController pushViewController:vc animated:YES];
    }
    //日历
    if (5 == indexPath.row)
    {
        FDShowCalendarVC *myVC = [[FDShowCalendarVC alloc]init];
        [self.navigationController pushViewController:myVC animated:YES];
    }
    //跟帖回复
    if (6 == indexPath.row)
    {
        [BlurCommentView commentshowSuccess:^(NSString *text)
         {
             NSLog(@"跟帖回复：%@",text);
         }];
    }
    //多级类型筛选
    if (7 == indexPath.row)
    {
        RMoreSelectItemVC *myVC = [[RMoreSelectItemVC alloc]init];
        [self.navigationController pushViewController:myVC animated:YES];
    }
    //电子书阅读器
    if (8 == indexPath.row)
    {
        MMPopupItemHandler sheetblock = ^(NSInteger index)
        {
            if (index == 0)
            {
                E_ScrollViewController *myVC = [[E_ScrollViewController alloc]init];
                [self.navigationController pushViewController:myVC animated:YES];
            }
            if (index == 1)
            {
                NSString *fileFullPath = [[NSBundle mainBundle] pathForResource:@"为人处世曾国藩" ofType:@"epub" inDirectory:nil];
                NSMutableDictionary *fileInfo = [NSMutableDictionary dictionary];
                [fileInfo setObject:fileFullPath forKey:@"fileFullPath"];
                
                EPUBReadMainViewController *epubVC = [EPUBReadMainViewController new];
                epubVC.epubParser = self.epubParser;
                epubVC.fileInfo = fileInfo;
                epubVC.epubReadBackBlock=^(NSMutableDictionary *para1)
                {
                    [self dismissViewControllerAnimated:YES completion:nil];
                    return 1;
                };
                [self.navigationController presentViewController:epubVC animated:YES completion:nil];
            }
        };
        NSArray *items =
        @[MMItemMake(@"Text阅读器", MMItemTypeNormal, sheetblock),
          MMItemMake(@"Epub阅读器", MMItemTypeNormal, sheetblock)];
        
        [[[MMSheetView alloc] initWithTitle:@"电子书"
                                      items:items] showWithBlock:nil];
    }
    //朋友圈
    if (9 == indexPath.row)
    {
        WXViewController *myVC = [[WXViewController alloc]init];
        [self.navigationController pushViewController:myVC animated:YES];
    }
    //导航隐藏与显示
    if (10 == indexPath.row)
    {
        RNavBarShowHideVC *myVC = [[RNavBarShowHideVC alloc]init];
        [self.navigationController pushViewController:myVC animated:YES];
    }
    //菜单样式
    if (11 == indexPath.row)
    {
        RMenuDisplayVC *myVC = [[RMenuDisplayVC alloc]init];
        [self.navigationController pushViewController:myVC animated:YES];
    }
    //列表样式
    if (12 == indexPath.row)
    {
        RNormalListVC *myVC = [[RNormalListVC alloc]init];
        [self.navigationController pushViewController:myVC animated:YES];
    }
}
@end
