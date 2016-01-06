//
//  ResetPwdVC.m
//  Hema
//
//  Created by MsTail on 16/1/4.
//  Copyright © 2016年 Hemaapp. All rights reserved.
//

#import "ResetPwdVC.h"

@interface ResetPwdVC () <UITextFieldDelegate>

@property (nonatomic,strong) UITextField *oldTF;
@property (nonatomic,strong) UITextField *newlyTF;
@property (nonatomic,strong) UITextField *confirmTF;

@end

@implementation ResetPwdVC

- (void)viewWillDisappear:(BOOL)animated {
    self.navigationController.navigationBarHidden = YES;
}
- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = NO;
}

- (void)loadSet {
    
    [self.navigationItem setNewTitle:@"修改密码"];
    [self.navigationItem setLeftItemWithTarget:self action:@selector(leftbtnPressed:) image:@"lg_back"];
    
    //原密码输入框
    _oldTF = [[UITextField alloc] init];
    _oldTF.frame = CGRectMake(23, 15, UI_View_Width - 30, 50);
    _oldTF.delegate = self;
    _oldTF.secureTextEntry = YES;
    _oldTF.placeholder = @"请输入6-16个字符的原密码";
    
    UIView *firstView = [[UIView alloc] init];
    firstView.frame = CGRectMake(14, 15, UI_View_Width - 28, 50);
    firstView.layer.borderWidth = 1;
    firstView.layer.borderColor = BB_Gray_Color.CGColor;
    
    //新密码输入框
    _newlyTF = [[UITextField alloc] init];
    _newlyTF.frame = CGRectMake(23, 80, UI_View_Width - 30, 50);
    _newlyTF.secureTextEntry = YES;
    _newlyTF.placeholder = @"请输入6-16个字符的新密码";
    
    UIView *secondView = [[UIView alloc] init];
    secondView.frame = CGRectMake(14, 80, UI_View_Width - 30, 50);
    secondView.layer.borderWidth = 1;
    secondView.layer.borderColor = BB_Gray_Color.CGColor;
    
    //确认新密码输入框
    _confirmTF = [[UITextField alloc] init];
    _confirmTF.frame = CGRectMake(23, 145, UI_View_Width - 30, 50);
    _confirmTF.secureTextEntry = YES;
    _confirmTF.placeholder = @"请确认密码";
    
    UIView *thirdView = [[UIView alloc] init];
    thirdView.frame = CGRectMake(14, 145, UI_View_Width - 30, 50);
    thirdView.layer.borderWidth = 1;
    thirdView.layer.borderColor = BB_Gray_Color.CGColor;
    
    //提交
    HemaButton *commitBtn = [[HemaButton alloc] init];
    commitBtn.frame = CGRectMake(43, 235, UI_View_Width - 86, 50);
    [commitBtn setBackgroundImage:[UIImage imageNamed:@"lg_login"] forState:UIControlStateNormal];
    [commitBtn addTarget:self action:@selector(commitBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [commitBtn setTitle:@"提交" forState:UIControlStateNormal];
    
    [self.view addSubview:firstView];
    [self.view addSubview:secondView];
    [self.view addSubview:thirdView];
    [self.view addSubview:_oldTF];
    [self.view addSubview:_newlyTF];
    [self.view addSubview:_confirmTF];
    [self.view addSubview:commitBtn];
    
}

- (void)commitBtnClick:(HemaButton *)sender {
    
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
