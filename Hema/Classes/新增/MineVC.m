//
//  MineVC.m
//  Hema
//
//  Created by MsTail on 15/12/23.
//  Copyright © 2015年 Hemaapp. All rights reserved.
//

#import "MineVC.h"

@interface MineVC ()<UITableViewDataSource,UITableViewDelegate>{
    UITableView *_tableView;
}

@end

@implementation MineVC

- (void)loadSet {
    //隐藏导航栏
    self.navigationController.navigationBarHidden = YES;
    //导航
    UIView *navView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UI_View_Width, self.view.height/3)];
    navView.backgroundColor = [UIColor colorWithRed:217.0/255 green:29.0/255 blue:43.0/255 alpha:1];
    [self.view addSubview:navView];
    //标题
    UILabel *loginLbl = [[UILabel alloc] init];
    loginLbl.frame = CGRectMake(UI_View_Width / 2 - 40, 30, 80, 17);
    loginLbl.textColor = BB_White_Color;
    loginLbl.font = [UIFont systemFontOfSize:18];
    loginLbl.text = @"个人中心";
    [navView addSubview:loginLbl];
    //设置
    UIButton *setBtn = [[UIButton alloc]initWithFrame:CGRectMake(UI_View_Width - 29, 29, 20, 20)];
    [setBtn setBackgroundImage:[UIImage imageNamed:@"mine_setting"] forState:UIControlStateNormal];
    [navView addSubview: setBtn];
    //头像
    UIImageView *iconView = [[UIImageView alloc]initWithFrame:CGRectMake(UI_View_Width/2-33, 60, 66, 66)];
    [iconView setImage:[UIImage imageNamed:@"mine_icon"]];
    [navView addSubview:iconView];
    //昵称
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(UI_View_Width/2-50, 136, 100, 15)];
    nameLabel.text = @"夺宝奇兵";
    nameLabel.textColor = BB_White_Color;
    nameLabel.font = [UIFont systemFontOfSize:14];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    [navView addSubview:nameLabel];
    //ID
    UILabel *idLabel = [[UILabel alloc]initWithFrame:CGRectMake(UI_View_Width/2-50, 151, 100, 15)];
    idLabel.font = [UIFont systemFontOfSize:11];
    idLabel.textAlignment = NSTextAlignmentCenter;
    idLabel.text = @"ID:3562642";
    idLabel.textColor =[UIColor colorWithRed:143.0/255 green:14.0/255 blue:30.0/255 alpha:1];
    [navView addSubview:idLabel];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, self.view.height/3, UI_View_Width, self.view.height-self.view.height/3-64)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}
