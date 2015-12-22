//
//  RChangPasswordVC.m
//  Hema
//
//  Created by LarryRodic on 15/10/7.
//  Copyright (c) 2015年 Hemaapp. All rights reserved.
//

#import "RChangPasswordVC.h"
#import "HemaTextField.h"
#import "IQKeyboardManager.h"

@interface RChangPasswordVC ()<UITextFieldDelegate>
@property(nonatomic,strong)NSMutableArray *listArr;
@end

@implementation RChangPasswordVC
@synthesize keytype;

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [[IQKeyboardManager sharedManager] setEnable:NO];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
    [super viewWillDisappear:animated];
}
-(void)loadSet
{
    if (keytype == 1)
    {
        [self.navigationItem setNewTitle:@"修改登录密码"];
    }
    if (keytype == 2)
    {
        [self.navigationItem setNewTitle:@"修改提现/支付密码"];
    }
    
    //设置边线位移
    [SystemFunction setTableSeparatorInset:self.mytable left:10];
    
    [self.mytable setScrollEnabled:NO];
    [self forbidPullRefresh];
}
-(void)loadData
{
    _listArr =  [[NSMutableArray alloc]initWithObjects:@"输入初始密码",@"输入新密码",@"再次输入新密码", nil];
}
#pragma mark- 自定义
#pragma mark 事件
//确定
-(void)surePressed:(id)sender
{
    UITableViewCell *temCell1 = (UITableViewCell *)[self.mytable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    UITableViewCell *temCell2 = (UITableViewCell *)[self.mytable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    UITableViewCell *temCell3 = (UITableViewCell *)[self.mytable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    HemaTextField *textfield1 = (HemaTextField*)[temCell1 viewWithTag:11];
    HemaTextField *textfield2 = (HemaTextField*)[temCell2 viewWithTag:11];
    HemaTextField *textfield3 = (HemaTextField*)[temCell3 viewWithTag:11];
    
    if (textfield1.text.length == 0)
    {
        [HemaFunction openIntervalHUD:@"初始密码不能为空"];
        return;
    }
    if (textfield1.text.length < 6)
    {
        [HemaFunction openIntervalHUD:@"初始密码格式不正确"];
        return;
    }
    if(textfield1.text.length > 12)
    {
        [HemaFunction openIntervalHUD:@"初始密码不正确"];
        return;
    }
    if (textfield2.text.length< 6||textfield2.text.length > 12)
    {
        [HemaFunction openIntervalHUD:@"新密码6至12位"];
        return;
    }
    if(![textfield2.text isEqualToString:textfield3.text])
    {
        [HemaFunction openIntervalHUD:@"两次新密码输入不一致"];
        return;
    }
    [textfield1 resignFirstResponder];
    [textfield2 resignFirstResponder];
    [textfield3 resignFirstResponder];
    
    [self requestMyResetPassword:textfield1.text mynew:textfield2.text];
}
#pragma mark- UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
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
        cell.backgroundColor = BB_White_Color;
        
        //输入TextField
        HemaTextField *password = [[HemaTextField alloc]init];
        password.textColor = [UIColor grayColor];
        password.font = [UIFont systemFontOfSize:15.0];
        password.secureTextEntry = YES;
        password.delegate = self;
        password.keyboardType = UIKeyboardTypeDefault;
        password.tag = 11;
        password.frame = CGRectMake(10, 11, UI_View_Width-20, 20);
        password.textAlignment = NSTextAlignmentLeft;
        password.clearButtonMode = UITextFieldViewModeWhileEditing;
        password.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        password.returnKeyType = UIReturnKeyDone;
        [cell.contentView addSubview:password];
    }
    HemaTextField *password = (HemaTextField*)[cell viewWithTag:11];
    password.btnRow = indexPath.row;
    password.placeholder = [_listArr objectAtIndex:indexPath.row];
    password.text = @"";
    
    if (0 == indexPath.row)
    {
        [password becomeFirstResponder];
    }
    
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footView = [[UIView alloc]init];
    if (0 == section)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(42, 23, UI_View_Width-86, 44);
        [HemaFunction addbordertoView:btn radius:6.0f width:0.0f color:[UIColor clearColor]];
        [btn setBackgroundColor:BB_Blue_Color];
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [btn setTitle:@"确定" forState:UIControlStateNormal];
        [btn setTitleColor:BB_White_Color forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        [btn addTarget:self action:@selector(surePressed:) forControlEvents:UIControlEventTouchUpInside];
        [footView addSubview:btn];
        
        if (keytype == 2)
        {
            [btn setFrame:CGRectMake(42, 42, 236, 44)];
            
            UILabel *labLeft = [[UILabel alloc]init];
            labLeft.backgroundColor = [UIColor clearColor];
            labLeft.textAlignment = NSTextAlignmentLeft;
            labLeft.font = [UIFont boldSystemFontOfSize:11];
            labLeft.text = @"*初始密码为软件登录密码";
            labLeft.textColor = BB_Gray_Color;
            [labLeft setFrame:CGRectMake(10, 8, 200, 13)];
            [footView addSubview:labLeft];
        }
    }
    return footView;
}
#pragma mark - Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if(0 == section)
    {
        return 100;
    }
    return 0.1f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *temCell = (UITableViewCell*)[self.mytable cellForRowAtIndexPath:indexPath];
    UITextField *passwords = (UITextField*)[temCell viewWithTag:11];
    [passwords becomeFirstResponder];
}
#pragma mark- 连接服务器
#pragma mark 保存新密码
-(void)requestMyResetPassword:(NSString*)myold mynew:(NSString*)mynew
{
    NSString *token = [[HemaManager sharedManager] userToken];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:token forKey:@"token"];
    [dic setObject:[NSString stringWithFormat:@"%d",(int)keytype] forKey:@"keytype"];
    [dic setObject:myold forKey:@"old_password"];
    [dic setObject:mynew forKey:@"new_password"];
    
    waitMB = [HemaFunction openHUD:@"正在保存"];
    
    [HemaRequest requestWithURL:[NSString stringWithFormat:@"%@%@",REQUEST_MAINLINK,REQUEST_PASSWORD_SAVE] target:self selector:@selector(responseMyResetPassword:) parameter:dic];
}
-(void)responseMyResetPassword:(NSDictionary*)info
{
    [HemaFunction closeHUD:waitMB];
    if(1 == [[info objectForKey:@"success"] intValue])
    {
        UITextField *textfield3 = (UITextField*)[self.mytable viewWithTag:12];
        [[NSUserDefaults standardUserDefaults] setValue:textfield3.text forKey:BB_XCONST_LOCAL_PASSWORD];
        
        [HemaFunction openIntervalHUDOK:@"密码修改成功"];
        [self.navigationController popViewControllerAnimated:YES];
    }else
    {
        [HemaFunction openIntervalHUD:[info objectForKey:@"msg"]];
    }
}
@end
