//
//  MinePlaceVC.m
//  Hema
//
//  Created by Lsy on 16/1/4.
//  Copyright © 2016年 Hemaapp. All rights reserved.
//

#import "MinePlaceVC.h"
#import "MIneWritePlaceVC.h"

@interface MinePlaceVC ()<UITableViewDataSource,UITableViewDelegate>{
    UITableView *_tableView;
    NSMutableArray *_dataArr;
    NSMutableDictionary *_dateDic;
}

@end

@implementation MinePlaceVC

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
}

-(void)loadSet{
    [self.navigationItem setNewTitle:@"收货地址"];
    _dataArr = [[NSMutableArray alloc]init];
    _dateDic = [[NSMutableDictionary alloc]init];
    //左按钮
    [self.navigationItem setLeftItemWithTarget:self action:@selector(leftbtnPressed:) image:@"lg_back"];
    [self.navigationItem setRightItemWithTarget:self action:@selector(rightbtnClick:) image:@"mine_placeadd"];
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
    
    
    UIImageView *bgimgView = [[UIImageView alloc]initWithFrame:bgView.frame];
    [bgimgView setImage:[UIImage imageNamed:@"np_blackView"]];
    [bgView addSubview:bgimgView];
    
    UIImageView *arrowView = [[UIImageView alloc]initWithFrame:CGRectMake(UI_View_Width -100, 0, 65, 103)];
    [arrowView setImage:[UIImage imageNamed:@"mine_placejiantou1"]];
    [bgimgView addSubview:arrowView];
    
    UIImageView *squareView = [[UIImageView alloc]initWithFrame:CGRectMake(UI_View_Width -160, 108, 130, 40)];
    [squareView setImage:[UIImage imageNamed:@"mine_placekuang"]];
    [bgimgView addSubview:squareView];
    
    UILabel *placeLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 110, 40)];
    placeLabel.text = @"请输入收货地址";
    placeLabel.textColor = BB_White_Color;
    placeLabel.textAlignment = NSTextAlignmentCenter;
    placeLabel.font = [UIFont systemFontOfSize:15];
    [squareView addSubview:placeLabel];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, UI_View_Width, UI_View_Height)];
    _tableView.delegate =self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    _tableView.backgroundColor = [UIColor colorWithRed:252.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1];
    [self.view addSubview:_tableView];
    [self.view addSubview:bgView];
    bgView.hidden = YES;
    self.blockDic = ^(NSMutableDictionary *data){
        [_dataArr addObject:data];
        [_tableView reloadData];
        bgView.hidden = YES;
    };
    if (_dataArr.count == 0) {
        bgView.hidden = NO;
    }
}
-(void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSLog(@"%zd",_dataArr.count);
    return _dataArr.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_dataArr.count ==0) {
        return 0;
    }
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_dataArr.count == 0) {
        return 0;
    }
    return 120;
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
    //名称
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 15, 100, 20)];
    nameLabel.font = [UIFont systemFontOfSize:15];
    nameLabel.text = [[_dataArr objectAtIndex:indexPath.section] objectForKey:@"name"];
    [cell addSubview:nameLabel];
    //手机号
    UILabel *phoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(115, 15, 150, 20)];
    phoneLabel.font = [UIFont systemFontOfSize:15];
    phoneLabel.text =[[_dataArr objectAtIndex:indexPath.section] objectForKey:@"phone"];
    [cell addSubview:phoneLabel];
    //地址
    UILabel *placeLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 35, UI_View_Width - 30, 40)];
    placeLabel.font = [UIFont systemFontOfSize:15];
    placeLabel.numberOfLines = 2;
//    placeLabel.textColor = BB_Gray_Color;
    NSString *addressStr = [[_dataArr objectAtIndex:indexPath.section] objectForKey:@"address"];
    NSString *address = [addressStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    placeLabel.text = [NSString stringWithFormat:@"%@%@",address,[[_dataArr objectAtIndex:indexPath.section] objectForKey:@"place"]];
    [cell addSubview:placeLabel];
   
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
-(void)rightbtnClick:(UIButton *)sender{
    MIneWritePlaceVC *mwp = [[MIneWritePlaceVC alloc]init];
    mwp.blockDic = self.blockDic;
    [self.navigationController pushViewController:mwp animated:YES];
}

@end
