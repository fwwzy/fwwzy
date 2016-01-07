//
//  MineRedVC.m
//  Hema
//
//  Created by MsTail on 16/1/5.
//  Copyright © 2016年 Hemaapp. All rights reserved.
//

#import "MineRedVC.h"
#import "LjjUISegmentedControl.h"
#import "RedMethodVC.h"


@interface MineRedVC () {
    UILabel *_sepLabel;
    UIView *_viewOne; //可使用
    UIView *_viewTwo; //已使用
    NSInteger _selectIndex;  //可使用1 已使用2
    NSInteger _loadNum; //第几次加载cell
    CGFloat _autoHeight; //footerView高度
    NSMutableArray *_dataSource;
    NSInteger _lastIndex;
}
@end

@implementation MineRedVC

- (void)viewWillDisappear:(BOOL)animated {
    self.navigationController.navigationBarHidden = YES;
}
- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = NO;
}

- (void)loadSet {
    
    [self.navigationItem setNewTitle:@"我的红包"];
    [self.navigationItem setLeftItemWithTarget:self action:@selector(leftbtnPressed:) image:@"lg_back"];
    self.mytable.tableFooterView.userInteractionEnabled = YES;
    //可使用 已使用view
    _viewOne = [[UIView alloc] init];
    _viewOne.frame = CGRectMake(0, 0, self.view.width, 30 + self.view.height / 4.5 * 2);
    _viewOne.backgroundColor = RGB_UI_COLOR(255, 246, 246);
    _viewTwo = [[UIView alloc] init];
    _viewTwo.backgroundColor = RGB_UI_COLOR(255, 246, 246);
    _viewTwo.frame = _viewOne.frame;
    _viewOne.userInteractionEnabled = YES;
    _viewOne.hidden = NO;
    _viewTwo.hidden = YES;
    
    _autoHeight = self.view.height / 4 * 2 + 30;
    
    for (int i = 0; i < 2; i++) {
        
        //红包
        UIImageView *redView = [[UIImageView alloc] init];
        redView.userInteractionEnabled = YES;
        redView.tag = 100 + i;
        redView.frame = CGRectMake(15, 15 + i * self.view.height / 4, UI_View_Width - 30, self.view.size.height / 4.5);
        redView.backgroundColor = RGB_UI_COLOR(224, 58, 81);
        [HemaFunction addbordertoView:redView radius:5 width:0 color:nil];
        
        UIButton *getRedView = [[UIButton alloc] init];
        getRedView.frame = CGRectMake(redView.size.width / 3 * 2, 0, redView.size.width / 3, redView.size.height);
        [getRedView setImage:[UIImage imageNamed:@"mine_getred"] forState:UIControlStateNormal];
        [getRedView addTarget:self action:@selector(getRedClick:) forControlEvents:UIControlEventTouchUpInside];
        
        //期数
        UILabel *numLbl = [[UILabel alloc] init];
        numLbl.frame = CGRectMake(10, 10, 100, 10);
        numLbl.font = [UIFont systemFontOfSize:12];
        numLbl.textColor = RGB_UI_COLOR(255, 202, 209);
        numLbl.text = @"第1235期";
        
        //金额
        UILabel *moneyLbl = [[UILabel alloc] init];
        moneyLbl.frame = CGRectMake(40, redView.size.height / 3, 150, redView.size.height / 3);
        moneyLbl.textColor = BB_White_Color;
        NSString *moneyStr = [NSString stringWithFormat:@"%0.1f",0.5];
        NSString *totalStr = [NSString stringWithFormat:@"￥%@",moneyStr];
        NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:totalStr];
        NSRange range = NSMakeRange(1, moneyStr.length);
        [attributeStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:30] range:range];
        moneyLbl.attributedText = attributeStr;
        
        //有效期
        UILabel *timeLbl = [[UILabel alloc] init];
        timeLbl.frame = CGRectMake(10, redView.size.height - 20, 200, 10);
        timeLbl.textColor = RGB_UI_COLOR(255, 202, 209);
        timeLbl.font = [UIFont systemFontOfSize:12];
        timeLbl.text = @"2015-12-30前有效";
        
        [redView addSubview:timeLbl];
        [redView addSubview:moneyLbl];
        [redView addSubview:numLbl];
        [redView addSubview:getRedView];
        [_viewOne addSubview:redView];
        
    }
    self.view.backgroundColor = RGB_UI_COLOR(255, 246, 246);
}

- (void)loadData {
    _selectIndex = 1;
    _loadNum = 0;
}

