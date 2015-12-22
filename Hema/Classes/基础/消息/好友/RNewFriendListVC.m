//
//  ApplyListVC.m
//  PingChuan
//
//  Created by LarryRodic on 14-11-7.
//  Copyright (c) 2014年 平川嘉恒. All rights reserved.
//

#import "RNewFriendListVC.h"
#import "RInforVC.h"

@interface RNewFriendListVC ()
@property(nonatomic,strong)NSMutableArray *dataSource;
@end

@implementation RNewFriendListVC
@synthesize dataSource;

-(void)loadSet
{
    [self.navigationItem setNewTitle:@"新的好友"];
    [self.mytable setSeparatorInset:UIEdgeInsetsMake(0, 72, 0, 0)];
}
-(void)loadData
{
    [self refresh];
}
#pragma mark- 自定义
#pragma mark 事件 
//处理
-(void)operatePress:(HemaButton*)sender
{
    myRow = sender.btnRow;
    
    UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"同意",@"拒绝",@"取消", nil];
    [SystemFunction setActionSheet:actionSheet index:2 myVC:self];
}
#pragma mark 方法
//定时器
-(void)timerSetNotice:(NSTimer*)sender
{
    [self reShowView];
}
#pragma mark- UIActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString*title = [actionSheet buttonTitleAtIndex:buttonIndex];
    if([title isEqualToString:@"同意"])
    {
        [self requestAgree];
        return;
    }
    if([title isEqualToString:@"拒绝"])
    {
        [self requestDelete];
        return;
    }
}
#pragma mark - UITableView dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"all";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.backgroundColor = BB_White_Color;
        
        HemaImgView *leftImgView = [[HemaImgView alloc]init];
        [leftImgView setFrame:CGRectMake(10, 12.5, 50, 50)];
        [HemaFunction addbordertoView:leftImgView radius:5.0 width:0 color:[UIColor clearColor]];
        leftImgView.tag = 9;
        [cell.contentView addSubview:leftImgView];
        
        //第一个
        UILabel *labLeft = [[UILabel alloc]init];
        labLeft.backgroundColor = [UIColor clearColor];
        labLeft.textAlignment = NSTextAlignmentLeft;
        labLeft.font = [UIFont systemFontOfSize:15];
        labLeft.frame = CGRectMake(72, 17, UI_View_Width-190, 17);
        labLeft.tag = 10;
        [labLeft setTextColor:BB_Blake_Color];
        [cell.contentView addSubview:labLeft];
        
        //第二个
        UILabel *labRight = [[UILabel alloc]init];
        labRight.backgroundColor = [UIColor clearColor];
        labRight.textAlignment = NSTextAlignmentLeft;
        labRight.font = [UIFont systemFontOfSize:14];
        labRight.frame = CGRectMake(72, 41, UI_View_Width-150, 16);
        labRight.tag = 11;
        [labRight setTextColor:BB_Gray_Color];
        [cell.contentView addSubview:labRight];
        
        //右侧按钮
        HemaButton *btn = [HemaButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(UI_View_Width-67, 21, 56, 33);
        [HemaFunction addbordertoView:btn radius:4.0f width:0.5f color:BB_Blue_Color];
        [btn setBackgroundColor:BB_White_Color];
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [btn setTitle:@"处理" forState:UIControlStateNormal];
        [btn setTitleColor:BB_Blue_Color forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        btn.tag = 12;
        [cell.contentView addSubview:btn];
    }
    NSMutableDictionary *temDic = [dataSource objectAtIndex:indexPath.row];
    
    UILabel *labLeft = (UILabel*)[cell viewWithTag:10];
    labLeft.text = [temDic objectForKey:@"nickname"];
    
    HemaImgView *leftImgView = (HemaImgView*)[cell viewWithTag:9];
    [SystemFunction cashImgView:leftImgView url:[temDic objectForKey:@"avatar"] firstImg:@"R默认小头像.png"];
    
    UILabel *labRight = (UILabel*)[cell viewWithTag:11];
    [labRight setText:[temDic objectForKey:@"content"]];
    
    HemaButton *btn = (HemaButton*)[cell viewWithTag:12];
    btn.btnRow = indexPath.row;
    [btn addTarget:self action:@selector(operatePress:) forControlEvents:UIControlEventTouchUpInside];
    
    if ([[temDic objectForKey:@"looktype"]integerValue] == 3)
    {
        [btn setUserInteractionEnabled:NO];
        [btn setTitle:@"已同意" forState:UIControlStateNormal];
        [HemaFunction addbordertoView:btn radius:0.0f width:0.0f color:BB_Blue_Color];
        [btn setTitleColor:BB_Gray_Color forState:UIControlStateNormal];
    }else
    {
        [btn setUserInteractionEnabled:YES];
        [btn setTitle:@"处理" forState:UIControlStateNormal];
        [HemaFunction addbordertoView:btn radius:4.0f width:0.5f color:BB_Blue_Color];
        [btn setTitleColor:BB_Blue_Color forState:UIControlStateNormal];
    }
    
    return cell;
}
#pragma mark - Table view delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *) indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    NSMutableDictionary *temDic = [dataSource objectAtIndex:indexPath.row];
    
    RInforVC *myVC = [[RInforVC alloc]init];
    myVC.userId = [temDic objectForKey:@"from_id"];
    [self.navigationController pushViewController:myVC animated:YES];
}
#pragma mark - 连接服务器
#pragma mark 同意
- (void)requestAgree
{
    NSMutableDictionary *temDic = [dataSource objectAtIndex:myRow];
    NSString *token = [[HemaManager sharedManager] userToken];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:token forKey:@"token"];
    [dic setObject:[temDic objectForKey:@"id"] forKey:@"id"];
    [dic setObject:@"5" forKey:@"keytype"];
    [dic setObject:[temDic objectForKey:@"keyid"] forKey:@"keyid"];
    [dic setObject:@"5" forKey:@"operatetype"];
    
    waitMB = [HemaFunction openHUD:@"正在处理"];
    
    [HemaRequest requestWithURL:[NSString stringWithFormat:@"%@%@",REQUEST_MAINLINK,REQUEST_NOTiCE_SAVEOPERATE] target:self selector:@selector(responseAgree:) parameter:dic];
}
- (void)responseAgree:(NSDictionary*)info
{
    [HemaFunction closeHUD:waitMB];
    if(1 == [[info objectForKey:@"success"] intValue])
    {
        [HemaFunction openIntervalHUDOK:@"已成功添加对方为好友"];
        
        NSMutableDictionary *temDic = [dataSource objectAtIndex:myRow];
        [temDic setObject:@"3" forKey:@"looktype"];
        [self.mytable reloadData];
    }else
    {
        [HemaFunction openIntervalHUD:[info objectForKey:@"msg"]];
    }
}
#pragma mark 拒绝
- (void)requestDelete
{
    NSMutableDictionary *temDic = [dataSource objectAtIndex:myRow];
    NSString *token = [[HemaManager sharedManager] userToken];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:token forKey:@"token"];
    [dic setObject:[temDic objectForKey:@"id"] forKey:@"id"];
    [dic setObject:@"5" forKey:@"keytype"];
    [dic setObject:[temDic objectForKey:@"keyid"] forKey:@"keyid"];
    [dic setObject:@"3" forKey:@"operatetype"];
    
    waitMB = [HemaFunction openHUD:@"正在处理"];
    
    [HemaRequest requestWithURL:[NSString stringWithFormat:@"%@%@",REQUEST_MAINLINK,REQUEST_NOTiCE_SAVEOPERATE] target:self selector:@selector(responseDelete:) parameter:dic];
}
- (void)responseDelete:(NSDictionary*)info
{
    [HemaFunction closeHUD:waitMB];
    if(1 == [[info objectForKey:@"success"] intValue])
    {
        //后续动作 动画
        [dataSource removeObjectAtIndex:myRow];
        [self.mytable deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:myRow inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
        myRow = -1;
        [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerSetNotice:) userInfo:nil repeats:NO];
    }else
    {
        [HemaFunction openIntervalHUD:[info objectForKey:@"msg"]];
    }
}
#pragma mark 列表
- (void)requestChapterList
{
    NSString *token = [[HemaManager sharedManager] userToken];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:token forKey:@"token"];
    [dic setObject:@"5" forKey:@"noticetype"];
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
                //如果有数据
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
        [self showNoDataView:@"暂无好友申请"];
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
