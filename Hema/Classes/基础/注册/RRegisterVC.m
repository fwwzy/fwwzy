//
//  RRegisterVC.m
//  Hema
//
//  Created by LarryRodic on 15/10/7.
//  Copyright (c) 2015年 Hemaapp. All rights reserved.
//

#import "RRegisterVC.h"
#import "HemaWebVC.h"
#import "RResetPasswordVC.h"

@interface RRegisterVC ()<UITextFieldDelegate>
{
    BOOL isSelect;//是否选择说明
    BOOL isClicked;//重新发送按钮是否点击
}
@property(nonatomic,strong)UITextField *textfill;//输入手机号
@property(nonatomic,strong)UITextField *textpassword;//输入验证码

@property(nonatomic,strong)UIButton *btnClick;//重新发送按钮
@property(nonatomic,strong)UILabel *lblTimer;//60秒倒计时
@property(nonatomic,strong)UILabel *lblSeconds;//一个字“秒”
@property(nonatomic,strong)UILabel *lblSend;//发送的提示
@property(nonatomic,strong)UIButton *selectBtn;//选择框（是否同意条款）击
@end

@implementation RRegisterVC
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
    
    //输入账号
    textfill = [[UITextField alloc]init];
    textfill.textColor = [UIColor grayColor];
    textfill.font = [UIFont systemFontOfSize:15.0];
    textfill.placeholder = @"请输入手机号";
    textfill.delegate = self;
    textfill.frame = CGRectMake(20, 18, UI_View_Width-40, 20);
    textfill.textAlignment = NSTextAlignmentLeft;
    textfill.keyboardType = UIKeyboardTypeNumberPad;
    textfill.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textfill.returnKeyType = UIReturnKeySend;
    [textfill becomeFirstResponder];
    [backView addSubview:textfill];
    
    //-----输入框view
    UIView *backView1 = [[UIView alloc]init];
    backView1.frame = CGRectMake(-1, 94, UI_View_Width+2,55);
    [backView1 setBackgroundColor:BB_White_Color];
    [HemaFunction addbordertoView:backView1 radius:0.0f width:1.0f color:BB_Border_Color];
    backView1.clipsToBounds = YES;
    [self.view addSubview:backView1];
    
    //输入验证码
    textpassword = [[UITextField alloc ]init];
    textpassword.frame = CGRectMake(20, 18, UI_View_Width-165, 20);
    textpassword.font = [UIFont systemFontOfSize:15];
    textpassword.placeholder = @"请输入验证码";
    textpassword.delegate = self;
    textpassword.keyboardType = UIKeyboardTypeNumberPad;
    textpassword.textAlignment = NSTextAlignmentLeft;
    textpassword.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textpassword.backgroundColor = [UIColor clearColor];
    textpassword.textColor = [UIColor grayColor];
    textpassword.clearButtonMode = UITextFieldViewModeNever;
    [backView1 addSubview:textpassword];
    
    //中间分割线
    UIImageView *line = [[UIImageView alloc]init];
    [line setFrame:CGRectMake(UI_View_Width-135, 0, 1, 55)];
    [line setBackgroundColor:BB_lineColor];
    [backView1 addSubview:line];
    
    //重新发送按钮
    _btnClick=[[UIButton alloc]init];
    _btnClick.frame = CGRectMake(UI_View_Width-118, 0, 100, 55);
    [_btnClick setTitle:@"发送验证码" forState:UIControlStateNormal];
    [_btnClick setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _btnClick.titleLabel.font = [UIFont systemFontOfSize: 15.0];
    [_btnClick addTarget:self action:@selector(reverseNumber:) forControlEvents:UIControlEventTouchUpInside];
    [backView1 addSubview:_btnClick];
    
    //添加红色时间标签
    _lblTimer = [[UILabel alloc]init];
    _lblTimer.frame = CGRectMake(UI_View_Width-60, 0, 22, 54);
    _lblTimer.textAlignment = NSTextAlignmentRight;
    _lblTimer.textColor = BB_Red_Color;
    _lblTimer.font = [UIFont systemFontOfSize:15];
    _lblTimer.backgroundColor = [UIColor clearColor];
    _lblTimer.text = @"60";
    [_lblTimer setHidden:YES];
    [backView1 addSubview:_lblTimer];
    
    //秒字体标签
    _lblSeconds = [[UILabel alloc]init];
    _lblSeconds.frame = CGRectMake(UI_View_Width-36, 0, 15, 54);
    _lblSeconds.textAlignment = NSTextAlignmentLeft;
    _lblSeconds.text = @"秒";
    _lblSeconds.font = [UIFont systemFontOfSize:15];
    _lblSeconds.textColor = [UIColor grayColor];
    _lblSeconds.backgroundColor = [UIColor clearColor];
    [_lblSeconds setHidden:YES];
    [backView1 addSubview:_lblSeconds];
    
    //添加第一个标签
    _lblSend = [[UILabel alloc]init];
    _lblSend.font = [UIFont systemFontOfSize:13];
    _lblSend.backgroundColor = [UIColor clearColor];
    _lblSend.frame = CGRectMake(20, 65, 270, 20);
    [_lblSend setHidden:YES];
    [self.view addSubview:_lblSend];
    
    //确定按钮
    UIButton *loginButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [loginButton setBackgroundColor:BB_Red_Color];
    [loginButton setTitle:@"下一步" forState:UIControlStateNormal];
    [loginButton setTitleColor:BB_White_Color forState:UIControlStateNormal];
    [loginButton.titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
    [loginButton setFrame:CGRectMake(43, 188, UI_View_Width-86, 40)];
    [HemaFunction addbordertoView:loginButton radius:5.0f width:0.0f color:[UIColor clearColor]];
    [loginButton addTarget:self action:@selector(nextPressed:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:loginButton];
    
    if (keytype == 1)
    {
        [self.navigationItem setNewTitle:@"注册"];
        
        isSelect = YES;
        
        //选择框
        _selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_selectBtn setFrame:CGRectMake(43, 235, 15, 15)];
        [_selectBtn setBackgroundImage:[UIImage imageNamed:@"R单选框已选中.png"] forState:UIControlStateNormal];
        [_selectBtn addTarget:self action:@selector(selectPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_selectBtn];
        
        //用户协议
        UILabel *temLabel = [[UILabel alloc]init];
        [temLabel setFont:[UIFont boldSystemFontOfSize:14]];
        [temLabel setBackgroundColor:[UIColor clearColor]];
        [temLabel setTextAlignment:NSTextAlignmentLeft];
        [temLabel setTextColor:BB_Gray_Color];
        [temLabel setText:@"我同意"];
        CGSize temSize = [HemaFunction getSizeWithStr:temLabel.text width:200 font:14];
        [temLabel setFrame:CGRectMake(63, 233, temSize.width, 16)];
        [self.view addSubview:temLabel];
        
        UIButton *lostButton=[UIButton buttonWithType:UIButtonTypeCustom];
        [lostButton setBackgroundColor:[UIColor clearColor]];
        [lostButton setFrame:CGRectMake(63+temSize.width, 233, 100, 16)];
        [lostButton addTarget:self action:@selector(xyPressed:) forControlEvents:UIControlEventTouchDown];
        [self.view addSubview:lostButton];
        
        UILabel *labLost = [[UILabel alloc]init];
        [labLost setFont:[UIFont boldSystemFontOfSize:14]];
        [labLost setBackgroundColor:[UIColor clearColor]];
        [labLost setTextAlignment:NSTextAlignmentLeft];
        [labLost setTextColor:BB_Red_Color];
        [labLost setText:@"注册声明"];
        [labLost setFrame:CGRectMake(0, 0 ,100, 16)];
        [lostButton addSubview:labLost];
    }else
    {
        UILabel *labLost = [[UILabel alloc]init];
        [labLost setFont:[UIFont boldSystemFontOfSize:15]];
        [labLost setBackgroundColor:[UIColor clearColor]];
        [labLost setTextAlignment:NSTextAlignmentCenter];
        [labLost setTextColor:BB_Red_Color];
        [labLost setText:[NSString stringWithFormat:@"客服电话：%@",[[[HemaManager sharedManager] myInitInfor] objectForKey:@"sys_service_phone"]]];
        [labLost setFrame:CGRectMake(0, UI_View_Height-100 ,UI_View_Width, 100)];
        [self.view addSubview:labLost];
    }
    
    isClicked = YES;
    
    if (keytype == 2)
    {
        [self.navigationItem setNewTitle:@"找回登录密码"];
    }
}
#pragma mark- 自定义
#pragma mark 事件
//下一步
-(void)nextPressed:(id)sender
{
    if (textfill.text.length == 0||textpassword.text.length == 0)
    {
        [HemaFunction openIntervalHUD:@"文本框不能为空"];
        return;
    }
    if (![HemaFunction xfunc_isMobileNumber:textfill.text])
    {
        [HemaFunction openIntervalHUD:@"手机号格式不正确"];
        return;
    }
    if (keytype == 1)
    {
        if (!isSelect)
        {
            [HemaFunction openIntervalHUD:@"请同意软件声明"];
            return;
        }
    }
    [self requestVerifyCode];
}
//选择框按钮点击
-(void)selectPressed:(id)sender
{
    if (isSelect)
    {
        isSelect = NO;
        [_selectBtn setBackgroundImage:[UIImage imageNamed:@"R单选框未选中.png"] forState:UIControlStateNormal];
        return;
    }else
    {
        isSelect = YES;
        [_selectBtn setBackgroundImage:[UIImage imageNamed:@"R单选框已选中.png"] forState:UIControlStateNormal];
        return;
    }
}
//用户协议
-(void)xyPressed:(id)sender
{
    HemaWebVC *web = [[HemaWebVC alloc]init];
    web.urlPath = [NSString stringWithFormat:@"%@webview/parm/protocal",[[[HemaManager sharedManager] myInitInfor] objectForKey:@"sys_web_service"]];
    web.objectTitle = @"用户协议";
    web.isAdgust = NO;
    [self.navigationController pushViewController:web animated:YES];
}
//定时器
-(void)timerSet:(NSTimer*)sender
{
    int listSecond = [_lblTimer.text intValue];
    if(1 == listSecond)
    {
        [sender invalidate];
        [_btnClick setTitle:@"重新发送" forState:UIControlStateNormal];
        [self.btnClick setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.btnClick.enabled = YES;//开启按钮
        self.lblTimer.text = @"0";
        [_lblTimer setHidden:YES];
        isClicked = YES;
        self.lblSeconds.hidden = YES;
    }
    else
    {
        listSecond --;
        [_btnClick setTitle:@"重新发送" forState:UIControlStateNormal];
        [self.btnClick setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        self.btnClick.enabled = NO;
        isClicked = NO;
        self.lblTimer.text = [NSString stringWithFormat:@"%d",listSecond];
        [_lblTimer setHidden:NO];
        [_lblSeconds setHidden:NO];
    }
}
//点击重新发送按钮，启动计时器
-(void)reverseNumber:(UIButton *)sender
{
    if (isClicked)
    {
        if ([HemaFunction xfunc_isMobileNumber:textfill.text])
        {
            [self requestVerifyUser];
        }else
        {
            [HemaFunction openIntervalHUD:@"手机号格式错误"];
        }
    }
}
#pragma mark 方法
//发送
-(void)sendCode
{
    [_lblSend setText:[NSString stringWithFormat:@"验证码已发送到%@",[HemaFunction getSecreatMobile:textfill.text]]];
    [_btnClick setTitle:@"重新发送" forState:UIControlStateNormal];
    _btnClick.frame = CGRectMake(UI_View_Width-118, 0, 65, 55);
    _lblTimer.text = @"60";
    self.lblSeconds.hidden = NO;
    [self.lblSend setHidden:NO];
    [_lblTimer setHidden:NO];
    [self.btnClick setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerSet:) userInfo:nil repeats:YES];
    isClicked = NO;
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
#pragma mark 验证用户
- (void)requestVerifyUser
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:self.textfill.text forKey:@"username"];
    
    [HemaRequest requestWithURL:[NSString stringWithFormat:@"%@%@",REQUEST_MAINLINK,REQUEST_CLIENT_VERIFY] target:self selector:@selector(responseVerifyUser:) parameter:dic];
}
- (void)responseVerifyUser:(NSDictionary*)info
{
    if(1 == [ [info objectForKey:@"success"] intValue])
    {
        if (keytype == 1)
        {
            [HemaFunction openIntervalHUD:@"用户名已经被注册"];
        }else
        {
            [self sendCode];
            [self requestGetCode];
        }
    }else
    {
        if ([[info objectForKey:@"error_code"]integerValue] == 106)
        {
            if (keytype == 1)
            {
                [self sendCode];
                [self requestGetCode];
            }else
            {
                [HemaFunction openIntervalHUD:@"用户名不存在"];
            }
        }else
        {
            if([info objectForKey:@"msg"])
            {
                [HemaFunction openIntervalHUD:[info objectForKey:@"msg"]];
            }
        }
    }
}
#pragma mark 申请获取验证码
- (void)requestGetCode
{
    waitMB = [HemaFunction openHUD:@"正在获取"];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:self.textfill.text forKey:@"username"];
    
    [HemaRequest requestWithURL:[NSString stringWithFormat:@"%@%@",REQUEST_MAINLINK,REQUEST_CODE_GET] target:self selector:@selector(responseGetCode:) parameter:dic];
}
- (void)responseGetCode:(NSDictionary*)info
{
    [HemaFunction closeHUD:waitMB];
    if(1 == [[info objectForKey:@"success"] intValue])
    {
        [textpassword becomeFirstResponder];
    }
    else
    {
        [HemaFunction openIntervalHUD:[info objectForKey:@"msg"]];
    }
}
#pragma mark 验证验证码
- (void)requestVerifyCode
{
    waitMB = [HemaFunction openHUD:@"正在验证"];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:self.textfill.text forKey:@"username"];
    [dic setObject:self.textpassword.text forKey:@"code"];
    
    [HemaRequest requestWithURL:[NSString stringWithFormat:@"%@%@",REQUEST_MAINLINK,REQUEST_CODE_VERIFY] target:self selector:@selector(responseVerifyCode:) parameter:dic];
}
- (void)responseVerifyCode:(NSDictionary*)info
{
    [HemaFunction closeHUD:waitMB];
    if(1 == [[info objectForKey:@"success"] intValue])
    {
        NSString *temToken = [[[info objectForKey:@"infor"] objectAtIndex:0] objectForKey:@"temp_token"];
        
        //存到fromDic里面
        NSMutableDictionary *temDic = [[HemaManager sharedManager] fromDic];
        if (!temDic)
            temDic = [[NSMutableDictionary alloc]init];
        
        [temDic setObject:temToken forKey:@"token"];
        [temDic setObject:self.textfill.text forKey:@"mobile"];
        
        //处理业务逻辑
        RResetPasswordVC *myVC = [[RResetPasswordVC alloc]init];
        myVC.keytype = self.keytype;
        [self.navigationController pushViewController:myVC animated:YES];
    }
    else
    {
        [HemaFunction openIntervalHUD:[info objectForKey:@"msg"]];
    }
}
@end
