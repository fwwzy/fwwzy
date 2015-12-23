//
//  LoginVC.m
//  Hema
//
//  Created by MsTail on 15/12/23.
//  Copyright © 2015年 Hemaapp. All rights reserved.
//

#import "LoginVC.h"

@interface LoginVC () {
    UITextField *_phoneTF;
    UITextField *_pwdTF;
}
@end

@implementation LoginVC

- (void)loadSet {
    
    self.navigationController.navigationBar.hidden = YES;
    
    //自定义navigation
    HemaImgView *navigationView = [[HemaImgView alloc] init];
    navigationView.frame = CGRectMake(0, 0, UI_View_Width, self.view.height / 3.5);
    navigationView.backgroundColor = BB_Red_Color;
    [self.view addSubview:navigationView];
    
    HemaButton *backBtn = [[HemaButton alloc] init];
    backBtn.frame = CGRectMake(10, 35, 14, 20);
    [backBtn setImage:[UIImage imageNamed:@"lg_back"] forState:UIControlStateNormal];
    [navigationView addSubview:backBtn];
    
    UILabel *loginLbl = [[UILabel alloc] init];
    loginLbl.frame = CGRectMake(UI_View_Width / 2 - 18, 35, 36, 17);
    loginLbl.textColor = BB_White_Color;
    loginLbl.font = [UIFont systemFontOfSize:18];
    loginLbl.text = @"登陆";
    [navigationView addSubview:loginLbl];
    
    HemaButton *registBtn = [[HemaButton alloc] init];
    registBtn.frame = CGRectMake(UI_View_Width - 40, 35, 28, 14);
    [registBtn setBackgroundColor:[UIColor clearColor]];
    registBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [registBtn.titleLabel setTextColor:BB_White_Color] ;
    [registBtn setTitle:@"注册" forState:UIControlStateNormal];
    [registBtn addTarget:self action:@selector(registBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [navigationView addSubview:registBtn];
    
    //HemaImgView *logoView = [[HemaImgView alloc] init];
    
    //手机号输入框
    UIView *phoneView = [[UIView alloc] init];
    phoneView.frame = CGRectMake(30, navigationView.size.height + 15, UI_View_Width - 60, self.view.height / 13);
    phoneView.layer.borderWidth = 1;
    phoneView.layer.borderColor = BB_Blake_Color.CGColor;
    
    HemaImgView *phoneImg = [[HemaImgView alloc] init];
    phoneImg.frame = CGRectMake(10, phoneView.height / 3.5, 18, 22);
    phoneImg.image = [UIImage imageNamed:@"lg_phone"];
    
    UILabel *phoneSep = [[UILabel alloc] init];
    phoneSep.frame = CGRectMake(38, phoneView.height / 3.5, 1, 22);
    phoneSep.backgroundColor = BB_Gray_Color;
    phoneSep.alpha = 0.5;
    
    _phoneTF = [[UITextField alloc] init];
    _phoneTF.frame = CGRectMake(45, phoneView.height / 10 , phoneView.size.width - 42, 40);
    _phoneTF.placeholder = @"请输入手机号";
    _phoneTF.keyboardType = UIKeyboardTypeNumberPad;
    
    [phoneView addSubview:phoneImg];
    [phoneView addSubview:phoneSep];
    [phoneView addSubview:_phoneTF];
    [self.view addSubview:phoneView];
    
    //密码输入
    UIView *pwdView = [[UIView alloc] init];
    pwdView.frame = CGRectMake(30, phoneView.origin.y + phoneView.size.height + 15, UI_View_Width - 60, self.view.height / 13);
    pwdView.layer.borderWidth = 1;
    pwdView.layer.borderColor = BB_Blake_Color.CGColor;
    
    HemaImgView *pwdImg = [[HemaImgView alloc] init];
    pwdImg.frame = CGRectMake(10, phoneView.height / 3.5, 18, 22);
    pwdImg.image = [UIImage imageNamed:@"lg_lock"];
    
    UILabel *pwdSep = [[UILabel alloc] init];
    pwdSep.frame = CGRectMake(38, phoneView.height / 3.5, 1, 22);
    pwdSep.backgroundColor = BB_Gray_Color;
    pwdSep.alpha = 0.5;
    
    _pwdTF = [[UITextField alloc] init];
    _pwdTF.frame = CGRectMake(45, phoneView.height / 10 , phoneView.size.width - 42, 40);
    _pwdTF.placeholder = @"请输入六位数以上的密码";
    
    [pwdView addSubview:pwdImg];
    [pwdView addSubview:pwdSep];
    [pwdView addSubview:_pwdTF];
    [self.view addSubview:pwdView];
    
    //登陆按钮
    HemaButton *loginBtn = [[HemaButton alloc] init];
    loginBtn.frame = CGRectMake(30, pwdView.origin.y + pwdView.size.height + 20, UI_View_Width - 60, 40);
    [loginBtn setBackgroundColor:BB_Red_Color];
    [loginBtn setTitle:@"登陆" forState:UIControlStateNormal];
    [loginBtn setBackgroundImage:[UIImage imageNamed:@"lg_logo"] forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(loginBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
    
    //忘记密码
    HemaButton *forgetBtn = [[HemaButton alloc] init];
    forgetBtn.frame = CGRectMake(loginBtn.origin.x + loginBtn.size.width - 64, loginBtn.origin.y + loginBtn.size.height + 10, 64, 18);
    [forgetBtn setImage:[UIImage imageNamed:@"lg_forget"] forState:UIControlStateNormal];
    [forgetBtn addTarget:self action:@selector(forgetBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:forgetBtn];
    
    //三方登陆
    UIView *thirdLogin = [[UIView alloc] init];
    thirdLogin.frame = CGRectMake(0, forgetBtn.origin.y + forgetBtn.size.height + 10, UI_View_Width, UI_View_Height - forgetBtn.origin.y);
    thirdLogin.backgroundColor = [UIColor clearColor];
    
    UILabel *thirdLbl = [[UILabel alloc] init];
    thirdLbl.frame = CGRectMake(UI_View_Width / 2 - 42, 15, 84, 17);
    thirdLbl.text = @"第三方登陆";
    thirdLbl.font = [UIFont systemFontOfSize:15];
    
    UILabel *sepOne = [[UILabel alloc] init];
    sepOne.frame = CGRectMake(UI_View_Width / 2 - 60, 38, 55, 1.5);
    sepOne.backgroundColor = BB_Gray_Color;
    sepOne.alpha = 0.5;
    
    UILabel *sepTwo = [[UILabel alloc] init];
    sepTwo.frame = CGRectMake(UI_View_Width / 2 + 2, 38, 55, 1.5);
    sepTwo.backgroundColor = BB_Gray_Color;
    sepTwo.alpha = 0.5;
    
    //图标
    
    NSArray *thirdArr = @[@"QQ登陆",@"微信登陆",@"微博登陆"];
    NSArray *thirdImg = @[@"lg_qq",@"lg_wx",@"lg_sina"];
    for (int i = 0; i < 3;  i++) {
        
        HemaButton *thirdLogo = [[HemaButton alloc] init];
        thirdLogo.frame = CGRectMake(self.view.width / 10 + i * self.view.width / 3 , 60, 40, 40);
        [thirdLogo setImage:[UIImage imageNamed:[thirdImg objectAtIndex:i]] forState:UIControlStateNormal];
        [thirdLogo addTarget:self action:@selector(thirdLogoClick:) forControlEvents:UIControlEventTouchUpInside];
        thirdLogo.tag = i;
        [thirdLogin addSubview:thirdLogo];
        
        UILabel *thirdName = [[UILabel alloc] init];
        thirdName.frame = CGRectMake((self.view.width / 10 - 10)+ i * self.view.width / 3 , 105, 60, 20);
        thirdName.text = [thirdArr objectAtIndex:i];
        thirdName.font = [UIFont systemFontOfSize:15];
        thirdName.textAlignment = NSTextAlignmentCenter;
        [thirdLogin addSubview:thirdName];
    }
    
    [thirdLogin addSubview:thirdLbl];
    [thirdLogin addSubview:sepOne];
    [thirdLogin addSubview:sepTwo];
    [self.view addSubview:thirdLogin];
    
    
    
}

- (void)loadData {
    
}

#pragma mark - 自定义事件

//登陆点击
- (void)loginBtnClick:(HemaButton *)sender {
    
}

//注册点击
- (void)registBtnClick:(HemaButton *)sender {
    
}

//忘记密码点击
- (void)forgetBtnClick:(HemaButton *)sender {
    
}

//三方登陆点击
- (void)thirdLogoClick:(HemaButton *)sender {
    switch (sender.tag) {
        case 0:{
            
        }
            break;
        case 1:{
            
        }
            break;
        case 2:{
            
        }
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
