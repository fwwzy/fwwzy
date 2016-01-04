//
//  MinePlaceVC.m
//  Hema
//
//  Created by Lsy on 16/1/4.
//  Copyright © 2016年 Hemaapp. All rights reserved.
//

#import "MinePlaceVC.h"

@interface MinePlaceVC ()

@end

@implementation MinePlaceVC

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
}

-(void)loadSet{
    [self.navigationItem setNewTitle:@"收货地址"];
    //左按钮
    [self.navigationItem setLeftItemWithTarget:self action:@selector(leftbtnPressed:) image:@"lg_back"];
    [self.navigationItem setRightItemWithTarget:self action:@selector(rightbtnClick:) image:@"mine_placeadd"];
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
    [self.view addSubview:bgView];
    
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
}

-(void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;
}
#pragma mark - 事件
-(void)rightbtnClick:(UIButton *)sender{
    
}

@end
