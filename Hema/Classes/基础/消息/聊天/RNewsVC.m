//
//  QiHomeVC.m
//  PingChuan
//
//  Created by LarryRodic on 15/7/28.
//  Copyright (c) 2015年 平川嘉恒. All rights reserved.
//
#define TopHeight 44

#import "RNewsVC.h"
#import "RFriendVC.h"
#import "RChatListVC.h"

#import "MMDrawerController.h"

@interface RNewsVC ()<UITableViewDataSource,UITableViewDelegate>
{
    NSInteger selectIndex;
}
@property(nonatomic,strong)UITableView *categoryTable;//话题类别表
@property(nonatomic,strong)NSArray *categoryList;//类别名称数组
@property(nonatomic,strong)UIScrollView *categoryScroll;
@property(nonatomic,strong)NSMutableDictionary *topicDict;//topicList字典
@property(nonatomic,strong)RChatListVC *chatlist;
@property(nonatomic,strong)RFriendVC *friendlist;
@end

@implementation RNewsVC
@synthesize categoryTable;
@synthesize categoryList;
@synthesize categoryScroll;
@synthesize topicDict;
@synthesize chatlist;
@synthesize friendlist;

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [categoryTable setHidden:NO];
    if (friendlist)
        [friendlist requestGetFriendList];
    
    //禁止使用三级导航的侧滑
    if ([[HemaFunction xfuncGetAppdelegate].window.rootViewController isKindOfClass:[MMDrawerController class]])
    {
        MMDrawerController *mm = (MMDrawerController*)[HemaFunction xfuncGetAppdelegate].window.rootViewController;
        [mm.pan setEnabled:NO];
    }
    
    if (chatlist)
        [chatlist refresh];
}
- (void)viewWillDisappear:(BOOL)animated
{
    //允许使用三级导航的侧滑
    if ([[HemaFunction xfuncGetAppdelegate].window.rootViewController isKindOfClass:[MMDrawerController class]])
    {
        MMDrawerController *mm = (MMDrawerController*)[HemaFunction xfuncGetAppdelegate].window.rootViewController;
        [mm.pan setEnabled:YES];
    }
    [categoryTable setHidden:YES];
    [super viewWillDisappear:animated];
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:BB_NOTIFICATION_GET_MESSAGE object:nil];
}
-(void)loadSet
{
    //类别表
    categoryTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, UI_View_Width, TopHeight) style:UITableViewStylePlain];
    categoryTable.bounds = CGRectMake(0, 0, UI_View_Width, TopHeight);
    categoryTable.delegate = self;
    categoryTable.dataSource = self;
    categoryTable.showsVerticalScrollIndicator = NO;
    categoryTable.backgroundColor = [UIColor clearColor];
    categoryTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    categoryTable.backgroundView = nil;
    [categoryTable setScrollEnabled:NO];
    [self.navigationController.navigationBar addSubview:categoryTable];
    
    //scrollerView
    categoryScroll = [[UIScrollView alloc] init];
    categoryScroll.frame = CGRectMake(0, 0, UI_View_Width, UI_View_Height-49);
    categoryScroll.contentSize = CGSizeMake(UI_View_Width*categoryList.count, UI_View_Height-49);
    categoryScroll.pagingEnabled = YES;
    [categoryScroll setBackgroundColor:[UIColor clearColor]];
    categoryScroll.showsHorizontalScrollIndicator = NO;
    categoryScroll.delegate = self;
    [categoryScroll setScrollEnabled:NO];
    [self.view addSubview:categoryScroll];
    
    [self selectCategory:0];
    
    //聊天消息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getXiMessage:) name:BB_NOTIFICATION_GET_MESSAGE object:nil];
}
-(void)loadData
{
    categoryList = [[NSArray alloc] initWithObjects:@"信息",@"好友", nil];
    topicDict = [[NSMutableDictionary alloc] init];
}
#pragma mark- 自定义
#pragma mark 事件
//去选择类别
-(void)gotoSelect:(HemaButton*)sender
{
    [self selectCategory:(int)sender.btnRow];
}
#pragma mark 方法
//选择类别
- (void)selectCategory:(int)number
{
    NSString *name = [categoryList objectAtIndex:number];
    if(![topicDict objectForKey:name])
    {
        switch (number)
        {
            case 0:
            {
                chatlist = [[RChatListVC alloc] init];
                [topicDict setObject:chatlist forKey:name];
                [categoryScroll addSubview:chatlist.view];
                [chatlist reSetTableViewFrame:CGRectMake(0, 0, UI_View_Width, UI_View_Height-49)];
                [chatlist.view setFrame:CGRectMake(UI_View_Width*number, 0, UI_View_Width, UI_View_Height-49)];
                break;
            }
            case 1:
            {
                friendlist = [[RFriendVC alloc] init];
                [topicDict setObject:friendlist forKey:name];
                [categoryScroll addSubview:friendlist.view];
                [friendlist reSetTableViewFrame:CGRectMake(0, 0, UI_View_Width, UI_View_Height-49)];
                [friendlist.view setFrame:CGRectMake(UI_View_Width*number, 0, UI_View_Width, UI_View_Height-49)];
                break;
            }
            default:
                break;
        }
    }
    selectIndex = number;
    [categoryTable reloadData];
    [categoryScroll setContentOffset:CGPointMake(UI_View_Width*number,0) animated:NO];
}
#pragma mark- 获取聊天通知
//聊天
- (void)getXiMessage:(NSNotification*)notification
{
    [chatlist refresh];
}
#pragma mark- UITableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *categoryCellID = @"all";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:categoryCellID];
    if(nil == cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:categoryCellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
    }else
    {
        for(UIView *subView in cell.contentView.subviews)
        {
            [subView removeFromSuperview];
        }
    }
    
    for (int i = 0; i<2; i++)
    {
        HemaButton *temBtn = [HemaButton buttonWithType:UIButtonTypeCustom];
        [temBtn setFrame:CGRectMake(60+(UI_View_Width-120)/2*i, 0, (UI_View_Width-120)/2, 44)];
        if (selectIndex == i)
        {
            [temBtn.titleLabel setTextColor:BB_White_Color];
            [temBtn setTitleColor:BB_White_Color forState:UIControlStateNormal];
        }else
        {
            [temBtn.titleLabel setTextColor:BB_Blake_Color];
            [temBtn setTitleColor:BB_Blake_Color forState:UIControlStateNormal];
        }
        
        temBtn.btnRow = i;
        [temBtn addTarget:self action:@selector(gotoSelect:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:temBtn];
        
        [temBtn setTitle:[categoryList objectAtIndex:i] forState:UIControlStateNormal];
        [temBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
    }
    
    UIView *lineView = [[UIView alloc]init];
    [lineView setFrame:CGRectMake(70+(UI_View_Width-120)/2*selectIndex, 42, (UI_View_Width-120)/2-20, 2)];
    [lineView setBackgroundColor:BB_White_Color];
    [cell.contentView addSubview:lineView];
    
    return cell;
}
#pragma mark- UITableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return TopHeight;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
#pragma mark- UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == categoryTable)
    {
        return;
    }
    CGFloat offsetx = scrollView.contentOffset.x;
    
    if(0 == fmod(offsetx, UI_View_Width))
    {
        int page = (offsetx+UI_View_Width - 1)/UI_View_Width;
        [self selectCategory:page];
    }
}
@end
