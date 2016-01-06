//
//  TwoWeiVC.m
//  Hema
//
//  Created by Lsy on 16/1/6.
//  Copyright © 2016年 Hemaapp. All rights reserved.
//

#import "TwoWeiVC.h"


@interface TwoWeiVC ()

@end

@implementation TwoWeiVC

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
}

-(void)loadSet{
    
    [self.navigationItem setNewTitle:@"我的二维码"];
    
    [self.navigationItem setLeftItemWithTarget:self action:@selector(leftbtnPressed:) image:@"lg_back"];
    
    UILabel *myLabel = [[UILabel alloc]initWithFrame:CGRectMake((UI_View_Width- UI_View_Width/1.5)/2, self.view.height/5, UI_View_Width/1.5, 20)];
//    UILabel *myLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 100, 100, 20)];
    myLabel.textAlignment = NSTextAlignmentCenter;
    myLabel.text = @"邀请好友扫一扫，返利赚不停";
    myLabel.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:myLabel];
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(UI_View_Width/4, self.view.height/5+40, UI_View_Width/2, UI_View_Width/2)];
    view.layer.borderWidth = 1;
    view.layer.borderColor = [BB_Red_Color CGColor];
    [self.view addSubview:view];
    
    UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(20, 20, view.width-40 , view.height-40)];
    img.image = [HemaFunction generateQRCode:@"www.baidu.com" width:100 height:100];
    [view addSubview:img];
}

-(void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;
}


@end
