//
//  MineGetTreing.m
//  Hema
//
//  Created by Lsy on 16/1/8.
//  Copyright © 2016年 Hemaapp. All rights reserved.
//

#import "MineGetTreing.h"

@interface MineGetTreing ()

@end

@implementation MineGetTreing

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
    return self.view.width/2.5+20;
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
    //商品图片
    iconView.frame = CGRectMake(10, 10, self.view.width / 2.5, self.view.width / 2.5);
    iconView.image = [UIImage imageNamed:@"newpulish"];
    iconView.tag = 1;
    
    UIImageView *blackView = [[UIImageView alloc]initWithFrame:CGRectMake(0, (iconView.height- iconView.height/6), iconView.width, iconView.height/6)];
    [blackView setImage:[UIImage imageNamed:@"np_black"]];
    [iconView addSubview:blackView];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, iconView.width, iconView.height/6)];
    titleLabel.text = @"进行中";
    titleLabel.font = [UIFont systemFontOfSize:12];
    titleLabel.textColor = BB_White_Color;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [blackView addSubview:titleLabel];
    
    //商品名称
    userName.frame = CGRectMake(20 + self.view.width / 2.5, 15, UI_View_Width - self.view.width / 2.5 - 40, iconView.size.height / 3);
    userName.lineBreakMode = NSLineBreakByTruncatingTail;
    userName.numberOfLines = 0;
    userName.font = [UIFont systemFontOfSize:16];
    userName.text = @"Apple ipad mini 4 64G(颜色随机唯一的不同.....)";
    userName.tag = 2;
    
    priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(iconView.width +20, CGRectGetMaxY(userName.frame)+13, 40, 15)];
    priceLabel.font = [UIFont systemFontOfSize:12];
    priceLabel.textColor = BB_Gray_Color;
    priceLabel.text = @"价格：";
    
    numLabel = [[UILabel alloc]initWithFrame:CGRectMake(iconView.width +55, CGRectGetMaxY(userName.frame)+10, 100, 20)];
    numLabel.textColor = BB_Red_Color;
    numLabel.font = [UIFont systemFontOfSize:15];
    numLabel.text = @"￥1234";
    
    //已参与
    UILabel *joinLbl =[[UILabel alloc] init];
    joinLbl.font = [UIFont systemFontOfSize:13];
    joinLbl.textColor = BB_Gray_Color;
    NSString *joinString = [NSString stringWithFormat:@"%zd",1540];
    NSString *joinText =[NSString stringWithFormat:@"已参与:%@",joinString];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:joinText];
    NSRange range = [joinText rangeOfString:joinString];
    UIColor *color = RGB_UI_COLOR(1, 182, 159);
    [attrString addAttribute:NSForegroundColorAttributeName value:color range:range];
    joinLbl.attributedText = attrString;
    joinLbl.tag = 3;
    
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:13]};
    CGSize sizeTitle = [joinLbl.text boundingRectWithSize:CGSizeMake(MAXFLOAT, iconView.size.height / 4.5)  options:NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil].size;
    joinLbl.frame = CGRectMake(userName.origin.x, CGRectGetMaxY(iconView.frame)-iconView.size.height / 4.5-7-10, sizeTitle.width, iconView.size.height / 4.5);
    [cell addSubview:joinLbl];
    
    //剩余
    UILabel *remainLbl =[[UILabel alloc] init];
    remainLbl.font = [UIFont systemFontOfSize:13];
    remainLbl.textColor = BB_Gray_Color;
    NSString *remainString = [NSString stringWithFormat:@"%zd",1540];
    NSString *remainText =[NSString stringWithFormat:@"剩余:%@",remainString];
    NSMutableAttributedString *remainAttrString = [[NSMutableAttributedString alloc] initWithString:remainText];
    NSRange remainRange = [remainText rangeOfString:remainString];
    UIColor *remainColor = BB_Red_Color;
    [remainAttrString addAttribute:NSForegroundColorAttributeName value:remainColor range:remainRange];
    remainLbl.attributedText = remainAttrString;
    remainLbl.tag = 4;
    CGSize titleSize = [remainLbl.text boundingRectWithSize:CGSizeMake(MAXFLOAT, iconView.size.height / 4.5)  options:NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil].size;
    remainLbl.frame = CGRectMake(self.view.width - 12 - titleSize.width, CGRectGetMaxY(iconView.frame)-iconView.size.height / 4.5-7-10, titleSize.width, iconView.size.height / 4.5);
    [cell addSubview:remainLbl];
    
    //进度条
    UIView *blackView1 = [[UIView alloc] init];
    blackView1.frame = CGRectMake(userName.origin.x, joinLbl.origin.y + joinLbl.size.height + 5, UI_View_Width - self.view.width / 2.5 - 45, 7);
    blackView1.backgroundColor = RGB_UI_COLOR(208, 208, 208);
    blackView1.alpha = 0.5;
    
    UIView *frontView = [[UIView alloc] init];
    frontView.frame = CGRectMake(userName.origin.x, joinLbl.origin.y + joinLbl.size.height + 5, (UI_View_Width - self.view.width / 2.5 - 45) * 0.83, 7);
    frontView.backgroundColor =  RGB_UI_COLOR(248, 190, 24);
    frontView.alpha = 0.5;
    frontView.tag = 5;
    
    [cell addSubview:blackView1];
    [cell addSubview:frontView];
    [cell addSubview:priceLabel];
    [cell addSubview:numLabel];
    [cell addSubview:iconView];
    [cell addSubview:userName];

    return  cell;
}

@end
