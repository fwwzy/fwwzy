//
//  RResetPasswordVC.m
//  Hema
//
//  Created by LarryRodic on 15/10/7.
//  Copyright (c) 2015年 Hemaapp. All rights reserved.
//

#import "RResetPasswordVC.h"
#import "RInforVC.h"

@interface RResetPasswordVC ()<UITextFieldDelegate>
@property(nonatomic,strong)UITextField *textfill;
@property(nonatomic,strong)UITextField *textpassword;
@end

@implementation RResetPasswordVC
@synthesize keytype;
@synthesize textfill;
@synthesize textpassword;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadSet];
}
-(void)loadSet
{
    //-----输入框view
    UIView *backView = [[UIView alloc]init];
    backView.frame = CGRectMake(-1, 0, UI_View_Width+2,55);
    [backView setBackgroundColor:BB_White_Color];
    [HemaFunction addbordertoView:backView radius:0.0f width:1.0f color:BB_Border_Color];
    backView.clipsToBounds = YES;
    [self.view addSubview:backView];
    
    //新密码
    textfill = [[UITextField alloc]init];
    textfill.textColor = [UIColor grayColor];
    textfill.secureTextEntry = YES;
    textfill.font = [UIFont systemFontOfSize:15.0];
    textfill.placeholder = @"新密码";
    textfill.font = [UIFont systemFontOfSize:15];
    textfill.delegate = self;
    textfill.frame = CGRectMake(20, 18, UI_View_Width-40, 20);
    textfill.textAlignment = NSTextAlignmentLeft;
    textfill.clearButtonMode = UITextFieldViewModeNever;
    textfill.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    textfill.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textfill.returnKeyType = UIReturnKeyDone;
    [textfill becomeFirstResponder];
    [backView addSubview:textfill];
    
    //-----输入框view
    UIView *backView1 = [[UIView alloc]init];
    backView1.frame = CGRectMake(-1, 60, UI_View_Width+2,54);
    [backView1 setBackgroundColor:BB_White_Color];
    [HemaFunction addbordertoView:backView1 radius:0.0f width:1.0f color:BB_Border_Color];
    backView1.clipsToBounds = YES;
    [self.view addSubview:backView1];
    
    //重复新密码
    textpassword = [[UITextField alloc]init];
    textpassword.textColor = [UIColor grayColor];
    textpassword.secureTextEntry = YES;
    textpassword.delegate = self;
    textpassword.placeholder = @"重复新密码";
    textpassword.font = [UIFont systemFontOfSize:15];
    textpassword.frame = CGRectMake(20,18, UI_View_Width-40, 20);
    textpassword.textAlignment = NSTextAlignmentLeft;
    textpassword.clearButtonMode = UITextFieldViewModeNever;
    textpassword.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    textpassword.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textpassword.returnKeyType = UIReturnKeyDone;
    [backView1 addSubview:textpassword];
    
    //登录按钮
    UIButton *loginButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [loginButton setBackgroundColor:BB_Red_Color];
    [loginButton setTitleColor:BB_White_Color forState:UIControlStateNormal];
    [loginButton.titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
    [loginButton setFrame:CGRectMake(43, 188, UI_View_Width-86, 40)];
    [HemaFunction addbordertoView:loginButton radius:5.0f width:0.0f color:[UIColor clearColor]];
    [loginButton addTarget:self action:@selector(okPressed:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:loginButton];
    
    if (keytype == 1)
    {
        [self.navigationItem setNewTitle:@"设置密码"];
        [loginButton setTitle:@"下一步" forState:UIControlStateNormal];
    }
    if (keytype == 2)
    {
        [self.navigationItem setNewTitle:@"重设密码"];
        [loginButton setTitle:@"确定" forState:UIControlStateNormal];
    }
}
#pragma mark- 自定义
#pragma mark 事件
//下一步
-(void)okPressed:(id)sender
{
    if (textfill.text.length == 0)
    {
        [HemaFunction openIntervalHUD:@"密码不能为空"];
        return;
    }
    if (textfill.text.length < 6)
    {
        [HemaFunction openIntervalHUD:@"密码不能低于六位"];
        return;
    }
    if(textfill.text.length >12)
    {
        [HemaFunction openIntervalHUD:@"密码不能高于十二位"];
        return;
    }
    if (![textpassword.text isEqualToString:textfill.text])
    {
        [HemaFunction openIntervalHUD:@"两次密码输入不一致"];
        return;
    }
    //去个人资料页面
    if (keytype == 1)
    {
        [[[HemaManager sharedManager] fromDic] setObject:textfill.text forKey:@"password"];
        
        RInforVC *myVC = [[RInforVC alloc]init];
        myVC.isRegister = YES;
        [self.navigationController pushViewController:myVC animated:YES];
    }
    //调取接口
    if (keytype == 2)
    {
        [self requestResetPassword:@"1"];
    }
}
#pragma mark- UITextFieldDelegate
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [textpassword resignFirstResponder];
    [textfill resignFirstResponder];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
#pragma mark- 连接服务器
#pragma mark 重设密码
- (void)requestResetPassword:(NSString*)type
{
    waitMB = [HemaFunction openHUD:@"正在提交"];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:[[[HemaManager sharedManager]fromDic]objectForKey:@"token"] forKey:@"temp_token"];
    [dic setObject:type forKey:@"keytype"];
    [dic setObject:textfill.text forKey:@"new_password"];
    
    [HemaRequest requestWithURL:[NSString stringWithFormat:@"%@%@",REQUEST_MAINLINK,REQUEST_PASSWORD_RESET] target:self selector:@selector(responseResetPassword:) parameter:dic];
}
- (void)responseResetPassword:(NSDictionary*)info
{
    [HemaFunction closeHUD:waitMB];
    if(1 == [[info objectForKey:@"success"] intValue])
    {
        if (keytype == 2)
        {
            [HemaFunction openIntervalHUD:@"密码重设成功"];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }else
    {
        [HemaFunction openIntervalHUD:[info objectForKey:@"msg"]];
    }
}
@end
