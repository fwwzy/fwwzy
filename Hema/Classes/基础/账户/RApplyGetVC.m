//
//  RApplyGetVC.m
//  Hema
//
//  Created by LarryRodic on 15/10/8.
//  Copyright (c) 2015年 Hemaapp. All rights reserved.
//
#define NUMBERS @"0123456789\n"

#import "RApplyGetVC.h"
#import "HemaEditorVC.h"
#import "HemaWebVC.h"
#import "REditCardVC.h"

@interface RApplyGetVC ()<HemaEditorDelegate,UITextFieldDelegate>
@property(nonatomic,strong)NSMutableDictionary *dataSource;
@property(nonatomic,strong)UITextField *textfill;
@property(nonatomic,strong)UITextField *textpassword;
@end

@implementation RApplyGetVC
@synthesize dataSource;
@synthesize keytype;
@synthesize textfill;
@synthesize textpassword;

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.mytable reloadData];
}
-(void)loadSet
{
    if (keytype == 1)
    {
        [self.navigationItem setNewTitle:@"银行卡提现"];
    }
    if (keytype == 2)
    {
        [self.navigationItem setNewTitle:@"支付宝提现"];
    }
    
    [SystemFunction setTableSeparatorInset:self.mytable left:10];
    [self forbidPullRefresh];
}
-(void)loadData
{
    if (!dataSource)
        dataSource = [[NSMutableDictionary alloc]init];
    [self requestGetInfor];
}
#pragma mark- 自定义
#pragma mark 事件
//提交申请按钮事件
-(void)okPressed:(id)sender
{
    if ([HemaFunction xfunc_check_strEmpty:textfill.text])
    {
        [HemaFunction openIntervalHUD:@"请输入提现金额"];
        return;
    }
    if ([HemaFunction xfunc_check_strEmpty:textpassword.text])
    {
        [HemaFunction openIntervalHUD:@"请输入提现密码"];
        return;
    }
    if ([textfill.text integerValue]%100 != 0)
    {
        [HemaFunction openIntervalHUD:@"提现金额输入不正确"];
        return;
    }
    if ([textfill.text integerValue]/100 == 0)
    {
        [HemaFunction openIntervalHUD:@"提现金额输入不正确"];
        return;
    }
    if(textpassword.text.length < 6)
    {
        [HemaFunction openIntervalHUD:@"提现密码不能低于六位"];
        return;
    }
    if(textpassword.text.length >12)
    {
        [HemaFunction openIntervalHUD:@"提现密码不能高于十二位"];
        return;
    }
    if (keytype == 1)
    {
        if ([HemaFunction xfunc_check_strEmpty:[dataSource objectForKey:@"bankname"]])
        {
            [HemaFunction openIntervalHUD:@"请输入银行卡信息"];
            return;
        }
    }
    if (keytype == 2)
    {
        if ([HemaFunction xfunc_check_strEmpty:[dataSource objectForKey:@"alipay"]])
        {
            [HemaFunction openIntervalHUD:@"请输入支付宝账号"];
            return;
        }
    }
    
    [self requestCashAdd];
}
//钱包使用说明
-(void)qianPressed:(id)sender
{
    HemaWebVC *web = [[HemaWebVC alloc]init];
    web.urlPath = [NSString stringWithFormat:@"%@webview/parm/wallet",[[[HemaManager sharedManager] myInitInfor] objectForKey:@"sys_web_service"]];
    web.objectTitle = @"钱包使用说明";
    web.isAdgust = NO;
    [self.navigationController pushViewController:web animated:YES];
}
#pragma mark- HemaEditorDelegate
-(void)HemaEditorOK:(HemaEditorVC*)editor backValue:(NSString*)value
{
    if(editor.key)
    {
        if(!value)
            value = @"";
        [dataSource setObject:value forKey:editor.key];
        [self.mytable reloadData];
        
        [self requestAlipayAdd:value];
    }
}
#pragma mark- UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(id)textField
{
    [textField resignFirstResponder];
    [SystemFunction actionActive];
    [self.mytable setFrame:CGRectMake(0, 0, UI_View_Width, UI_View_Height)];
    [UIView commitAnimations];
    return YES;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [SystemFunction actionActive];
    [self.mytable setFrame:CGRectMake(0, -100, UI_View_Width, UI_View_Height+100)];
    [UIView commitAnimations];
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.textpassword)
    {
        return YES;
    }
    //textfill 只允许输入数字
    NSCharacterSet *cs;
    cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS] invertedSet];
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    BOOL basicTest = [string isEqualToString:filtered];
    if(!basicTest)
    {
        return NO;
    }
    return YES;
}
#pragma mark- UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [textpassword resignFirstResponder];
    [textfill resignFirstResponder];
    
    [SystemFunction actionActive];
    [self.mytable setFrame:CGRectMake(0, 0, UI_View_Width, UI_View_Height)];
    [UIView commitAnimations];
}
#pragma mark- TableView DataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (2 == section)
    {
        return 1;
    }
    return 2;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.section)
    {
        if (0 == indexPath.row)
        {
            if (keytype == 2)
            {
                //如果是空的
                if ([HemaFunction xfunc_check_strEmpty:[dataSource objectForKey:@"alipay"]])
                {
                    static NSString *CellIdentifier = @"00keytype2YES";
                    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    if(cell == nil)
                    {
                        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                        cell.backgroundColor = BB_White_Color;
                        
                        UILabel *labLeft = [[UILabel alloc]init];
                        labLeft.backgroundColor = [UIColor clearColor];
                        labLeft.textAlignment = NSTextAlignmentLeft;
                        labLeft.font = [UIFont systemFontOfSize:16];
                        [labLeft setFrame:CGRectMake(10, 0, 200, 55)];
                        labLeft.textColor = BB_Blake_Color;
                        labLeft.text = @"请填写支付宝账号";
                        [cell.contentView addSubview:labLeft];
                    }
                    
                    return cell;
                }
            }else
            {
                //如果是空的
                if ([HemaFunction xfunc_check_strEmpty:[dataSource objectForKey:@"bankname"]])
                {
                    static NSString *CellIdentifier = @"00keytype1YES";
                    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    if(cell == nil)
                    {
                        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                        cell.backgroundColor = BB_White_Color;
                        
                        UILabel *labLeft = [[UILabel alloc]init];
                        labLeft.backgroundColor = [UIColor clearColor];
                        labLeft.textAlignment = NSTextAlignmentLeft;
                        labLeft.font = [UIFont systemFontOfSize:16];
                        [labLeft setFrame:CGRectMake(10, 0, 200, 55)];
                        labLeft.textColor = BB_Blake_Color;
                        labLeft.text = @"请选择银行卡";
                        [cell.contentView addSubview:labLeft];
                    }
                    
                    return cell;
                }
            }
            
            
            //如果不是空的
            static NSString *CellIdentifier = @"00NO";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if(cell == nil)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.backgroundColor = BB_White_Color;
            }else
            {
                for(UIView *view in cell.contentView.subviews)
                {
                    [view removeFromSuperview];
                }
            }
            if (keytype == 2)
            {
                UILabel *labLeft = [[UILabel alloc]init];
                labLeft.backgroundColor = [UIColor clearColor];
                labLeft.textAlignment = NSTextAlignmentLeft;
                labLeft.font = [UIFont systemFontOfSize:18];
                [labLeft setFrame:CGRectMake(10, 24, UI_View_Width-70, 20)];
                labLeft.textColor = BB_Blake_Color;
                labLeft.text = @"支付宝账号";
                [cell.contentView addSubview:labLeft];
                
                UILabel *labName = [[UILabel alloc]init];
                labName.backgroundColor = [UIColor clearColor];
                labName.textAlignment = NSTextAlignmentLeft;
                labName.font = [UIFont systemFontOfSize:14];
                [labName setFrame:CGRectMake(10, 60, UI_View_Width-70, 16)];
                labName.textColor = BB_Gray_Color;
                labName.text = [dataSource objectForKey:@"alipay"];
                [cell.contentView addSubview:labName];
            }else
            {
                UILabel *labLeft = [[UILabel alloc]init];
                labLeft.backgroundColor = [UIColor clearColor];
                labLeft.textAlignment = NSTextAlignmentLeft;
                labLeft.font = [UIFont systemFontOfSize:18];
                [labLeft setFrame:CGRectMake(10, 24, UI_View_Width-70, 20)];
                labLeft.textColor = BB_Blake_Color;
                labLeft.text = [dataSource objectForKey:@"bankname"];
                [cell.contentView addSubview:labLeft];
                
                UILabel *labName = [[UILabel alloc]init];
                labName.backgroundColor = [UIColor clearColor];
                labName.textAlignment = NSTextAlignmentLeft;
                labName.font = [UIFont systemFontOfSize:14];
                [labName setFrame:CGRectMake(10, 60, UI_View_Width-70, 16)];
                labName.textColor = BB_Gray_Color;
                labName.text = [dataSource objectForKey:@"bankuser"];
                [cell.contentView addSubview:labName];
                
                UILabel *labCard = [[UILabel alloc]init];
                labCard.backgroundColor = [UIColor clearColor];
                labCard.textAlignment = NSTextAlignmentLeft;
                labCard.font = [UIFont systemFontOfSize:14];
                [labCard setFrame:CGRectMake(10, 80, UI_View_Width-70, 16)];
                labCard.textColor = BB_Gray_Color;
                labCard.text = [dataSource objectForKey:@"bankcard"];
                [cell.contentView addSubview:labCard];
            }
            return cell;
        }
        //当前钱包余额
        static NSString *CellIdentifier = @"01";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = BB_White_Color;
        }else
        {
            for(UIView *view in cell.contentView.subviews)
            {
                [view removeFromSuperview];
            }
        }
        UILabel *labLeft = [[UILabel alloc]init];
        labLeft.backgroundColor = [UIColor clearColor];
        labLeft.textAlignment = NSTextAlignmentLeft;
        labLeft.font = [UIFont systemFontOfSize:14];
        [labLeft setFrame:CGRectMake(10, 0, 100, 55)];
        labLeft.textColor = BB_Gray_Color;
        labLeft.text = @"当前钱包余额:";
        [cell.contentView addSubview:labLeft];
        
        UILabel *labName = [[UILabel alloc]init];
        labName.backgroundColor = [UIColor clearColor];
        labName.textAlignment = NSTextAlignmentLeft;
        labName.font = [UIFont systemFontOfSize:18];
        [labName setFrame:CGRectMake(110, 0, 200, 55)];
        labName.textColor = BB_Blake_Color;
        if (![HemaFunction xfunc_check_strEmpty:[dataSource objectForKey:@"feeaccount"]])
        {
            labName.text = [NSString stringWithFormat:@"￥%@",[dataSource objectForKey:@"feeaccount"]];
        }
        [cell.contentView addSubview:labName];
        
        return cell;
    }
    if (1 == indexPath.section)
    {
        if (0 == indexPath.row)
        {
            static NSString *CellIdentifier = @"10";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if(cell == nil)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.backgroundColor = BB_White_Color;
                
                textfill = [[UITextField alloc]init];
                textfill.textColor = [UIColor grayColor];
                textfill.font = [UIFont systemFontOfSize:16.0];
                textfill.placeholder = @"输入提现金额";
                textfill.delegate = self;
                textfill.frame = CGRectMake(10, 10, UI_View_Width-20, 35);
                textfill.textAlignment = NSTextAlignmentLeft;
                textfill.clearButtonMode = UITextFieldViewModeNever;
                textfill.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
                textfill.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
                textfill.returnKeyType = UIReturnKeyDone;
                [cell.contentView addSubview:textfill];
            }
            return cell;
        }
        
        static NSString *CellIdentifier = @"11";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = BB_White_Color;
        }else
        {
            for(UIView *view in cell.contentView.subviews)
            {
                [view removeFromSuperview];
            }
        }
        
        UILabel *labLeft = [[UILabel alloc]init];
        labLeft.backgroundColor = [UIColor clearColor];
        labLeft.textAlignment = NSTextAlignmentLeft;
        labLeft.font = [UIFont systemFontOfSize:15];
        [labLeft setFrame:CGRectMake(10, 0, 290, 40)];
        labLeft.textColor = BB_Blue_Color;
        labLeft.text = @"(注：提现金额需为100的整数倍)";
        [cell.contentView addSubview:labLeft];
        
        return cell;
    }
    static NSString *CellIdentifier = @"all";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = BB_White_Color;
        
        textpassword = [[UITextField alloc]init];
        textpassword.textColor = [UIColor grayColor];
        textpassword.secureTextEntry = YES;
        textpassword.delegate = self;
        textpassword.placeholder = @"输入提现密码";
        textpassword.font = [UIFont systemFontOfSize:16];
        textpassword.frame = CGRectMake(10, 10, UI_View_Width-20, 35);
        textpassword.textAlignment = NSTextAlignmentLeft;
        textpassword.clearButtonMode = UITextFieldViewModeNever;
        textpassword.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        textpassword.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        textpassword.returnKeyType = UIReturnKeyDone;
        [cell.contentView addSubview:textpassword];
    }
    
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = [[UIView alloc]init];
    headView.backgroundColor = [UIColor clearColor];
    return headView;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView = [[UIView alloc]init];
    footerView.backgroundColor = [UIColor clearColor];
    
    if (2 == section)
    {
        UIImageView *temImgView = [[UIImageView alloc]init];
        [temImgView setFrame:CGRectMake(20, 12, 14, 14)];
        [temImgView setImage:[UIImage imageNamed:@"R警告.png"]];
        [footerView addSubview:temImgView];
        
        UILabel *labLeft = [[UILabel alloc]init];
        labLeft.backgroundColor = [UIColor clearColor];
        labLeft.textAlignment = NSTextAlignmentLeft;
        labLeft.font = [UIFont systemFontOfSize:12];
        labLeft.text = @"钱包使用说明";
        labLeft.textColor = BB_Gray_Color;
        [labLeft setFrame:CGRectMake(39, 11, 200, 14)];
        [footerView addSubview:labLeft];
        
        UIButton *qianBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [qianBtn setFrame:CGRectMake(10, 10, 150, 30)];
        [qianBtn addTarget:self action:@selector(qianPressed:) forControlEvents:UIControlEventTouchDown];
        [footerView addSubview:qianBtn];
        
        //按钮
        UIButton *loginButton=[UIButton buttonWithType:UIButtonTypeCustom];
        [loginButton setBackgroundColor:BB_Blue_Color];
        [loginButton setTitle:@"提交申请" forState:UIControlStateNormal];
        [loginButton setTitleColor:BB_White_Color forState:UIControlStateNormal];
        [loginButton.titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
        [loginButton setFrame:CGRectMake(20, 45, UI_View_Width-40, 40)];
        [HemaFunction addbordertoView:loginButton radius:5.0f width:0.0f color:[UIColor clearColor]];
        [loginButton addTarget:self action:@selector(okPressed:) forControlEvents:UIControlEventTouchDown];
        [footerView addSubview:loginButton];
    }
    
    return footerView;
}
#pragma mark- TableView Delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.section)
    {
        if (0 == indexPath.row)
        {
            if (keytype == 2)
            {
                if ([HemaFunction xfunc_check_strEmpty:[dataSource objectForKey:@"alipay"]])
                {
                    return 55;
                }
                return 95;
            }
            if ([HemaFunction xfunc_check_strEmpty:[dataSource objectForKey:@"bankname"]])
            {
                return 55;
            }
            return 110;
        }
        return 55;
    }
    if (1 == indexPath.section)
    {
        if (0 == indexPath.row)
        {
            return 55;
        }
        return 40;
    }
    return 55;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (2 == section)
    {
        return 100;
    }
    return 4;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *) indexPath
{
    if (0 == indexPath.section)
    {
        if (0 == indexPath.row)
        {
            if (keytype == 1)
            {
                REditCardVC *myVC = [[REditCardVC alloc]init];
                myVC.dataSource = dataSource;
                [self.navigationController pushViewController:myVC animated:YES];
            }
            if (keytype == 2)
            {
                HemaEditorVC *editor = [[HemaEditorVC alloc]init];
                editor.editorType = EditorTypeSinleInput;
                editor.key = @"alipay";
                editor.title = @"编辑支付宝账号";
                editor.mymaxlength = 30;
                editor.content = [dataSource objectForKey:@"alipay"];
                editor.keyBoardType = UIKeyboardTypeEmailAddress;
                editor.delegate = self;
                [self.navigationController pushViewController:editor animated:YES];
            }
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
            if (!dataSource)
                dataSource = [[NSMutableDictionary alloc]init];
            dataSource = [SystemFunction getDicFromDic:[[info objectForKey:@"infor"] objectAtIndex:0]];
            
            HemaManager *myManager = [HemaManager sharedManager];
            myManager.myInfor = dataSource;
            [self.mytable reloadData];
        }
    }else
    {
        [HemaFunction openIntervalHUD:[info objectForKey:@"msg"]];
    }
}
#pragma mark 提现申请
- (void)requestCashAdd
{
    NSString *token = [[HemaManager sharedManager] userToken];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:token forKey:@"token"];
    [dic setObject:[NSString stringWithFormat:@"%d",(int)keytype] forKey:@"keytype"];
    [dic setObject:self.textfill.text forKey:@"applyfee"];
    [dic setObject:self.textpassword.text forKey:@"password"];
    
    waitMB = [HemaFunction openHUD:@"正在提交申请"];
    
    [HemaRequest requestWithURL:[NSString stringWithFormat:@"%@%@",REQUEST_MAINLINK,REQUEST_CASH_ADD] target:self selector:@selector(responseCashAdd:) parameter:dic];
}
- (void)responseCashAdd:(NSDictionary*)info
{
    [HemaFunction closeHUD:waitMB];
    if(1 == [[info objectForKey:@"success"] intValue])
    {
        [HemaFunction openIntervalHUDOK:@"已申请，敬请等待！"];
        [self.navigationController popViewControllerAnimated:YES];
    }else
    {
        [HemaFunction openIntervalHUD:[info objectForKey:@"msg"]];
    }
}
#pragma mark 支付宝账号保存
- (void)requestAlipayAdd:(NSString*)alipay
{
    NSString *token = [[HemaManager sharedManager] userToken];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:token forKey:@"token"];
    [dic setObject:alipay forKey:@"alipay"];
    
    [HemaRequest requestWithURL:[NSString stringWithFormat:@"%@%@",REQUEST_MAINLINK,REQUEST_ALIPAY_SAVE] target:self selector:@selector(responseAlipayAdd:) parameter:dic];
}
- (void)responseAlipayAdd:(NSDictionary*)info
{
    if(1 == [[info objectForKey:@"success"] intValue])
    {
        
    }else
    {
        [HemaFunction openIntervalHUD:[info objectForKey:@"msg"]];
    }
}
@end
