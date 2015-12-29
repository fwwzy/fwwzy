//
//  SumbitOrderVC.m
//  Hema
//
//  Created by MsTail on 15/12/29.
//  Copyright © 2015年 Hemaapp. All rights reserved.
//

#import "SumbitOrderVC.h"

@interface SumbitOrderVC ()

@end

@implementation SumbitOrderVC

- (void)loadSet {
    [self.navigationItem setNewTitle:@"提交订单"];
    [self.navigationItem setLeftItemWithTarget:self action:@selector(leftbtnPressed:) image:@"lg_back"];
    [self.mytable setSeparatorStyle:UITableViewCellSeparatorStyleSingleLineEtched];
}

- (void)loadData {
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2) {
        if (indexPath.row != 0) {
            return 70;
        }
    }
    if (indexPath.section == 3) {
        return 80;
    }
    return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1) {
        return 2;
    }
    if (section == 2) {
        return 4;
    }
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];
    view.frame = CGRectMake(0, 0, UI_View_Width, 10);
    view.backgroundColor = RGB_UI_COLOR(255, 248, 250);
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    UIColor *textColor = RGB_UI_COLOR(123, 123, 123);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    switch (indexPath.section) {
        case 0:{
            //请支付
            UILabel *payLbl = [[UILabel alloc] init];
            payLbl.frame = CGRectMake(15, 15, 60, 20);
            payLbl.textColor = textColor;
            payLbl.text = @"请支付:";
            
            //抢币
            UILabel *moneyLbl = [[UILabel alloc] init];
            moneyLbl.frame = CGRectMake(UI_View_Width - 150, 15, 125, 20);
            moneyLbl.textAlignment = NSTextAlignmentRight;
            moneyLbl.textColor = BB_Red_Color;
            moneyLbl.text = @"61抢币";
            
            [cell.contentView addSubview:payLbl];
            [cell.contentView addSubview:moneyLbl];
        }
            break;
        case 1:{
            if (indexPath.row == 0) {
                //余额支付
                UILabel *balanceLbl = [[UILabel alloc] init];
                balanceLbl.frame = CGRectMake(15, 15, UI_View_Width - 54, 20);
                NSString *balanceStr = [NSString stringWithFormat:@"(账户余额:%zd抢币)",0];
                NSString *totalStr = [NSString stringWithFormat:@"余额支付%@",balanceStr];
                balanceLbl.textColor = textColor;
                NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:totalStr];
                NSRange range = [totalStr rangeOfString:balanceStr];
                [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:range];
                [attrStr addAttribute:NSForegroundColorAttributeName value:BB_Gray_Color range:range];
                balanceLbl.attributedText = attrStr;
                
                //分割线
                UILabel *sepLbl = [[UILabel alloc] init];
                sepLbl.frame = CGRectMake(15, 49, UI_View_Width - 30, 1);
                sepLbl.backgroundColor = BB_Gray_Color;
                sepLbl.alpha = 0.3;
                
                //单选框
                HemaButton *selectBtn = [[HemaButton alloc] init];
                selectBtn.frame = CGRectMake(UI_View_Width - 70, 13, 28, 28);
                [selectBtn setImage:[UIImage imageNamed:@"hp_payyes"] forState:UIControlStateNormal];
                [selectBtn setImage:[UIImage imageNamed:@"hp_selected"] forState:UIControlStateSelected];
                [selectBtn addTarget:self action:@selector(selectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                
                [cell.contentView addSubview:balanceLbl];
                [cell.contentView addSubview:selectBtn];
                [cell.contentView addSubview:sepLbl];
            }
            if (indexPath.row == 1) {
                //红包抵扣
                UILabel *redLbl = [[UILabel alloc] init];
                redLbl.frame = CGRectMake(15, 15, UI_View_Width - 100, 20);
                redLbl.textColor = textColor;
                redLbl.text = @"红包抵扣          2元";
                
                //switch
                UISwitch *redSwitch = [[UISwitch alloc] init];
                redSwitch.frame = CGRectMake(UI_View_Width - 70, 10, 35, 20);
                redSwitch.thumbTintColor = BB_White_Color;
                redSwitch.onTintColor = RGB_UI_COLOR(237, 88, 99);
                redSwitch.tintColor = BB_Gray_Color;
                
                [cell.contentView addSubview:redLbl];
                [cell.contentView addSubview:redSwitch];
                
            }
        }
            break;
        case 2:{
            if (indexPath.row == 0) {
                //其他支付方式
                UILabel *redLbl = [[UILabel alloc] init];
                redLbl.frame = CGRectMake(15, 15, UI_View_Width - 100, 20);
                redLbl.textColor = textColor;
                redLbl.text = @"其他支付方式";
                
                //分割线
                UILabel *sepLbl = [[UILabel alloc] init];
                sepLbl.frame = CGRectMake(15, 49, UI_View_Width - 30, 1);
                sepLbl.backgroundColor = BB_Gray_Color;
                sepLbl.alpha = 0.3;
                [cell.contentView addSubview:redLbl];
                [cell.contentView addSubview:sepLbl];
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
                selectBtn.frame = CGRectMake(UI_View_Width - 70, 15, 28, 28);
                selectBtn.tag = 1 + 10;
                [selectBtn setImage:[UIImage imageNamed:@"hp_payyes"] forState:UIControlStateNormal];
                [selectBtn setImage:[UIImage imageNamed:@"hp_selected"] forState:UIControlStateSelected];
                [selectBtn addTarget:self action:@selector(payTypeClick:) forControlEvents:UIControlEventTouchUpInside];
                
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
            break;
        case 3:{
            //提交
            cell.backgroundColor = RGB_UI_COLOR(255, 248, 250);
            HemaButton *submitBtn = [[HemaButton alloc] init];
            submitBtn.frame = CGRectMake(50, 15, UI_View_Width - 100, 50);
            [submitBtn setBackgroundImage:[UIImage imageNamed:@"lg_login"] forState:UIControlStateNormal];
            [submitBtn setTitle:@"提交" forState:UIControlStateNormal];
            
            [cell.contentView addSubview:submitBtn];
        }
            break;
    }
    return cell;
}

- (void)selectBtnClick:(HemaButton *)sender {
    sender.selected = !sender.selected;
}

- (void)payTypeClick:(HemaButton *)sender {
    switch (sender.tag - 10) {
        case 1:{
            sender.selected = !sender.selected;
        }
            break;
            
        default:
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
