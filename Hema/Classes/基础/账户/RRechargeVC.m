//
//  RRechargeVC.m
//  Hema
//
//  Created by LarryRodic on 15/10/7.
//  Copyright (c) 2015年 Hemaapp. All rights reserved.
//

#import "RRechargeVC.h"
#import "UPPayPlugin.h"
#import "UPPayPluginDelegate.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"

@interface RRechargeVC ()<UPPayPluginDelegate,UITextFieldDelegate>
{
    NSInteger paySection;//充值方式
    BOOL isTextField;//键盘是否弹起
}
@property(nonatomic,strong)UITextField *textfill;
@end

@implementation RRechargeVC
@synthesize textfill;

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:BB_NOTIFICATION_OrderOK object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:BB_NOTIFICATION_OrderFail object:nil];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadSet];
}
-(void)loadSet
{
    [self.navigationItem setNewTitle:@"账户充值"];
    
    [SystemFunction setTableSeparatorInset:self.mytable left:10];
    [self forbidPullRefresh];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getOkMessage) name:BB_NOTIFICATION_OrderOK object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getFailMessage) name:BB_NOTIFICATION_OrderFail object:nil];
    
    paySection = 0;
}
#pragma mark- 自定义
#pragma mark 事件
//支付
-(void)okPressed:(id)sender
{
    if ([HemaFunction xfunc_check_strEmpty:textfill.text])
    {
        [HemaFunction openIntervalHUD:@"请选择充值金额"];
        return;
    }
    [self requestGetOrder];
}
#pragma mark 支付通知
//第三方支付成功
-(void)getOkMessage
{
    [HemaFunction openIntervalHUDOK:@"支付成功"];
}
//第三方支付失败
-(void)getFailMessage
{
    [HemaFunction openIntervalHUD:@"支付失败"];
}
#pragma mark 银联回调
//银联回调函数
-(void)UPPayPluginResult:(NSString*)result
{
    if ([result isEqualToString:@"success"])
    {
        [HemaFunction openIntervalHUDOK:@"支付成功"];
        return;
    }
    if ([result isEqualToString:@"fail"])
    {
        [HemaFunction openIntervalHUD:@"支付失败"];
        return;
    }
    if ([result isEqualToString:@"cancel"])
    {
        [HemaFunction openIntervalHUD:@"已取消支付"];
        return;
    }
}
#pragma mark- UITextFieldDelegate
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [textfill resignFirstResponder];
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    isTextField = YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    isTextField = NO;
}
#pragma mark- TableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (1 == section)
    {
        return 3;
    }
    return 1;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        static NSString *CellIdentifier = @"000";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if(cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = BB_White_Color;
            
            //左侧
            UILabel *labLeft = [[UILabel alloc]init];
            labLeft.backgroundColor = [UIColor clearColor];
            labLeft.textAlignment = NSTextAlignmentLeft;
            labLeft.font = [UIFont boldSystemFontOfSize:15];
            labLeft.textColor = [UIColor blackColor];
            labLeft.frame = CGRectMake(10, 0, 16, 46);
            labLeft.text = @"￥";
            [cell.contentView addSubview:labLeft];
            
            textfill = [[UITextField alloc]init];
            textfill.textColor = [UIColor blackColor];
            textfill.font = [UIFont systemFontOfSize:15.0];
            textfill.placeholder = @"";
            textfill.delegate = self;
            textfill.frame = CGRectMake(26, 13, 180, 20);
            textfill.textAlignment = NSTextAlignmentLeft;
            textfill.clearButtonMode = UITextFieldViewModeNever;
            textfill.keyboardType = UIKeyboardTypeNumberPad;
            textfill.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            textfill.returnKeyType = UIReturnKeyDone;
            [cell.contentView addSubview:textfill];
            [textfill becomeFirstResponder];
        }
        
        return cell;
    }
    static NSString *CellIdentifier = @"all";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 80, 0, 0)];
        cell.backgroundColor = BB_White_Color;
        
        //左侧图片
        UIImageView *leftImgView = [[UIImageView alloc]init];
        leftImgView.tag = 9;
        [cell.contentView addSubview:leftImgView];
        
        //左侧
        UILabel *labLeft = [[UILabel alloc]init];
        labLeft.backgroundColor = [UIColor clearColor];
        labLeft.textAlignment = NSTextAlignmentLeft;
        labLeft.font = [UIFont systemFontOfSize:15];
        labLeft.textColor = BB_Blake_Color;
        labLeft.frame = CGRectMake(80, 20, UI_View_Width-120, 17);
        labLeft.tag = 10;
        [cell.contentView addSubview:labLeft];
        
        //右侧
        UILabel *labRight = [[UILabel alloc]init];
        labRight.backgroundColor = [UIColor clearColor];
        labRight.textAlignment = NSTextAlignmentLeft;
        labRight.textColor = BB_Gray_Color;
        labRight.font = [UIFont systemFontOfSize:12];
        labRight.frame = CGRectMake(80, 43, UI_View_Width-120, 14);
        labRight.tag = 11;
        [cell.contentView addSubview:labRight];
        
        //右侧按钮
        UIImageView *rightImgView = [[UIImageView alloc]init];
        [rightImgView setFrame:CGRectMake(UI_View_Width-40, 27, 22, 22)];
        rightImgView.tag = 12;
        [cell.contentView addSubview:rightImgView];
    }
    NSMutableArray *temArr = [[NSMutableArray alloc]initWithObjects:@"微信客户端支付",@"银联手机支付",@"支付宝客户端支付",nil];
    NSMutableArray *temArr1 = [[NSMutableArray alloc]initWithObjects:@"推荐安装微信客户端的用户使用",@"推荐有银联账户的用户使用",@"推荐安装支付宝客户端的用户使用",nil];
    
    //左侧图片
    UIImageView *leftImgView = (UIImageView*)[cell viewWithTag:9];
    if (0 == indexPath.row)
    {
        [leftImgView setFrame:CGRectMake(23, 20, 36, 36)];
        [leftImgView setImage:[UIImage imageNamed:@"R微信充值.png"]];
    }
    if (1 == indexPath.row)
    {
        [leftImgView setFrame:CGRectMake(15, 24, 51, 27.5)];
        [leftImgView setImage:[UIImage imageNamed:@"R银联.png"]];
    }
    if (2 == indexPath.row)
    {
        [leftImgView setFrame:CGRectMake(13, 29, 56, 19.9)];
        [leftImgView setImage:[UIImage imageNamed:@"R支付宝.png"]];
    }
    UILabel *labLeft = (UILabel*)[cell viewWithTag:10];
    labLeft.text = [temArr objectAtIndex:indexPath.row];
    
    UILabel *labRight = (UILabel*)[cell viewWithTag:11];
    labRight.text = [temArr1 objectAtIndex:indexPath.row];
    
    //右侧按钮
    UIImageView *rightImgView = (UIImageView*)[cell viewWithTag:12];
    if (paySection == indexPath.row)
    {
        [rightImgView setImage:[UIImage imageNamed:@"R蓝色对勾选中.png"]];
    }else
    {
        [rightImgView setImage:[UIImage imageNamed:@"R对勾未选中.png"]];
    }
    
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = [[UIView alloc]init];
    headView.backgroundColor = [UIColor clearColor];
    
    if (0 == section)
    {
        UILabel *labLogin = [[UILabel alloc]init];
        [labLogin setFont:[UIFont systemFontOfSize:14]];
        [labLogin setBackgroundColor:[UIColor clearColor]];
        [labLogin setTextAlignment:NSTextAlignmentLeft];
        [labLogin setTextColor:BB_Gray_Color];
        [labLogin setText:@"请输入充值金额"];
        [labLogin setFrame:CGRectMake(11, 0 ,234, 33)];
        [headView addSubview:labLogin];
    }
    if (1 == section)
    {
        UILabel *labLogin = [[UILabel alloc]init];
        [labLogin setFont:[UIFont systemFontOfSize:14]];
        [labLogin setBackgroundColor:[UIColor clearColor]];
        [labLogin setTextAlignment:NSTextAlignmentLeft];
        [labLogin setTextColor:BB_Gray_Color];
        [labLogin setText:@"选择支付方式"];
        [labLogin setFrame:CGRectMake(11, 0 ,234, 33)];
        [headView addSubview:labLogin];
    }
    return headView;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footView = [[UIView alloc]init];
    footView.backgroundColor = [UIColor clearColor];
    
    if (1 == section)
    {
        UIButton *loginButton=[UIButton buttonWithType:UIButtonTypeCustom];
        [loginButton setBackgroundColor:BB_Blue_Color];
        [loginButton.titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
        [loginButton setTitle:@"确认支付" forState:UIControlStateNormal];
        [loginButton setTitleColor:BB_White_Color forState:UIControlStateNormal];
        [loginButton setFrame:CGRectMake(20, 39, UI_View_Width-40, 40)];
        [HemaFunction addbordertoView:loginButton radius:5.0f width:0.0f color:[UIColor clearColor]];
        [loginButton addTarget:self action:@selector(okPressed:) forControlEvents:UIControlEventTouchDown];
        [footView addSubview:loginButton];
    }
    return footView;
}
#pragma mark - Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (0 == section||1 == section)
    {
        return 33;
    }
    return 0.1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 3;
    }
    return 100;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return 46;
    }
    return 76;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *) indexPath
{
    if (isTextField)
    {
        [self.textfill resignFirstResponder];
        return;
    }
    if (indexPath.section == 0)
    {
        return;
    }
    paySection = indexPath.row;
    [self.mytable reloadData];
}
#pragma mark - 连接服务器
#pragma mark 订单生成
- (void)requestGetOrder
{
    NSString *token = [[HemaManager sharedManager] userToken];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:token forKey:@"token"];
    [dic setObject:@"1" forKey:@"keytype"];
    [dic setObject:@"0" forKey:@"keyid"];
    [dic setObject:@"0" forKey:@"buycount"];
    [dic setObject:self.textfill.text forKey:@"total_fee"];
    
    if (0 == paySection)
    {
        [dic setObject:@"3" forKey:@"paytype"];
        [HemaRequest requestWithURL:[NSString stringWithFormat:@"%@OnlinePay/Weixinpay/weixinpay_get.php",[[[HemaManager sharedManager] myInitInfor] objectForKey:@"sys_plugins"]] target:self selector:@selector(responseGetOrder:) parameter:dic];//微信
    }
    if (1 == paySection)
    {
        [dic setObject:@"2" forKey:@"paytype"];
        [HemaRequest requestWithURL:[NSString stringWithFormat:@"%@OnlinePay/Unionpay/unionpay_get.php",[[[HemaManager sharedManager] myInitInfor] objectForKey:@"sys_plugins"]] target:self selector:@selector(responseGetOrder:) parameter:dic];//银联
    }
    if (2 == paySection)
    {
        [dic setObject:@"1" forKey:@"paytype"];
        [HemaRequest requestWithURL:[NSString stringWithFormat:@"%@OnlinePay/Alipay/alipaysign_get.php",[[[HemaManager sharedManager] myInitInfor] objectForKey:@"sys_plugins"]] target:self selector:@selector(responseGetOrder:) parameter:dic];//支付宝
        return;
    }
}
- (void)responseGetOrder:(NSDictionary*)info
{
    if(1 == [[info objectForKey:@"success"] intValue])
    {
        if (0 == paySection)
        {
            NSMutableDictionary *temDic = [[info objectForKey:@"infor"]objectAtIndex:0];
            
            [WXApi registerApp:[temDic objectForKey:@"appid"]];
            PayReq *request = [[PayReq alloc] init];
            request.partnerId = [temDic objectForKey:@"partnerid"];
            request.prepayId= [temDic objectForKey:@"prepayid"];
            request.package = [temDic objectForKey:@"package"];
            request.nonceStr= [temDic objectForKey:@"noncestr"];
            request.timeStamp= [[temDic objectForKey:@"timestamp"]intValue];
            request.sign= [temDic objectForKey:@"sign"];
            
            [WXApi sendReq:request];
        }
        if (1 == paySection)
        {
            NSString *orderStr = [[[info objectForKey:@"infor"]objectAtIndex:0]objectForKey:@"tn"];
            [UPPayPlugin startPay:orderStr mode:BB_XCONST_IS_YLCeshi viewController:self delegate:self];
        }
        if (2 == paySection)
        {
            NSString *appScheme = @"HemaDemo";
            NSString *orderStr = [[[info objectForKey:@"infor"]objectAtIndex:0]objectForKey:@"alipaysign"];
            [[AlipaySDK defaultService] payOrder:orderStr fromScheme:appScheme callback:^(NSDictionary *resultDic)
             {
                 NSLog(@"reslut = %@",resultDic);
                 if ([[resultDic objectForKey:@"resultStatus"]integerValue] == 9000)
                 {
                     [HemaFunction openIntervalHUDOK:@"支付成功"];
                 }else
                 {
                     [HemaFunction openIntervalHUD:@"支付失败"];
                 }
             }];
        }
    }else
    {
        [HemaFunction openIntervalHUD:[info objectForKey:@"msg"]];
    }
}
@end