//tableView 代理
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 1) {
        return _autoHeight;
    }
    return 10;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1) {
        return 1;
    }
    return 2;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 90;
        }
    }
    if (indexPath.section == 1) {
        return 50;
    }
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 1) {
        //显示可使用还是已使用
        if (_viewOne.hidden == YES) {
            return _viewTwo;
        } else {
        return _viewOne;
        }
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellId = @"redCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    } else {
        while ([cell.contentView.subviews lastObject]!=nil) {
            [(UIView *)[cell.contentView.subviews lastObject]removeFromSuperview];
        }
    }
    
    //红包可用金额
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            
            //可用金额
            UILabel *availableLbl = [[UILabel alloc] init];
            availableLbl.frame = CGRectMake(15, 15, 150, 20);
            availableLbl.font = [UIFont systemFontOfSize:15];
            availableLbl.text = @"红包可用金额(元)";
            availableLbl.textColor = RGB_UI_COLOR(102, 102, 102);
            
            //如何使用红包
            UIButton *useRedBtn = [[UIButton alloc] init];
            useRedBtn.frame = CGRectMake(UI_View_Width - 80, 19, 66, 14);
            [useRedBtn setImage:[UIImage imageNamed:@"mine_usered"] forState:UIControlStateNormal];
            [useRedBtn addTarget:self action:@selector(useRedBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            
            //金额
            UILabel *money = [[UILabel alloc] init];
            money.frame = CGRectMake(0, 0, 250, 50);
            money.textAlignment = NSTextAlignmentCenter;
            money.center = CGPointMake(self.view.width / 2, 65);
            money.font = [UIFont systemFontOfSize:25];
            money.text = @"￥1.00";
            
            [cell.contentView addSubview:availableLbl];
            [cell.contentView addSubview:useRedBtn];
            [cell.contentView addSubview:money];
        }
        if (indexPath.row == 1) {
            
            //总金额
            UILabel *totalMoneyLbl = [[UILabel alloc] init];
            totalMoneyLbl.frame = CGRectMake(15, 15, UI_View_Width - 30, 20);
            totalMoneyLbl.textColor = RGB_UI_COLOR(102, 102, 102);
            totalMoneyLbl.font = [UIFont systemFontOfSize:15];
            NSString *moneyStr = [NSString stringWithFormat:@"￥%0.2f",2.00];
            NSString *totalStr = [NSString stringWithFormat:@"红包总金额:%@ (红包整元使用)",moneyStr];
            NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:totalStr];
            NSRange range = [totalStr rangeOfString:moneyStr];
            [attributeStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(range.location + range.length, 8)];
            [attributeStr addAttribute:NSForegroundColorAttributeName value:BB_Blake_Color range:range];
            totalMoneyLbl.attributedText = attributeStr;
            
            [cell.contentView addSubview:totalMoneyLbl];
        }
    }
    if (indexPath.section == 1) {
        
        //红包可使用及已使用
        
        _sepLabel = [[UILabel alloc] init];
        _sepLabel.backgroundColor = RGB_UI_COLOR(217, 29, 43);
        
        UIButton *leftBtn = [[UIButton alloc] init];
        leftBtn.frame = CGRectMake(40, 15, 60, 20);
        leftBtn.tag = 1;
        [leftBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [leftBtn setTitle:@"可使用" forState:UIControlStateNormal];
        
        [leftBtn addTarget:self action:@selector(btnChange:) forControlEvents:UIControlEventTouchUpInside];
        
       UIButton *rightBtn = [[UIButton alloc] init];
        rightBtn.frame = CGRectMake(UI_View_Width - 130, 15, 100, 20);
        rightBtn.tag = 2;
        [rightBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [rightBtn setTitle:@"已使用/过期" forState:UIControlStateNormal];
        
        //选择滑动动画
      
        if (_selectIndex == 2) {
            _sepLabel.frame = CGRectMake(leftBtn.origin.x - 10, 49, leftBtn.size.width + 20, 2);
            [rightBtn setTitleColor:RGB_UI_COLOR(217, 29, 43) forState:UIControlStateNormal];
            [UIView animateWithDuration:0.5 animations:^{
                _sepLabel.frame = CGRectMake(rightBtn.origin.x - 10, 49, rightBtn.size.width + 20, 2);
            }];
        } else {
        [rightBtn setTitleColor:BB_Blake_Color forState:UIControlStateNormal];
        }
     
  
        if (_selectIndex == 1 ) {
            if (_loadNum == 2) {
                _sepLabel.frame = CGRectMake(leftBtn.origin.x - 10, 49, leftBtn.size.width + 20, 2);
            } else {
            _sepLabel.frame = CGRectMake(rightBtn.origin.x - 10, 49, rightBtn.size.width + 20, 2);
            }
            [leftBtn setTitleColor:RGB_UI_COLOR(217, 29, 43) forState:UIControlStateNormal];
            [UIView animateWithDuration:0.5 animations:^{
                _sepLabel.frame = CGRectMake(leftBtn.origin.x - 10, 49, leftBtn.size.width + 20, 2);
            }];
        } else {
            [leftBtn setTitleColor:BB_Blake_Color forState:UIControlStateNormal];
        }
    
        [rightBtn addTarget:self action:@selector(btnChange:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:leftBtn];
        [cell.contentView addSubview:rightBtn];
        [cell.contentView addSubview:_sepLabel];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    _loadNum ++;
    return cell;
}

//可使用已使用切换
- (void)btnChange:(UIButton *)sender {
    _lastIndex = _selectIndex;
    if (sender.tag == 1) {
        _viewTwo.hidden = YES;
        _viewOne.hidden = NO;
        _selectIndex = 1;
    } else {
        _viewOne.hidden = YES;
        _viewTwo.hidden = NO;
        _selectIndex = 2;
    }
    [self.mytable reloadData];
}

//点击领取红包
- (void)getRedClick:(UIButton *)sender {
    
    [HemaFunction openIntervalHUDOK:@"红包已领取"];
    [sender.superview removeFromSuperview];
    
    //删除后上移
    for (NSInteger i = sender.superview.tag - 100; i < 2; i++) {
        UIImageView *redView = (id)[self.view viewWithTag:100 + i];
        redView.center = CGPointMake(redView.center.x, redView.center.y - self.view.height / 4 - 15);
    }
    
    //移除 创建已领取
    
    NSArray *viewTwoSubViews = _viewTwo.subviews;
    
    UIImageView *redView = [[UIImageView alloc] init];
    redView.frame = CGRectMake(15, 15 + viewTwoSubViews.count * self.view.height / 4, UI_View_Width - 30, self.view.size.height / 4.5);
    redView.backgroundColor = RGB_UI_COLOR(224, 58, 81);
    [HemaFunction addbordertoView:redView radius:5 width:0 color:nil];
    
    UIImageView *getRedView = [[UIImageView alloc] init];
    getRedView.frame = CGRectMake(redView.size.width / 3 * 2, 0, redView.size.width / 3, redView.size.height);
    getRedView.backgroundColor = BB_Gray_Color;
    getRedView.image = [UIImage imageNamed:@"mine_gotred"];
    
    //期数
    UILabel *numLbl = [[UILabel alloc] init];
    numLbl.frame = CGRectMake(10, 10, 100, 10);
    numLbl.font = [UIFont systemFontOfSize:12];
    numLbl.textColor = RGB_UI_COLOR(255, 202, 209);
    numLbl.text = @"第1235期";
    
    //金额
    UILabel *moneyLbl = [[UILabel alloc] init];
    moneyLbl.frame = CGRectMake(40, redView.size.height / 3, 150, redView.size.height / 3);
    moneyLbl.textColor = BB_White_Color;
    NSString *moneyStr = [NSString stringWithFormat:@"%0.1f",0.5];
    NSString *totalStr = [NSString stringWithFormat:@"￥%@",moneyStr];
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:totalStr];
    NSRange range = NSMakeRange(1, moneyStr.length);
    [attributeStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:30] range:range];
    moneyLbl.attributedText = attributeStr;

    //有效期
    UILabel *timeLbl = [[UILabel alloc] init];
    timeLbl.frame = CGRectMake(10, redView.size.height - 20, 200, 10);
    timeLbl.textColor = RGB_UI_COLOR(255, 202, 209);
    timeLbl.font = [UIFont systemFontOfSize:12];
    timeLbl.text = @"2015-12-30前有效";
    
    [redView addSubview:timeLbl];
    [redView addSubview:moneyLbl];
    [redView addSubview:numLbl];
    [redView addSubview:getRedView];
    [_viewTwo addSubview:redView];

}


- (void)useRedBtnClick:(UIButton *)sender {
    RedMethodVC *redMethodVC = [[RedMethodVC alloc] init];
    [self.navigationController pushViewController:redMethodVC animated:YES];
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
