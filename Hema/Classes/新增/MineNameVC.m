//
//  MineNameVC.m
//  Hema
//
//  Created by Lsy on 16/1/4.
//  Copyright © 2016年 Hemaapp. All rights reserved.
//

#import "MineNameVC.h"
#import "MineMessVC.h"


@interface MineNameVC ()<UITextFieldDelegate>{
    UITextField *_field;
}

@end

@implementation MineNameVC

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
}

-(void)loadSet{
    [self.navigationItem setNewTitle:@"昵称"];
    //左按钮
    [self.navigationItem setLeftItemWithTarget:self action:@selector(leftbtnPressed:) image:@"lg_back"];
    //输入框
    _field = [[UITextField alloc]initWithFrame:CGRectMake(10, 20, UI_View_Width-20, 50)];
    _field.placeholder = @"请输入您的昵称";
    _field.clearButtonMode = UITextFieldViewModeAlways;
    _field.borderStyle = UITextBorderStyleRoundedRect;
    _field.delegate = self;
    [self.view addSubview:_field];
    //提交
    UIButton *finishBtn = [[UIButton alloc]initWithFrame:CGRectMake(30, 140, UI_View_Width-60, 40)];
    finishBtn.backgroundColor = BB_Red_Color;
    [finishBtn setTitleColor:BB_White_Color forState:UIControlStateNormal];
    [finishBtn setTitle:@"提交" forState:UIControlStateNormal];
    finishBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [finishBtn addTarget:self action:@selector(finishBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:finishBtn];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
#pragma mark - 事件
-(void)finishBtnClick{
    if (_field.text.length<8) {
        self.blockName(_field.text);
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        UIAlertView *view = [[UIAlertView alloc]initWithTitle:@"昵称不能超过8位！" message:nil delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil];
        [view show];
    }
    
}

@end
