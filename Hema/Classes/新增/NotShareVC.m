//
//  NotShareVC.m
//  Hema
//
//  Created by MsTail on 16/1/6.
//  Copyright © 2016年 Hemaapp. All rights reserved.
//

#import "NotShareVC.h"
#import "CountDetailVC.h"
#import "MineShareVC.h"


@interface NotShareVC () {
    NSInteger _count; //模拟删除
}

@end

@implementation NotShareVC

- (void)loadSet {
    
    [self.navigationItem setNewTitle:@"未晒单"];
    [self.navigationItem setLeftItemWithTarget:self action:@selector(leftbtnPressed:) image:@"lg_back"];
    self.view.backgroundColor = RGB_UI_COLOR(255, 246, 244);
    [self.mytable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    _count = 5;
}

- (void)loadData {
    
}

//tableView 代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  
    return 275;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"notShareCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        //时间
        UILabel *timeLbl = [[UILabel alloc] init];
        timeLbl.frame = CGRectMake(0, 0, 250, 20);
        timeLbl.center = CGPointMake(self.view.width / 2, 30);
        timeLbl.textColor = RGB_UI_COLOR(91, 91, 91);
        timeLbl.textAlignment = NSTextAlignmentCenter;
        timeLbl.font = [UIFont systemFontOfSize:16];
        timeLbl.text = @"2015-12-07 12:25:36";
        [cell.contentView addSubview:timeLbl];
        
        //分割线
        UILabel *sepLbl = [[UILabel alloc] init];
        sepLbl.frame = CGRectMake(0, 0, 230, 1);
        sepLbl.center = CGPointMake(self.view.width / 2, 50);
        sepLbl.backgroundColor = BB_Gray_Color;
        sepLbl.alpha = 0.3;
        [cell.contentView addSubview:sepLbl];
        
        //背景
        UIImageView *bgView = [[UIImageView alloc]init];
        bgView.frame = CGRectMake(15, 70, UI_View_Width - 30, 145);
        [bgView setImage:[UIImage imageNamed:@"biankuang_03"]];
        bgView.userInteractionEnabled = YES;
        
        UIImageView *winView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 15, 40, 40)];
        [winView setImage:[UIImage imageNamed:@"np_detailicon"]];
        [bgView addSubview:winView];
        
        UILabel *winLabel = [[UILabel alloc]initWithFrame:CGRectMake(65, 18, 150, 15)];
        winLabel.text = @"获奖者：18532625352";
        //            winLabel.textColor = BB_Gray_Color;
        winLabel.font = [UIFont systemFontOfSize:13];
        [bgView addSubview:winLabel];
        
        UILabel *IPLabel = [[UILabel alloc]initWithFrame:CGRectMake(65, 35, 230, 15)];
        IPLabel.text = @"用户IP：221.2.71.110（山东济南）";
        //            IPLabel.textColor = BB_Gray_Color;
        IPLabel.font = [UIFont systemFontOfSize:13];
        [bgView addSubview:IPLabel];
        
        UILabel *winerLabel = [[UILabel alloc]initWithFrame:CGRectMake(65, 52, 200, 15)];
        //            winerLabel.textColor = BB_Gray_Color;
        winerLabel.font = [UIFont systemFontOfSize:13];
        NSString *myStr = @"参与次数：3人次";
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:myStr];
        NSRange range = [myStr rangeOfString:@"3"];
        UIColor *color = BB_Red_Color;
        [attrString addAttribute:NSForegroundColorAttributeName value:color range:range];
        winerLabel.attributedText = attrString;
        [bgView addSubview:winerLabel];
        
        UILabel *winDayLabel = [[UILabel alloc]initWithFrame:CGRectMake(65, 69, 240, 15)];
        winDayLabel.text = @"揭晓时间：2015-12-08 12:35:25:102";
        //            winDayLabel.textColor = BB_Gray_Color;
        winDayLabel.font = [UIFont systemFontOfSize:13];
        [bgView addSubview:winDayLabel];
        
        UIView *grayView = [[UIView alloc]initWithFrame:CGRectMake(0, 100, bgView.width, 45)];
        grayView.backgroundColor = BB_Back_Color_Here;
        [bgView addSubview:grayView];
        
        UILabel *luckLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 15, 60, 15)];
        luckLabel.textColor = BB_Gray_Color;
        luckLabel.text = @"幸运号：";
        luckLabel.font = [UIFont systemFontOfSize:13];
        [grayView addSubview:luckLabel];
        
        UILabel *luckNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(70, 15, 100, 15)];
        luckNumLabel.textColor = BB_Red_Color;
        luckNumLabel.text = @"100000095";
        luckNumLabel.font = [UIFont systemFontOfSize:15];
        [grayView addSubview:luckNumLabel];
        
        UIButton *countBtn = [[UIButton alloc]initWithFrame:CGRectMake(bgView.size.width - 80, 12, 60, 25)];
        countBtn.backgroundColor = BB_Red_Color;
        [countBtn setTitle:@"计算详情" forState:UIControlStateNormal];
        countBtn.titleLabel.font = [UIFont systemFontOfSize:11];
        [countBtn addTarget:self action:@selector(countBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [grayView addSubview:countBtn];
        
        [bgView addSubview:grayView];
        [cell.contentView addSubview:bgView];
        
        //删除
        UIButton *deleteBtn = [[UIButton alloc] init];
        deleteBtn.frame = CGRectMake(UI_View_Width - 150, 235, 60, 30);
        [deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
        [HemaFunction addbordertoView:deleteBtn radius:0 width:0.8 color:BB_Gray_Color];
        [deleteBtn setTitleColor:BB_Gray_Color forState:UIControlStateNormal];
        [deleteBtn addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [deleteBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        deleteBtn.tag = indexPath.row;
        [cell.contentView addSubview:deleteBtn];
        
        //去晒单
        UIButton *shareBtn = [[UIButton alloc] init];
        shareBtn.frame = CGRectMake(UI_View_Width - 75, 235, 60, 30);
        [shareBtn setTitle:@"去晒单" forState:UIControlStateNormal];
        [shareBtn setTitleColor:BB_White_Color forState:UIControlStateNormal];
        [shareBtn setBackgroundColor:RGB_UI_COLOR(236, 88, 102)];
        [shareBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [shareBtn addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:shareBtn];
        
        //footer
        UILabel *footerView = [[UILabel alloc] init];
        footerView.frame = CGRectMake(0, 280, UI_View_Width, 10);
        footerView.backgroundColor = RGB_UI_COLOR(255, 246, 244);
        [cell.contentView addSubview:footerView];
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.tag = 100 + indexPath.row;
    return cell;
}

-(void)countBtnClick{
    CountDetailVC *cvc = [[CountDetailVC alloc]init];
    [self.navigationController pushViewController:cvc animated:YES];
}

//晒单点击事件
- (void)shareBtnClick:(UIButton *)sender {
    MineShareVC *mineShare = [[MineShareVC alloc] init];
    [self.navigationController pushViewController:mineShare animated:YES];
//    ShareVC *shareVC = [[ShareVC alloc] init];
//    shareVC.shareType = mineShare;
//    [self.navigationController pushViewController:shareVC animated:YES];
}

//删除点击事件
- (void)deleteBtnClick:(UIButton *)sender {
    UITableViewCell *cell = (UITableViewCell *)[self.view viewWithTag:100 + sender.tag];
     _count--;
    [cell removeFromSuperview];
    [self.mytable reloadData];
   
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
