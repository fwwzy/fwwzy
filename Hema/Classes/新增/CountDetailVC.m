//
//  CountDetailVC.m
//  Hema
//
//  Created by Lsy on 15/12/29.
//  Copyright © 2015年 Hemaapp. All rights reserved.
//

#import "CountDetailVC.h"

@interface CountDetailVC (){
    BOOL _close;
    UIView *_blackView;
}

@end

@implementation CountDetailVC

-(void)loadSet{
    _close = YES;
    [self.navigationItem setNewTitle:@"计算详情"];
    //左按钮
    [self.navigationItem setLeftItemWithTarget:self action:@selector(leftbtnPressed:) image:@"lg_back"];
    [self reSetTableViewFrame:CGRectMake(0, 0, UI_View_Width, UI_View_Height)];
    //计算方式
    _blackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UI_View_Width, UI_View_Height+80)];
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:_blackView];
    _blackView.userInteractionEnabled = YES;
    _blackView.hidden = YES;
    
    UIImageView *blackView1 = [[UIImageView alloc]initWithFrame:_blackView.frame];
    [blackView1 setImage:[UIImage imageNamed:@"np_blackView"]];
    [_blackView addSubview:blackView1];
    blackView1.userInteractionEnabled = YES;
    
    UIView *medoView = [[UIView alloc]initWithFrame:CGRectMake(UI_View_Width/8, _blackView.height/4, UI_View_Width*3/4, _blackView.height/2)];
    medoView.backgroundColor = BB_White_Color;
    [blackView1 addSubview:medoView];
    
