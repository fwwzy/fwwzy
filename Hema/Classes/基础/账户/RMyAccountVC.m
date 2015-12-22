//
//  RMyAccountVC.m
//  Hema
//
//  Created by LarryRodic on 15/10/7.
//  Copyright (c) 2015年 Hemaapp. All rights reserved.
//
#define TopHeight 48
#import "RMyAccountVC.h"
#import "RRechargeVC.h"
#import "RApplyGetVC.h"

@interface RMyAccountVC ()<UIActionSheetDelegate>

@end

@implementation RMyAccountVC

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self requestGetInfor];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadSet];
}
-(void)loadSet
{
    [self.navigationItem setNewTitle:@"我的账户"];
    
    [self.mytable setSeparatorInset:UIEdgeInsetsMake(0, 17, 0, 0)];
    [self reSetTableViewFrame:CGRectMake(0, 0, UI_View_Width, UI_View_Height-TopHeight)];
    [self forbidPullRefresh];
    
    //底部view
    UIView *downView = [[UIView alloc]init];
    [downView setFrame:CGRectMake(-1, UI_View_Height-TopHeight, UI_View_Width+2, TopHeight+1)];
    [HemaFunction addbordertoView:downView radius:0.0 width:0.5f color:BB_Gray_Color];
    [downView setBackgroundColor:BB_Back_Color_Here_Bar];
    [self.view addSubview:downView];
    
    for (int i = 0; i<2; i++)
    {
        HemaButton *downBtn = [HemaButton buttonWithType:UIButtonTypeCustom];
        [downBtn setFrame:CGRectMake(20+i*(UI_View_Width/2-10), 5, UI_View_Width/2-30, 38)];
        downBtn.btnRow = i;
        [downBtn addTarget:self action:@selector(downPressed:) forControlEvents:UIControlEventTouchUpInside];
        [HemaFunction addbordertoView:downBtn radius:4.0 width:0 color:[UIColor clearColor]];
        [downView addSubview:downBtn];
        
        UIImageView *downImgView = [[UIImageView alloc]init];
        [downImgView setContentMode:UIViewContentModeScaleAspectFit];
        [downImgView setFrame:CGRectMake(0, 0, UI_View_Width/2-30, 38)];
        [downBtn addSubview:downImgView];
        
        if (i == 0)
        {
            [downBtn setBackgroundColor:RGB_UI_COLOR(224, 119, 238)];
            [downImgView setImage:[UIImage imageNamed:@"R充值按钮.png"]];
        }else
        {
            [downBtn setBackgroundColor:RGB_UI_COLOR(119, 167, 238)];
            [downImgView setImage:[UIImage imageNamed:@"R申请提现按钮.png"]];
        }
    }
}
#pragma mark- 自定义
#pragma mark 事件
//底部栏按钮 充值与提现
-(void)downPressed:(HemaButton*)sender
{
    if (0 == sender.btnRow)
    {
        RRechargeVC *myVC = [[RRechargeVC alloc]init];
        [self.navigationController pushViewController:myVC animated:YES];
    }else
    {
        UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"支付宝",@"银行卡",@"取消", nil];
        [SystemFunction setActionSheet:actionSheet index:2 myVC:self];
    }
}
#pragma mark- UIActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString*title = [actionSheet buttonTitleAtIndex:buttonIndex];
    if([title isEqualToString:@"支付宝"])
    {
        RApplyGetVC *myVC = [[RApplyGetVC alloc]init];
        myVC.keytype = 2;
        [self.navigationController pushViewController:myVC animated:YES];
    }
    if([title isEqualToString:@"银行卡"])
    {
        RApplyGetVC *myVC = [[RApplyGetVC alloc]init];
        myVC.keytype = 1;
        [self.navigationController pushViewController:myVC animated:YES];
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
    if (1 == indexPath.section)
    {
        static NSString *CellIdentifier = @"100";
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
            labLeft.font = [UIFont systemFontOfSize:16];
            labLeft.frame = CGRectMake(17, 0, 120, 52);
            [labLeft setTextColor:BB_Gray_Color];
            labLeft.tag = 10;
            [cell.contentView addSubview:labLeft];
        }
        NSMutableArray *temArr = [[NSMutableArray alloc]initWithObjects:@"充值记录",@"提现记录", nil];
        
        UILabel *labLeft = (UILabel*)[cell viewWithTag:10];
        labLeft.text = [temArr objectAtIndex:indexPath.row];
        
        return cell;
    }
    static NSString *CellIdentifier = @"BWMSetting2";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.backgroundColor = BB_White_Color;
    }else
    {
        for(UIView *view in cell.contentView.subviews)
        {
            [view removeFromSuperview];
        }
    }
    
    //账户
    UILabel *labLeft = [[UILabel alloc]init];
    labLeft.backgroundColor = [UIColor clearColor];
    labLeft.textAlignment = NSTextAlignmentCenter;
    labLeft.font = [UIFont systemFontOfSize:20];
    [labLeft setText:[NSString stringWithFormat:@"￥%@",[[[HemaManager sharedManager] myInfor] objectForKey:@"feeaccount"]]];
    [labLeft setTextColor:BB_Blake_Color];
    [labLeft setFrame:CGRectMake(0, 68, UI_View_Width, 22)];
    [cell.contentView addSubview:labLeft];
    
    //说明
    UILabel *labInfor = [[UILabel alloc]init];
    labInfor.backgroundColor = [UIColor clearColor];
    labInfor.textAlignment = NSTextAlignmentLeft;
    labInfor.font = [UIFont systemFontOfSize:16];
    labInfor.text = @"账户余额";
    [labInfor setTextColor:BB_Gray_Color];
    [labInfor setFrame:CGRectMake(17, 19, 150, 18)];
    [cell.contentView addSubview:labInfor];
    
    return cell;
}
#pragma mark - Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (1 == indexPath.section)
    {
        return 52;
    }
    return 115;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *) indexPath
{
    if (1 == indexPath.section)
    {
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
        //充值记录
        if (0 == indexPath.row)
        {
            
        }
        //提现记录
        if (1 == indexPath.row)
        {
            
        }
    }
}
#pragma mark - 连接服务器
#pragma mark 个人资料
-(void)requestGetInfor
{
    NSString *token = [[HemaManager sharedManager] userToken];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:token forKey:@"token"];
    [dic setObject:[[[HemaManager sharedManager] myInfor] objectForKey:@"id"] forKey:@"id"];
    
    [HemaRequest requestWithURL:[NSString stringWithFormat:@"%@%@",REQUEST_MAINLINK,REQUEST_CLIENT_GET] target:self selector:@selector(responseGetInfor:) parameter:dic];
}
- (void)responseGetInfor:(NSDictionary*)info
{
    if(1 == [[info objectForKey:@"success"] intValue])
    {
        if(![HemaFunction xfunc_check_strEmpty:[info objectForKey:@"infor"]])
        {
            NSMutableDictionary *dataSource = [SystemFunction getDicFromDic:[[info objectForKey:@"infor"] objectAtIndex:0]];
            
            HemaManager *myManager = [HemaManager sharedManager];
            myManager.myInfor = dataSource;
            [self.mytable reloadData];
        }
    }else
    {
        [HemaFunction openIntervalHUD:[info objectForKey:@"msg"]];
    }
}

@end
