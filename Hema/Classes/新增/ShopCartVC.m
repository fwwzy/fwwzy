//
//  ShopCartVC.m
//  Hema
//
//  Created by MsTail on 15/12/23.
//  Copyright © 2015年 Hemaapp. All rights reserved.
//

#import "ShopCartVC.h"
#import "MyLabel.h"
#import "SumbitOrderVC.h"

@interface ShopCartVC (){
    UITableView *_tableView;
    NSInteger _page;
    NSString *_myStr;
    UILabel *_titleLabel;
}

@end

@implementation ShopCartVC

- (void)loadSet {
    [self.navigationItem setNewTitle:@"购物车"];
    _page = 3;
    //左按钮
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = CGRectMake(0, 0, 14, 20);
    [btn setBackgroundImage:[UIImage imageNamed:@"lg_back"] forState:UIControlStateNormal];
    UIBarButtonItem *btni = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = btni;
    //列表
    //[self.mytable setSeparatorInset:UIEdgeInsetsMake(0, 0, UI_View_Width, UI_View_Height -49-50)];
    [self.mytable setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [self reSetTableViewFrame:CGRectMake(0, 0, UI_View_Width, UI_View_Height-49 - 50)];
    self.view.backgroundColor = BB_White_Color;
    //总数
    UIView *allView = [[UIView alloc]initWithFrame:CGRectMake(0, UI_View_Height-49-50, UI_View_Width, 50)];
    allView.backgroundColor = BB_Back_Color_Here;
    [self.view addSubview:allView];
    
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 15, 240, 20)];
    _titleLabel.textColor = BB_Gray_Color;
    _titleLabel.font = [UIFont systemFontOfSize:15];
    _myStr = [NSString stringWithFormat:@"共3件商品，总计需要%zd抢币",_page];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:_myStr];
    NSRange range = [_myStr rangeOfString:@"3"];
    UIColor *color = BB_Blake_Color;
    [attrString addAttribute:NSForegroundColorAttributeName value:color range:range];
    [attrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18] range:range];
    NSRange range1 = [_myStr rangeOfString:@"要"];
    NSString *numStr = [NSString stringWithFormat:@"%zd",_page];
    NSRange range2 = NSMakeRange(range1.location+range1.length,numStr.length+2);
    UIColor *color1 = BB_Red_Color;
    [attrString addAttribute:NSForegroundColorAttributeName value:color1 range:range2];
    [attrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18] range:range2];
    _titleLabel.attributedText = attrString;
    [allView addSubview:_titleLabel];
    
    UIButton *buyBtn = [[UIButton alloc]initWithFrame:CGRectMake(allView.width - 90, 10, 80, 30)];
    buyBtn.backgroundColor = BB_Red_Color;
    [buyBtn setTitle:@"立即购买" forState:UIControlStateNormal];
    [buyBtn addTarget:self action:@selector(buyBtnClcik) forControlEvents:UIControlEventTouchUpInside];
    [allView addSubview:buyBtn];
}

- (void)loadData {
    
}

