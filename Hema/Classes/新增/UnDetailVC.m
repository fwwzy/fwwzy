//
//  UnDetailVC.m
//  Hema
//
//  Created by Lsy on 15/12/28.
//  Copyright © 2015年 Hemaapp. All rights reserved.
//

#import "UnDetailVC.h"

@interface UnDetailVC (){
    UIScrollView *_adView;
    UIPageControl *_pageView;
    NSMutableArray *imgSource;
    NSTimer *_prizeTimer;
    UIView *_blackView;
}

@end

@implementation UnDetailVC

-(void)loadSet{
    [self.navigationItem setNewTitle:@"奖品详情"];
    //左按钮
    [self.navigationItem setLeftItemWithTarget:self action:@selector(leftbtnPressed:) image:@"lg_back"];
    
    [self reSetTableViewFrame:CGRectMake(0, 0, UI_View_Width, UI_View_Height-49)];
    self.view.backgroundColor = BB_White_Color;
    
    _prizeTimer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(topScrollViewPass) userInfo:nil repeats:YES];
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenSize.width, 150)];
    
    UIScrollView *top = [[UIScrollView alloc] init];
    [top setFrame:CGRectMake(0, 0, UI_View_Width, 140)];
    top.contentSize = CGSizeMake(UI_View_Width * 4, 0);
    top.tag = 1;
    top.pagingEnabled = YES;
    top.showsHorizontalScrollIndicator = NO;
    top.delegate = self;
    [headerView addSubview:top];
    UIPageControl *topControl = [[UIPageControl alloc] init];
    [topControl setFrame:CGRectMake(0, 0 , 90, 30)];
    topControl.center = CGPointMake(self.view.width / 2 , 120);
    topControl.numberOfPages = 4;
    topControl.currentPage = 0;
    topControl.tag = 2;
    topControl.currentPageIndicatorTintColor = BB_Orange_Color;
    topControl.pageIndicatorTintColor = BB_Gray_Color;
    [headerView addSubview:topControl];
    
    //添加轮播图片
    for (int i = 0; i < imgSource.count; i++) {
        UIImageView *img = [[UIImageView alloc] init];
        [img setFrame:CGRectMake(i * UI_View_Width, 0, UI_View_Width, 140)];
        [img setImage:[UIImage imageNamed:imgSource[i]]];
        [top addSubview:img];
    }
    
    
    self.mytable.tableHeaderView = headerView;
    //底部视图
    UIView *dayView = [[UIView alloc]initWithFrame:CGRectMake(0, UI_View_Height-49, UI_View_Width, 49)];
    [self.view addSubview:dayView];
    
    UILabel *myDayLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 15, 150, 19)];
    myDayLabel.font = [UIFont systemFontOfSize:13];
    myDayLabel.text = @"第15657期进行中···";
    [dayView addSubview:myDayLabel];
    
    UIButton *goBtn = [[UIButton alloc]initWithFrame:CGRectMake(UI_View_Width-100, 0, 100, 49)];
    goBtn.backgroundColor = BB_Red_Color;
    [goBtn setTitle:@"立即前往" forState:UIControlStateNormal];
    [dayView addSubview:goBtn];
    
    _blackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UI_View_Width, UI_View_Height+80)];
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:_blackView];
    _blackView.userInteractionEnabled = YES;
    
    UIImageView *blackView1 = [[UIImageView alloc]initWithFrame:_blackView.frame];
    [blackView1 setImage:[UIImage imageNamed:@"np_blackView"]];
    [_blackView addSubview:blackView1];
    blackView1.userInteractionEnabled = YES;
    
    UIImageView *redBagView = [[UIImageView alloc]initWithFrame:CGRectMake(UI_View_Width/6, _blackView.height / 4, UI_View_Width*2/3, _blackView.height/2)];
    [redBagView setImage:[UIImage imageNamed:@"hongbao_03"]];
    [blackView1 addSubview:redBagView];
    redBagView.userInteractionEnabled = YES;
    
    UILabel *theDayLabel = [[UILabel alloc]initWithFrame:CGRectMake(redBagView.width/4 + 5, redBagView.height/8, redBagView.width/2, 20)];
    theDayLabel.text = @"第12355期";
    theDayLabel.textColor = BB_Red_Color;
    theDayLabel.font = [UIFont systemFontOfSize:18];
    [redBagView addSubview:theDayLabel];
    
    UIButton *robBtn = [[UIButton alloc]initWithFrame:CGRectMake(redBagView.width/3, redBagView.width*3/4 - 5, redBagView.width/3, redBagView.width/3)];
    robBtn.backgroundColor = [UIColor clearColor];
    [robBtn addTarget:self action:@selector(robBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [redBagView addSubview:robBtn];
}

- (void)loadData {
    
    imgSource = [[NSMutableArray alloc] init];
    [imgSource addObjectsFromArray:@[@"newpulish",@"newpulish",@"newpulish",@"newpulish"]];
    [self.mytable reloadData];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 2;
    }
    if (section == 1) {
        return 2;
    }
    return 4;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 1) {
            return 155;
        }
    }
    if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            return 40;
        }
        return 60;
    }
    return 40;
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
    //倒计时
    UILabel *lastLabel = [[UILabel alloc]init];
    //期数
    UILabel *dayLabel = [[UILabel alloc]init];
    //名称
    UILabel *nameLabel = [[UILabel alloc]init];
    //头像
    UIImageView *iconView = [[UIImageView alloc]init];
    //定位
    UIImageView *placeView = [[UIImageView alloc]init];
    //人数
    UILabel *peopleLabel = [[UILabel alloc]init];
    //背景
    UIImageView *bgView = [[UIImageView alloc]init];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            lastLabel .frame = CGRectMake(10, 12.5, 35, 15);
            lastLabel.backgroundColor = BB_Red_Color;
            lastLabel.textColor = BB_White_Color;
            lastLabel.text = @"倒计时";
            lastLabel.textAlignment = NSTextAlignmentCenter;
            lastLabel.font = [UIFont systemFontOfSize:10];
            
            dayLabel.frame = CGRectMake(55, 12.5, 50, 15);
            dayLabel.textColor = BB_Gray_Color;
            dayLabel.text = @"第2531期";
            dayLabel.font = [UIFont systemFontOfSize:10];
            
            nameLabel.frame = CGRectMake(110, 10, 150, 20);
            nameLabel.text = @"神火手电筒";
            nameLabel.font = [UIFont systemFontOfSize:15];
        }
        if (indexPath.row == 1) {
            bgView.frame = CGRectMake(5, 5, UI_View_Width - 10, 145);
            [bgView setImage:[UIImage imageNamed:@"biankuang_03"]];
            
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
            
            UIButton *countBtn = [[UIButton alloc]initWithFrame:CGRectMake(UI_View_Width - 80, 12, 60, 21)];
            countBtn.backgroundColor = BB_Red_Color;
            [countBtn setTitle:@"计算详情" forState:UIControlStateNormal];
            countBtn.titleLabel.font = [UIFont systemFontOfSize:11];
            [grayView addSubview:countBtn];
        }
    }
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            nameLabel.frame = CGRectMake(10, 10, 60, 20);
            nameLabel.text = @"晒单分享";
            nameLabel.font = [UIFont systemFontOfSize:15];
            
            lastLabel.frame = CGRectMake(70, 11, 50, 20);
            lastLabel.font = [UIFont systemFontOfSize:10];
            lastLabel.text = @"（40）";
            lastLabel.textColor = BB_Gray_Color;
        }
        if (indexPath.row == 1) {
            nameLabel.frame = CGRectMake(10, 10, 60, 20);
            nameLabel.text = @"往期揭晓";
            nameLabel.font = [UIFont systemFontOfSize:15];
        }
    }
    if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            nameLabel.frame = CGRectMake(10, 10, 60, 20);
            nameLabel.text = @"本期参与";
            nameLabel.font = [UIFont systemFontOfSize:15];
            
            lastLabel.frame = CGRectMake(70, 11, 200, 20);
            lastLabel.font = [UIFont systemFontOfSize:10];
            lastLabel.text = @"（2015-12-07 07：08：56开始）";
            lastLabel.textColor = BB_Gray_Color;
        }else{
            cell.backgroundColor = BB_Back_Color_Here;
            
            iconView.frame = CGRectMake(10, 10, 40, 40);
            [iconView setImage:[UIImage imageNamed:@"np_detailicon"]];
            
            nameLabel.frame = CGRectMake(60, 15, 60, 15);
            nameLabel.font = [UIFont systemFontOfSize:14];
            nameLabel.text = @"夺宝王者";
            
            placeView.frame = CGRectMake(140, 17, 8, 12);
            [placeView setImage:[UIImage imageNamed:@"np_detailplace"]];
            
            dayLabel.frame = CGRectMake(150, 16, 150, 15);
            dayLabel.text = @"辽宁·大连(IP:228.192.1.21)";
            dayLabel.font = [UIFont systemFontOfSize:12];
            dayLabel.textColor = BB_Gray_Color;
            
            peopleLabel.frame = CGRectMake(60, 35, 70, 15);
            peopleLabel.textColor = BB_Gray_Color;
            peopleLabel.font = [UIFont systemFontOfSize:12];
            NSString *myStr = @"参与了9人次";
            NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:myStr];
            NSRange range = [myStr rangeOfString:@"9"];
            UIColor *color = BB_Red_Color;
            [attrString addAttribute:NSForegroundColorAttributeName value:color range:range];
            peopleLabel.attributedText = attrString;
            
            lastLabel.frame = CGRectMake(140, 35, 150, 15);
            lastLabel.textColor = BB_Gray_Color;
            lastLabel.text = @"2015-12-07 12:53:52.181";
            lastLabel.font = [UIFont systemFontOfSize:12];
        }
        
    }
    [cell addSubview:nameLabel];
    [cell addSubview:dayLabel];
    [cell addSubview:lastLabel];
    [cell addSubview:iconView];
    [cell addSubview:placeView];
    [cell addSubview:peopleLabel];
    [cell addSubview:bgView];
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
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView == _adView) {
        _pageView.currentPage = scrollView.contentOffset.x/scrollView.bounds.size.width;
    }
}

#pragma mark - 事件

- (void)topScrollViewPass {
    
    UIPageControl *control = (id)[self.view viewWithTag:2];
    UIScrollView *scrollView = (id)[self.view viewWithTag:1];
    [UIView animateWithDuration:1 animations:^{
        CGPoint contentSet = CGPointMake(scrollView.contentOffset.x + UI_View_Width, 0);
        scrollView.contentOffset = contentSet;
    }];
    
    control.currentPage = scrollView.contentOffset.x / UI_View_Width;
    if (control.currentPage == 3) {
        scrollView.contentOffset = CGPointMake(0, 0);
    }
    
    
}
-(void)robBtnClick{
    _blackView.hidden = YES;
    NSLog(@"===============");
}
@end
