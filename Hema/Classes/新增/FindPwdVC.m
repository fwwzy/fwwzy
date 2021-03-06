//
//  FindPwdVC.m
//  Hema
//
//  Created by MsTail on 15/12/25.
//  Copyright © 2015年 Hemaapp. All rights reserved.
//

#import "FindPwdVC.h"
#import "SetPwdVC.h"
@interface FindPwdVC ()<UITextFieldDelegate> {
    NSInteger _time;
}


@property (nonatomic,strong) UITextField *phoneTF;
@property (nonatomic,strong) UITextField *codeTF;
@property (nonatomic,strong) UILabel *resultLbl;
@property (nonatomic,strong) HemaButton *sendBtn;
@property (nonatomic,strong) NSTimer *timer;

@end

@implementation FindPwdVC

- (void)viewWillDisappear:(BOOL)animated {
    if ([self.titleName isEqualToString:@"设置支付密码"]) {
    } else {
    self.navigationController.navigationBarHidden = YES;
    }
}
- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = NO;
}

- (void)loadSet {
  
    [self.navigationItem setNewTitle:self.titleName];
    [self.navigationItem setLeftItemWithTarget:self action:@selector(leftbtnPressed:) image:@"lg_back"];
    //密码输入框
    _phoneTF = [[UITextField alloc] init];
    _phoneTF.frame = CGRectMake(23, 15, UI_View_Width - 30, 40);
    _phoneTF.keyboardType = UIKeyboardTypeNumberPad;
    _phoneTF.delegate = self;
    _phoneTF.placeholder = @"请输入手机号";
    
    UIView *phoneView = [[UIView alloc] init];
    phoneView.frame = CGRectMake(14, 15, UI_View_Width - 28, 40);
    phoneView.layer.borderWidth = 1;
    phoneView.layer.borderColor = BB_Gray_Color.CGColor;
    
    //发送验证码提示
    _resultLbl = [[UILabel alloc] init];
    _resultLbl.frame = CGRectMake(20, 90, UI_View_Width - 50, 20);
    _resultLbl.font = [UIFont systemFontOfSize:17];
    _resultLbl.text = @"验证码已发送到152***6264";
    
    //验证码输入框
    _codeTF = [[UITextField alloc] init];
    _codeTF.frame = CGRectMake(23, 120, UI_View_Width / 1.7, 40);
    _codeTF.keyboardType = UIKeyboardTypeNumberPad;
    _codeTF.placeholder = @"请输入验证码";
    
    UIView *codeView = [[UIView alloc] init];
    codeView.frame = CGRectMake(14, 120, UI_View_Width / 1.7, 40);
    codeView.layer.borderWidth = 1;
    codeView.layer.borderColor = BB_Gray_Color.CGColor;
    
    //发送按钮
    _sendBtn = [[HemaButton alloc] init];
    _sendBtn.frame = CGRectMake(codeView.origin.x + codeView.size.width - 1, 120, UI_View_Width - 26 - UI_View_Width / 1.7, 40);
    [_sendBtn setBackgroundImage:[UIImage imageNamed:@"lg_login"] forState:UIControlStateNormal];
    [_sendBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
    [_sendBtn addTarget:self action:@selector(sendBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    _time = 5;
    
    //下一步按钮
    HemaButton *nextBtn = [[HemaButton alloc] init];
    nextBtn.frame = CGRectMake(43, 210, UI_View_Width - 86, 40);
    [nextBtn setBackgroundImage:[UIImage imageNamed:@"lg_login"] forState:UIControlStateNormal];
    [nextBtn addTarget:self action:@selector(nextBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    
    [self.view addSubview:phoneView];
    [self.view addSubview:codeView];
    [self.view addSubview:_phoneTF];
    [self.view addSubview:_resultLbl];
    [self.view addSubview:_codeTF];
    [self.view addSubview:_sendBtn];
    [self.view addSubview:nextBtn];

}

//计时器调用
- (void)timeChanged {
    _time --;
    NSString *time = [NSString stringWithFormat:@"%zd",_time];
    NSString *registStr = [NSString stringWithFormat:@"重新发送%@秒",time];
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:registStr];
    NSRange range = NSMakeRange(4,time.length);
    [attrStr addAttribute:NSForegroundColorAttributeName value:BB_Red_Color range:range];
    [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range:range];
    UILabel *sendLbl = (UILabel *)[self.view viewWithTag:1];
    sendLbl.attributedText = attrStr;
    if (_time == 0) {
        [sendLbl removeFromSuperview];
        [_sendBtn setBackgroundImage:[UIImage imageNamed:@"lg_login"] forState:UIControlStateNormal];
        [_sendBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
        _sendBtn.userInteractionEnabled = YES;
        [_timer invalidate];
        _time = 5;
    }
}
//发送按钮点击
- (void)sendBtnClick:(HemaButton *)sender {
    if (_phoneTF.text.length != 11) {
        UIAlertView *alertOne = [[UIAlertView alloc] initWithTitle:@"提示！" message:@"您输入的手机号不正确" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertOne show];
        //清除按钮
        HemaButton *removeBtn = [[HemaButton alloc] init];
        removeBtn.frame = CGRectMake(_phoneTF.origin.x + _phoneTF.size.width - 70, 10, 20, 20);
        [removeBtn setImage:[UIImage imageNamed:@"rg_remove"] forState:UIControlStateNormal];
        [removeBtn addTarget:self action:@selector(removeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_phoneTF addSubview:removeBtn];
    }
    else {
    //开启计时器，重设Btn背景标题
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeChanged) userInfo:nil repeats:YES];
    [_sendBtn setTitle:@"" forState:UIControlStateNormal];
    [_sendBtn setBackgroundImage:[UIImage imageNamed:@"rg_send"] forState:UIControlStateNormal];
    _sendBtn.userInteractionEnabled = NO;
    UILabel *sendLbl = [[UILabel alloc] init];
    sendLbl.textColor = BB_White_Color;
    sendLbl.font = [UIFont systemFontOfSize:16];
    sendLbl.tag = 1;
    sendLbl.frame = CGRectMake(_sendBtn.origin.x + 15, _sendBtn.origin.y, _sendBtn.size.width, _sendBtn.size.height);
    
    NSString *time = [NSString stringWithFormat:@"%zd",_time];
    NSString *registStr = [NSString stringWithFormat:@"重新发送%@秒",time];
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:registStr];
    NSRange range = NSMakeRange(4,time.length);
    [attrStr addAttribute:NSForegroundColorAttributeName value:BB_Red_Color range:range];
    [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range:range];
    sendLbl.attributedText = attrStr;
    
    [self.view addSubview:sendLbl];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (toBeString.length > 11 && range.length!=1){
        textField.text = [toBeString substringToIndex:11];
        return NO;
    }
    return YES;
}

- (void)nextBtnClick:(HemaButton *)sender {
    SetPwdVC *setPwdVC = [[SetPwdVC alloc] init];
    if ([self.titleName isEqualToString:@"设置支付密码"]) {
        setPwdVC.titleName = self.titleName;
    }
    [self.navigationController pushViewController:setPwdVC animated:YES];
}

//清除按钮点击事件
- (void)removeBtnClick:(HemaButton *) sender {
    _phoneTF.text = @"";
    [sender removeFromSuperview];
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
