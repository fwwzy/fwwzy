//
//  ClassifyListVC.m
//  Hema
//
//  Created by MsTail on 15/12/29.
//  Copyright © 2015年 Hemaapp. All rights reserved.
//

#import "ClassifyListVC.h"
#import "PrizeDetailVC.h"
#import "SumbitOrderVC.h"

@interface ClassifyListVC ()

@end

@implementation ClassifyListVC

- (void)loadSet {
    [self.navigationItem setNewTitle:self.titleName];
    [self.navigationItem setLeftItemWithTarget:self action:@selector(leftbtnPressed:) image:@"lg_back"];
    [self.mytable setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
}

- (void)loadData {
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.view.width / 2.5 + 30;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"classifyListCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        //商品图片
        HemaImgView *iconView = [[HemaImgView alloc] init];
        iconView.frame = CGRectMake(15, 15, self.view.width / 2.5, self.view.width / 2.5);
        iconView.image = [UIImage imageNamed:@"newpulish"];
        iconView.tag = 1;
        
        //商品名称
        UILabel *userName = [[UILabel alloc] init];
        userName.frame = CGRectMake(30 + self.view.width / 2.5, 15, UI_View_Width - self.view.width / 2.5 - 40, iconView.size.height / 3);
        userName.lineBreakMode = NSLineBreakByTruncatingTail;
        userName.numberOfLines = 0;
        userName.font = [UIFont systemFontOfSize:16];
        userName.text = @"Apple ipad mini 4 64G(颜色随机唯一的不同.....)";
        userName.tag = 2;
        
        //已参与
        UILabel *joinLbl =[[UILabel alloc] init];
        joinLbl.font = [UIFont systemFontOfSize:13];
        joinLbl.textColor = BB_Gray_Color;
        NSString *joinString = [NSString stringWithFormat:@"%zd",15410];
        NSString *joinText =[NSString stringWithFormat:@"已参与:%@",joinString];
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:joinText];
        NSRange range = [joinText rangeOfString:joinString];
        UIColor *color = RGB_UI_COLOR(1, 182, 159);
        [attrString addAttribute:NSForegroundColorAttributeName value:color range:range];
        joinLbl.attributedText = attrString;
        joinLbl.tag = 3;
        
        NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:13]};
        CGSize sizeTitle = [joinLbl.text boundingRectWithSize:CGSizeMake(MAXFLOAT, iconView.size.height / 4.5)  options:NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil].size;
        joinLbl.frame = CGRectMake(userName.origin.x, userName.origin.y + userName.size.height, sizeTitle.width, iconView.size.height / 4.5);
        
        //剩余
        UILabel *remainLbl =[[UILabel alloc] init];
        remainLbl.font = [UIFont systemFontOfSize:13];
        remainLbl.textColor = BB_Gray_Color;
        NSString *remainString = [NSString stringWithFormat:@"%zd",15410];
        NSString *remainText =[NSString stringWithFormat:@"剩余:%@",remainString];
        NSMutableAttributedString *remainAttrString = [[NSMutableAttributedString alloc] initWithString:remainText];
        NSRange remainRange = [remainText rangeOfString:remainString];
        UIColor *remainColor = BB_Red_Color;
        [remainAttrString addAttribute:NSForegroundColorAttributeName value:remainColor range:remainRange];
        remainLbl.attributedText = remainAttrString;
        remainLbl.tag = 4;
        
        CGSize titleSize = [remainLbl.text boundingRectWithSize:CGSizeMake(MAXFLOAT, iconView.size.height / 4.5)  options:NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil].size;
         remainLbl.frame = CGRectMake(self.view.width - 12 - titleSize.width, userName.origin.y + userName.size.height, titleSize.width, iconView.size.height / 4.5);
        
        //进度条
        UIView *blackView = [[UIView alloc] init];
        blackView.frame = CGRectMake(userName.origin.x, joinLbl.origin.y + joinLbl.size.height + 5, UI_View_Width - self.view.width / 2.5 - 45, 7);
        blackView.backgroundColor = RGB_UI_COLOR(208, 208, 208);
        blackView.alpha = 0.5;
        
        UIView *frontView = [[UIView alloc] init];
        frontView.frame = CGRectMake(userName.origin.x, joinLbl.origin.y + joinLbl.size.height + 5, (UI_View_Width - self.view.width / 2.5 - 45) * 0.83, 7);
        frontView.backgroundColor =  RGB_UI_COLOR(248, 190, 24);
        frontView.alpha = 0.5;
        frontView.tag = 5;
        
        //立即抢购
        HemaButton *buyNowBtn = [[HemaButton alloc] init];
        buyNowBtn.frame = CGRectMake(UI_View_Width - 140, iconView.origin.y + iconView.size.height - 27, 58, 27);
        [buyNowBtn setImage:[UIImage imageNamed:@"hp_buynow"] forState:UIControlStateNormal];
        [buyNowBtn addTarget:self action:@selector(buyNowBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        //加入购物车
        HemaButton *addCartBtn = [[HemaButton alloc] init];
        addCartBtn.frame = CGRectMake(UI_View_Width - 70, buyNowBtn.origin.y, 58, 27);
        [addCartBtn setImage:[UIImage imageNamed:@"hp_addcart"] forState:UIControlStateNormal];
        [addCartBtn addTarget:self action:@selector(addCartBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [cell.contentView addSubview:iconView];
        [cell.contentView addSubview:userName];
        [cell.contentView addSubview:joinLbl];
        [cell.contentView addSubview:remainLbl];
        [cell.contentView addSubview:blackView];
        [cell.contentView addSubview:frontView];
        [cell.contentView addSubview:buyNowBtn];
        [cell.contentView addSubview:addCartBtn];
    }
    
    //赋值
//    UIImageView *iconView = (UIImageView *)[cell viewWithTag:1];
//    UILabel *titleLbl = (UILabel *)[cell viewWithTag:2];
//    UILabel *joinLbl = (UILabel *)[cell viewWithTag:3];
//    UILabel *remainLbl = (UILabel *)[cell viewWithTag:4];
//    UIView *frontView = (UIView *)[cell viewWithTag:5];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PrizeDetailVC *prizeDetailVC = [[PrizeDetailVC alloc] init];
    [self.navigationController pushViewController:prizeDetailVC animated:YES];
}

- (void)buyNowBtnClick:(HemaButton *)sender {
    SumbitOrderVC *submitOrderVC = [[SumbitOrderVC alloc] init];
    [self.navigationController pushViewController:submitOrderVC animated:YES];
}

- (void)addCartBtn:(HemaButton *)sender {
    
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
