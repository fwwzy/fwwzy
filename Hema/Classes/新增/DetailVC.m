//
//  DetailVC.m
//  Hema
//
//  Created by Lsy on 15/12/25.
//  Copyright © 2015年 Hemaapp. All rights reserved.
//

#import "DetailVC.h"

@interface DetailVC ()

@end

@implementation DetailVC

-(void)loadSet{
    [self.navigationItem setNewTitle:@"奖品详情"];
    //左按钮
    [self.navigationItem setLeftItemWithTarget:self action:@selector(leftbtnPressed:) image:@"lg_back"];
    
    [self reSetTableViewFrame:CGRectMake(0, 0, UI_View_Width, UI_View_Height-49)];
    self.view.backgroundColor = BB_White_Color;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 2;
    }
    if (section == 1) {
        return 2;
    }
    return 3;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
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
    //倒计时
    UILabel *lastLabel = [[UILabel alloc]init];
    //期数
    UILabel *dayLabel = [[UILabel alloc]init];
    //名称
    UILabel *nameLabel = [[UILabel alloc]init];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            lastLabel .frame = CGRectMake(10, 12.5, 35, 15);
            lastLabel.backgroundColor = BB_Red_Color;
            lastLabel.textColor = BB_White_Color;
            lastLabel.text = @"倒计时";
            lastLabel.textAlignment = NSTextAlignmentCenter;
            lastLabel.font = [UIFont systemFontOfSize:10];
            
            dayLabel.frame = CGRectMake(55, 12.5, 50, 15);
            dayLabel.textColor = BB_Gray_Color;
            dayLabel.text = @"第2531期";
            dayLabel.font = [UIFont systemFontOfSize:10];
            
            nameLabel.frame = CGRectMake(110, 10, 150, 20);
            nameLabel.text = @"神火手电筒";
            nameLabel.font = [UIFont systemFontOfSize:15];
        }
        if (indexPath.row == 1) {
            
        }
    }
    [cell addSubview:nameLabel];
    [cell addSubview:dayLabel];
    [cell addSubview:lastLabel];
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
