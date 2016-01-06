//
//  RechargeVC.m
//  Hema
//
//  Created by MsTail on 16/1/4.
//  Copyright © 2016年 Hemaapp. All rights reserved.
//

#import "RechargeVC.h"


@interface RechargeVC ()<UITextFieldDelegate> {
    NSMutableArray *_selectArr;
}

@end

@implementation RechargeVC

- (void)viewWillDisappear:(BOOL)animated {
    self.navigationController.navigationBarHidden = YES;
}
- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = NO;
}

- (void)loadSet {

    [self.navigationItem setNewTitle:@"抢币充值"];
    [self.navigationItem setLeftItemWithTarget:self action:@selector(leftbtnPressed:) image:@"lg_back"];
    self.view.backgroundColor = RGB_UI_COLOR(255, 246, 246);
}

- (void)loadData {
    
}

//tableView 代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1) {
        return 2;
    }
    if  (section == 2) {
        return 4;
    }
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

//提交
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if  (section == 2) {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = RGB_UI_COLOR(255, 246, 246);
    HemaButton *submitBtn = [[HemaButton alloc] init];
    submitBtn.frame = CGRectMake(60, 30, UI_View_Width - 120, 40);
    [submitBtn setBackgroundImage:[UIImage imageNamed:@"lg_login"] forState:UIControlStateNormal];
    [submitBtn setTitle:@"确定" forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(submitBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:submitBtn];
        return view;
    }
    return nil;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            return 50;
        }
        if (indexPath.row == 1) {
            return 105;
        }
    }
    if (indexPath.section == 2) {
        if (indexPath.row != 0) {
            return 70;
        } else {
            return 50;
        }
    }
    return 80;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 2) {
        return 120;
    }
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"rechargeCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    } else {
        while ([cell.contentView.subviews lastObject]!=nil) {
            [(UIView *)[cell.contentView.subviews lastObject]removeFromSuperview];
        }
    }
    //头像个人资料cell
    if (indexPath.section == 0) {
        //头像
        HemaImgView *iconView = [[HemaImgView alloc] init];
        iconView.frame = CGRectMake(15, 15, 50, 50);
        [HemaFunction addbordertoView:iconView radius:20 width:0 color:nil];
        iconView.image = [UIImage imageNamed:@"newpulish"];
        
        //用户名
        UILabel *userName = [[UILabel alloc] init];
        userName.frame = CGRectMake(80, 19, UI_View_Width - 150, 20);
        userName.font = [UIFont systemFontOfSize:14];
        userName.textColor = BB_Gray_Color;
        NSString *userStr = @"亓化泽(假肢)";
        NSString *totalStr = [NSString stringWithFormat:@"昵称：%@",userStr];
        NSMutableAttributedString *userAttrStr = [[NSMutableAttributedString alloc] initWithString:totalStr];
        NSRange range = [totalStr rangeOfString:userStr];
        [userAttrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:range];
        [userAttrStr addAttribute:NSForegroundColorAttributeName value:BB_Red_Color range:range];
        userName.attributedText = userAttrStr;
        
        //余额
        UILabel *remainLbl = [[UILabel alloc] init];
        remainLbl.frame = CGRectMake(80, 45, UI_View_Width - 150, 20);
        remainLbl.font = [UIFont systemFontOfSize:14];
        userName.textColor = BB_Gray_Color;
        NSString *remainStr = [NSString stringWithFormat:@"%zd个",0];
        NSString *totalString = [NSString stringWithFormat:@"抢币余额：%@",remainStr];
        NSMutableAttributedString *remainAttrStr = [[NSMutableAttributedString alloc] initWithString:totalString];
        NSRange remainRange = [totalString rangeOfString:remainStr];
        [remainAttrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:remainRange];
        [remainAttrStr addAttribute:NSForegroundColorAttributeName value:BB_Red_Color range:remainRange];
        remainLbl.attributedText = remainAttrStr;
        
        [cell.contentView addSubview:iconView];
        [cell.contentView addSubview:userName];
        [cell.contentView addSubview:remainLbl];
    }
    
    //充值金额cell
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            //充值金额
            UILabel *priceLbl = [[UILabel alloc] init];
            priceLbl.frame = CGRectMake(15, 15, UI_View_Width - 30, 20);
            priceLbl.font = [UIFont systemFontOfSize:15];
            priceLbl.textColor = BB_Gray_Color;
            priceLbl.text = @"请选择充值金额(元)：";
            
            [cell.contentView addSubview:priceLbl];
            
        }
        if (indexPath.row == 1) {
            NSArray *moneyArr = [NSArray arrayWithObjects:@"20",@"50",@"100",@"200",@"500", nil];
            for (int i = 0; i < 6; i++) {
                
                if (i != 5) {
                    
                UIButton *rechargeBtn = [[UIButton alloc] init];
                rechargeBtn.frame = CGRectMake(17 + UI_View_Width / 3.2 * i, 15, UI_View_Width / 3.6, 35);
                rechargeBtn.backgroundColor = BB_Red_Color;
                [rechargeBtn addTarget:self action:@selector(rechargeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                [rechargeBtn setBackgroundColor:BB_White_Color];
                [rechargeBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
                [HemaFunction addbordertoView:rechargeBtn radius:5 width:0.8 color:BB_Gray_Color];
                [rechargeBtn setTitleColor:BB_Blake_Color forState:UIControlStateNormal];
                [rechargeBtn setTitle:moneyArr[i] forState:UIControlStateNormal];
                rechargeBtn.tag = i + 1;
                [cell.contentView addSubview:rechargeBtn];
                    
                if (i >= 3) {
                    rechargeBtn.frame = CGRectMake(17 + UI_View_Width / 3.2 * (i - 3), 60, UI_View_Width / 3.6, 35);
                }
                } else {
                    
                    UIView *textView = [[UIView alloc] init];
                    textView.frame = CGRectMake(17 + UI_View_Width / 3.2 * (i - 3), 60, UI_View_Width / 3.6, 35);
                    [HemaFunction addbordertoView:textView radius:5 width:0.8 color:BB_Gray_Color];
                    UITextField *textField = [[UITextField alloc] init];
                    textField.frame = CGRectMake(20, 0, UI_View_Width / 3.6 - 15, 35);
                    textField.placeholder = @"输入金额";
                    textField.font = [UIFont systemFontOfSize:14];
                    textField.tag = i + 1;
                    textField.delegate = self;
                    [textView addSubview:textField];
                    [cell.contentView addSubview:textView];
                    
                }
            }
        }
    }
    
    //支付方式
    if  (indexPath.section == 2) {
        if (indexPath.row == 0) {
            //其他支付方式
            UILabel *redLbl = [[UILabel alloc] init];
            redLbl.frame = CGRectMake(15, 15, UI_View_Width - 100, 20);
            redLbl.textColor = RGB_UI_COLOR(123, 123, 123);
            redLbl.text = @"请选择支付方式";
            [cell.contentView addSubview:redLbl];

        }
        
        NSArray *imgArr = @[@"hp_zhifubao",@"hp_yinlian",@"hp_wx"];
        NSArray *textArr = @[@"支付宝客户端支付\n推荐安装支付宝客户端的用户使用",@"银联手机支付\n推荐安装银联客户端的用户使用",@"微信支付\n推荐安装微信客户端的用户使用"];
        NSArray *rangeArr = @[@[@8,@16],@[@6,@15],@[@4,@15]];
        for (int i = 0; i < 3; i++) {
            if (indexPath.row == i + 1) {
                //支付宝
                HemaImgView *zfbView = [[HemaImgView alloc] init];
                if (i == 1) {
                    zfbView.frame = CGRectMake(15, 15, 65, 40);
                } else if ( i == 2) {
                    zfbView.frame = CGRectMake(20, 15, 50, 40);
                } else {
                    zfbView.frame = CGRectMake(15, 20, 65, 25);
                }
                zfbView.image = [UIImage imageNamed:imgArr[i]];
                
                //支付宝label
                UILabel *zfbLbl = [[UILabel alloc] init];
                zfbLbl.frame = CGRectMake(90, 10, 200, 40);
                zfbLbl.font = [UIFont systemFontOfSize:15];
                zfbLbl.lineBreakMode = NSLineBreakByWordWrapping;
                zfbLbl.numberOfLines = 0;
                NSString *totalStr = textArr[i];
                NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:totalStr];
                NSRange range = NSMakeRange([[rangeArr[i] objectAtIndex:0] integerValue],[[rangeArr[i] objectAtIndex:1] integerValue]);
                [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:range];
                [attrStr addAttribute:NSForegroundColorAttributeName value:BB_Gray_Color range:range];
                zfbLbl.attributedText = attrStr;
                
                //单选框
                HemaButton *selectBtn = [[HemaButton alloc] init];
                selectBtn.frame = CGRectMake(UI_View_Width - 40, 19, 28, 28);
                selectBtn.tag = i + 10;
                [selectBtn setImage:[UIImage imageNamed:@"hp_payyes"] forState:UIControlStateNormal];
                [selectBtn setImage:[UIImage imageNamed:@"hp_selected"] forState:UIControlStateSelected];
                [selectBtn addTarget:self action:@selector(payTypeClick:) forControlEvents:UIControlEventTouchUpInside];
                _selectArr = [[NSMutableArray alloc] init];
                
                
                //分割线
                UILabel *sepLbl = [[UILabel alloc] init];
                sepLbl.frame = CGRectMake(15, 69, UI_View_Width - 30, 1);
                sepLbl.backgroundColor = BB_Gray_Color;
                sepLbl.alpha = 0.3;
                
                [cell.contentView addSubview:zfbView];
                [cell.contentView addSubview:zfbLbl];
                [cell.contentView addSubview:selectBtn];
                [cell.contentView addSubview:sepLbl];
            }
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - 自定义事件

//选择金额点击事件
- (void)rechargeBtnClick:(UIButton *)sender {
     
    for (int i = 1; i < 6; i++) {
        UIButton *btn = (UIButton *)[self.mytable viewWithTag:i];
        if (sender == btn) {
            [sender  setBackgroundColor:RGB_UI_COLOR(237, 88, 99)];
            [sender setTitleColor:BB_White_Color forState:UIControlStateNormal];
        } else {
        [btn setBackgroundColor:BB_White_Color];
        [btn setTitleColor:BB_Blake_Color forState:UIControlStateNormal];
        }
    }
}

//点击输入放弃button
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    for (int i = 1; i < 6; i++) {
        UIButton *btn = (UIButton *)[self.mytable viewWithTag:i];
        [btn setBackgroundColor:BB_White_Color];
        [btn setTitleColor:BB_Blake_Color forState:UIControlStateNormal];
    }
    return YES;
}

//提交按钮点击事件
- (void)submitBtnClick:(UIButton *)sender {
   
}

//支付方式选择
- (void)payTypeClick:(UIButton *)sender {
    for (int i = 10; i < 13; i++) {
        UIButton *btn = (UIButton *)[self.mytable viewWithTag:i];
        if (sender == btn) {
            sender.selected = !sender.selected;
        } else {
        btn.selected = NO;
        }
    }
    
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
