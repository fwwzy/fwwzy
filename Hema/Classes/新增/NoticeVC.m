//
//  NoticeVC.m
//  Hema
//
//  Created by MsTail on 15/12/30.
//  Copyright © 2015年 Hemaapp. All rights reserved.
//

#import "NoticeVC.h"
#import "LjjUISegmentedControl.h"
#import "PrizeMsgVC.h"

@interface NoticeVC ()<LjjUISegmentedControlDelegate> {
    BOOL _isLeft;
    NSInteger _rowNum;
}

@end

@implementation NoticeVC

- (void)loadSet {
    
    [self.navigationItem setLeftItemWithTarget:self action:@selector(leftbtnPressed:) image:@"lg_back"];
    
    LjjUISegmentedControl *segmentedControl = [[LjjUISegmentedControl alloc] init];
    segmentedControl.delegate = self;
    segmentedControl.frame = CGRectMake(0, 0, 130, 30);
    NSArray *segmentArr = [NSArray arrayWithObjects:@"公告",@"消息",nil];
    [segmentedControl AddSegumentArray:segmentArr];
    segmentedControl.backgroundColor = RGB_UI_COLOR(217, 29, 43);
    self.navigationItem.titleView = segmentedControl;
    
    _isLeft = YES;
    
}

- (void)loadData {
    _rowNum = 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    //测试通知
    if (_rowNum != 5) {
        NSNotification *notice = [NSNotification notificationWithName:@"getNotice" object:nil];
        [[NSNotificationCenter defaultCenter] postNotification:notice];
    }
    return _rowNum;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"NoticeVC";

       UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];

        if (_isLeft) {
   
            //iconView
            UIImageView *iconView = [[UIImageView alloc] init];
            iconView.frame = CGRectMake(15, 15, 50, 50);
            iconView.image = [UIImage imageNamed:@"newpulish"];
            iconView.tag = 100;
        
            //titleLbl
            UILabel *titleLbl = [[UILabel alloc] init];
            titleLbl.frame = CGRectMake(70, 17, UI_View_Width - 65, 18);
            titleLbl.textColor = BB_Gray_Color;
            titleLbl.text = @"夺宝奖品声明";
            titleLbl.font = [UIFont systemFontOfSize:15];
            titleLbl.tag = 101;
        
            //contentLbl
            UILabel *contentLbl = [[UILabel alloc] init];
            contentLbl.frame = CGRectMake(70, 45, UI_View_Width - 65, 18);
            contentLbl.font = [UIFont systemFontOfSize:14];
            contentLbl.text = @"请在参与夺宝前，认真阅读一下说明";
            contentLbl.tag = 102;
        
            //时间
            UILabel *timeLbl = [[UILabel alloc] init];
            timeLbl.frame = CGRectMake(UI_View_Width - 150, 17, 140, 20);
            timeLbl.textAlignment = NSTextAlignmentRight;
            timeLbl.font = [UIFont systemFontOfSize:15];
            timeLbl.textColor = BB_Gray_Color;
            timeLbl.text = @"2014-02-25";
            contentLbl.tag = 103;
            
            //删除
            UIButton *deleteBtn = [[UIButton alloc] init];
            deleteBtn.frame = CGRectMake(self.view.width, 0, 70, 80);
            deleteBtn.backgroundColor = RGB_UI_COLOR(243, 92, 103);
            [deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
            [deleteBtn setTitleColor:BB_White_Color forState:UIControlStateNormal];
             [deleteBtn addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            deleteBtn.tag = indexPath.row;
            
            //scrollView
            UIScrollView *scrollView = [[UIScrollView alloc] init];
            scrollView.frame = CGRectMake(0, 0, self.view.width, 80);
            scrollView.contentSize = CGSizeMake(self.view.width + 70, 0);
            scrollView.pagingEnabled = YES;
            scrollView.showsHorizontalScrollIndicator = NO;
            
            [scrollView addSubview:iconView];
            [scrollView addSubview:titleLbl];
            [scrollView addSubview:contentLbl];
            [scrollView addSubview:timeLbl];
            [scrollView addSubview:deleteBtn];
            [cell.contentView addSubview:scrollView];
        
        } else {
            
            //iconView
            UIImageView *iconView = [[UIImageView alloc] init];
            iconView.frame = CGRectMake(15, 15, 50, 50);
            iconView.image = [UIImage imageNamed:@"newpulish"];
            iconView.tag = 200;
            
            //contentLbl
            UILabel *contentLbl = [[UILabel alloc] init];
            contentLbl.frame = CGRectMake(70, 17, UI_View_Width - 80, 30);
            contentLbl.font = [UIFont systemFontOfSize:12];
            contentLbl.lineBreakMode = NSLineBreakByTruncatingTail;
            contentLbl.numberOfLines = 0;
            contentLbl.text = @"恭喜您！在第1235期中，赢得煎饼果子一个，煎饼果子还是加鸡蛋加油条加火腿肠的，您赚大了";
            contentLbl.tag = 201;
            
            //时间
            UILabel *timeLbl = [[UILabel alloc] init];
            timeLbl.frame = CGRectMake(UI_View_Width - 150, 47, 140, 20);
            timeLbl.textAlignment = NSTextAlignmentRight;
            timeLbl.font = [UIFont systemFontOfSize:15];
            timeLbl.textColor = BB_Gray_Color;
            timeLbl.text = @"2014-02-25";
            timeLbl.tag = 202;
            
            //删除
            UIButton *deleteBtn = [[UIButton alloc] init];
            deleteBtn.frame = CGRectMake(self.view.width, 0, 70, 80);
            deleteBtn.backgroundColor = RGB_UI_COLOR(243, 92, 103);
            [deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
            [deleteBtn setTitleColor:BB_White_Color forState:UIControlStateNormal];
            [deleteBtn addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            deleteBtn.tag = indexPath.row;
            
            //scrollView
            UIScrollView *scrollView = [[UIScrollView alloc] init];
            scrollView.frame = CGRectMake(0, 0, self.view.width, 80);
            scrollView.contentSize = CGSizeMake(self.view.width + 70, 0);
            scrollView.pagingEnabled = YES;
            scrollView.showsHorizontalScrollIndicator = NO;
            
            [scrollView addSubview:iconView];
            [scrollView addSubview:contentLbl];
            [scrollView addSubview:timeLbl];
            [scrollView addSubview:deleteBtn];
            [cell.contentView addSubview:scrollView];
        }
    //赋值
//    UIImageView *leftIcon = (UIImageView *)[cell viewWithTag:100];
//    UILabel *leftTitle = (UILabel *)[cell viewWithTag:101];
//    UILabel *leftTime = (UILabel *)[cell viewWithTag:103];
//    UILabel *leftContent = (UILabel *)[cell viewWithTag:102];
//    
//    UIImageView *rightIcon = (UIImageView *)[cell viewWithTag:200];
//    UILabel *rightTime = (UILabel *)[cell viewWithTag:202];
//    UILabel *rightContent = (UILabel *)[cell viewWithTag:201];
    
    cell.tag = 100 + indexPath.row;
    return cell;
}

//segument切换点击事件
-(void)uisegumentSelectionChange:(NSInteger)selection {
    if (selection == 0) {
        _isLeft = YES;
        [self.mytable reloadData];
    } else {
        _isLeft = NO;
        [self.mytable reloadData];
    }
}

//cell删除点击事件
- (void)deleteBtnClick:(UIButton *)sender {
    UITableViewCell *cell = (UITableViewCell *)[self.view viewWithTag:100 + sender.tag];
    [cell removeFromSuperview];
    //模拟数据源行数减1
    _rowNum --;
   [self.mytable reloadData];
   
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PrizeMsgVC *msgVC = [[PrizeMsgVC alloc] init];
    [self.navigationController pushViewController:msgVC animated:YES];
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
