//
//  MineGetTreed.m
//  Hema
//
//  Created by Lsy on 16/1/8.
//  Copyright © 2016年 Hemaapp. All rights reserved.
//

#import "MineGetTreed.h"

@interface MineGetTreed ()

@end

@implementation MineGetTreed

-(void)loadSet{
    [self reSetTableViewFrame:CGRectMake(0, 0, UI_View_Width, UI_View_Height-49)];
    self.mytable.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.view.width/2.5+20+self.view.width/3;
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
    UIImageView *iconView = [[UIImageView alloc]init];
    //商品名称
    UILabel *userName = [[UILabel alloc] init];
    //价格
    UILabel *priceLabel = [[UILabel alloc]init];
    UILabel *numLabel = [[UILabel alloc]init];
    UILabel *peopleLabel = [[UILabel alloc]init];
    iconView.frame = CGRectMake(10, 10, self.view.width/2.5,self.view.width/2.5 );
    [iconView setImage:[UIImage imageNamed:@"newpulish"]];
    
    UIImageView *blackView = [[UIImageView alloc]initWithFrame:CGRectMake(0, (iconView.height- iconView.height/6), iconView.width, iconView.height/6)];
    [blackView setImage:[UIImage imageNamed:@"np_black"]];
    [iconView addSubview:blackView];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, iconView.width, iconView.height/6)];
    titleLabel.text = @"已揭晓";
    titleLabel.font = [UIFont systemFontOfSize:12];
    titleLabel.textColor = BB_White_Color;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [blackView addSubview:titleLabel];
    
    userName.frame = CGRectMake(iconView.width +20,15,UI_View_Width-(iconView.width +20)-10,40);
    userName.lineBreakMode = NSLineBreakByTruncatingTail;
    userName.numberOfLines = 0;
    userName.font = [UIFont systemFontOfSize:14];
    
    NSString *myStr = @"第197期 Apple ipad mini 4 64G(颜色随机唯一的不同.....)";
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:myStr];
    NSRange range = [myStr rangeOfString:@"期"];
    NSRange range1 = NSMakeRange(0, range.location+1);
    NSLog(@"%zd",range1.length);
    UIColor *color = BB_Gray_Color;
    [attrString addAttribute:NSForegroundColorAttributeName value:color range:range1];
    [attrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:range1];
    userName.attributedText = attrString;
    
    priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(iconView.width +20, CGRectGetMaxY(userName.frame)+13, 40, 15)];
    priceLabel.font = [UIFont systemFontOfSize:12];
    priceLabel.textColor = BB_Gray_Color;
    priceLabel.text = @"价格：";
    
    numLabel = [[UILabel alloc]initWithFrame:CGRectMake(iconView.width +55, CGRectGetMaxY(userName.frame)+10, 100, 20)];
    numLabel.textColor = BB_Red_Color;
    numLabel.font = [UIFont systemFontOfSize:15];
    numLabel.text = @"￥1234";
    
    peopleLabel.frame = CGRectMake(iconView.width +20, CGRectGetMaxY(iconView.frame)-35, 80, 15);
    peopleLabel.textColor = BB_Gray_Color;
    peopleLabel.font = [UIFont systemFontOfSize:12];
    NSString *myStr1 = @"本次参与9人次";
    NSMutableAttributedString *attrString1 = [[NSMutableAttributedString alloc] initWithString:myStr1];
    NSRange range3= [myStr1 rangeOfString:@"9"];
    UIColor *color1 = BB_Red_Color;
    [attrString1 addAttribute:NSForegroundColorAttributeName value:color1 range:range3];
    peopleLabel.attributedText = attrString1;
    
    UIButton *countBtn=[[UIButton alloc]initWithFrame:CGRectMake(UI_View_Width - 70, CGRectGetMaxY(iconView.frame)-35, 60, 20)];
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:@"查看夺宝号"];
    NSRange titleRange = {0,[title length]};
    [title addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:titleRange];
    [countBtn setAttributedTitle:title
                        forState:UIControlStateNormal];
    countBtn.titleLabel.textColor = [UIColor colorWithRed:211.0/255.0 green:178.0/255.0 blue:118.0/255.0 alpha:0.8];
    [countBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [countBtn addTarget:self action:@selector(countBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [cell addSubview:countBtn];
    
    UIImageView *bgView = [[UIImageView alloc]initWithFrame:CGRectMake(10, self.view.width/2.5 +10, UI_View_Width-20, self.view.width/3)];
    [bgView setImage:[UIImage imageNamed:@"np_overdetail"]];
    [cell addSubview:bgView];
    
    //中奖
    UILabel *_winerLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10 ,55, (bgView.height-20)/4)];
    _winerLabel.font = [UIFont systemFontOfSize:13];
    _winerLabel.text = @"中奖者：";
    [bgView addSubview:_winerLabel];
    //小头像
    UIImageView *_winView = [[UIImageView alloc]initWithFrame:CGRectMake(65, CGRectGetMinY(_winerLabel.frame), 20, 20)];
    [_winView setImage:[UIImage imageNamed:@"np_winner"]];
    [bgView addSubview:_winView];
    //号码
    UILabel *_phoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(85, CGRectGetMinY(_winerLabel.frame), 100,(bgView.height-20)/4)];
    _phoneLabel.textColor = BB_Orange_Color;
    _phoneLabel.font = [UIFont systemFontOfSize:13];
    _phoneLabel.text = @"18253462562";
    [bgView addSubview:_phoneLabel];
    
    UILabel *luckLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(_winerLabel.frame), 55, (bgView.height-20)/4)];
    luckLabel.text = @"幸运号：";
    luckLabel.font = [UIFont systemFontOfSize:13];
    [bgView addSubview:luckLabel];
    
    UILabel *luckNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(65, CGRectGetMaxY(_winerLabel.frame), 100, (bgView.height-20)/4)];
    luckNumLabel.textColor = BB_Red_Color;
    luckNumLabel.text = @"100000095";
    luckNumLabel.font = [UIFont systemFontOfSize:15];
    [bgView addSubview:luckNumLabel];
    
    UILabel *winerLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(luckLabel.frame), 150, (bgView.height-20)/4)];
    winerLabel.font = [UIFont systemFontOfSize:13];
    NSString *myStr2 = @"参与次数：280人次";
    NSMutableAttributedString *attrString2 = [[NSMutableAttributedString alloc] initWithString:myStr2];
    NSRange range4 = [myStr2 rangeOfString:@"："];
    NSRange range5 = NSMakeRange(range4.location+range4.length,3);
    UIColor *color2 = BB_Red_Color;
    [attrString2 addAttribute:NSForegroundColorAttributeName value:color2 range:range5];
    winerLabel.attributedText = attrString2;
    [bgView addSubview:winerLabel];
    
    UILabel *winDayLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(winerLabel.frame), 220, (bgView.height-20)/4)];
    winDayLabel.text = @"揭晓时间：2015-12-09";
    winDayLabel.font = [UIFont systemFontOfSize:13];
    [bgView addSubview:winDayLabel];


    [cell addSubview:iconView];
    [cell addSubview:userName];
    [cell addSubview:priceLabel];
    [cell addSubview:numLabel];
    [cell addSubview:peopleLabel];
    return  cell;
}

-(void)countBtnClick{
    
}
@end
