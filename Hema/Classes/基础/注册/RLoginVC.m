//
//  RLoginVC.m
//  Hema
//
//  Created by LarryRodic on 15/10/7.
//  Copyright (c) 2015年 Hemaapp. All rights reserved.
//

#import "RLoginVC.h"
#import <ShareSDK/ShareSDK.h>

#import "RRegisterVC.h"

@interface RLoginVC ()<UITextFieldDelegate>
@property(nonatomic,strong)UITextField *textfill;
@property(nonatomic,strong)UITextField *textpassword;
@end

@implementation RLoginVC
@synthesize textfill;
@synthesize textpassword;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadSet];
}
-(void)loadSet
{
    [self.navigationItem setNewTitle:@"登录"];
    [self.navigationItem setRightItemWithTarget:self action:@selector(rightbtnPressed:) title:@"注册"];
    
    //-----输入框view
    UIView *backView = [[UIView alloc]init];
    backView.frame = CGRectMake(-1, 0, UI_View_Width+2,55);
    [backView setBackgroundColor:BB_White_Color];
    [HemaFunction addbordertoView:backView radius:0.0f width:1.0f color:BB_Border_Color];
    backView.clipsToBounds = YES;
    [self.view addSubview:backView];
    
    //账号俩字
    UILabel *labName = [[UILabel alloc]init];
    [labName setFont:[UIFont systemFontOfSize:15]];
    [labName setBackgroundColor:[UIColor clearColor]];
    [labName setTextAlignment:NSTextAlignmentCenter];
    [labName setText:@"账号："];
    [labName setFrame:CGRectMake(20, 1 ,45, 54)];
    [backView addSubview:labName];
    
    //输入邮箱TextField
    textfill = [[UITextField alloc]init];
    textfill.textColor = [UIColor grayColor];
    textfill.font = [UIFont systemFontOfSize:15.0];
    textfill.placeholder = @"请输入手机号";
    textfill.delegate = self;
    textfill.frame = CGRectMake(70, 18, UI_View_Width-140, 20);
    textfill.textAlignment = NSTextAlignmentLeft;
    textfill.clearButtonMode = UITextFieldViewModeWhileEditing;
    textfill.keyboardType = UIKeyboardTypeNumberPad;
    textfill.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textfill.returnKeyType = UIReturnKeyDone;
    [backView addSubview:textfill];
    
    //-----输入框view
    UIView *backView1 = [[UIView alloc]init];
    backView1.frame = CGRectMake(-1, 60, UI_View_Width+2,54);
    [backView1 setBackgroundColor:BB_White_Color];
    [HemaFunction addbordertoView:backView1 radius:0.0f width:1.0f color:BB_Border_Color];
    backView1.clipsToBounds = YES;
    [self.view addSubview:backView1];
    
    //密码俩字
    UILabel *labPass = [[UILabel alloc]init];
    [labPass setFont:[UIFont systemFontOfSize:15]];
    [labPass setBackgroundColor:[UIColor clearColor]];
    [labPass setTextAlignment:NSTextAlignmentCenter];
    [labPass setText:@"密码："];
    [labPass setFrame:CGRectMake(20, 1 ,45, 54)];
    [backView1 addSubview:labPass];
    
    //输入密码TextField
    textpassword = [[UITextField alloc]init];
    textpassword.textColor = [UIColor grayColor];
    textpassword.secureTextEntry = YES;
    textpassword.delegate = self;
    textpassword.placeholder = @"请输入6位以上的密码";
    textpassword.font = [UIFont systemFontOfSize:15];
    textpassword.frame = CGRectMake(70, 18, UI_View_Width-140, 20);
    textpassword.textAlignment = NSTextAlignmentLeft;
    textpassword.clearButtonMode = UITextFieldViewModeWhileEditing;
    textpassword.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    textpassword.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textpassword.returnKeyType = UIReturnKeyDone;
    [backView1 addSubview:textpassword];
    
    //登录按钮
    UIButton *loginButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [loginButton setBackgroundColor:BB_Red_Color];
    [loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [loginButton setTitleColor:BB_White_Color forState:UIControlStateNormal];
    [loginButton.titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
    [loginButton setFrame:CGRectMake(43, 162, UI_View_Width-86, 40)];
    [HemaFunction addbordertoView:loginButton radius:5.0f width:0.0f color:[UIColor clearColor]];
    [loginButton addTarget:self action:@selector(loginPressed:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:loginButton];
    
    //忘记密码
    UIButton *lostButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [lostButton setBackgroundColor:[UIColor clearColor]];
    [lostButton setFrame:CGRectMake(100, 200, UI_View_Width-143, 32)];
    [lostButton addTarget:self action:@selector(lostPressed:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:lostButton];
    
    UILabel *labLost = [[UILabel alloc]init];
    [labLost setFont:[UIFont boldSystemFontOfSize:14]];
    [labLost setBackgroundColor:[UIColor clearColor]];
    [labLost setTextAlignment:NSTextAlignmentRight];
    [labLost setTextColor:BB_Red_Color];
    [labLost setText:@"忘记密码?"];
    [labLost setFrame:CGRectMake(0, 0 ,UI_View_Width-143, 32)];
    [lostButton addSubview:labLost];
    
    CGSize temSize = [HemaFunction getSizeWithStr:labLost.text width:UI_View_Width-143 font:14];
    
    UIView *line = [[UIView alloc]init];
    [line setFrame:CGRectMake(UI_View_Width-143-temSize.width, 23, temSize.width, 1)];
    [line setBackgroundColor:BB_Red_Color];
    [lostButton addSubview:line];
    
    //第三方登录 自己看着比例调吧
    UILabel *labInfo = [[UILabel alloc]init];
    [labInfo setFont:[UIFont boldSystemFontOfSize:14]];
    [labInfo setBackgroundColor:[UIColor clearColor]];
    [labInfo setTextAlignment:NSTextAlignmentLeft];
    [labInfo setTextColor:BB_Blake_Color];
    [labInfo setText:@"或使用第三方账号登录，无须注册"];
    [labInfo setFrame:CGRectMake((UI_View_Width-290)/2, 285 ,274, 16)];
    [self.view addSubview:labInfo];
    
    UIView *downView = [[UIView alloc]init];
    [downView setFrame:CGRectMake((UI_View_Width-290)/2, 310, 290, 60)];
    [downView setBackgroundColor:BB_White_Color];
    [HemaFunction addbordertoView:downView radius:0.0f width:0.5f color:BB_lineColor];
    [self.view addSubview:downView];
    
    UIButton *wechatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [wechatBtn setFrame:CGRectMake(30, 14, 41, 33.5)];
    [wechatBtn setBackgroundImage:[UIImage imageNamed:@"R微信.png"] forState:UIControlStateNormal];
    [wechatBtn addTarget:self action:@selector(wechatLogin:) forControlEvents:UIControlEventTouchUpInside];
    [downView addSubview:wechatBtn];
    
    UIButton *qqBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [qqBtn setFrame:CGRectMake(130, 11, 35, 38.5)];
    [qqBtn setBackgroundImage:[UIImage imageNamed:@"RQQ.png"] forState:UIControlStateNormal];
    [qqBtn addTarget:self action:@selector(qqLogin:) forControlEvents:UIControlEventTouchUpInside];
    [downView addSubview:qqBtn];
    
    UIButton *sinaBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [sinaBtn setFrame:CGRectMake(210, 3, 54, 54)];
    [sinaBtn setBackgroundImage:[UIImage imageNamed:@"R微博.png"] forState:UIControlStateNormal];
    [sinaBtn addTarget:self action:@selector(sinaLogin:) forControlEvents:UIControlEventTouchUpInside];
    [downView addSubview:sinaBtn];
}
#pragma mark- 自定义
#pragma mark 事件
//注册
-(void)rightbtnPressed:(id)sender
{
    RRegisterVC *myVC = [[RRegisterVC alloc]init];
    myVC.keytype = 1;
    [self.navigationController pushViewController:myVC animated:YES];
}
//微信登录
-(void)wechatLogin:(id)sender
{
    [ShareSDK getUserInfoWithType:ShareTypeWeixiSession authOptions:nil result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error)
     {
         NSLog(@"wechat:%d",result);
         if (result)
         {
             NSMutableDictionary *temDic = [[NSMutableDictionary alloc]init];
             [temDic setObject:[userInfo uid] forKey:@"uid"];
             [temDic setObject:[userInfo profileImage]?[userInfo profileImage]:@"" forKey:@"avatar"];
             [temDic setObject:[userInfo nickname]?[userInfo nickname]:@"中国买家" forKey:@"nickname"];
             if ([userInfo gender] == 1)
             {
                 [temDic setObject:@"女" forKey:@"sex"];
             }else
             {
                 [temDic setObject:@"男" forKey:@"sex"];
             }
             [temDic setObject:@"20" forKey:@"age"];
             
             [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:BB_XCONST_LOCAL_PLATTYPE];
             
             [self requestPlatformLogin:temDic plattype:@"1"];
         }else
         {
             [HemaFunction openIntervalHUD:@"登录失败"];
         }
     }];
}
//QQ登录
-(void)qqLogin:(id)sender
{
    [ShareSDK getUserInfoWithType:ShareTypeQQSpace authOptions:nil result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error)
     {
         NSLog(@"qq:%d",result);
         if (result)
         {
             NSMutableDictionary *temDic = [[NSMutableDictionary alloc]init];
             [temDic setObject:[userInfo uid] forKey:@"uid"];
             [temDic setObject:[userInfo profileImage]?[userInfo profileImage]:@"" forKey:@"avatar"];
             [temDic setObject:[userInfo nickname]?[userInfo nickname]:@"中国买家" forKey:@"nickname"];
             if ([userInfo gender] == 1)
             {
                 [temDic setObject:@"女" forKey:@"sex"];
             }else
             {
                 [temDic setObject:@"男" forKey:@"sex"];
             }
             [temDic setObject:@"20" forKey:@"age"];
             
             [[NSUserDefaults standardUserDefaults] setValue:@"2" forKey:BB_XCONST_LOCAL_PLATTYPE];
             
             [self requestPlatformLogin:temDic plattype:@"2"];
         }else
         {
             [HemaFunction openIntervalHUD:@"登录失败"];
         }
     }];
}
//微博登录
-(void)sinaLogin:(id)sender
{
    [ShareSDK getUserInfoWithType:ShareTypeSinaWeibo authOptions:nil result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error)
     {
         NSLog(@"wb:%d",result);
         if (result)
         {
             NSMutableDictionary *temDic = [[NSMutableDictionary alloc]init];
             [temDic setObject:[userInfo uid] forKey:@"uid"];
             [temDic setObject:[userInfo profileImage]?[userInfo profileImage]:@"" forKey:@"avatar"];
             [temDic setObject:[userInfo nickname]?[userInfo nickname]:@"中国买家" forKey:@"nickname"];
             if ([userInfo gender] == 1)
             {
                 [temDic setObject:@"女" forKey:@"sex"];
             }else
             {
                 [temDic setObject:@"男" forKey:@"sex"];
             }
             [temDic setObject:@"20" forKey:@"age"];
             
             [[NSUserDefaults standardUserDefaults] setValue:@"3" forKey:BB_XCONST_LOCAL_PLATTYPE];
             
             [self requestPlatformLogin:temDic plattype:@"3"];
         }else
         {
             [HemaFunction openIntervalHUD:@"登录失败"];
         }
     }];
}
//登录按钮点击
-(void)loginPressed:(id)sender
{
    if (textfill.text.length==0||textpassword.text.length==0)
    {
        [HemaFunction openIntervalHUD:@"文本框不能为空"];
        return;
    }else if (![HemaFunction xfunc_isMobileNumber:textfill.text])
    {
        [HemaFunction openIntervalHUD:@"手机号格式不正确"];
        return;
    }else
    {
        if(textpassword.text.length < 6)
        {
            [HemaFunction openIntervalHUD:@"密码不能低于六位"];
            return;
        }else if(textpassword.text.length >12)
        {
            [HemaFunction openIntervalHUD:@"密码不能高于十二位"];
            return;
        }else
        {
            [self requestLogin];
        }
    }
}
//忘记密码按钮点击
-(void)lostPressed:(id)sender
{
    RRegisterVC *myVC = [[RRegisterVC alloc]init];
    myVC.keytype = 2;
    [self.navigationController pushViewController:myVC animated:YES];
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
#pragma mark - 连接服务器
#pragma mark 登录
- (void)requestLogin
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *currentVersion = [infoDictionary objectForKey:@"CFBundleVersion"];//客户端软件当前版本
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:textfill.text forKey:@"username"];
    [dic setObject:textpassword.text forKey:@"password"];
    [dic setObject:[HemaFunction xfuncGetAppdelegate].mydeviceid?[HemaFunction xfuncGetAppdelegate].mydeviceid:@"无"  forKey:@"deviceid"];
    [dic setObject:@"1" forKey:@"devicetype"];
    [dic setObject:currentVersion forKey:@"lastloginversion"];
    
    waitMB = [HemaFunction openHUD:@"正在登录"];
    [HemaRequest requestWithURL:[NSString stringWithFormat:@"%@%@",REQUEST_MAINLINK,REQUEST_CLIENT_LOGIN] target:self selector:@selector(responseLogin:) parameter:dic];
}
- (void)responseLogin:(NSDictionary*)info
{
    [HemaFunction closeHUD:waitMB];
    if(1 == [[info objectForKey:@"success"] intValue])
    {
        NSArray *temArray = [info objectForKey:@"infor"];
        NSDictionary *dic = [temArray objectAtIndex:0];
        NSMutableDictionary *temDic = [[NSMutableDictionary alloc] init];
        for(NSString * key in dic.allKeys)
        {
            if(![HemaFunction xfunc_check_strEmpty:[dic objectForKey:key]])
            {
                NSString*value = [dic objectForKey:key];
                [temDic setValue:value forKey:key];
            }
        }
        HemaManager *myManager = [HemaManager sharedManager];
        myManager.myInfor = temDic;
        myManager.userToken = [dic objectForKey:@"token"];
        
        [HemaFunction xfuncGetAppdelegate].isLogin = YES;
        [[NSUserDefaults standardUserDefaults] setValue:@"yes" forKey:BB_XCONST_ISAUTO_LOGIN];
        [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:BB_XCONST_LOCAL_PLATTYPE];
        
        [[NSUserDefaults standardUserDefaults] setValue:textfill.text forKey:BB_XCONST_LOCAL_LOGINNAME];
        [[NSUserDefaults standardUserDefaults] setValue:textpassword.text forKey:BB_XCONST_LOCAL_PASSWORD];
        
        [[HemaFunction xfuncGetAppdelegate] gotoRoot];
    }else
    {
        [HemaFunction openIntervalHUD:[info objectForKey:@"msg"]];
    }
}
#pragma mark 第三方登录
- (void)requestPlatformLogin:(NSMutableDictionary*)temDic plattype:(NSString*)plattype
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *currentVersion = [infoDictionary objectForKey:@"CFBundleVersion"];//客户端软件当前版本
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:plattype forKey:@"plattype"];
    [dic setObject:[temDic objectForKey:@"uid"] forKey:@"uid"];
    [dic setObject:@"1" forKey:@"devicetype"];
    [dic setObject:currentVersion forKey:@"lastloginversion"];
    
    [dic setObject:[temDic objectForKey:@"avatar"]?[temDic objectForKey:@"avatar"]:@"无" forKey:@"avatar"];
    [dic setObject:[temDic objectForKey:@"nickname"]?[temDic objectForKey:@"nickname"]:@"无" forKey:@"nickname"];
    [dic setObject:[temDic objectForKey:@"sex"]?[temDic objectForKey:@"sex"]:@"无" forKey:@"sex"];
    [dic setObject:[temDic objectForKey:@"age"]?[temDic objectForKey:@"age"]:@"无" forKey:@"age"];
    
    [[NSUserDefaults standardUserDefaults] setValue:[temDic objectForKey:@"uid"] forKey:BB_XCONST_LOCAL_UID];
    
    waitMB = [HemaFunction openHUD:@"正在登录"];
    [HemaRequest requestWithURL:[NSString stringWithFormat:@"%@%@",REQUEST_MAINLINK,REQUEST_PLATFORM_SAVE] target:self selector:@selector(responsePlatformLogin:) parameter:dic];
}
- (void)responsePlatformLogin:(NSDictionary*)info
{
    [HemaFunction closeHUD:waitMB];
    if(1 == [[info objectForKey:@"success"] intValue])
    {
        NSArray *temArray = [info objectForKey:@"infor"];
        NSDictionary *dic = [temArray objectAtIndex:0];
        NSMutableDictionary *temDic = [[NSMutableDictionary alloc] init];
        for(NSString * key in dic.allKeys)
        {
            if(![HemaFunction xfunc_check_strEmpty:[dic objectForKey:key]])
            {
                NSString*value = [dic objectForKey:key];
                [temDic setValue:value forKey:key];
            }
        }
        HemaManager *myManager = [HemaManager sharedManager];
        myManager.myInfor = temDic;
        myManager.userToken = [dic objectForKey:@"token"];
        
        [HemaFunction xfuncGetAppdelegate].isLogin = YES;
        [[NSUserDefaults standardUserDefaults] setValue:@"yes" forKey:BB_XCONST_ISAUTO_LOGIN];
        
        [[HemaFunction xfuncGetAppdelegate] gotoRoot];
    }else
    {
        [HemaFunction openIntervalHUD:[info objectForKey:@"msg"]];
    }
}
@end
