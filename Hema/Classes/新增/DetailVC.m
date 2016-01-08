//
//  DetailVC.m
//  Hema
//
//  Created by Lsy on 15/12/25.
//  Copyright © 2015年 Hemaapp. All rights reserved.
//

#import "DetailVC.h"
#import "ShareVC.h"


@interface DetailVC (){
    NSInteger time;
    UIScrollView *_adView;
    UIPageControl *_pageView;
    NSMutableArray *imgSource;
    NSTimer *_prizeTimer;
    UIView *_blackView;
}

@end

@implementation DetailVC

-(void)loadSet{
    [self.navigationItem setNewTitle:@"奖品详情"];
    //左按钮
    [self.navigationItem setLeftItemWithTarget:self action:@selector(leftbtnPressed:) image:@"lg_back"];
    
    [self reSetTableViewFrame:CGRectMake(0, 0, UI_View_Width, UI_View_Height-49)];
    self.view.backgroundColor = BB_White_Color;
    
     NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];
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
    [goBtn addTarget:self action:@selector(goBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [dayView addSubview:goBtn];
    //计算方式
    _blackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UI_View_Width, UI_View_Height+80)];
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:_blackView];
    _blackView.userInteractionEnabled = YES;
    _blackView.hidden = YES;
    
    UIImageView *blackView1 = [[UIImageView alloc]initWithFrame:_blackView.frame];
    [blackView1 setImage:[UIImage imageNamed:@"np_blackView"]];
    [_blackView addSubview:blackView1];
    blackView1.userInteractionEnabled = YES;
    
    UIView *medoView = [[UIView alloc]initWithFrame:CGRectMake(UI_View_Width/8, _blackView.height/4, UI_View_Width*3/4, _blackView.height/2)];
    medoView.backgroundColor = BB_White_Color;
    [blackView1 addSubview:medoView];
    
    //    UILabel *medoLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, medoView.width, medoView.height/8)];
    //    medoLabel.backgroundColor = BB_Back_Color_Here;
    //    medoLabel.text = @"幸运号码计算方式";
    //    medoLabel.font = [UIFont systemFontOfSize:16];
    //    medoLabel.textAlignment = NSTextAlignmentCenter;
    //    [medoView addSubview:medoLabel];
    
    UIButton *medoBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, medoView.height - medoView.height/8, medoView.width, medoView.height/8)];
    medoBtn.backgroundColor = [UIColor clearColor];
    [medoBtn addTarget:self action:@selector(medoBtnClcik) forControlEvents:UIControlEventTouchUpInside];
    [medoView addSubview:medoBtn];
    
    UIImageView *medoimageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, medoView.width, medoView.height)];
    [medoimageView setImage:[UIImage imageNamed:@"np_countmedo"]];
    [medoView addSubview:medoimageView];
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
            return 60;
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
            nameLabel.frame = CGRectMake(10, 20, 70, 20);
            nameLabel.text = @"揭晓倒计时";
            nameLabel.textColor = BB_Gray_Color;
            nameLabel.font = [UIFont systemFontOfSize:12];
            
            UIView *timeView= [[UIView alloc]init];
            timeView.frame = CGRectMake(80,20,155, 20);
            [cell addSubview:timeView];
            
            UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 12, 155, 20)];
            timeLabel.text = @"          分           秒";
            timeLabel.font = [UIFont systemFontOfSize:13];
            timeLabel.textColor = BB_Gray_Color;
            [timeView addSubview:timeLabel];
            
            for (int i =0 ; i<3; i++) {
                UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(5 + i*50, 0, 25, 25)];
                label.backgroundColor = [UIColor blackColor];
                label.textColor = BB_White_Color;
                label.tag = 6000 + i;
                label.textAlignment = NSTextAlignmentCenter;
                [timeView addSubview:label];
            }
            UIButton *countBtn=[[UIButton alloc]initWithFrame:CGRectMake(240, 23, 70, 20)];
            NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:@"查看计算规则"];
            NSRange titleRange = {0,[title length]};
            [title addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:titleRange];
            [countBtn setAttributedTitle:title
                              forState:UIControlStateNormal];
            countBtn.titleLabel.textColor = [UIColor colorWithRed:211.0/255.0 green:178.0/255.0 blue:118.0/255.0 alpha:0.8];
            [countBtn.titleLabel setFont:[UIFont systemFontOfSize:11]];
            [countBtn addTarget:self action:@selector(countBtnClick) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:countBtn];
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
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            ShareVC *hvc = [[ShareVC alloc]init];
            hvc.shareType = otherShare;
            [self.navigationController pushViewController:hvc animated:YES];
        }
        if (indexPath.row == 1) {
            OverDetailVC *ovc = [[OverDetailVC alloc]init];
            [self.navigationController pushViewController:ovc animated:YES];
        }
    }
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
    if (1 == scrollView.tag) {
        _prizeTimer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(topScrollViewPass) userInfo:nil repeats:YES];
    }
}

#pragma mark - 事件
- (void)timerFireMethod:(NSTimer *)timer
{
    if (time == 0) {
        time = 100;
    }
    time-=1.3;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setYear:2016];
    [components setMonth:12];
    [components setDay:23];
    [components setHour:16];
    [components setMinute:0];
    [components setSecond:0];
    NSDate *fireDate = [calendar dateFromComponents:components];//目标时间
    NSDate *today = [NSDate date];//当前时间
    unsigned int unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *d = [calendar components:unitFlags fromDate:today toDate:fireDate options:0];//计算时间差
    
    UILabel *label = (id)[self.view viewWithTag:6000];
    label.text = [NSString stringWithFormat:@"%zd",[d minute]];
        
    UILabel *label1 = (id)[self.view viewWithTag:6001];
    label1.text = [NSString stringWithFormat:@"%zd",[d second]];
        
    UILabel *label2 = (id)[self.view viewWithTag:6002];
    label2.text = [NSString stringWithFormat:@"%zd",time];
        //        timeLabel.text = [NSString stringWithFormat:@"%ld分%ld秒%zd", (long)[d minute], (long)[d second],time];//倒计时显示
    
}

- (void)topScrollViewPass {
    
    UIPageControl *control = (id)[self.view viewWithTag:2];
    UIScrollView *scrollView = (id)[self.view viewWithTag:1];
    [UIView animateWithDuration:1 animations:^{
        CGPoint contentSet = CGPointMake(scrollView.contentOffset.x + UI_View_Width, 0);
        scrollView.contentOffset = contentSet;
        
        control.currentPage = scrollView.contentOffset.x / UI_View_Width;
        if (contentSet.x == scrollView.contentSize.width) {
            scrollView.contentOffset = CGPointMake(0, 0);
        }
    }];
}
#pragma mark - scrollView代理方法

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [super scrollViewWillBeginDragging:scrollView];
    
    if (1 == scrollView.tag) {
        [_prizeTimer invalidate];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [super scrollViewDidScroll:scrollView];
    
    if (1 == scrollView.tag) {
        UIPageControl *control = (id)[self.view viewWithTag:2];
        if (scrollView.contentOffset.x + UI_View_Width > scrollView.contentSize.width) {
            //            scrollView.contentOffset = CGPointMake(0, 0);
            //            control.currentPage = 0;
        } else {
            control.currentPage = scrollView.contentOffset.x / UI_View_Width;
        }
    }
    
}
-(void)medoBtnClcik{
    _blackView.hidden = YES;
}
-(void)countBtnClick{
    _blackView.hidden = NO;
}
-(void)goBtnClick{
    
}

@end
