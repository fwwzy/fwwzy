//
//  ApplyListVC.m
//  PingChuan
//
//  Created by LarryRodic on 14-11-7.
//  Copyright (c) 2014年 平川嘉恒. All rights reserved.
//

#import "RPeopleListVC.h"
#import "RInforVC.h"

@interface RPeopleListVC ()
@property(nonatomic,strong)NSMutableArray *dataSource;
@end

@implementation RPeopleListVC
@synthesize dataSource;
@synthesize keyword;

-(void)loadSet
{
    [self.navigationItem setNewTitle:@"人员列表"];
    [self.mytable setSeparatorInset:UIEdgeInsetsMake(0, 72, 0, 0)];
}
-(void)loadData
{
    [self refresh];
}
#pragma mark- 自定义
#pragma mark 事件
//添加按钮
-(void)operatePress:(HemaButton*)sender
{
    NSMutableDictionary *temDic = [dataSource objectAtIndex:sender.btnRow];
    [self requestSaveFriend:[temDic objectForKey:@"client_id"]];
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
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.backgroundColor = BB_White_Color;
        
        HemaImgView *leftImgView = [[HemaImgView alloc]init];
        [leftImgView setFrame:CGRectMake(10, 12.5, 50, 50)];
        [HemaFunction addbordertoView:leftImgView radius:5.0 width:0 color:[UIColor clearColor]];
        leftImgView.tag = 9;
        [cell.contentView addSubview:leftImgView];
        
        //左侧
        UILabel *labLeft = [[UILabel alloc]init];
        labLeft.backgroundColor = [UIColor clearColor];
        labLeft.textAlignment = NSTextAlignmentLeft;
        labLeft.font = [UIFont systemFontOfSize:15];
        labLeft.frame = CGRectMake(72, 17, UI_View_Width-190, 17);
        labLeft.tag = 10;
        [labLeft setTextColor:BB_Blake_Color];
        [cell.contentView addSubview:labLeft];
        
        //左侧
        UILabel *labRight = [[UILabel alloc]init];
        labRight.backgroundColor = [UIColor clearColor];
        labRight.textAlignment = NSTextAlignmentLeft;
        labRight.font = [UIFont systemFontOfSize:14];
        labRight.frame = CGRectMake(72, 41, UI_View_Width-150, 16);
        labRight.tag = 11;
        [labRight setTextColor:BB_Gray_Color];
        [cell.contentView addSubview:labRight];
        
        HemaButton *btn = [HemaButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(UI_View_Width-67, 21, 56, 33);
        [HemaFunction addbordertoView:btn radius:6.0f width:0.5f color:BB_Blue_Color];
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
    [labRight setText:[temDic objectForKey:@"selfsign"]];
    
    HemaButton *btn = (HemaButton*)[cell viewWithTag:12];
    btn.btnRow = indexPath.row;
    [btn addTarget:self action:@selector(operatePress:) forControlEvents:UIControlEventTouchUpInside];
    
    if ([[temDic objectForKey:@"client_id"]isEqualToString:[[[HemaManager sharedManager] myInfor] objectForKey:@"id"]])
    {
        [btn setHidden:YES];
    }else
    {
        if ([[temDic objectForKey:@"friendflag"]integerValue] == 1)
        {
            [btn setUserInteractionEnabled:NO];
            [btn setTitle:@"已添加" forState:UIControlStateNormal];
            [HemaFunction addbordertoView:btn radius:4.0f width:0.5f color:BB_Gray_Color];
            [btn setTitleColor:BB_Gray_Color forState:UIControlStateNormal];
        }else
        {
            [btn setUserInteractionEnabled:YES];
            [btn setTitle:@"添加" forState:UIControlStateNormal];
            [HemaFunction addbordertoView:btn radius:4.0f width:0.5f color:BB_Blue_Color];
            [btn setTitleColor:BB_Blue_Color forState:UIControlStateNormal];
        }
        [btn setHidden:NO];
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
    myVC.userId = [temDic objectForKey:@"client_id"];
    [[SystemFunction getFirstVCFromVC:self].navigationController pushViewController:myVC animated:YES];
}
#pragma mark - 连接服务器
#pragma mark 添加好友
- (void)requestSaveFriend:(NSString*)friendid
{
    NSString *token = [[HemaManager sharedManager] userToken];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:token forKey:@"token"];
    [dic setObject:friendid forKey:@"friendid"];
    
    waitMB = [HemaFunction openHUD:@"正在申请"];
    
    [HemaRequest requestWithURL:[NSString stringWithFormat:@"%@%@",REQUEST_MAINLINK,REQUEST_FRIEND_ADD] target:self selector:@selector(responseSaveFriend:) parameter:dic];
}
- (void)responseSaveFriend:(NSDictionary*)info
{
    [HemaFunction closeHUD:waitMB];
    if(1 == [[info objectForKey:@"success"] intValue])
    {
        [HemaFunction openIntervalHUD:@"已向对方申请，敬请等待"];
    }else
    {
        [HemaFunction openIntervalHUD:[info objectForKey:@"msg"]];
    }
}
#pragma mark 列表
- (void)requestGetFriendList
{
    NSString *token = [[HemaManager sharedManager] userToken];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:token forKey:@"token"];
    [dic setObject:@"7" forKey:@"keytype"];
    [dic setObject:self.keyword?self.keyword:@"" forKey:@"keyid"];
    [dic setObject:[NSString stringWithFormat:@"%d",(int)currentPage] forKey:@"page"];
    
    [HemaRequest requestWithURL:[NSString stringWithFormat:@"%@%@",REQUEST_MAINLINK,REQUEST_CLIENT_LIST] target:self selector:@selector(responseGetFriendList:) parameter:dic];
}
- (void)responseGetFriendList:(NSDictionary*)info
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
        [self showNoDataView:@"暂无搜索结果"];
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
    [self requestGetFriendList];
}
-(void)addMore
{
    if (!isEnd)
    {
        currentPage++;
    }
    [self requestGetFriendList];
}
@end
