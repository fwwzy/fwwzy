//
//  RSettingVC.m
//  Hema
//
//  Created by LarryRodic on 15/10/7.
//  Copyright (c) 2015年 Hemaapp. All rights reserved.
//

#import "RSettingVC.h"
#import "HemaWebVC.h"
#import "HemaReplyVC.h"
#import "RMoreFunctionVC.h"
#import "SDImageCache.h"

@interface RSettingVC ()<HemaReplyDelegate>
@property(nonatomic,strong)NSMutableArray *listArr;
@end

@implementation RSettingVC

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.mytable reloadData];
}
-(void)loadSet
{
    [self.navigationItem setNewTitle:@"设置"];
    [self.navigationItem setRightItemWithTarget:self action:@selector(rightbtnPressed:) image:@"R聊天右导航设置按钮.png"];
    
    [self.mytable setSeparatorInset:UIEdgeInsetsMake(0, 43, 0, 0)];
    [self reSetTableViewFrame:CGRectMake(0, 0, UI_View_Width, UI_View_Height-49)];
    
    [self forbidPullRefresh];
}
-(void)loadData
{
    _listArr = [[NSMutableArray alloc]initWithObjects:@"意见反馈",@"关于软件",@"清除缓存",@"联系客服",@"给我好评",@"软件分享",@"仅在WIFI下显示图片", nil];
}
#pragma mark- 自定义
#pragma mark 事件
-(void)rightbtnPressed:(id)sender
{
    RMoreFunctionVC *myVC = [[RMoreFunctionVC alloc]init];
    [self.navigationController pushViewController:myVC animated:YES];
}
//仅在WIFI下显示图片
- (void)changeStateXia:(UISwitch*)sender
{
    [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%d",sender.on] forKey:GDownLoad];
}
#pragma mark 方法
//刷新页面
-(void)reShowView
{
    [self.mytable reloadData];
}
#pragma mark- HemaReplyDelegate
-(void)HemaReplyOK:(HemaReplyVC*)reply content:(NSString*)content
{
    [self requestSaveAdvice:content];
}
#pragma mark- UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //退出登录
    if(300 == alertView.tag&&1 == buttonIndex)
    {
        [[HemaFunction xfuncGetAppdelegate] requestQuit];
    }
    //联系客服
    if(101 == alertView.tag&&1 == buttonIndex)
    {
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",[[[HemaManager sharedManager] myInitInfor] objectForKey:@"sys_service_phone"]]]];
    }
}
#pragma mark- TableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([HemaFunction xfuncGetAppdelegate].isLogin)
    {
        return 2;
    }
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (0 == section)
    {
        return _listArr.count;
    }
    return 1;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (1 == indexPath.section)
    {
        static NSString *CellIdentifier = @"001";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if(cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.backgroundColor = BB_White_Color;
            
            //左侧
            UILabel *labLeft = [[UILabel alloc]init];
            labLeft.backgroundColor = [UIColor clearColor];
            labLeft.textAlignment = NSTextAlignmentCenter;
            labLeft.font = [UIFont systemFontOfSize:15];
            labLeft.text = @"退出登录";
            [labLeft setTextColor:BB_Red_Color];
            labLeft.frame = CGRectMake(0, 0, UI_View_Width, 55);
            [cell.contentView addSubview:labLeft];
        }
        return cell;
    }
    static NSString *CellIdentifier = @"all";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.backgroundColor = BB_White_Color;
        
        UIImageView *leftImgView = [[UIImageView alloc]init];
        [leftImgView setFrame:CGRectMake(10, 16, 23, 23)];
        leftImgView.tag = 9;
        [cell.contentView addSubview:leftImgView];
        
        //左侧
        UILabel *labLeft = [[UILabel alloc]init];
        labLeft.backgroundColor = [UIColor clearColor];
        labLeft.textAlignment = NSTextAlignmentLeft;
        labLeft.font = [UIFont systemFontOfSize:15];
        labLeft.tag = 10;
        labLeft.frame = CGRectMake(43, 0, 140, 55);
        labLeft.textColor = BB_Blake_Color;
        [cell.contentView addSubview:labLeft];
        
        //右侧
        UILabel *labRight = [[UILabel alloc]init];
        labRight.backgroundColor = [UIColor clearColor];
        labRight.textAlignment = NSTextAlignmentRight;
        labRight.font = [UIFont systemFontOfSize:15];
        labRight.tag = 11;
        labRight.frame = CGRectMake(200, 0, UI_View_Width-230, 55);
        labRight.textColor = BB_Gray_Color;
        [cell.contentView addSubview:labRight];
        
        UIImageView *arrowImgView = [[UIImageView alloc]init];
        [arrowImgView setImage:[UIImage imageNamed:@"R右侧蓝色箭头.png"]];
        [arrowImgView setFrame:CGRectMake(UI_View_Width-25, 19, 11, 17)];
        arrowImgView.tag = 12;
        [cell.contentView addSubview:arrowImgView];
        
        UISwitch *temSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(UI_View_Width-68, 15, 54, 25)];
        [cell.contentView addSubview:temSwitch];
        temSwitch.tag = 13;
        temSwitch.onTintColor = BB_Blue_Color;
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    UILabel *labLeft = (UILabel*)[cell viewWithTag:10];
    labLeft.text = [_listArr objectAtIndex:indexPath.row];
    [labLeft setFrame:CGRectMake(43, 0, 140, 55)];
    
    UIImageView *leftImgView = (UIImageView*)[cell viewWithTag:9];
    [leftImgView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"R设置之%d.png",(int)indexPath.row]]];
    
    UILabel *labRight = (UILabel*)[cell viewWithTag:11];
    [labRight setHidden:YES];
    
    if (2 == indexPath.row)
    {
        unsigned long long size = [SDImageCache.sharedImageCache getSize];
        if (size/1024 > 0)
        {
            [labRight setHidden:NO];
            if (size/(1024*1024) == 0)
            {
                [labRight setText:[NSString stringWithFormat:@"%lluK",size/1024]];
            }else
            {
                [labRight setText:[NSString stringWithFormat:@"%lluM",size/(1024*1024)]];
            }
        }else
        {
            [labRight setHidden:YES];
        }
    }
    
    UIImageView *arrowImgView = (UIImageView*)[cell viewWithTag:12];
    [arrowImgView setHidden:NO];
    
    UISwitch *temSwitch = (UISwitch*)[cell viewWithTag:13];
    [temSwitch setHidden:YES];
    
    if (6 == indexPath.row)
    {
        [temSwitch setHidden:NO];
        [arrowImgView setHidden:YES];
        [labLeft setFrame:CGRectMake(10, 0, 140, 55)];
        
        [temSwitch addTarget:self action:@selector(changeStateXia:) forControlEvents:UIControlEventValueChanged];
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:GDownLoad]integerValue] == 1)
        {
            temSwitch.on = YES;
        }else
        {
            temSwitch.on = NO;
        }
    }
    
    return cell;
}
#pragma mark - Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 7;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (1 == section)
    {
        return 12;
    }
    return 0.1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *) indexPath
{
    if (1 == indexPath.section)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"退出" message:@"确定要退出当前账号么？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
        alert.tag = 300;
        alert.delegate = self;
        return;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    //意见反馈
    if (0 == indexPath.row)
    {
        HemaReplyVC *myVC = [[HemaReplyVC alloc]init];
        myVC.keyName = @"comment";
        myVC.titleName = @"意见反馈";
        myVC.placeholder = @"请留下您的宝贵意见...";
        myVC.delegate = self;
        [self.navigationController pushViewController:myVC animated:YES];
    }
    //关于软件
    if (1 == indexPath.row)
    {
        HemaWebVC *web = [[HemaWebVC alloc]init];
        web.urlPath = [NSString stringWithFormat:@"%@webview/parm/aboutus",[[[HemaManager sharedManager] myInitInfor] objectForKey:@"sys_web_service"]];
        web.objectTitle = @"关于我们";
        web.isAdgust = NO;
        [self.navigationController pushViewController:web animated:YES];
    }
    //清除缓存
    if (2 == indexPath.row)
    {
        NSString *avatarDocument = [NSString stringWithFormat:@"%@/%@",BB_CASH_DOCUMENT,BB_CASH_AVATAR];
        [[HemaCashManager sharedManager] removeDocument:avatarDocument];
        NSString *audioDocument = [NSString stringWithFormat:@"%@/%@",BB_CASH_DOCUMENT,BB_CASH_AUDIO];
        [[HemaCashManager sharedManager] removeDocument:audioDocument];
        NSString *videoDocument = [NSString stringWithFormat:@"%@/%@",BB_CASH_DOCUMENT,BB_CASH_VIDEO];
        [[HemaCashManager sharedManager] removeDocument:videoDocument];
        
        [SDImageCache.sharedImageCache clearMemory];
        [SDImageCache.sharedImageCache clearDisk];
        [SDImageCache.sharedImageCache cleanDisk];
        
        [HemaFunction openIntervalHUDOK:@"已经成功删除缓存"];
        
        [self performSelector:@selector(reShowView) withObject:nil afterDelay:0.5];
    }
    //联系客服
    if (3 == indexPath.row)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"联系客服" message:[[[HemaManager sharedManager] myInitInfor] objectForKey:@"sys_service_phone"] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alertView.tag = 101;
        alertView.delegate = self;
        [alertView show];
    }
    //给我好评
    if (4 == indexPath.row)
    {
        NSString * updateURL = [[[HemaManager sharedManager] myInitInfor] objectForKey:@"iphone_comment_url"];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:updateURL]];
    }
    //软件分享
    if (5 == indexPath.row)
    {
        [ShareFunction share:1 dataDic:nil myVC:self];
    }
}
#pragma mark- 连接服务器
#pragma mark 意见反馈
- (void)requestSaveAdvice:(NSString*)myStr
{
    NSString *token = [[HemaManager sharedManager] userToken];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:token forKey:@"token"];
    [dic setObject:myStr forKey:@"content"];
    
    [HemaRequest requestWithURL:[NSString stringWithFormat:@"%@%@",REQUEST_MAINLINK,REQUEST_ADVICE_ADD] target:self selector:@selector(responseSaveAdvice:) parameter:dic];
}
- (void)responseSaveAdvice:(NSDictionary*)info
{
    if(1 == [[info objectForKey:@"success"] intValue])
    {
        [HemaFunction openIntervalHUDOK:@"感谢您的宝贵意见!客服会及时处理！"];
    }else
    {
        [HemaFunction openIntervalHUD:[info objectForKey:@"msg"]];
    }
}
@end
