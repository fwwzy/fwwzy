//
//  PullRefreshPlainVC.h
//  Hema
//
//  Created by LarryRodic on 15/10/6.
//  Copyright (c) 2015年 Hemaapp. All rights reserved.
//

#import "AllVC.h"

@interface PullRefreshPlainVC : AllVC<UITableViewDataSource,UITableViewDelegate>
{
    BOOL isMore;//加载更多
    BOOL isLoading;//正在加载
    BOOL isForbidMore;//禁止加载更多
    BOOL isForbidRefresh;//禁止刷新;
    
    NSInteger currentPage;
    BOOL isEnd;
}
@property(nonatomic,strong)UITableView *mytable;

-(void)forbidPullRefresh;//禁止加载刷新
-(void)forbidAddMore;//禁止加载更多
-(void)canAddMore;//可以加载更多

//处理无数据显示
-(void)showNoDataView:(NSString*)str;
-(void)showNoDataImg:(NSString*)str;
-(void)hideNoDataView;

//加载
-(void)startAddMore;
-(void)addMore;
-(void)stopAddMore;
-(void)getNoMoreData;

//刷新
-(void)startLoading;
-(void)stopLoading;
-(void)refresh;

-(void)reSetTableViewFrame:(CGRect)newFrame;
@end
