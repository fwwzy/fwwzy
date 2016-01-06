//
//  SafeVC.m
//  Hema
//
//  Created by MsTail on 16/1/4.
//  Copyright © 2016年 Hemaapp. All rights reserved.
//

#import "SafeVC.h"
#import "FindPwdVC.h"
#import "ResetPwdVC.h"
@interface SafeVC ()

@end

@implementation SafeVC

- (void)viewWillDisappear:(BOOL)animated {
    self.navigationController.navigationBarHidden = YES;
}
- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = NO;
}

- (void)loadSet {
    
    [self.navigationItem setNewTitle:@"安全管理"];
    [self.navigationItem setLeftItemWithTarget:self action:@selector(leftbtnPressed:) image:@"lg_back"];
    self.view.backgroundColor = RGB_UI_COLOR(255, 246, 246);
    [self.mytable setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    
}

- (void)loadData {
    
}

//tableView 代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1) {
        return 2;
    }
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return 10;
    }
    return 120;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if  (section == 0) {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = RGB_UI_COLOR(255, 246, 246);
    return view;
    }
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    NSArray *titleArr = [NSArray arrayWithObjects:@"账号密码管理",@"支付密码管理", nil];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        
        if (indexPath.section == 0) {
            UILabel *userLbl = [[UILabel alloc] init];
            userLbl.frame = CGRectMake(15, 15, 200, 20);
            userLbl.text = @"用户名";
            userLbl.textColor = BB_Gray_Color;
            userLbl.font = [UIFont systemFontOfSize:16];
            [cell.contentView addSubview:userLbl];
            
            UILabel *user = [[UILabel alloc] init];
            user.frame = CGRectMake(UI_View_Width - 150, 15, 140, 20);
            user.textAlignment = NSTextAlignmentRight;
            user.text = @"jiazhiisdog";
            [cell.contentView addSubview:user];
        }
        if  (indexPath.section == 1) {
            //title
            UILabel *titleLbl = [[UILabel alloc] init];
            titleLbl.frame = CGRectMake(15, 15, 200, 20);
            titleLbl.text = titleArr[indexPath.row];
            titleLbl.font = [UIFont systemFontOfSize:16];
            
            //next
            UIButton *nextBtn = [[UIButton alloc] init];
            nextBtn.frame = CGRectMake(UI_View_Width - 35, 20, 7, 14);
            [nextBtn setImage:[UIImage imageNamed:@"mine_next"] forState:UIControlStateNormal];
            

            [cell.contentView addSubview:titleLbl];
            [cell.contentView addSubview:nextBtn];
        }
        
    }
    return cell;
}

//cell点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            
            ResetPwdVC *resetPwdVC = [[ResetPwdVC alloc] init];
            [self.navigationController pushViewController:resetPwdVC animated:YES];
        } else {
            
            FindPwdVC *findPwdVC = [[FindPwdVC alloc] init];
            findPwdVC.titleName = @"设置支付密码";
            [self.navigationController pushViewController:findPwdVC animated:YES];
        }
    }
}

//确定按钮点击事件
- (void)submitBtnClick:(UIButton *)sender {
    
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
