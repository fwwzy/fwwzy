//
//  MineVC.m
//  Hema
//
//  Created by MsTail on 15/12/23.
//  Copyright © 2015年 Hemaapp. All rights reserved.
//

#import "MineVC.h"
#import "MineMessVC.h"
#import "MinePlaceVC.h"
#import "MineAdressVC.h"
#import "SYContactsPickerController.h"
#import "TwoWeiVC.h"
#import "RechargeVC.h"
#import "MineMoneyVC.h"
#import "MineRedVC.h"
#import "SettingVC.h"
#import "NotShareVC.h"
#import "ShareVC.h"
#import "MineShareVC.h"
#import "MIneGetTre.h"

@interface MineVC ()<UITableViewDataSource,UITableViewDelegate,SYContactsPickerControllerDelegate>{
    UITableView *_tableView;
}

@end

@implementation MineVC

- (void)loadSet {
    //隐藏导航栏
    self.navigationController.navigationBarHidden = YES;
    //导航
    UIView *navView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UI_View_Width, self.view.height/3)];
    //    navView.backgroundColor = [UIColor colorWithRed:217.0/255 green:29.0/255 blue:43.0/255 alpha:1];
    navView.backgroundColor = [UIColor colorWithRed:179.0/255 green:23.0/255 blue:40.0/255 alpha:1];
    navView.userInteractionEnabled = YES;
    [self.view addSubview:navView];
    //标题
    UILabel *loginLbl = [[UILabel alloc] init];
    loginLbl.frame = CGRectMake(UI_View_Width / 2 - 40, 30, 80, 17);
    loginLbl.textColor = BB_White_Color;
    loginLbl.font = [UIFont systemFontOfSize:18];
    loginLbl.text = @"个人中心";
    [navView addSubview:loginLbl];
    //设置
    UIButton *setBtn = [[UIButton alloc]initWithFrame:CGRectMake(UI_View_Width - 33, 27, 25, 25)];
    [setBtn setBackgroundImage:[UIImage imageNamed:@"mine_setting"] forState:UIControlStateNormal];
    [setBtn addTarget:self action:@selector(titleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    setBtn.tag = 60003;
    [navView addSubview: setBtn];
    //头像
    UIImageView *iconView = [[UIImageView alloc]initWithFrame:CGRectMake(UI_View_Width/2-33, 60, 66, 66)];
    [iconView setImage:[UIImage imageNamed:@"mine_icon"]];
    iconView.userInteractionEnabled = YES;
    [navView addSubview:iconView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(iconViewClick)];
    [iconView addGestureRecognizer:tap];
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
    _tableView.backgroundColor =[UIColor colorWithRed:252.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:0.8];
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
            [titleBtn addTarget:self action:@selector(titleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            titleBtn.tag = 60000;
            [cell addSubview:titleBtn];
            
            UIButton *titleBtn1 = [[UIButton alloc]initWithFrame:CGRectMake(150,20 , 23, 27)];
            [titleBtn1 setBackgroundImage:[UIImage imageNamed:@"mine_redbag1"] forState:UIControlStateNormal];
            [titleBtn1 addTarget:self action:@selector(titleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            titleBtn1.tag = 60001;
            [cell addSubview:titleBtn1];
            
            UIButton *titleBtn2 = [[UIButton alloc]initWithFrame:CGRectMake(249, 20, 29, 29)];
            [titleBtn2 setBackgroundImage:[UIImage imageNamed:@"mine_recharge"] forState:UIControlStateNormal];
            [titleBtn2 addTarget:self action:@selector(titleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            titleBtn2.tag = 60002;
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
            [titleBtn addTarget:self action:@selector(mineBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            titleBtn.tag = 100;
            [cell addSubview:titleBtn];
            
            UIButton *titleBtn1 = [[UIButton alloc]initWithFrame: CGRectMake(98, 19, 48, 45)];
            [titleBtn1 setBackgroundImage:[UIImage imageNamed:@"mine_winrecord"] forState:UIControlStateNormal];
            [titleBtn1 addTarget:self action:@selector(mineBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            titleBtn1.tag = 101;
            [cell addSubview:titleBtn1];
            
            UIButton *titleBtn2 = [[UIButton alloc]initWithFrame: CGRectMake(172, 16, 37, 48)];
            [titleBtn2 setBackgroundImage:[UIImage imageNamed:@"mine_bask"] forState:UIControlStateNormal];
            [titleBtn2 addTarget:self action:@selector(mineBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            titleBtn2.tag = 102;
            [cell addSubview:titleBtn2];
            
            UIButton *titleBtn3 = [[UIButton alloc]initWithFrame: CGRectMake(246, 16, 37, 48)];
            [titleBtn3 setBackgroundImage:[UIImage imageNamed:@"mine_unbask"] forState:UIControlStateNormal];
            [titleBtn3 addTarget:self action:@selector(mineBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            titleBtn3.tag = 103;
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
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 2) {
        if (indexPath.row == 1) {
//            FindAddressVC *mac = [[FindAddressVC alloc]init];
//            mac.hidesBottomBarWhenPushed = YES;
//            [self.navigationController pushViewController:mac animated:YES];
            SYContactsPickerController *vcContacts = [[SYContactsPickerController alloc] init];
            vcContacts.delegate = self;
            vcContacts.hidesBottomBarWhenPushed = YES;
            [self presentViewController:vcContacts animated:YES completion:nil];
        }
        if (indexPath.row == 2) {
            TwoWeiVC *tvc = [[TwoWeiVC alloc]init];
            tvc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:tvc animated:YES];
        }
        if (indexPath.row == 3) {
            MinePlaceVC *mpc = [[MinePlaceVC alloc]init];
            mpc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:mpc animated:YES];
        }
    }
    
}
#pragma mark - 点击事件
-(void)iconViewClick{
    MineMessVC *mvc = [[MineMessVC alloc]init];
    mvc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:mvc animated:YES];
}
-(void)titleBtnClick:(UIButton *)sender{
    if (sender.tag == 60000) {
        MineMoneyVC *mmc = [[MineMoneyVC alloc]init];
        mmc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:mmc animated:YES];
    }
    if (sender.tag == 60001) {
        MineRedVC *mrc = [[MineRedVC alloc]init];
        mrc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:mrc animated:YES];
    }
    if (sender.tag == 60002) {
        RechargeVC *rhc = [[RechargeVC alloc]init];
        rhc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:rhc animated:YES];
    }
    if (sender.tag == 60003) {
        SettingVC *stc = [[SettingVC alloc]init];
        stc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:stc animated:YES];
    }
    
}

- (void)mineBtnClick:(UIButton *)sender {
    switch (sender.tag) {
        case 100:{
            MIneGetTre *mgt = [[MIneGetTre alloc]init];
            mgt.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:mgt animated:YES];
        }
            break;
        case 101:{
            NotShareVC *notshareVC = [[NotShareVC alloc] init];
            [self.navigationController pushViewController:notshareVC animated:YES];
        }
            break;
        case 102:{
            ShareVC *shareVC = [[ShareVC alloc] init];
            shareVC.shareType = mineShare;
            [self.navigationController pushViewController:shareVC animated:YES];
        }
            break;
        case 103:{
            NotShareVC *notshareVC = [[NotShareVC alloc] init];
            [self.navigationController pushViewController:notshareVC animated:YES];
        }
            break;
    }
}
- (void)contactsPickerController:(SYContactsPickerController *)picker didFinishPickingContacts:(NSArray *)contacts {
    NSLog(@"contacts==%@",contacts);
}

- (void)contactsPickerController:(SYContactsPickerController *)picker didSelectContacter:(SYContacter *)contacter {
    NSLog(@"contacter==%@",contacter);
}

- (void)contactsPickerController:(SYContactsPickerController *)picker didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"indexPath==%@",indexPath);
}

- (void)contactsPickerControllerDidCancel:(SYContactsPickerController *)picker {
    NSLog(@"contactsPickerControllerDidCancel");
}

@end