- (void)loadData {
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 2) {
        return 4;
    }
    return 2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 1) {
            return 80;
        }
    }
    if (indexPath.section == 1) {
        if (indexPath.row == 1) {
            return 80;
        }
    }
    return 40;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = nil;
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"qqq"];
    }else{
        while ([cell.contentView.subviews lastObject]!=nil) {
            [(UIView *)[cell.contentView.subviews lastObject]removeFromSuperview];
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //图标
    UIImageView *iconView = [[UIImageView alloc]init];
    //标题
    UILabel *titleLabel = [[UILabel alloc]init];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            iconView.frame = CGRectMake(10, 10, 20, 20);
            [iconView setImage:[UIImage imageNamed:@"mine_purse"]];
            
            titleLabel.frame = CGRectMake(40, 10, 60, 20);
            titleLabel.text = @"我的钱包";
            titleLabel.font = [UIFont systemFontOfSize:14];
        }
        if (indexPath.row == 1) {
            UIButton *titleBtn = [[UIButton alloc]initWithFrame:CGRectMake(50, 20, 27, 28)];
            [titleBtn setBackgroundImage:[UIImage imageNamed:@"mine_money"] forState:UIControlStateNormal];
            [cell addSubview:titleBtn];
            
            UIButton *titleBtn1 = [[UIButton alloc]initWithFrame:CGRectMake(150,20 , 23, 27)];
            [titleBtn1 setBackgroundImage:[UIImage imageNamed:@"mine_redbag1"] forState:UIControlStateNormal];
            [cell addSubview:titleBtn1];
            
            UIButton *titleBtn2 = [[UIButton alloc]initWithFrame:CGRectMake(249, 20, 29, 29)];
            [titleBtn2 setBackgroundImage:[UIImage imageNamed:@"mine_recharge"] forState:UIControlStateNormal];
            [cell addSubview:titleBtn2];
            
            UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 54, 87, 15)];
            titleLabel.text = @"抢币：12个";
            titleLabel.textColor = BB_Gray_Color;
            titleLabel.textAlignment = NSTextAlignmentCenter;
            titleLabel.font = [UIFont systemFontOfSize:12];
            [cell addSubview:titleLabel];
            
            UILabel *titleLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(120, 54, 87, 15)];
            titleLabel1.text = @"红包：12￥";
            titleLabel1.textColor = BB_Gray_Color;
            titleLabel1.textAlignment = NSTextAlignmentCenter;
            titleLabel1.font = [UIFont systemFontOfSize:12];
            [cell addSubview:titleLabel1];
            
            UILabel *titleLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(219, 54, 87, 15)];
            titleLabel2.text = @"充值";
            titleLabel2.textColor = BB_Gray_Color;
            titleLabel2.textAlignment = NSTextAlignmentCenter;
            titleLabel2.font = [UIFont systemFontOfSize:12];
            [cell addSubview:titleLabel2];
        }
    }
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            iconView.frame = CGRectMake(10, 10, 20, 20);
            [iconView setImage:[UIImage imageNamed:@"mine_myIndiana"]];
            
            titleLabel.frame = CGRectMake(40, 10, 60, 20);
            titleLabel.text = @"我的夺宝";
            titleLabel.font = [UIFont systemFontOfSize:14];
        }
        if (indexPath.row == 1) {
            UIButton *titleBtn = [[UIButton alloc]initWithFrame: CGRectMake(24, 15, 50, 49)];
            [titleBtn setBackgroundImage:[UIImage imageNamed:@"mine_record"] forState:UIControlStateNormal];
            [cell addSubview:titleBtn];
            
            UIButton *titleBtn1 = [[UIButton alloc]initWithFrame: CGRectMake(98, 19, 48, 45)];
            [titleBtn1 setBackgroundImage:[UIImage imageNamed:@"mine_winrecord"] forState:UIControlStateNormal];
            [cell addSubview:titleBtn1];
            
            UIButton *titleBtn2 = [[UIButton alloc]initWithFrame: CGRectMake(172, 16, 37, 48)];
            [titleBtn2 setBackgroundImage:[UIImage imageNamed:@"mine_bask"] forState:UIControlStateNormal];
            [cell addSubview:titleBtn2];
            
            UIButton *titleBtn3 = [[UIButton alloc]initWithFrame: CGRectMake(246, 16, 37, 48)];
            [titleBtn3 setBackgroundImage:[UIImage imageNamed:@"mine_unbask"] forState:UIControlStateNormal];
            [cell addSubview:titleBtn3];
        }
    }
    if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            iconView.frame = CGRectMake(10, 10, 20, 20);
            [iconView setImage:[UIImage imageNamed:@"mine_mess"]];
            
            titleLabel.frame = CGRectMake(40, 10, 60, 20);
            titleLabel.text = @"消息盒子";
            titleLabel.font = [UIFont systemFontOfSize:14];
        }
        if (indexPath.row == 1) {
            iconView.frame = CGRectMake(10, 10, 20, 20);
            [iconView setImage:[UIImage imageNamed:@"mine_friend"]];
            
            titleLabel.frame = CGRectMake(40, 10, 60, 20);
            titleLabel.text = @"邀请好友";
            titleLabel.font = [UIFont systemFontOfSize:14];
        }
        if (indexPath.row == 2) {
            iconView.frame = CGRectMake(10, 10, 20, 20);
            [iconView setImage:[UIImage imageNamed:@"mine_twoma"]];
            
            titleLabel.frame = CGRectMake(40, 10, 80, 20);
            titleLabel.text = @"我的二维码";
            titleLabel.font = [UIFont systemFontOfSize:14];
        }
        if (indexPath.row == 3) {
            iconView.frame = CGRectMake(10, 10, 20, 20);
            [iconView setImage:[UIImage imageNamed:@"mine_place"]];
            
            titleLabel.frame = CGRectMake(40, 10, 60, 20);
            titleLabel.text = @"收货地址";
            titleLabel.font = [UIFont systemFontOfSize:14];
        }
    }
    [cell addSubview:titleLabel];
    [cell addSubview:iconView];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *picView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 10)];
    picView.backgroundColor = [UIColor colorWithRed:252.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:0.8];
    return picView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
