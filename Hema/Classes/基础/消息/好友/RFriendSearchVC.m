//
//  GoodSearchVC.m
//  PingChuan
//
//  Created by LarryRodic on 15/6/20.
//  Copyright (c) 2015年 平川嘉恒. All rights reserved.
//

#import "RFriendSearchVC.h"
#import "HemaTapGR.h"

#import "RFriendVC.h"
#import "RPeopleListVC.h"

@interface RFriendSearchVC ()<UISearchBarDelegate,UIGestureRecognizerDelegate>
@property(nonatomic,strong)RFriendVC *friendlist;
@property(nonatomic,strong)RPeopleListVC *peoplelist;
@property(nonatomic,strong)UISearchBar *searcher;//搜索框
@property(nonatomic,strong)UIView *disableViewOverlay;//搜索时候的遮盖层
@end

@implementation RFriendSearchVC
@synthesize searchType;
@synthesize friendlist;
@synthesize peoplelist;
@synthesize searcher;
@synthesize disableViewOverlay;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadSet];
}
-(void)loadSet
{
    self.navigationItem.backBarButtonItem = nil;
    [self.navigationItem setHidesBackButton:YES];
    self.navigationItem.leftBarButtonItems = nil;
    
    //搜索相关
    searcher = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, UI_View_Width, 44)];
    searcher.barStyle = UIBarButtonItemStyleBordered;
    searcher.placeholder = @"搜索";
    [searcher setTintColor:BB_Green_Color];
    searcher.delegate = self;
    searcher.translucent = YES;
    searcher.backgroundColor = [UIColor clearColor];
    self.navigationItem.titleView = searcher;
    
    UIView *temView = [[[searcher.subviews objectAtIndex:0] subviews]objectAtIndex:1];
    [temView setBackgroundColor:BB_White_Color];
    
    disableViewOverlay = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UI_View_Width, UI_View_Height)];
    [disableViewOverlay setBackgroundColor:[UIColor blackColor]];
    [disableViewOverlay setAlpha:0.5];
    [disableViewOverlay setHidden:NO];
    [self.view addSubview:disableViewOverlay];
    
    HemaTapGR *temTap = [[HemaTapGR alloc] initWithTarget:self action:@selector(handlemySingleTap:)];
    [disableViewOverlay addGestureRecognizer:temTap];
    temTap.numberOfTapsRequired = 1;
    temTap.numberOfTouchesRequired = 1;
    temTap.delegate = self;
    
    [searcher becomeFirstResponder];
    
    [self.view setFrame:CGRectMake(0, 0, UI_View_Width, UI_View_Height)];
    
    if (searchType == 1)
    {
        searcher.placeholder = @"请输入奇信号或昵称";
    }
    if (searchType == 2)
    {
        searcher.placeholder = @"搜索添加好友";
    }
}
#pragma mark- 自定义
#pragma mark 事件
- (void)handlemySingleTap:(HemaTapGR *)tap
{
    [disableViewOverlay setHidden:YES];
    [self.searcher resignFirstResponder];
    
    for (UIView *search in searcher.subviews)
    {
        for(UIView *subView in search.subviews)
        {
            if([subView isKindOfClass:[UIButton class]])
            {
                UIButton *cancelBtn = (UIButton*)subView;
                [cancelBtn setEnabled: YES];
            }
        }
    }
}
#pragma mark- UISearchBar Delegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    [disableViewOverlay setHidden:NO];
    self.searcher.showsCancelButton = YES;
    
    for (UIView *search in searchBar.subviews)
    {
        for (UIView *searchbuttons in search.subviews)
        {
            if ([searchbuttons isKindOfClass:[UIButton class]])
            {
                UIButton *cancelButton = (UIButton*)searchbuttons;
                cancelButton.enabled = YES;
                [cancelButton setHidden:NO];
                [cancelButton setTitleShadowColor:[UIColor clearColor] forState:UIControlStateNormal];
                [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
                [cancelButton setTitleColor:BB_White_Color forState:UIControlStateNormal];
                [cancelButton setTitleEdgeInsets:UIEdgeInsetsMake(3.0f, 0.0f, 0.0f, 0.0f)];
                [cancelButton.titleLabel setFont:[UIFont systemFontOfSize:13]];
                break;
            }
        }
    }
    
    return YES;
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    self.searcher.showsCancelButton = NO;
    [self.searcher resignFirstResponder];
    searcher.text = nil;
    
    [self.navigationController popViewControllerAnimated:NO];
    return;
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    if ([HemaFunction xfunc_check_strEmpty:searchBar.text])
    {
        return;
    }
    [searchBar resignFirstResponder];
    
    for (UIView *search in searchBar.subviews)
    {
        for(UIView *subView in search.subviews)
        {
            if([subView isKindOfClass:[UIButton class]])
            {
                UIButton *cancelBtn = (UIButton*)subView;
                [cancelBtn setEnabled: YES];
            }
        }
    }
    [disableViewOverlay setHidden:YES];
    
    if (searchType == 1)
    {
        if (friendlist)
        {
            [friendlist.view removeFromSuperview];
        }
        friendlist = [[RFriendVC alloc]init];
        friendlist.keyword = searchBar.text;
        [self.view insertSubview:friendlist.view belowSubview:disableViewOverlay];
        [friendlist.view setFrame:CGRectMake(0, 0, UI_View_Width, UI_View_Height)];
    }
    if (searchType == 2)
    {
        if (peoplelist)
        {
            [peoplelist.view removeFromSuperview];
        }
        peoplelist = [[RPeopleListVC alloc]init];
        peoplelist.keyword = searchBar.text;
        [self.view insertSubview:peoplelist.view belowSubview:disableViewOverlay];
        [peoplelist.view setFrame:CGRectMake(0, 0, UI_View_Width, UI_View_Height)];
    }
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    
}
@end
