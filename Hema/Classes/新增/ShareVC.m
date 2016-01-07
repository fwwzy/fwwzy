//
//  ShareVC.m
//  Hema
//
//  Created by MsTail on 15/12/28.
//  Copyright © 2015年 Hemaapp. All rights reserved.
//

#import "ShareVC.h"
#import "ShareDetailVC.h"

@interface ShareVC () {
    NSInteger _count;
    UIImageView *_backView;
}

@end

@implementation ShareVC

- (void)viewWillDisappear:(BOOL)animated {
    if (self.shareType == mineShare) {
        self.navigationController.navigationBarHidden = YES;
    }
}
- (void)viewWillAppear:(BOOL)animated {
    if (self.shareType == mineShare) {
        self.navigationController.navigationBarHidden = NO;
    }
}

- (void)loadData {
    _count = 5;
}

- (void)loadSet {
    [self.navigationItem setNewTitle:@"晒单"];
    [self.navigationItem setLeftItemWithTarget:self action:@selector(leftbtnPressed:) image:@"lg_back"];
    [self.mytable setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.shareType == mineShare) {
        return 335;
    }
    return 280;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"shareCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        //头像
        HemaImgView *iconView = [[HemaImgView alloc] init];
        iconView.frame = CGRectMake(15, 15, 40, 40);
        [HemaFunction addbordertoView:iconView radius:20 width:0 color:nil];
        iconView.image = [UIImage imageNamed:@"newpulish"];
        iconView.tag = 1;
        
        //用户名
        UILabel *userName = [[UILabel alloc] init];
        userName.frame = CGRectMake(70, 30, UI_View_Width - 150, 20);
        userName.font = [UIFont systemFontOfSize:14];
        userName.text = @"亓化泽(假肢)";
        userName.tag = 2;
        
        //时间
        UILabel *timeLbl = [[UILabel alloc] init];
        timeLbl.frame = CGRectMake(UI_View_Width - 150, 30, 140, 20);
        timeLbl.textAlignment = NSTextAlignmentRight;
        timeLbl.font = [UIFont systemFontOfSize:12];
        timeLbl.textColor = BB_Gray_Color;
        timeLbl.text = @"2014-02-25";
        timeLbl.tag = 3;
        
        //分享view
        HemaImgView *view = [[HemaImgView alloc] init];
        view.frame = CGRectMake(15, 60, UI_View_Width - 30, (130 + (UI_View_Width - 30) / 4.8));
        view.image = [UIImage imageNamed:@"hp_view"];
        view.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewClick:)];
        [view addGestureRecognizer:tapGR];
        
        //商品名称
        UILabel *goodsName = [[UILabel alloc] init];
        goodsName.frame = CGRectMake(15, 15, UI_View_Width - 100, 25);
        goodsName.font = [UIFont systemFontOfSize:17];
        goodsName.text = @"LOL无敌账号";
        goodsName.tag = 4;
        
        //商品详情
        UILabel *goodsDetail = [[UILabel alloc] init];
        goodsDetail.frame = CGRectMake(15, 40, UI_View_Width - 100, 20);
        goodsDetail.font = [UIFont systemFontOfSize:13];
        goodsDetail.textColor = BB_Gray_Color;
        goodsDetail.text = @"(第2531期)英雄联盟全英雄全皮肤账号";
        goodsDetail.tag = 5;
        
        //晒单评价
        UILabel *appraiseLbl = [[UILabel alloc] init];
        appraiseLbl.frame = CGRectMake(15, 75, UI_View_Width - 100, 20);
        appraiseLbl.font = [UIFont systemFontOfSize:15];
        appraiseLbl.text = @"太爽辣，我又可以装逼辣";
        appraiseLbl.lineBreakMode = NSLineBreakByTruncatingTail;
        appraiseLbl.tag = 6;
        
        NSArray *imgArr = @[@"newpulish",@"newpulish",@"newpulish",@"newpulish"];
        //晒单图片
        for (int i = 0; i < 4; i++) {
            HemaImgView *shareImg = [[HemaImgView alloc] init];
            shareImg.frame = CGRectMake(15 + view.size.width / 4.3 * i, 110, view.size.width / 4.8, view.size.width / 4.8);
            shareImg.image = [UIImage imageNamed:imgArr[i]];
            [view addSubview:shareImg];
        }
        
        //我的分享 shareType = mineShare;
        //删除
        if (self.shareType == mineShare) {
       
        UIButton *deleteBtn = [[UIButton alloc] init];
        deleteBtn.frame = CGRectMake(UI_View_Width - 150, 280, 60, 30);
        [deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
        [HemaFunction addbordertoView:deleteBtn radius:0 width:0.8 color:BB_Gray_Color];
        [deleteBtn setTitleColor:BB_Gray_Color forState:UIControlStateNormal];
        [deleteBtn addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [deleteBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        deleteBtn.tag = indexPath.row;
        [cell.contentView addSubview:deleteBtn];
        
        //去晒单
        UIButton *shareBtn = [[UIButton alloc] init];
        shareBtn.frame = CGRectMake(UI_View_Width - 75, 280, 60, 30);
        [shareBtn setTitle:@"分享" forState:UIControlStateNormal];
        [shareBtn setTitleColor:BB_White_Color forState:UIControlStateNormal];
        [shareBtn setBackgroundColor:RGB_UI_COLOR(243, 182, 6)];
        [shareBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [shareBtn addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:shareBtn];
            
        //footer
        UILabel *footerView = [[UILabel alloc] init];
        footerView.frame = CGRectMake(0, 325, UI_View_Width, 10);
        footerView.backgroundColor = RGB_UI_COLOR(255, 246, 244);
        [cell.contentView addSubview:footerView];
            
        }
        
        [cell.contentView addSubview:iconView];
        [cell.contentView addSubview:userName];
        [cell.contentView addSubview:timeLbl];
        [view addSubview:goodsName];
        [view addSubview:goodsDetail];
        [view addSubview:appraiseLbl];
        [cell.contentView addSubview:view];
       
    }
    
    //赋值
//    UIImageView *iconView = (UIImageView *)[cell viewWithTag:1];
//    UILabel *titleLbl = (UILabel *)[cell viewWithTag:2];
//    UILabel *timeLbl = (UILabel *)[cell viewWithTag:3];
//    UILabel *goodsNameLbl = (UILabel *)[cell viewWithTag:4];
//    UILabel *goodsDetailLbl = (UILabel *)[cell viewWithTag:5];
//    UILabel *appraiseLbl = (UILabel *)[cell viewWithTag:6];
    
    cell.tag = 100 + indexPath.row;
    return cell;
}

//晒单view点击进入详情
- (void)viewClick:(UITapGestureRecognizer *)gesture {
    
    ShareDetailVC *shareDetailVC = [[ShareDetailVC alloc] init];
    [self.navigationController pushViewController:shareDetailVC animated:YES];
}

//删除点击事件
- (void)deleteBtnClick:(UIButton *)sender {
    UITableViewCell *cell = (UITableViewCell *)[self.view viewWithTag:100 + sender.tag];
    _count--;
    [cell removeFromSuperview];
    [self.mytable reloadData];
    
}

- (void)shareBtnClick:(UIButton *)sender {
    UIView *shareView = [[UIView alloc] init];
    shareView.frame = CGRectMake(0, self.view.height - 90, UI_View_Width, 156);
    shareView.userInteractionEnabled = YES;
    shareView.backgroundColor = BB_White_Color;
    
    if (_backView) {
        _backView.hidden = NO;
    } else {
    _backView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, UI_View_Width, self.view.height + 80)];
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    _backView.image = [UIImage imageNamed:@"np_blackView"];
    _backView.userInteractionEnabled = YES;
    [window addSubview:_backView];
    
    NSArray *titleArr = @[@"QQ",@"微信好友",@"朋友圈",@"新浪"];
    NSArray *imgArr = @[@"lg_qq",@"lg_wx",@"share_pyq",@"lg_sina"];
    for (int i = 0; i < 4; i++) {
        UIButton *shareBtn = [[UIButton alloc] init];
        shareBtn.frame = CGRectMake(self.view.width / 10 + UI_View_Width / 4.5 * i, 20, 40, 40);
        [shareBtn setImage:[UIImage imageNamed:imgArr[i] ] forState:UIControlStateNormal];
        
        UILabel *thirdName = [[UILabel alloc] init];
        thirdName.frame = CGRectMake(self.view.width / 10 + UI_View_Width / 4.5 * i, 55, 45, 40);
        thirdName.center = CGPointMake(shareBtn.center.x, shareBtn.center.y + 35);
        thirdName.text = [titleArr objectAtIndex:i];
        thirdName.font = [UIFont systemFontOfSize:11];
        thirdName.textAlignment = NSTextAlignmentCenter;
        [shareView addSubview:thirdName];
        [shareView addSubview:shareBtn];
    }
    
    //取消按钮
    UIButton *cancelBtn = [[UIButton alloc] init];
    cancelBtn.frame = CGRectMake(0, 110, UI_View_Width, 46);
    cancelBtn.backgroundColor = RGB_UI_COLOR(245, 245, 245);
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [cancelBtn setTitleColor:BB_Red_Color forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [shareView addSubview:cancelBtn];
    
    [_backView addSubview:shareView];
    }
    
}

- (void)cancelBtnClick:(UIButton *)sender {
    _backView.hidden = YES;
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
