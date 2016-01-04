//
//  SettingVC.m
//  Hema
//
//  Created by MsTail on 16/1/4.
//  Copyright © 2016年 Hemaapp. All rights reserved.
//

#import "SettingVC.h"
#import "HelpVC.h"
#import "ProtocolVC.h"
#import "RuleVC.h"
#import "AboutVC.h"
#import "SDImageCache.h"
#import "SafeVC.h"
@interface SettingVC () <UITableViewDataSource,UITableViewDelegate>{
    UITableView *_tableView;
    NSMutableArray *_dataSource;
}

@end

@implementation SettingVC

- (void)loadSet {
    
    [self.navigationItem setNewTitle:@"设置"];
    [self.navigationItem setLeftItemWithTarget:self action:@selector(leftbtnPressed:) image:@"lg_back"];
    self.view.backgroundColor = BB_White_Color;
    [self.mytable setSeparatorStyle:UITableViewCellSeparatorStyleNone];

}

- (void)loadData {
    
}

//tableView 代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 7;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 6) {
        return 120;
    }
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    NSArray *iconArr = [NSArray arrayWithObjects:@"hp_help", @"hp_kaijiang",@"sz_safe",@"hp_xieyi",@"hp_clean",@"sz_about",nil];
    NSArray *titleArr = [NSArray arrayWithObjects:@"新手帮助",@"开奖规则",@"安全管理",@"用户协议",@"清除缓存",@"关于", nil];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        if (indexPath.row != 6) {
  
            //icon
            UIImageView *imgView = [[UIImageView alloc] init];
            imgView.frame = CGRectMake(15, 15, 30, 30);
            imgView.image = [UIImage imageNamed:iconArr[indexPath.row]];
            
            //title
            UILabel *titleLbl = [[UILabel alloc] init];
            titleLbl.frame = CGRectMake(60, 19, 200, 20);
            titleLbl.text = titleArr[indexPath.row];
            titleLbl.font = [UIFont systemFontOfSize:16];
            
            //next
            UIButton *nextBtn = [[UIButton alloc] init];
            nextBtn.frame = CGRectMake(UI_View_Width - 35, 20, 7, 14);
            [nextBtn setImage:[UIImage imageNamed:@"mine_next"] forState:UIControlStateNormal];
            
            //分割线
            UILabel *sepLbl = [[UILabel alloc] init];
            sepLbl.frame = CGRectMake(60, 59, UI_View_Width - 70, 1);
            sepLbl.backgroundColor = BB_Gray_Color;
            sepLbl.alpha = 0.3;
            
            [cell.contentView addSubview:imgView];
            [cell.contentView addSubview:titleLbl];
            [cell.contentView addSubview:nextBtn];
            [cell.contentView addSubview:sepLbl];
        
        } else {
            
            //退出登录
            UIButton *outBtn = [[UIButton alloc] init];
            outBtn.frame = CGRectMake(45, 60, UI_View_Width - 90, 40);
            [outBtn setTitle:@"退出登录" forState:UIControlStateNormal];
            [outBtn setTitleColor:BB_White_Color forState:UIControlStateNormal];
            [outBtn setBackgroundColor:RGB_UI_COLOR(217, 29, 43)];
            [cell.contentView addSubview:outBtn];
        }
        
        
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:{
            HelpVC *helpVC = [[HelpVC alloc] init];
            [self.navigationController pushViewController:helpVC animated:YES];
        }
            break;
        case 1:{
            RuleVC *ruleVC = [[RuleVC alloc] init];
            [self.navigationController pushViewController:ruleVC animated:YES];
        }
            break;
        case 2:{
            SafeVC *safeVC = [[SafeVC alloc] init];
            [self.navigationController pushViewController:safeVC animated:YES];
        }
            break;
        case 3:{
            ProtocolVC *protocolVC = [[ProtocolVC alloc] init];
            [self.navigationController pushViewController:protocolVC animated:YES];
        }
            break;
        case 4:{
            NSString *avatarDocument = [NSString stringWithFormat:@"%@/%@",BB_CASH_DOCUMENT,BB_CASH_AVATAR];
            [[HemaCashManager sharedManager] removeDocument:avatarDocument];
            NSString *audioDocument = [NSString stringWithFormat:@"%@/%@",BB_CASH_DOCUMENT,BB_CASH_AUDIO];
            [[HemaCashManager sharedManager] removeDocument:audioDocument];
            NSString *videoDocument = [NSString stringWithFormat:@"%@/%@",BB_CASH_DOCUMENT,BB_CASH_VIDEO];
            [[HemaCashManager sharedManager] removeDocument:videoDocument];
            
            [SDImageCache.sharedImageCache clearMemory];
            [SDImageCache.sharedImageCache clearDisk];
            [SDImageCache.sharedImageCache cleanDisk];
            
            [HemaFunction openIntervalHUDOK:@"已经成功删除缓存"];
            
            [self performSelector:@selector(reShowView) withObject:nil afterDelay:0.5];
        }
            break;
        case 5:{
            AboutVC *aboutVC = [[AboutVC alloc] init];
            [self.navigationController pushViewController:aboutVC animated:YES];
        }
            break;
    }
}

-(void)reShowView
{
    [self.mytable reloadData];
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
