//
//  RGroupSetVC.m
//  Hema
//
//  Created by LarryRodic on 15/10/11.
//  Copyright (c) 2015年 Hemaapp. All rights reserved.
//

#import "RGroupSetVC.h"
#import "RInforVC.h"
#import "RGroupAddVC.h"

@interface RGroupSetVC ()<RGroupAddDelegate>
@property(nonatomic,strong)NSMutableDictionary *dataSource;//资料
@property(nonatomic,strong)NSMutableArray *dataImg;//成员列表
@end

@implementation RGroupSetVC
@synthesize dataSource;
@synthesize dataImg;
@synthesize groupId;

-(void)loadSet
{
    [self.navigationItem setNewTitle:@"群组设置"];
    
    [SystemFunction setTableSeparatorInset:self.mytable left:10];
    [self forbidPullRefresh];
}
-(void)loadData
{
    if (dataSource)
        dataSource = [[NSMutableDictionary alloc]init];
    [self requestGetInfor];
    [self requestMemberList];
}
#pragma mark-事件
//状态切换
-(void)changeState:(UISwitch*)sender
{
    if (sender.on)
    {
        [self requestHide:@"1"];
    }else
    {
        [self requestHide:@"0"];
    }
}
//个人资料
-(void)ownerPressed:(HemaButton*)sender
{
    NSMutableDictionary *myDic = [dataImg objectAtIndex:sender.btnRow];
    
    RInforVC *myVC = [[RInforVC alloc]init];
    myVC.userId = [myDic objectForKey:@"client_id"];
    [self.navigationController pushViewController:myVC animated:YES];
}
//退出群组
-(void)quitButtonPress:(id)sender
{
    if ([[dataSource objectForKey:@"adminflag"]integerValue] == 1)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"解散" message:@"确定解散此群组？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alertView.tag = 88;
        alertView.delegate = self;
        [alertView show];
    }else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"退出" message:@"确定退出此群组？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alertView.tag = 88;
        alertView.delegate = self;
        [alertView show];
    }
}
//删除人员
-(void)deleteMember:(HemaButton*)sender
{
    [self requestRemoveMember:[[dataImg objectAtIndex:sender.btnRow] objectForKey:@"client_id"]];
}
//添加成员
-(void)addPressed:(id)sender
{
    RGroupAddVC *myVC = [[RGroupAddVC alloc]init];
    myVC.delegate = self;
    myVC.dataHave = dataImg;
    [self.navigationController pushViewController:myVC animated:YES];
}
#pragma mark- UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(88 == alertView.tag&&1 == buttonIndex)
    {
        [self requestRelease];
    }
    if(100 == alertView.tag&&1 == buttonIndex)
    {
        NSString *insertSQL = [NSString stringWithFormat:@"DELETE FROM message WHERE dxgroupid = '%@'",groupId];
        [SystemFunction exceSQL:insertSQL];
        [HemaFunction openIntervalHUDOK:@"已清空聊天记录"];
    }
}
#pragma mark- RGroupAddDelegate
-(void)RGroupAddOK:(NSMutableArray*)backArr
{
    NSString *myStr = @"";
    for (int i = 0; i<backArr.count; i++)
    {
        NSMutableDictionary *myDic = [backArr objectAtIndex:i];
        if (i == 0)
        {
            myStr = [myDic objectForKey:@"client_id"];
        }else
        {
            myStr = [NSString stringWithFormat:@"%@,%@",myStr,[myDic objectForKey:@"client_id"]];
        }
    }
    [self requestAdd:myStr];
}
#pragma mark- TableView DataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
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
        
        UILabel *labRight = [[UILabel alloc]init];
        labRight.backgroundColor = [UIColor clearColor];
        labRight.textAlignment = NSTextAlignmentRight;
        labRight.font = [UIFont systemFontOfSize:14];
        labRight.tag = 12;
        [labRight setTextColor:BB_Gray_Color];
        labRight.frame = CGRectMake(130, 0, UI_View_Width-145, 50);
        [cell.contentView addSubview:labRight];
    }
    NSMutableArray *temArr = [[NSMutableArray alloc]initWithObjects:@"群组名称",@"消息免打扰",@"清空聊天记录",nil];
    UILabel *labLeft = (UILabel*)[cell viewWithTag:10];
    labLeft.text = [temArr objectAtIndex:indexPath.row];
    
    UISwitch *temSwitch = (UISwitch*)[cell viewWithTag:11];
    [temSwitch setHidden:YES];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    UILabel *labRight = (UILabel*)[cell viewWithTag:12];
    [labRight setHidden:YES];
    
    if (1 == indexPath.row)
    {
        [temSwitch setHidden:NO];
        [temSwitch addTarget:self action:@selector(changeState:) forControlEvents:UIControlEventValueChanged];
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        if ([[dataSource objectForKey:@"hideflag"]integerValue] == 1)
        {
            [temSwitch setOn:YES];
        }else
        {
            [temSwitch setOn:NO];
        }
    }else
    {
        [labRight setHidden:NO];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [temSwitch setHidden:YES];
        
        if (0 == indexPath.row)
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
            [labRight setText:[dataSource objectForKey:@"name"]];
        }
        if (2 == indexPath.row)
        {
            [labRight setHidden:YES];
        }
    }
    
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = [[UIView alloc]init];
    headView.backgroundColor = [UIColor clearColor];
    
    //图片宽度 左右间距10 图片中间15
    float width = (UI_View_Width-80)/5;
    
    for (int i = 0; i<dataImg.count; i++)
    {
        NSMutableDictionary *myDic = [dataImg objectAtIndex:i];
        
        //头像
        HemaButton *backBtn = [HemaButton buttonWithType:UIButtonTypeCustom];
        [backBtn setFrame:CGRectMake(10+(15+width)*(i%5), 15+(33+width)*(i/5), width, width)];
        [HemaFunction addbordertoView:backBtn radius:8 width:2 color:BB_White_Color];
        backBtn.btnRow = i;
        [backBtn addTarget:self action:@selector(ownerPressed:) forControlEvents:UIControlEventTouchUpInside];
        [headView addSubview:backBtn];

        [SystemFunction cashButton:backBtn url:[myDic objectForKey:@"avatar"] firstImg:@"R默认小头像.png"];
        
        //删除按钮
        if ([[dataSource objectForKey:@"adminflag"]integerValue] == 1)
        {
            if ([[myDic objectForKey:@"client_id"]integerValue] != [[[[HemaManager sharedManager] myInfor] objectForKey:@"id"]integerValue])
            {
                HemaButton *deleteBtn = [HemaButton buttonWithType:UIButtonTypeCustom];
                [deleteBtn setFrame:CGRectMake(width-4+(15+width)*(i%5), 11+(33+width)*(i/5), 19, 19)];
                deleteBtn.btnRow = i;
                [deleteBtn addTarget:self action:@selector(deleteMember:) forControlEvents:UIControlEventTouchUpInside];
                [deleteBtn setImage:[UIImage imageNamed:@"R图片删除按钮.png"] forState:UIControlStateNormal];
                [headView addSubview:deleteBtn];
            }
        }
        
        //姓名
        UILabel *labLeft = [[UILabel alloc]init];
        labLeft.backgroundColor = [UIColor clearColor];
        labLeft.textAlignment = NSTextAlignmentCenter;
        labLeft.font = [UIFont systemFontOfSize:12];
        labLeft.textColor = BB_Blake_Color;
        labLeft.frame = CGRectMake(5+(15+width)*(i%5), 18+width+(33+width)*(i/5), 10+width, 14);
        labLeft.text = [myDic objectForKey:@"nickname"];
        [headView addSubview:labLeft];
    }
    //添加按钮
    if ([[dataSource objectForKey:@"adminflag"]integerValue] == 1)
    {
        HemaButton *backBtn = [HemaButton buttonWithType:UIButtonTypeCustom];
        [backBtn setFrame:CGRectMake(10+(15+width)*(dataImg.count%5), 15+(33+width)*(dataImg.count/5), width, width)];
        [HemaFunction addbordertoView:backBtn radius:8 width:2 color:BB_White_Color];
        [backBtn setBackgroundImage:[UIImage imageNamed:@"R群成员添加按钮.png"] forState:UIControlStateNormal];
        [backBtn addTarget:self action:@selector(addPressed:) forControlEvents:UIControlEventTouchUpInside];
        [headView addSubview:backBtn];
    }
    
    return headView;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footView = [[UIView alloc]init];
    footView.backgroundColor = [UIColor clearColor];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(24, 32, UI_View_Width-48, 36);
    [HemaFunction addbordertoView:btn radius:4.0f width:0.0f color:[UIColor clearColor]];
    [btn setBackgroundColor:BB_Red_Color];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [btn setTitleColor:BB_White_Color forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [btn addTarget:self action:@selector(quitButtonPress:) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:btn];
    
    if ([[dataSource objectForKey:@"adminflag"]integerValue] == 1)
    {
        [btn setTitle:@"解散群组" forState:UIControlStateNormal];
    }else
    {
        [btn setTitle:@"退出群组" forState:UIControlStateNormal];
    }
    
    return footView;
}
#pragma mark - Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    float width = (UI_View_Width-80)/5;
    
    if ([[dataSource objectForKey:@"adminflag"]integerValue] == 1)
    {
        if ((dataImg.count+1)%5 == 0)
        {
            return 15+(33+width)*(dataImg.count+1)/5;
        }
        return 15+(33+width)*((dataImg.count+1)/5+1);
    }
    if (dataImg.count%5 == 0)
    {
        return 15+(33+width)*dataImg.count/5;
    }
    return 15+(33+width)*(dataImg.count/5+1);
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 100;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 54;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *) indexPath
{
    if (2 == indexPath.row)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"清空" message:@"确定要清空聊天记录么？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alertView.tag = 100;
        alertView.delegate = self;
        [alertView show];
    }
}
#pragma mark - 连接服务器
#pragma mark 退出群组
- (void)requestRelease
{
    NSString *token = [[HemaManager sharedManager] userToken];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:token forKey:@"token"];
    [dic setObject:@"4" forKey:@"keytype"];
    [dic setObject:@"0" forKey:@"param"];
    [dic setObject:groupId forKey:@"id"];
    
    [HemaRequest requestWithURL:[NSString stringWithFormat:@"%@%@",REQUEST_MAINLINK,REQUEST_GROUP_SAVEOPERATE] target:self selector:@selector(responseRelease:) parameter:dic];
}
- (void)responseRelease:(NSDictionary*)info
{
    if(1 == [[info objectForKey:@"success"] intValue])
    {
        NSString *insertSQL = [NSString stringWithFormat:@"DELETE FROM message WHERE dxgroupid = '%@'",groupId];
        [SystemFunction exceSQL:insertSQL];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else
    {
        [HemaFunction openIntervalHUD:[info objectForKey:@"msg"]];
    }
}
#pragma mark 加人
- (void)requestAdd:(NSString*)param
{
    NSString *token = [[HemaManager sharedManager] userToken];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:token forKey:@"token"];
    [dic setObject:@"1" forKey:@"keytype"];
    [dic setObject:param forKey:@"param"];
    [dic setObject:groupId forKey:@"id"];
    
    [HemaRequest requestWithURL:[NSString stringWithFormat:@"%@%@",REQUEST_MAINLINK,REQUEST_GROUP_SAVEOPERATE] target:self selector:@selector(responseAdd:) parameter:dic];
}
- (void)responseAdd:(NSDictionary*)info
{
    if(1 == [[info objectForKey:@"success"] intValue])
    {
        [self requestMemberList];
    }else
    {
        [HemaFunction openIntervalHUD:[info objectForKey:@"msg"]];
    }
}
#pragma mark 踢人
- (void)requestRemoveMember:(NSString*)param
{
    NSString *token = [[HemaManager sharedManager] userToken];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:token forKey:@"token"];
    [dic setObject:@"7" forKey:@"keytype"];
    [dic setObject:param forKey:@"param"];
    [dic setObject:groupId forKey:@"id"];
    
    [HemaRequest requestWithURL:[NSString stringWithFormat:@"%@%@",REQUEST_MAINLINK,REQUEST_GROUP_SAVEOPERATE] target:self selector:@selector(responseRemoveMember:) parameter:dic];
}
- (void)responseRemoveMember:(NSDictionary*)info
{
    if(1 == [[info objectForKey:@"success"] intValue])
    {
        [self requestMemberList];
    }else
    {
        [HemaFunction openIntervalHUD:[info objectForKey:@"msg"]];
    }
}
#pragma mark 更改群名
- (void)requestChangeName:(NSString*)param
{
    NSString *token = [[HemaManager sharedManager] userToken];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:token forKey:@"token"];
    [dic setObject:@"2" forKey:@"keytype"];
    [dic setObject:param forKey:@"param"];
    [dic setObject:groupId forKey:@"id"];
    
    [HemaRequest requestWithURL:[NSString stringWithFormat:@"%@%@",REQUEST_MAINLINK,REQUEST_GROUP_SAVEOPERATE] target:self selector:@selector(responseChangeName:) parameter:dic];
}
- (void)responseChangeName:(NSDictionary*)info
{
    if(1 == [[info objectForKey:@"success"] intValue])
    {
        
    }else
    {
        [HemaFunction openIntervalHUD:[info objectForKey:@"msg"]];
    }
}
#pragma mark 消息免打扰开关
- (void)requestHide:(NSString*)param
{
    NSString *token = [[HemaManager sharedManager] userToken];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:token forKey:@"token"];
    [dic setObject:@"3" forKey:@"keytype"];
    [dic setObject:param forKey:@"param"];
    [dic setObject:groupId forKey:@"id"];
    
    [HemaRequest requestWithURL:[NSString stringWithFormat:@"%@%@",REQUEST_MAINLINK,REQUEST_GROUP_SAVEOPERATE] target:self selector:@selector(responseHide:) parameter:dic];
}
- (void)responseHide:(NSDictionary*)info
{
    if(1 == [[info objectForKey:@"success"] intValue])
    {
        [[HemaFunction xfuncGetAppdelegate]requestGroupList];
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
    [dic setObject:groupId forKey:@"id"];
    
    [HemaRequest requestWithURL:[NSString stringWithFormat:@"%@%@",REQUEST_MAINLINK,REQUEST_GROUP_GET] target:self selector:@selector(responseGetInfor:) parameter:dic];
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
            [self.mytable setHidden:NO];
            [self.mytable reloadData];
        }
    }else
    {
        if ([[info objectForKey:@"error_code"]integerValue] == 404)
        {
            [HemaFunction openIntervalHUD:@"您已不在此群组中"];
            NSString *insertSQL = [NSString stringWithFormat:@"DELETE FROM message WHERE dxgroupid = '%@'",groupId];
            [SystemFunction exceSQL:insertSQL];
            return;
        }
        [HemaFunction openIntervalHUD:[info objectForKey:@"msg"]];
    }
}
#pragma mark 成员列表
- (void)requestMemberList
{
    NSString *token = [[HemaManager sharedManager] userToken];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:token forKey:@"token"];
    [dic setObject:groupId forKey:@"id"];
    
    [HemaRequest requestWithURL:[NSString stringWithFormat:@"%@%@",REQUEST_MAINLINK,REQUEST_GROUP_CLIENT_LIST] target:self selector:@selector(responseMemberList:) parameter:dic];
}
- (void)responseMemberList:(NSDictionary*)info
{
    if(1 == [[info objectForKey:@"success"] intValue])
    {
        if (!dataImg)
            dataImg = [[NSMutableArray alloc]init];
        [dataImg removeAllObjects];
        
        if(![HemaFunction xfunc_check_strEmpty:[[info objectForKey:@"infor"]objectForKey:@"listItems"]])
        {
            NSMutableArray *temArr = [[info objectForKey:@"infor"]objectForKey:@"listItems"];
            
            for (int i = 0; i<temArr.count; i++)
            {
                NSMutableDictionary *dict = [SystemFunction getDicFromDic:[temArr objectAtIndex:i]];
                [dataImg addObject:dict];
            }
            [self.mytable reloadData];
        }
    }else
    {
        
    }
}
@end
