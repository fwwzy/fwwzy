//
//  RChatSetVC.m
//  Hema
//
//  Created by LarryRodic on 15/10/11.
//  Copyright (c) 2015年 Hemaapp. All rights reserved.
//

#import "RChatSetVC.h"
#import "RInforVC.h"

@interface RChatSetVC ()
@property(nonatomic,strong)NSMutableDictionary *dataSource;//资料
@end

@implementation RChatSetVC
@synthesize dataSource;
@synthesize userId;

-(void)loadSet
{
    [self.navigationItem setNewTitle:@"聊天设置"];
    
    [SystemFunction setTableSeparatorInset:self.mytable left:10];
    [self forbidPullRefresh];
}
-(void)loadData
{
    if (dataSource)
        dataSource = [[NSMutableDictionary alloc]init];
    [self requestGetInfor];
}
#pragma mark-事件
//状态切换
-(void)changeState:(UISwitch*)sender
{
    if (sender.on)
    {
        [self requestHide:@"5"];
    }else
    {
        [self requestHide:@"6"];
    }
}
//个人资料
-(void)ownerPressed:(id)sender
{
    RInforVC *myVC = [[RInforVC alloc]init];
    myVC.userId = self.userId;
    [self.navigationController pushViewController:myVC animated:YES];
}
#pragma mark- UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(100 == alertView.tag&&1 == buttonIndex)
    {
        NSString *insertSQL = [NSString stringWithFormat:@"DELETE FROM message WHERE talker = '%@'",userId];
        [SystemFunction exceSQL:insertSQL];
        [HemaFunction openIntervalHUDOK:@"已清空聊天记录"];
    }
}
#pragma mark- TableView DataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (1 == section)
    {
        return 2;
    }
    return 1;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //头像
    if (0 == indexPath.section)
    {
        static NSString *CellIdentifier = @"000";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if(cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = BB_White_Color;
            
            //头像
            HemaButton *leftBtn = [HemaButton buttonWithType:UIButtonTypeCustom];
            [leftBtn setFrame:CGRectMake(10, 15, 80, 80)];
            leftBtn.tag = 8;
            [HemaFunction addbordertoView:leftBtn radius:8 width:0.0f color:BB_White_Color];
            [cell.contentView addSubview:leftBtn];
        }
        
        HemaButton *leftBtn = (HemaButton*)[cell viewWithTag:8];
        [leftBtn addTarget:self action:@selector(ownerPressed:) forControlEvents:UIControlEventTouchUpInside];
        [SystemFunction cashButton:leftBtn url:[dataSource objectForKey:@"avatar"] firstImg:@"R默认小头像.png"];
        
        return cell;
    }
    static NSString *CellIdentifier = @"all";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.backgroundColor = BB_White_Color;
        cell.clipsToBounds = YES;
        
        //左侧
        UILabel *labLeft = [[UILabel alloc]init];
        labLeft.backgroundColor = [UIColor clearColor];
        labLeft.textAlignment = NSTextAlignmentLeft;
        labLeft.font = [UIFont systemFontOfSize:14];
        labLeft.tag = 10;
        [labLeft setTextColor:BB_Blake_Color];
        labLeft.frame = CGRectMake(10, 0, 120, 54);
        [cell.contentView addSubview:labLeft];
        
        UISwitch *temSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(UI_View_Width-67, 14.5, 54, 25)];
        [cell.contentView addSubview:temSwitch];
        temSwitch.tag = 11;
        temSwitch.onTintColor = RGB_UI_COLOR(37, 224, 108);
    }
    NSMutableArray *temArr = [[NSMutableArray alloc]initWithObjects:@"消息免打扰",@"清空聊天记录",nil];
    UILabel *labLeft = (UILabel*)[cell viewWithTag:10];
    labLeft.text = [temArr objectAtIndex:indexPath.row];
    
    UISwitch *temSwitch = (UISwitch*)[cell viewWithTag:11];
    [temSwitch setHidden:YES];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    if (0 == indexPath.row)
    {
        [temSwitch setHidden:NO];
        [temSwitch addTarget:self action:@selector(changeState:) forControlEvents:UIControlEventValueChanged];
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        if ([[dataSource objectForKey:@"messagehideflag"]integerValue] == 1)
        {
            [temSwitch setOn:YES];
        }else
        {
            [temSwitch setOn:NO];
        }
    }else
    {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [temSwitch setHidden:YES];
    }
    
    return cell;
}
#pragma mark - Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (0 == section)
    {
        return 8;
    }
    return 30;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.section)
    {
        return 110;
    }
    if (1 == indexPath.section)
    {
        return 54;
    }
    return 45;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *) indexPath
{
    if (1 == indexPath.section)
    {
        if (1 == indexPath.row)
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"清空" message:@"确定要清空聊天记录么？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alertView.tag = 100;
            alertView.delegate = self;
            [alertView show];
        }
    }
}
#pragma mark - 连接服务器
#pragma mark 消息免打扰开关
- (void)requestHide:(NSString*)keytype
{
    NSString *token = [[HemaManager sharedManager] userToken];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:token forKey:@"token"];
    [dic setObject:keytype forKey:@"keytype"];
    [dic setObject:self.userId forKey:@"id"];
    
    [HemaRequest requestWithURL:[NSString stringWithFormat:@"%@%@",REQUEST_MAINLINK,REQUEST_CLIENT_SAVEOPERATE] target:self selector:@selector(responseHide:) parameter:dic];
}
- (void)responseHide:(NSDictionary*)info
{
    if(1 == [[info objectForKey:@"success"] intValue])
    {
        [[HemaFunction xfuncGetAppdelegate]requestMemberList];
    }else
    {
        [HemaFunction openIntervalHUD:[info objectForKey:@"msg"]];
    }
}
#pragma mark 个人资料
- (void)requestGetInfor
{
    NSString *token = [[HemaManager sharedManager] userToken];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:token forKey:@"token"];
    [dic setObject:self.userId forKey:@"id"];
    
    [HemaRequest requestWithURL:[NSString stringWithFormat:@"%@%@",REQUEST_MAINLINK,REQUEST_CLIENT_GET] target:self selector:@selector(responseGetInfor:) parameter:dic];
}
- (void)responseGetInfor:(NSDictionary*)info
{
    if(1 == [[info objectForKey:@"success"] intValue])
    {
        if(![HemaFunction xfunc_check_strEmpty:[info objectForKey:@"infor"]])
        {
            if (!dataSource)
                dataSource = [[NSMutableDictionary alloc]init];
            dataSource = [SystemFunction getDicFromDic:[[info objectForKey:@"infor"] objectAtIndex:0]];
            
            [self.mytable reloadData];
        }
    }else
    {
        [HemaFunction openIntervalHUD:[info objectForKey:@"msg"]];
    }
}
@end
