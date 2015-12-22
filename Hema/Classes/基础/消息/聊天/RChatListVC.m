//
//  RChatListVC.m
//  Hema
//
//  Created by LarryRodic on 15/10/9.
//  Copyright (c) 2015年 Hemaapp. All rights reserved.
//

#import "RChatListVC.h"
#import "HemaSwipeGR.h"
#import <sqlite3.h>
#import "RMyChatVC.h"

@interface RChatListVC ()<UIGestureRecognizerDelegate>
@property(nonatomic,strong)NSMutableArray *dataSource;
@property(nonatomic,copy)NSString *databasePath;
@end

@implementation RChatListVC
@synthesize dataSource;

-(void)loadSet
{
    [self.navigationItem setNewTitle:@"消息列表"];
    [self.mytable setSeparatorInset:UIEdgeInsetsMake(0, 72, 0, 0)];
    
    [self forbidAddMore];
    _databasePath = [SystemFunction openDataBase];
}
-(void)loadData
{
    [self refresh];
}
#pragma mark- 自定义
#pragma mark 事件
//删除
-(void)gotoDelete:(HemaButton*)sender
{
    myRow = sender.btnRow;
    
    NSMutableDictionary *temDic = [dataSource objectAtIndex:sender.btnRow];
    NSString *insertSQL = [NSString stringWithFormat:@"update message set isdelete = 1 WHERE dxgroupid = '%@'",[temDic objectForKey:@"dxgroupid"]];
    if ([[temDic objectForKey:@"dxgroupid"]integerValue] == 0)
    {
        insertSQL = [NSString stringWithFormat:@"update message set isdelete = 1 WHERE talker = '%@'",[temDic objectForKey:@"talker"]];
    }
    [SystemFunction exceSQL:insertSQL];
    
    //后续动作
    [dataSource removeObjectAtIndex:myRow];
    [self.mytable deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:myRow inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    isSwipe = NO;
    myRow = -1;
    [NSTimer scheduledTimerWithTimeInterval:0.4 target:self selector:@selector(reShowView) userInfo:nil repeats:NO];
}
//处理手势滑动操作的方法
-(void)swipePressed:(HemaSwipeGR*)sender
{
    NSInteger rowId = sender.touchRow;
    if (isSwipe)
    {
        isSwipe = NO;
        [self.mytable reloadData];
        return;
    }else
    {
        isSwipe = YES;
        //获取选中的单元格
        if (sender.direction == UISwipeGestureRecognizerDirectionLeft)
        {
            if (myRow == rowId)
            {
                return;
            }
            myRow = rowId;
            
            UITableViewCell *temCell = (UITableViewCell *)[self.mytable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:rowId inSection:0]];
            for (int i = 0; i < dataSource.count; i++)
            {
                UITableViewCell *allCell = (UITableViewCell *)[self.mytable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                [SystemFunction actionActive];
                UIView *leftViewTem = (UIView*)[allCell viewWithTag:8];
                float height = leftViewTem.frame.size.height;
                [leftViewTem setFrame:CGRectMake(0, 0, UI_View_Width, height)];
                [UIView commitAnimations];
            }
            UIView *leftView = (UIView*)[temCell viewWithTag:8];
            if (leftView.frame.origin.x >= 0)
            {
                [SystemFunction actionActive];
                float height = leftView.frame.size.height;
                [leftView setFrame:CGRectMake(-84, 0, UI_View_Width, height)];
                [UIView commitAnimations];
            }
        }
        if (sender.direction == UISwipeGestureRecognizerDirectionRight)
        {
            UITableViewCell *temCell = (UITableViewCell *)[self.mytable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:rowId inSection:0]];
            UIView *leftView = (UIView*)[temCell viewWithTag:8];
            if (leftView.frame.origin.x < 0)
            {
                [SystemFunction actionActive];
                float height = leftView.frame.size.height;
                [leftView setFrame:CGRectMake(0, 0, UI_View_Width, height)];
                [UIView commitAnimations];
                myRow = -1;
            }
        }
    }
    return;
}
#pragma mark- UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.mytable)
    {
        if (isSwipe)
        {
            isSwipe = NO;
            myRow = -1;
            [self.mytable reloadData];
            return;
        }
        [super scrollViewDidScroll:scrollView];
    }
}
#pragma mark - UITableView dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"all";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.backgroundColor = BB_Red_Color;
        
        //右侧按钮
        HemaButton *btnRight = [HemaButton buttonWithType:UIButtonTypeCustom];
        [btnRight setFrame:CGRectMake(UI_View_Width-84, 0, 84, 76)];
        btnRight.tag = 6;
        [cell.contentView addSubview:btnRight];
        
        //右侧删除
        UILabel *labDelete = [[UILabel alloc]init];
        labDelete.backgroundColor = [UIColor clearColor];
        labDelete.textColor = BB_White_Color;
        labDelete.textAlignment = NSTextAlignmentCenter;
        labDelete.font = [UIFont boldSystemFontOfSize:17];
        labDelete.frame = CGRectMake(0, 0, 84, 76);
        labDelete.tag = 7;
        labDelete.text = @"删除";
        [btnRight addSubview:labDelete];
        
        //左侧view
        UIView *leftView = [[UIView alloc]init];
        [leftView setFrame:CGRectMake(0,0, UI_View_Width, 76)];
        [leftView setBackgroundColor:BB_White_Color];
        leftView.tag = 8;
        [cell.contentView addSubview:leftView];
        
        //图标
        HemaImgView *picImgView = [[HemaImgView alloc]init];
        [picImgView setFrame:CGRectMake(10, 12, 50, 50)];
        [HemaFunction addbordertoView:picImgView radius:5 width:0.0 color:[UIColor clearColor]];
        picImgView.tag = 9;
        [leftView addSubview:picImgView];
        
        //左侧
        UILabel *labLeft = [[UILabel alloc]init];
        labLeft.backgroundColor = [UIColor clearColor];
        labLeft.textAlignment = NSTextAlignmentLeft;
        labLeft.font = [UIFont systemFontOfSize:15];
        [labLeft setFrame:CGRectMake(72, 15, UI_View_Width-180, 17)];
        labLeft.tag = 10;
        [labLeft setTextColor:BB_Blake_Color];
        [leftView addSubview:labLeft];
        
        //内容
        UILabel *labRight = [[UILabel alloc]init];
        labRight.backgroundColor = [UIColor clearColor];
        labRight.textAlignment = NSTextAlignmentLeft;
        labRight.textColor = BB_Gray_Color;
        labRight.font = [UIFont systemFontOfSize:13];
        labRight.frame = CGRectMake(72, 41, UI_View_Width-82, 15);
        labRight.tag = 11;
        [leftView addSubview:labRight];
        
        //时间
        UILabel *labTime = [[UILabel alloc]init];
        labTime.backgroundColor = [UIColor clearColor];
        labTime.textAlignment = NSTextAlignmentRight;
        labTime.textColor = BB_Gray_Color;
        labTime.font = [UIFont systemFontOfSize:12];
        labTime.frame = CGRectMake(UI_View_Width-100, 15, 90, 17);
        labTime.tag = 12;
        [leftView addSubview:labTime];
        
        //聊天数量
        UIButton *countButton = [UIButton buttonWithType:UIButtonTypeCustom];
        countButton.frame = CGRectMake(50, 2, 20, 20);
        [countButton setBackgroundColor:BB_Red_Color];
        [countButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        countButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        countButton.titleLabel.font = [UIFont boldSystemFontOfSize:12];
        [countButton setHidden:YES];
        countButton.tag = 13;
        [HemaFunction addbordertoView:countButton radius:10.0f width:1.0f color:BB_White_Color];
        [leftView addSubview:countButton];
        
        //滑动
        HemaSwipeGR *temSwipeUp = [[HemaSwipeGR alloc]init];
        [temSwipeUp setDirection:UISwipeGestureRecognizerDirectionLeft];
        [temSwipeUp addTarget:self action:@selector(swipePressed:)];
        [leftView addGestureRecognizer:temSwipeUp];
        
        HemaSwipeGR *temSwipeDown = [[HemaSwipeGR alloc]init];
        [temSwipeDown setDirection:UISwipeGestureRecognizerDirectionRight];
        [temSwipeDown addTarget:self action:@selector(swipePressed:)];
        [leftView addGestureRecognizer:temSwipeDown];
    }
    NSMutableDictionary *temDic = [dataSource objectAtIndex:indexPath.row];
    
    //图标
    HemaImgView *picImgView = (HemaImgView*)[cell viewWithTag:9];
    
    UILabel *labLeft = (UILabel*)[cell viewWithTag:10];
    
    //单聊
    if ([[temDic objectForKey:@"dxgroupid"]integerValue] == 0)
    {
        labLeft.text = [temDic objectForKey:@"talkername"];
        [SystemFunction cashImgView:picImgView url:[temDic objectForKey:@"talkeravatar"] firstImg:@"R默认小头像.png"];
    }else//群聊
    {
        [picImgView setImage:[UIImage imageNamed:@"R群组logo.png"]];
        labLeft.text = [temDic objectForKey:@"dxgroupname"];
    }
    
    //聊天数量
    UIButton *countButton = (UIButton*)[cell viewWithTag:13];
    if ([[temDic objectForKey:@"count"]integerValue] == 0)
    {
        [countButton setHidden:YES];
    }else
    {
        [countButton setHidden:NO];
        if ([[temDic objectForKey:@"count"]integerValue] < 100)
        {
            [countButton setTitle:[temDic objectForKey:@"count"] forState:UIControlStateNormal];
        }else
        {
            [countButton setTitle:@"99" forState:UIControlStateNormal];
        }
    }
    //内容
    UILabel *labRight = (UILabel*)[cell viewWithTag:11];
    
    NSString *temStr = [temDic objectForKey:@"body"];
    
    //图片
    if (2 == [[temDic objectForKey:@"dxpacktype"]integerValue])
    {
        temStr = @"[图片]";
    }
    //音频
    if (3 == [[temDic objectForKey:@"dxpacktype"]integerValue])
    {
        temStr = @"[音频]";
    }
    //视频
    if (4 == [[temDic objectForKey:@"dxpacktype"]integerValue])
    {
        temStr = @"[视频]";
    }
    
    if ([[temDic objectForKey:@"dxgroupid"]integerValue] == 0)
    {
        [labRight setText:[NSString stringWithFormat:@"%@",temStr]];
    }else
    {
        [labRight setText:[NSString stringWithFormat:@"%@：%@",[temDic objectForKey:@"dxclientname"],temStr]];
    }
    
    //时间
    UILabel *labTime = (UILabel*)[cell viewWithTag:12];
    [labTime setText:[HemaFunction getTimeFromDate:[temDic objectForKey:@"regdate"]]];
    
    //右侧按钮
    HemaButton *btnRight = (HemaButton*)[cell viewWithTag:6];
    [btnRight addTarget:self action:@selector(gotoDelete:) forControlEvents:UIControlEventTouchUpInside];
    btnRight.btnRow = indexPath.row;
    [btnRight setHidden:NO];
    
    //左侧背景view
    UIView *leftView = (UIView*)[cell viewWithTag:8];
    [leftView setFrame:CGRectMake(0, 0, UI_View_Width, 76)];
    
    HemaSwipeGR *temSwipeUp = [leftView.gestureRecognizers objectAtIndex:0];
    HemaSwipeGR *temSwipeDown = [leftView.gestureRecognizers objectAtIndex:1];
    
    temSwipeUp.touchRow = indexPath.row;
    temSwipeDown.touchRow = indexPath.row;
    
    isSwipe = NO;
    myRow = -1;
    
    return cell;
}
#pragma mark - Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 8;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 76;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *) indexPath
{
    if (isSwipe)
    {
        isSwipe = NO;
        myRow = -1;
        [self.mytable reloadData];
        return;
    }
    
    NSMutableDictionary *temDic = [dataSource objectAtIndex:indexPath.row];
    RMyChatVC *chat = nil;
    //单聊
    if ([[temDic objectForKey:@"dxgroupid"]integerValue] == 0)
    {
        chat = [[RMyChatVC alloc]initWithChatter:[temDic objectForKey:@"talker"]];
        chat.isChatGroup = NO;
        chat.dataSource = [[NSMutableDictionary alloc]initWithObjectsAndKeys:[temDic objectForKey:@"talker"],@"id",[temDic objectForKey:@"talkername"],@"nickname",[temDic objectForKey:@"talkeravatar"],@"avatar", nil];
    }else
    {
        chat = [[RMyChatVC alloc]initWithChatter:[temDic objectForKey:@"dxgroupid"]];
        chat.isChatGroup = YES;
        chat.dataSource = [[NSMutableDictionary alloc]initWithObjectsAndKeys:[temDic objectForKey:@"dxgroupid"],@"id",[temDic objectForKey:@"dxgroupname"],@"name",[temDic objectForKey:@"dxgroupavatar"],@"avatar", nil];
    }
    [[SystemFunction getFirstVCFromVC:self].navigationController pushViewController:chat animated:YES];
}
#pragma mark - 连接服务器
#pragma mark 加载刷新
//刷新页面
-(void)reShowView
{
    if(0 == dataSource.count)
    {
        [self showNoDataView:@"暂无聊天信息"];
    }else
    {
        [self hideNoDataView];
    }
    [self.mytable reloadData];
}
//继承的方法
- (void)refresh
{
    isSwipe = NO;
    [self readFromSql:NO];
}
#pragma mark 数据库操作
//从数据库读取数据
- (void)readFromSql:(BOOL)isSearchM
{
    NSString *query = nil;
    NSString *myMobile = [HemaFunction xfuncGetAppdelegate].xmppStream.myJID.user;
    query = [NSString stringWithFormat:@"select rowid,owner,fromjid,tojid,body,regdate,dxpacktype,dxclientype,dxclientname,dxclientavatar,dxgroupid,dxgroupname,dxgroupavatar,dxdetail,(count(*)- sum(isread))as count,id,talkername,talkeravatar,talker,isdelete from `message` where owner = '%@' and isdelete = 0 group by dxgroupid ,talker order by rowid desc;",myMobile];
    [self selectDataBase:query isSearchM:isSearchM];
}
//查询数据
-(void)selectDataBase:(NSString*)query isSearchM:(BOOL)isSearchM
{
    if (!dataSource)
        dataSource = [[NSMutableArray alloc]init];
    [dataSource removeAllObjects];
    
    sqlite3_stmt *statement;
    sqlite3 *contactDB;
    
    NSMutableArray *keyArr = [[NSMutableArray alloc]initWithObjects:
                              @"rowid",@"owner",@"fromjid",@"tojid",@"body",
                              @"regdate",@"dxpacktype",@"dxclientype",@"dxclientname",@"dxclientavatar",
                              @"dxgroupid",@"dxgroupname",@"dxgroupavatar",@"dxdetail",@"count",
                              @"id",@"talkername",@"talkeravatar",@"talker",@"isdelete",nil];
    
    const char *dbpath = [_databasePath UTF8String];
    if (sqlite3_open(dbpath, &contactDB)==SQLITE_OK)
    {
        if (sqlite3_prepare_v2(contactDB, [query UTF8String],-1, &statement, nil) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                NSMutableDictionary *temDic = [[NSMutableDictionary alloc]init];
                for (int i = 0; i<20; i++)
                {
                    NSString *strObject = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, i)];
                    NSString *strKey = [keyArr objectAtIndex:i];
                    [temDic setObject:strObject forKey:strKey];
                }
                [dataSource addObject:temDic];
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
    [self reShowView];
    [self stopLoading];
}
@end
