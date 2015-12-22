//
//  RMessageVC.m
//  Hema
//
//  Created by LarryRodic on 15/10/15.
//  Copyright (c) 2015年 Hemaapp. All rights reserved.
//
#import "RMessageVC.h"
#import "HemaSwipeGR.h"

@interface RMessageVC ()
@property(nonatomic,strong)NSMutableArray *dataSource;
@end

@implementation RMessageVC
@synthesize dataSource;

-(void)loadSet
{
    [self.navigationItem setNewTitle:@"系统通知"];
    [self.navigationItem setRightItemWithTarget:self action:@selector(rightbtnPressed:) image:@"R三个圈.png"];
    [SystemFunction setTableSeparatorInset:self.mytable left:10];
}
-(void)loadData
{
    [self refresh];
}
#pragma mark- 自定义
#pragma mark 事件
-(void)rightbtnPressed:(id)sender
{
    UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:Button_Read,Button_Delete,Button_Cancel, nil];
    [SystemFunction setActionSheet:actionSheet index:2 myVC:self];
}
//同意好友
-(void)gotoOK:(HemaButton*)sender
{
    myRow = sender.btnRow;
    NSMutableDictionary *temDic = [dataSource objectAtIndex:sender.btnRow];
    [self requestSaveLookflag:[temDic objectForKey:@"id"] keytype:[temDic objectForKey:@"keytype"] keyid:[temDic objectForKey:@"keyid"] optype:@"5"];
}
//删除
-(void)gotoDelete:(HemaButton*)sender
{
    myRow = sender.btnRow;
    NSMutableDictionary *temDic = [dataSource objectAtIndex:sender.btnRow];
    [self requestRemoveNotice:[temDic objectForKey:@"id"] keytype:[temDic objectForKey:@"keytype"] keyid:[temDic objectForKey:@"keyid"] optype:@"3"];
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
#pragma mark- UIActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString*title = [actionSheet buttonTitleAtIndex:buttonIndex];
    //全部删除
    if([title isEqualToString:Button_Read])
    {
        if (dataSource.count == 0)
        {
            [HemaFunction openIntervalHUDOK:@"已成功删除"];
            return;
        }
        [self requestRemoveAllNotice];
    }
    //全部已读
    if([title isEqualToString:Button_Delete])
    {
        if (dataSource.count == 0)
        {
            [HemaFunction openIntervalHUDOK:@"已全部置为已读"];
            return;
        }
        [self requestSaveLookflag:@"0" keytype:@"0" keyid:@"0" optype:@"2"];
    }
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
#pragma mark- TableView DataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataSource.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"all";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.backgroundColor = BB_Red_Color;
        
        //右侧按钮
        HemaButton *btnRight = [HemaButton buttonWithType:UIButtonTypeCustom];
        [btnRight setFrame:CGRectMake(UI_View_Width-84, 0, 84, 70)];
        btnRight.tag = 6;
        [cell.contentView addSubview:btnRight];
        
        //右侧删除
        UILabel *labDelete = [[UILabel alloc]init];
        labDelete.backgroundColor = [UIColor clearColor];
        labDelete.textColor = BB_White_Color;
        labDelete.textAlignment = NSTextAlignmentCenter;
        labDelete.font = [UIFont boldSystemFontOfSize:17];
        labDelete.frame = CGRectMake(0, 0, 84, 70);
        labDelete.tag = 7;
        labDelete.text = @"删除";
        [btnRight addSubview:labDelete];
        
        //左侧背景view
        UIView *leftView = [[UIView alloc]init];
        [leftView setFrame:CGRectMake(0,0, UI_View_Width, 70)];
        [leftView setBackgroundColor:BB_White_Color];
        leftView.tag = 8;
        [cell.contentView addSubview:leftView];
        
        //头像
        HemaButton *leftBtn = [HemaButton buttonWithType:UIButtonTypeCustom];
        [leftBtn setFrame:CGRectMake(10, 14, 45, 45)];
        leftBtn.tag = 9;
        [HemaFunction addbordertoView:leftBtn radius:22.5f width:0.0f color:[UIColor clearColor]];
        [leftView addSubview:leftBtn];
        
        //内容
        UILabel *lableft = [[UILabel alloc]init];
        lableft.backgroundColor = [UIColor clearColor];
        lableft.textAlignment = NSTextAlignmentLeft;
        lableft.font = [UIFont systemFontOfSize:14];
        lableft.textColor = BB_Gray_Color;
        lableft.frame = CGRectMake(65, 39, UI_View_Width-75, 14);
        lableft.tag = 10;
        lableft.numberOfLines = 0;
        [leftView addSubview:lableft];
        
        //日期
        UILabel *labTime = [[UILabel alloc]init];
        labTime.backgroundColor = [UIColor clearColor];
        labTime.textColor = BB_Gray_Color;
        labTime.textAlignment = NSTextAlignmentRight;
        labTime.font = [UIFont systemFontOfSize:11];
        labTime.frame = CGRectMake(UI_View_Width-80, 13, 70, 13);
        labTime.tag = 11;
        [leftView addSubview:labTime];
        
        //红色
        UIImageView *redImg = [[UIImageView alloc]init];
        redImg.backgroundColor = [UIColor clearColor];
        redImg.image = [UIImage imageNamed:@"R新消息提醒.png"];
        [redImg setFrame:CGRectMake(45, 15, 12, 12)];
        redImg.tag = 12;
        [leftView addSubview:redImg];
        
        //名字
        UILabel *labName = [[UILabel alloc]init];
        labName.backgroundColor = [UIColor clearColor];
        labName.textAlignment = NSTextAlignmentLeft;
        labName.textColor = BB_Blake_Color;
        labName.font = [UIFont systemFontOfSize:14];
        labName.frame = CGRectMake(65, 14, UI_View_Width-150, 16);
        labName.tag = 14;
        [leftView addSubview:labName];
        
        //右侧同意
        HemaButton *btnOK = [HemaButton buttonWithType:UIButtonTypeCustom];
        [btnOK setFrame:CGRectMake(UI_View_Width-66, 33, 56, 30)];
        [HemaFunction addbordertoView:btnOK radius:5.0f width:0.0f color:[UIColor clearColor]];
        btnOK.tag = 4;
        [leftView addSubview:btnOK];
        
        //右侧同意
        UILabel *labOK = [[UILabel alloc]init];
        labOK.backgroundColor = BB_Blue_Color;
        labOK.textColor = BB_White_Color;
        labOK.textAlignment = NSTextAlignmentCenter;
        labOK.font = [UIFont boldSystemFontOfSize:16];
        labOK.frame = CGRectMake(0, 0, 56, 30);
        labOK.tag = 5;
        labOK.text = @"同意";
        [btnOK addSubview:labOK];
        
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
    
    UIView *leftView = (UIView*)[cell viewWithTag:8];
    
    //头像
    HemaButton *leftBtn = (HemaButton*)[cell viewWithTag:9];
    [leftBtn setUserInteractionEnabled:NO];
    [SystemFunction cashButton:leftBtn url:[temDic objectForKey:@"avatar"] firstImg:@"R消息图标.png"];
    
    //名字
    UILabel *labName = (UILabel*)[cell viewWithTag:14];
    [labName setText:[temDic objectForKey:@"nickname"]];
    
    //内容
    UILabel *lableft = (UILabel*)[cell viewWithTag:10];
    [lableft setText:[temDic objectForKey:@"content"]];
    
    CGSize temSize = [HemaFunction getSizeWithStrNo:[temDic objectForKey:@"content"] width:lableft.width font:14];
    [lableft setFrame:CGRectMake(lableft.left, lableft.top, lableft.width, temSize.height)];
    [leftView setFrame:CGRectMake(0,0, UI_View_Width, 39+temSize.height+12)];
    
    //日期
    UILabel *labTime = (UILabel*)[cell viewWithTag:11];
    NSString *temStr = [temDic objectForKey:@"regdate"];
    temStr = [HemaFunction getTimeFromDate:temStr];
    [labTime setText:temStr];
    
    //右侧按钮
    HemaButton *btnRight = (HemaButton*)[cell viewWithTag:6];
    [btnRight addTarget:self action:@selector(gotoDelete:) forControlEvents:UIControlEventTouchUpInside];
    btnRight.btnRow = indexPath.row;
    [btnRight setHidden:NO];
    
    //右侧删除
    UILabel *labDelete = (UILabel*)[cell viewWithTag:7];
    [btnRight setFrame:CGRectMake(btnRight.left, btnRight.top, btnRight.width, leftView.height)];
    [labDelete setFrame:CGRectMake(0, 0, labDelete.width, leftView.height)];
    
    //右侧同意
    HemaButton *btnOK = (HemaButton*)[cell viewWithTag:4];
    [btnOK addTarget:self action:@selector(gotoOK:) forControlEvents:UIControlEventTouchUpInside];
    btnOK.btnRow = indexPath.row;
    
    //右侧同意
    UILabel *labOK = (UILabel*)[cell viewWithTag:5];
    
    //红色
    UIImageView *redImg = (UIImageView*)[cell viewWithTag:12];
    if ([[temDic objectForKey:@"looktype"]integerValue] == 1)
    {
        [redImg setHidden:NO];
    }else
    {
        [redImg setHidden:YES];
    }
    
    NSInteger keytype = [[temDic objectForKey:@"keytype"]integerValue];
    
    //好友申请
    if (keytype == 5)
    {
        [btnOK setHidden:NO];
        if ([[temDic objectForKey:@"looktype"]integerValue] == 3)
        {
            [btnOK setUserInteractionEnabled:NO];
            [labOK setText:@"已同意"];
            [labOK setBackgroundColor:BB_Gray_Color];
        }else
        {
            [btnOK setUserInteractionEnabled:YES];
            [labOK setText:@"同意"];
            [labOK setBackgroundColor:BB_Blue_Color];
        }
    }else
    {
        [btnOK setHidden:YES];
    }
    
    HemaSwipeGR *temSwipeUp = [leftView.gestureRecognizers objectAtIndex:0];
    HemaSwipeGR *temSwipeDown = [leftView.gestureRecognizers objectAtIndex:1];
    
    temSwipeUp.touchRow = indexPath.row;
    temSwipeDown.touchRow = indexPath.row;
    
    isSwipe = NO;
    myRow = -1;
    
    /*
     特别提示：
     （1）客户端应该根据keytype和content的组合来拼装具体通知内容，其中keytype需要根据国际化原则配置到本地语言包中。
     （2）点击“系统通知”单条记录时，根据keytype和keyid的组合来跳转不同的模块，具体规定如下：
     当keytype=1时，keyid=notice_id;(此时需跳转系统消息详情模块)
     当keytype=2时，keyid=chapter_id;(此时需跳转章节详情模块)
     当keytype=3时，keyid=ask_id;(此时需跳转问答详情模块)
     当keytype=5时，keyid=friendid;(此时需打开对方用户资料页面)
     */
    
    return cell;
}
#pragma mark- TableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 8;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section;
{
    return 0.1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *temDic = [dataSource objectAtIndex:indexPath.row];
    CGSize temSize = [HemaFunction getSizeWithStrNo:[temDic objectForKey:@"content"] width:UI_View_Width-75 font:14];
    return 39+temSize.height+12;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *) indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (isSwipe)
    {
        isSwipe = NO;
        myRow = -1;
        [self.mytable reloadData];
        return;
    }
    
    NSMutableDictionary *temDic = [dataSource objectAtIndex:indexPath.row];
    if ([[temDic objectForKey:@"looktype"]integerValue] == 1)
    {
        //设置为已读
        [self requestSaveLookflag:[temDic objectForKey:@"id"] keytype:[temDic objectForKey:@"keytype"] keyid:[temDic objectForKey:@"keyid"] optype:@"1"];
        [temDic setValue:@"2" forKey:@"looktype"];
        [self.mytable reloadData];
    }
}
#pragma mark- 连接服务器
#pragma mark 删除
- (void)requestRemoveNotice:(NSString*)noticeid keytype:(NSString*)keytype keyid:(NSString*)keyid optype:(NSString*)optype
{
    NSString *token = [[HemaManager sharedManager] userToken];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:token forKey:@"token"];
    [dic setObject:noticeid forKey:@"id"];
    [dic setObject:keytype forKey:@"keytype"];
    [dic setObject:keyid forKey:@"keyid"];
    [dic setObject:optype forKey:@"operatetype"];
    
    waitMB = [HemaFunction openHUD:@"正在删除"];
    
    [HemaRequest requestWithURL:[NSString stringWithFormat:@"%@%@",REQUEST_MAINLINK,REQUEST_NOTiCE_SAVEOPERATE] target:self selector:@selector(responseRemoveNotice:) parameter:dic];
}
- (void)responseRemoveNotice:(NSDictionary*)info
{
    [HemaFunction closeHUD:waitMB];
    if(1 == [[info objectForKey:@"success"] intValue])
    {
        [HemaFunction openIntervalHUDOK:@"已成功删除"];
        
        [dataSource removeObjectAtIndex:myRow];
        [self.mytable deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:myRow inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
        myRow = -1;
        isSwipe = NO;
        [NSTimer scheduledTimerWithTimeInterval:0.4 target:self selector:@selector(reShowView) userInfo:nil repeats:NO];
    }else
    {
        [HemaFunction openIntervalHUD:[info objectForKey:@"msg"]];
    }
}
#pragma mark 全部删除
- (void)requestRemoveAllNotice
{
    NSString *token = [[HemaManager sharedManager] userToken];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:token forKey:@"token"];
    [dic setObject:@"0" forKey:@"id"];
    [dic setObject:@"0" forKey:@"keytype"];
    [dic setObject:@"0" forKey:@"keyid"];
    [dic setObject:@"4" forKey:@"operatetype"];
    
    waitMB = [HemaFunction openHUD:@"正在删除"];
    
    [HemaRequest requestWithURL:[NSString stringWithFormat:@"%@%@",REQUEST_MAINLINK,REQUEST_NOTiCE_SAVEOPERATE] target:self selector:@selector(responseRemoveAllNotice:) parameter:dic];
}
- (void)responseRemoveAllNotice:(NSDictionary*)info
{
    [HemaFunction closeHUD:waitMB];
    if(1 == [[info objectForKey:@"success"] intValue])
    {
        [HemaFunction openIntervalHUDOK:@"已成功删除"];
        [dataSource removeAllObjects];
        
        [self reShowView];
    }else
    {
        [HemaFunction openIntervalHUD:[info objectForKey:@"msg"]];
    }
}
#pragma mark 置为已读 / 同意好友申请
- (void)requestSaveLookflag:(NSString*)noticeid keytype:(NSString*)keytype keyid:(NSString*)keyid optype:(NSString*)optype
{
    NSString *token = [[HemaManager sharedManager] userToken];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:token forKey:@"token"];
    [dic setObject:noticeid forKey:@"id"];
    [dic setObject:keytype forKey:@"keytype"];
    [dic setObject:keyid forKey:@"keyid"];
    [dic setObject:optype forKey:@"operatetype"];
    
    if ([optype integerValue] == 5)//好友申请
    {
        [HemaRequest requestWithURL:[NSString stringWithFormat:@"%@%@",REQUEST_MAINLINK,REQUEST_NOTiCE_SAVEOPERATE] target:self selector:@selector(responseSaveFriend:) parameter:dic];
    }if ([optype integerValue] == 2)//全部已读
    {
        [HemaRequest requestWithURL:[NSString stringWithFormat:@"%@%@",REQUEST_MAINLINK,REQUEST_NOTiCE_SAVEOPERATE] target:self selector:@selector(responseSaveLookflagAll:) parameter:dic];
    }else
    {
        [HemaRequest requestWithURL:[NSString stringWithFormat:@"%@%@",REQUEST_MAINLINK,REQUEST_NOTiCE_SAVEOPERATE] target:self selector:nil parameter:dic];
    }
}
- (void)responseSaveFriend:(NSDictionary*)info
{
    if(1 == [[info objectForKey:@"success"] intValue])
    {
        [HemaFunction openIntervalHUDOK:@"已成功添加其为好友"];
        
        [[dataSource objectAtIndex:myRow] setObject:@"3" forKey:@"looktype"];
        [self reShowView];
    }else
    {
        [HemaFunction openIntervalHUD:[info objectForKey:@"msg"]];
    }
}
- (void)responseSaveLookflagAll:(NSDictionary*)info
{
    if(1 == [[info objectForKey:@"success"] intValue])
    {
        [HemaFunction openIntervalHUDOK:@"已全部置为已读"];
        for (int i = 0; i<dataSource.count; i++)
        {
            NSMutableDictionary *temDic = [dataSource objectAtIndex:i];
            
            if ([[temDic objectForKey:@"looktype"]integerValue] == 1)
            {
                [temDic setValue:@"2" forKey:@"looktype"];
            }
        }
        [self reShowView];
    }else
    {
        [HemaFunction openIntervalHUD:[info objectForKey:@"msg"]];
    }
}
#pragma mark 系统通知列表
- (void)requestChapterList
{
    NSString *token = [[HemaManager sharedManager] userToken];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:token forKey:@"token"];
    [dic setObject:@"1" forKey:@"noticetype"];
    [dic setObject:[NSString stringWithFormat:@"%d",(int)currentPage] forKey:@"page"];
    
    [HemaRequest requestWithURL:[NSString stringWithFormat:@"%@%@",REQUEST_MAINLINK,REQUEST_NOTICE_LIST] target:self selector:@selector(responseChapterList:) parameter:dic];
}
- (void)responseChapterList:(NSDictionary*)info
{
    if(1 == [[info objectForKey:@"success"] intValue])
    {
        if (!dataSource)
            dataSource = [[NSMutableArray alloc]init];
        if(0 == currentPage)
            [dataSource removeAllObjects];
        
        NSString *val=[[info objectForKey:@"infor"]objectForKey:@"listItems"];
        if ([HemaFunction xfunc_check_strEmpty:val])
        {
            [self forbidAddMore];
            isEnd = YES;
            if(isMore)
                [self getNoMoreData];
        }else
        {
            NSArray *temArr = [[info objectForKey:@"infor"]objectForKey:@"listItems"];
            if ([temArr count] == 0)
            {
                [self forbidAddMore];
                isEnd = YES;
                if(isMore)
                    [self getNoMoreData];
            }else
            {
                if (temArr.count < 20)
                {
                    [self forbidAddMore];
                }else
                {
                    [self canAddMore];
                }
                for (int i = 0; i<temArr.count; i++)
                {
                    NSMutableDictionary *dict = [SystemFunction getDicFromDic:[temArr objectAtIndex:i]];
                    [dataSource addObject:dict];
                }
            }
        }
    }else
    {
        [HemaFunction openIntervalHUD:[info objectForKey:@"msg"]];
    }
    [self reShowView];
    
    if(isMore)
    {
        [self stopAddMore];
    }
    if(isLoading)
    {
        [self stopLoading];
    }
}
#pragma mark 加载刷新
//刷新页面
-(void)reShowView
{
    if(0 == dataSource.count)
    {
        [self showNoDataView:@"暂无系统通知"];
    }else
    {
        [self hideNoDataView];
    }
    [self.mytable reloadData];
}
//继承的方法
- (void)refresh
{
    currentPage = 0;
    isEnd = NO;
    [self requestChapterList];
}
-(void)addMore
{
    if (!isEnd)
    {
        currentPage++;
    }
    [self requestChapterList];
}
@end