//
//  MineMoneyVC.m
//  Hema
//
//  Created by MsTail on 16/1/5.
//  Copyright © 2016年 Hemaapp. All rights reserved.
//

#import "MineMoneyVC.h"

@interface MineMoneyVC ()

@end

@implementation MineMoneyVC

- (void)loadSet {
    
    [self.navigationItem setNewTitle:@"我的抢币"];
    [self.navigationItem setLeftItemWithTarget:self action:@selector(leftbtnPressed:) image:@"lg_back"];
    
    //抢币view
    UIView *moneyView = [[UIView alloc] init];
    moneyView.frame = CGRectMake(0, 0, self.view.width, self.view.height / 4);
    moneyView.backgroundColor = BB_White_Color;
    
    //抢币金额
    UILabel *moneyLbl = [[UILabel alloc] init];
    moneyLbl.frame = CGRectMake(15, 20, 150, 20);
    moneyLbl.font = [UIFont systemFontOfSize:16];
    moneyLbl.textColor = RGB_UI_COLOR(123, 123, 123);
    moneyLbl.text = @"抢币金额(个)";
    
    //数字
    UILabel *totalMoney = [[UILabel alloc] init];
    totalMoney.frame = CGRectMake(0, 0, 200, 30);
    totalMoney.center = CGPointMake(self.view.width / 2, moneyView.height / 2 + 20);
    totalMoney.textAlignment = NSTextAlignmentCenter;
    totalMoney.font = [UIFont systemFontOfSize:30];
    totalMoney.text = @"120";
    
    HemaButton *submitBtn = [[HemaButton alloc] init];
    submitBtn.frame = CGRectMake(60, moneyView.size.height + 30, UI_View_Width - 120, 40);
    [submitBtn setBackgroundImage:[UIImage imageNamed:@"lg_login"] forState:UIControlStateNormal];
    [submitBtn setTitle:@"立即充值" forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(submitBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:submitBtn];
    [moneyView addSubview:moneyLbl];
    [moneyView addSubview:totalMoney];
    [self.view addSubview:moneyView];
}

- (void)loadData {
    
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