//    UILabel *medoLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, medoView.width, medoView.height/8)];
//    medoLabel.backgroundColor = BB_Back_Color_Here;
//    medoLabel.text = @"幸运号码计算方式";
//    medoLabel.font = [UIFont systemFontOfSize:16];
//    medoLabel.textAlignment = NSTextAlignmentCenter;
//    [medoView addSubview:medoLabel];
    
    UIButton *medoBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, medoView.height - medoView.height/8, medoView.width, medoView.height/8)];
    medoBtn.backgroundColor = [UIColor clearColor];
    [medoBtn addTarget:self action:@selector(medoBtnClcik) forControlEvents:UIControlEventTouchUpInside];
    [medoView addSubview:medoBtn];
    
    UIImageView *medoimageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, medoView.width, medoView.height)];
    [medoimageView setImage:[UIImage imageNamed:@"np_countmedo"]];
    [medoView addSubview:medoimageView];
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 3) {
        return 4;
    }
    return 1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 150;
    }
    if (indexPath.section == 1) {
        return 70;
    }
    if (indexPath.section == 2) {
        return 100;
    }
    if (indexPath.section == 3) {
        if (indexPath.row == 0) {
            return 120;
        }
        if (indexPath.row == 1) {
            return 40;
        }
        if (indexPath.row == 2) {
            if (_close) {
                return 120;
            }else{
                return 120+((4-1)*20);
            }
        }
    }
    return 10;
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
    //标题
    UIImageView *countView = [[UIImageView alloc]init];
    //号码
    UILabel *numLabel = [[UILabel alloc]init];
    if (indexPath.section == 0) {
        countView.frame = CGRectMake(15, 15, 65, 15);
        [countView setImage:[UIImage imageNamed:@"np_count"]];

        
        nameLabel.frame = CGRectMake(20, 40, 280, 20);
        nameLabel.text = @"（数值B÷数值A）取余数+10000000001";
        nameLabel.font = [UIFont systemFontOfSize:15];
        
        UIButton *countBtn = [[UIButton alloc]initWithFrame:CGRectMake(120, 90, 80, 30)];
        countBtn.backgroundColor = BB_Red_Color;
        [countBtn setTitle:@"计算方式" forState:UIControlStateNormal];
        countBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [countBtn addTarget:self action:@selector(countBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:countBtn];
    }
    if (indexPath.section == 1) {
        countView.frame = CGRectMake(15, 15, 65, 15);
        [countView setImage:[UIImage imageNamed:@"np_countResult"]];
        
        nameLabel.frame = CGRectMake(15, 40, 65, 15);
        nameLabel.text = @"幸运号码";
        nameLabel.font =[UIFont systemFontOfSize:14];
        
        numLabel.frame = CGRectMake(80, 40, 150, 15);
        numLabel.text = @"100086018";
        numLabel.textColor = BB_Red_Color;
        numLabel.font = [UIFont systemFontOfSize:18];
    }
    if (indexPath.section == 2) {
        countView.frame = CGRectMake(15, 15, 40, 15);
        [countView setImage:[UIImage imageNamed:@"np_numberA"]];
        
        nameLabel.frame = CGRectMake(15, 40, 150, 15);
        nameLabel.text = @"=奖品所需人次";
        nameLabel.font = [UIFont systemFontOfSize:18];
        
        numLabel.frame = CGRectMake(15, 65, 150, 15);
        numLabel.text = @"=621";
        numLabel.font = [UIFont systemFontOfSize:18];
    }
    if (indexPath.section == 3) {
        if (indexPath.row == 0) {
            countView.frame = CGRectMake(15, 15, 40, 15);
            [countView setImage:[UIImage imageNamed:@"np_numberB"]];
            
            nameLabel.frame = CGRectMake(15, 40, 290, 80);
            nameLabel.numberOfLines = 4;
            nameLabel.text = @"=截止至奖品的最后一个号码分配完毕后的150秒，该时间点前最后60条本站参与记录的中间50秒参与时间=800004784451";
            nameLabel.font = [UIFont systemFontOfSize:16];
        }
        if (indexPath.row == 1) {
            nameLabel.frame = CGRectMake(15, 10, 70, 20);
            nameLabel.text = @"夺宝时间";
            nameLabel.font = [UIFont systemFontOfSize:16];
            
            numLabel.frame = CGRectMake(cell.width-85, 10, 70, 20);
            numLabel.text = @"用户账号";
            numLabel.font = [UIFont systemFontOfSize:16];
        }
        if (indexPath.row == 2) {
            cell.backgroundColor = BB_Back_Color_Here;
            for (int i = 0; i<4; i++) {
                UILabel *allLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 10+i*20, 290, 15)];
                allLabel.text = @"2015-12-07 16:01:47.619>160147619      18253162058";
                allLabel.font = [UIFont systemFontOfSize:11];
                [cell addSubview:allLabel];
            }
            UIButton *openBtn = [[UIButton alloc]initWithFrame:CGRectMake(cell.width - 50, 90, 35, 10)];
            [openBtn setBackgroundImage:[UIImage imageNamed:@"np_countOpen"] forState:UIControlStateNormal];
            [openBtn addTarget:self action:@selector(openClick:) forControlEvents:UIControlEventTouchUpInside];
            if (!_close) {
                openBtn.hidden = YES;
            }
            [cell addSubview:openBtn];
            
            for (int i = 0; i<4; i++) {
                UILabel *allLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 90 + i*20, 290, 15)];
                allLabel.text = @"2015-12-07 16:01:47.619>160147619      18253162058";
                allLabel.font = [UIFont systemFontOfSize:11];
                allLabel.tag = 30000+i;
                if (_close) {
                    allLabel.hidden = YES;
                }else{
                    allLabel.hidden = NO;
                }
                [cell addSubview:allLabel];
            }
            
        }
    }
    [cell addSubview:nameLabel];
    [cell addSubview:countView];
    [cell addSubview:numLabel];
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
#pragma mark - 事件
-(void)openClick:(UIButton *)sender{
    if (_close) {
        _close = !_close;
        NSLog(@"%zd",sender.tag);
    }
    [self.mytable reloadData];
}
-(void)countBtnClick{
    _blackView.hidden = NO;
}
@end
