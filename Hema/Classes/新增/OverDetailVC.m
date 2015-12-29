//
//  OverDetailVC.m
//  Hema
//
//  Created by Lsy on 15/12/29.
//  Copyright © 2015年 Hemaapp. All rights reserved.
//

#import "OverDetailVC.h"

@interface OverDetailVC ()

@end

@implementation OverDetailVC
-(void)loadSet{
    [self.navigationItem setNewTitle:@"往期详情"];
    //左按钮
    [self.navigationItem setLeftItemWithTarget:self action:@selector(leftbtnPressed:) image:@"lg_back"];
    [self reSetTableViewFrame:CGRectMake(0, 0, UI_View_Width, UI_View_Height)];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 170;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = nil;
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"qqq"];
    }else{
        while ([cell.contentView.subviews lastObject]!=nil) {
            [(UIView *)[cell.contentView.subviews lastObject]removeFromSuperview];
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UILabel *numLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 10, 70, 30)];
    numLabel.text = @"第653期";
    numLabel.font = [UIFont systemFontOfSize:17];
    [cell addSubview:numLabel];
    
    UIImageView *bgView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 40, UI_View_Width - 10, 120)];
    [bgView setImage:[UIImage imageNamed:@"np_overdetail"]];
    [cell addSubview:bgView];
    
    UIImageView *winView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 15, 40, 40)];
    [winView setImage:[UIImage imageNamed:@"np_detailicon"]];
    [bgView addSubview:winView];
    
    UILabel *winLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, 18, 150, 15)];
    winLabel.text = @"获奖者：18532625352";
    //            winLabel.textColor = BB_Gray_Color;
    winLabel.font = [UIFont systemFontOfSize:14];
    [bgView addSubview:winLabel];
    
    UILabel *IPLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, 40, 240, 15)];
    IPLabel.text = @"用户IP：221.2.71.110（山东济南）";
    //            IPLabel.textColor = BB_Gray_Color;
    IPLabel.font = [UIFont systemFontOfSize:14];
    [bgView addSubview:IPLabel];
    
    UILabel *winerLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, 80, 150, 15)];
    //            winerLabel.textColor = BB_Gray_Color;
    winerLabel.font = [UIFont systemFontOfSize:14];
    NSString *myStr = @"参与次数：280人次";
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:myStr];
    NSRange range1 = [myStr rangeOfString:@"："];
    NSRange range2 = NSMakeRange(range1.location+range1.length,3);
    UIColor *color = BB_Red_Color;
    [attrString addAttribute:NSForegroundColorAttributeName value:color range:range2];
    winerLabel.attributedText = attrString;
    [bgView addSubview:winerLabel];
    
    UILabel *winDayLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, 17, 220, 15)];
    winDayLabel.text = @"揭晓时间：2015-12-08 12:35:25:102";
    winDayLabel.textColor = BB_Gray_Color;
    winDayLabel.font = [UIFont systemFontOfSize:12];
    [cell addSubview:winDayLabel];
    
    UILabel *luckLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, 60, 55, 15)];
    luckLabel.text = @"幸运号：";
    luckLabel.font = [UIFont systemFontOfSize:13];
    [bgView addSubview:luckLabel];
    
    UILabel *luckNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(115, 60, 100, 15)];
    luckNumLabel.textColor = BB_Red_Color;
    luckNumLabel.text = @"100000095";
    luckNumLabel.font = [UIFont systemFontOfSize:15];
    [bgView addSubview:luckNumLabel];
    
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

@end
