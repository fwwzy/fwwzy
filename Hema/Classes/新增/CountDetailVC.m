//
//  CountDetailVC.m
//  Hema
//
//  Created by Lsy on 15/12/29.
//  Copyright © 2015年 Hemaapp. All rights reserved.
//

#import "CountDetailVC.h"

@interface CountDetailVC ()

@end

@implementation CountDetailVC

-(void)loadSet{
    [self.navigationItem setNewTitle:@"计算详情"];
    //左按钮
    [self.navigationItem setLeftItemWithTarget:self action:@selector(leftbtnPressed:) image:@"lg_back"];
    [self reSetTableViewFrame:CGRectMake(0, 0, UI_View_Width, UI_View_Height)];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 150;
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
    //名字
    UILabel *nameLabel = [[UILabel alloc]init];
    if (indexPath.section == 0) {
        UIImageView *countView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 15, 65, 15)];
        [countView setImage:[UIImage imageNamed:@"np_count"]];
        [cell addSubview:countView];
        
        nameLabel.frame = CGRectMake(20, 40, 280, 20);
        nameLabel.text = @"（数值B÷数值A）取余数+10000000001";
        nameLabel.font = [UIFont systemFontOfSize:15];
        
        UIButton *countBtn = [[UIButton alloc]initWithFrame:CGRectMake(120, 90, 80, 30)];
        countBtn.backgroundColor = BB_Red_Color;
        [countBtn setTitle:@"计算详情" forState:UIControlStateNormal];
        countBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [cell addSubview:countBtn];
    }
    [cell addSubview:nameLabel];
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *picView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 10)];
    picView.backgroundColor = [UIColor colorWithRed:252.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:0.8];
    return picView;
}
@end
