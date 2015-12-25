//
//  SetPwdVC.m
//  Hema
//
//  Created by MsTail on 15/12/25.
//  Copyright © 2015年 Hemaapp. All rights reserved.
//

#import "SetPwdVC.h"

@interface SetPwdVC ()<UITextFieldDelegate>

@property (nonatomic,strong) UITextField *firstTF;
@property (nonatomic,strong) UITextField *secondTF;

@end

@implementation SetPwdVC

- (void)viewWillDisappear:(BOOL)animated {
    self.navigationController.navigationBarHidden = YES;
}
- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = NO;
}

- (void)loadSet {
    
    [self.navigationItem setNewTitle:@"设置密码"];
    [self.navigationItem setLeftItemWithTarget:self action:@selector(leftbtnPressed:) image:@"lg_back"];
    
    //密码输入框
    _firstTF = [[UITextField alloc] init];
    _firstTF.frame = CGRectMake(23, 15, UI_View_Width - 30, 50);
    _firstTF.delegate = self;
    _firstTF.secureTextEntry = YES;
    _firstTF.placeholder = @"密码";
    
    UIView *firstView = [[UIView alloc] init];
    firstView.frame = CGRectMake(14, 15, UI_View_Width - 28, 50);
    firstView.layer.borderWidth = 1;
    firstView.layer.borderColor = BB_Gray_Color.CGColor;
    
    //确认密码输入框
    _secondTF = [[UITextField alloc] init];
    _secondTF.frame = CGRectMake(23, 80, UI_View_Width - 30, 50);
    _secondTF.secureTextEntry = YES;
    _secondTF.placeholder = @"确认密码";
    
    UIView *secondView = [[UIView alloc] init];
    secondView.frame = CGRectMake(14, 80, UI_View_Width - 30, 50);
    secondView.layer.borderWidth = 1;
    secondView.layer.borderColor = BB_Gray_Color.CGColor;
    
    //提交
    HemaButton *commitBtn = [[HemaButton alloc] init];
    commitBtn.frame = CGRectMake(43, 170, UI_View_Width - 86, 50);
    [commitBtn setBackgroundImage:[UIImage imageNamed:@"lg_login"] forState:UIControlStateNormal];
    [commitBtn addTarget:self action:@selector(commitBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [commitBtn setTitle:@"提交" forState:UIControlStateNormal];
    
    [self.view addSubview:firstView];
    [self.view addSubview:secondView];
    [self.view addSubview:_firstTF];
    [self.view addSubview:_secondTF];
    [self.view addSubview:commitBtn];
    
}

- (void)commitBtnClick:(HemaButton *)sender {
    if ([_firstTF.text isEqualToString:_secondTF.text]) {
        if (_firstTF.text.length < 6 || _firstTF.text.length > 18) {
            UIAlertView *alertOne = [[UIAlertView alloc] initWithTitle:@"提示！" message:@"请输入6-18位密码" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertOne show];
        } else {
            
        }
    } else {
        UIAlertView *alertTwo = [[UIAlertView alloc] initWithTitle:@"提示！" message:@"两次密码输入不一致，请重新输入" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertTwo show];
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
