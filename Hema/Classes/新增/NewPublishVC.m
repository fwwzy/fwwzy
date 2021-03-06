//
//  NewPublishVC.m
//  Hema
//
//  Created by Lsy on 15/12/23.
//  Copyright © 2015年 Hemaapp. All rights reserved.
//

#import "NewPublishVC.h"
#import "NewPublishCell.h"
#import "DetailVC.h"
#import "UnDetailVC.h"

@interface NewPublishVC ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>{
    
    NSInteger time;
}

@end

@implementation NewPublishVC

- (void)viewDidLoad {
    [self.navigationItem setNewTitle:@"最新揭晓"];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"hp_navigationbar"]]];
    //列表
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, UI_View_Width, self.view.frame.size.height-49 )collectionViewLayout:flowLayout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [self.view addSubview:_collectionView];
    [self.collectionView registerClass:[NewPublishCell class] forCellWithReuseIdentifier:@"cell"];
    //背景色
    _collectionView.backgroundColor = [UIColor colorWithRed:252.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:0.8];
    
    time = 100;
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];
}

- (void)loadData {
    
}
#pragma mark - 代理
//展示个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 4;
}
//每一个cell大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%f",(UI_View_Height+49)/2);
    NSLog(@"%f",UI_View_Height);
    NSLog(@"%f",[UIScreen mainScreen].bounds.size.height);
    return CGSizeMake(UI_View_Width/2-5, (UI_View_Height+64)/2);
   
}
//每个cell间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identify = @"cell";
    NewPublishCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    //    [cell sizeToFit];
    if (!cell) {
        NSLog(@"error");
    }
    cell.iconView.image = [UIImage imageNamed:@"newpulish"];
    cell.nameLabel.text = @"Apple ipad mini4 64G (颜色随机唯一)";
    cell.priceLabel.text = @"价格：";
    cell.numLabel.text = @"￥1234";
    
    UIImageView *blackView = [[UIImageView alloc]initWithFrame:CGRectMake(0, (cell.height/2- cell.iconView.height/8), cell.iconView.width, cell.iconView.height/8)];
    [blackView setImage:[UIImage imageNamed:@"np_black"]];
    [cell.iconView addSubview:blackView];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(cell.iconView.width/3, 0, cell.iconView.width/3, cell.iconView.height/8)];
    titleLabel.text = @"正在揭晓";
    titleLabel.font = [UIFont systemFontOfSize:11];
    titleLabel.textColor = BB_White_Color;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [blackView addSubview:titleLabel];
    
    UIView *timeView= [[UIView alloc]init];
    timeView.frame = CGRectMake(10, CGRectGetMaxY(cell.numLabel.frame)+15, CGRectGetWidth(cell.frame)-20, 20);
    [cell addSubview:timeView];
    
    UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 12, CGRectGetWidth(cell.frame)-20, 20)];
    timeLabel.text = @"          分           秒";
    timeLabel.font = [UIFont systemFontOfSize:13];
    timeLabel.textColor = BB_Gray_Color;
    [timeView addSubview:timeLabel];
    
    for (int i =0 ; i<3; i++) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(5 + i*50, 0, 25, 25)];
        label.backgroundColor = [UIColor blackColor];
        label.textColor = BB_White_Color;
        label.tag = 600 * (i+1) + indexPath.row;
        label.textAlignment = NSTextAlignmentCenter;
        [timeView addSubview:label];
    }
    
    if (indexPath.row == 2) {
        timeView.hidden = YES;
        UIImageView *lineView = [[UIImageView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(cell.priceLabel.frame) + 5, cell.frame.size.width - 20, 1)];
        [lineView setImage:[UIImage imageNamed:@"np_xuxian"]];
        [cell addSubview:lineView];
        cell.winerLabel.text = @"中奖者:";
        cell.winView.image = [UIImage imageNamed:@"np_winner"];
        cell.phoneLabel.text = @"18223822237";
        cell.curLabel.text = @"本期夺宝：2人次";
        cell.timeLabel.text = @"揭晓时间：1分钟前";
        titleLabel.text = @"已结束";
    }
    
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 2) {
        UnDetailVC *uvc = [[UnDetailVC alloc]init];
        uvc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:uvc animated:YES];
    }else{
        DetailVC *dvc = [[DetailVC alloc]init];
        dvc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:dvc animated:YES];
    }
}
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
    
    for (int i = 0; i<4; i++) {
        UILabel *label = (id)[self.view viewWithTag:600 + i];
        label.text = [NSString stringWithFormat:@"%zd",[d minute]];
        
        UILabel *label1 = (id)[self.view viewWithTag:1200 + i];
        label1.text = [NSString stringWithFormat:@"%zd",[d second]];
        
        UILabel *label2 = (id)[self.view viewWithTag:1800 + i];
        label2.text = [NSString stringWithFormat:@"%zd",time];
        //        timeLabel.text = [NSString stringWithFormat:@"%ld分%ld秒%zd", (long)[d minute], (long)[d second],time];//倒计时显示
    }
    
    
    
    
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