#pragma mark - 代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
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
    cell.tag = 1000+indexPath.row;
    //图片
    UIImageView *iconView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 85, 85)];
    [iconView setImage:[UIImage imageNamed:@"sc_icon"]];
    [cell addSubview:iconView];
    //名称
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(105, 5, 200, 50)];
    nameLabel.numberOfLines = 2;
    nameLabel.font = [UIFont systemFontOfSize:18];
    nameLabel.text = @"Apple ipad mini 64G（颜色随机唯一的不同……）";
    [cell addSubview:nameLabel];
    //数量
    UILabel *antLabel = [[UILabel alloc]initWithFrame:CGRectMake(105, 60, 130, 15)];
    antLabel.font = [UIFont systemFontOfSize:13];
    antLabel.textColor = BB_Gray_Color;
    antLabel.text = @"总需：1540     剩余：";
    [cell addSubview:antLabel];
    
    UILabel *lastLabel = [[UILabel alloc]initWithFrame:CGRectMake(225, 60, 30, 15)];
    lastLabel.text = @"100";
    lastLabel.font = [UIFont systemFontOfSize:13];
    lastLabel.textColor = BB_Red_Color;
    [cell addSubview:lastLabel];
    
    UIView *numView = [[UIView alloc]initWithFrame:CGRectMake(105, 85, 100, 30)];
    numView.layer.borderWidth = 0.5;
    numView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [cell addSubview:numView];
    
    UIButton *plusBtn = [[UIButton alloc]initWithFrame:CGRectMake(75, 5, 20, 20)];
    [plusBtn setBackgroundImage:[UIImage imageNamed:@"sc_plus"] forState:UIControlStateNormal];
    [plusBtn addTarget:self action:@selector(numBtnPlus:) forControlEvents:UIControlEventTouchUpInside];
    plusBtn.tag = 900+indexPath.row;
    [numView addSubview:plusBtn];
    
    MyLabel *midLabel = [[MyLabel alloc]initWithFrame:CGRectMake(30, 0, 40, 30)];
    midLabel.page = 1;
    midLabel.text = [NSString stringWithFormat:@"%zd",midLabel.page];
    midLabel.textColor = [UIColor grayColor];
    midLabel.font = [UIFont systemFontOfSize:16];
    midLabel.textAlignment = NSTextAlignmentCenter;
    midLabel.layer.borderWidth = 0.5;
    midLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
    midLabel.tag = 700 +indexPath.row;
    [numView addSubview:midLabel];
    
    UIButton *minBtn = [[UIButton alloc]initWithFrame:CGRectMake(5, 5, 20, 20)];
    [minBtn setBackgroundImage:[UIImage imageNamed:@"sc_minus1"] forState:UIControlStateNormal];
    [minBtn addTarget:self action:@selector(numBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    minBtn.tag = 800 + indexPath.row;
    [numView addSubview:minBtn];
    
    UIButton *deleteBtn = [[UIButton alloc]initWithFrame:CGRectMake(UI_View_Width -25, 115, 18, 20)];
    [deleteBtn setBackgroundImage:[UIImage imageNamed:@"shanchu_03"] forState:UIControlStateNormal];
//    [deleteBtn addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    deleteBtn.tag = 1000+indexPath.row;
    [cell addSubview:deleteBtn];
    
    return cell;
}
-(void)numBtnClick:(UIButton *)button{
    MyLabel *midLabel = (id)[self.view viewWithTag:700+(button.tag - 800)];
        if (midLabel.page == 1) {
            midLabel.text = @"1";
        }else{
            midLabel.page--;
            midLabel.text = [NSString stringWithFormat:@"%zd",midLabel.page];
            _page-=1;
            _myStr = [NSString stringWithFormat:@"共3件商品，总计需要%zd抢币",_page];
            
            NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:_myStr];
            NSRange range = [_myStr rangeOfString:@"3"];
            UIColor *color = BB_Blake_Color;
            [attrString addAttribute:NSForegroundColorAttributeName value:color range:range];
            [attrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:range];
            NSRange range1 = [_myStr rangeOfString:@"要"];
            NSString *numStr = [NSString stringWithFormat:@"%zd",_page];
            NSRange range2 = NSMakeRange(range1.location+range1.length,numStr.length+2);
            UIColor *color1 = BB_Red_Color;
            [attrString addAttribute:NSForegroundColorAttributeName value:color1 range:range2];
            [attrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:range2];
            _titleLabel.attributedText = attrString;

        }
}
-(void)numBtnPlus:(UIButton *)button{
    MyLabel *midLabel = (id)[self.view viewWithTag:700+(button.tag - 900)];
    midLabel.page++;
    midLabel.text = [NSString stringWithFormat:@"%zd",midLabel.page];
    _page += 1;
    _myStr = [NSString stringWithFormat:@"共3件商品，总计需要%zd抢币",_page];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:_myStr];
    NSRange range = [_myStr rangeOfString:@"3"];
    UIColor *color = BB_Blake_Color;
    [attrString addAttribute:NSForegroundColorAttributeName value:color range:range];
    [attrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:range];
    NSRange range1 = [_myStr rangeOfString:@"要"];
    NSString *numStr = [NSString stringWithFormat:@"%zd",_page];
    NSRange range2 = NSMakeRange(range1.location+range1.length,numStr.length+2);
    UIColor *color1 = BB_Red_Color;
    [attrString addAttribute:NSForegroundColorAttributeName value:color1 range:range2];
    [attrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:range2];
    _titleLabel.attributedText = attrString;
    
}
-(void)buyBtnClcik{
    SumbitOrderVC *svc = [[SumbitOrderVC alloc]init];
    svc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:svc animated:YES];
}
//-(void)deleteBtnClick:(UIButton *)button{
//    NSArray *visibleCells=[_tableView visibleCells];
//    for (UITableViewCell *cell in visibleCells) {
//        if (cell.tag==button.tag) {
//            [self.cellInfoArray removeObjectAtIndex:[cell tag]];
//            [self.myTableView reloadData];
//            break;
//        }
//    }
//}

@end
