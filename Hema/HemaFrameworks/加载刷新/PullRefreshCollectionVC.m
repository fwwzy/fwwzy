//
//  PullRefreshPlainVC.m
//  Hema
//
//  Created by LarryRodic on 15/10/6.
//  Copyright (c) 2015年 Hemaapp. All rights reserved.
//

#define REFRESH_HEADER_HEIGHT 52.0f //刷新view的高度
#define ADDMORE_HEIGHT 0 //加载所拉的高度
#define Pic_X UI_View_Width/2-40 //图片的起始坐标

#import "PullRefreshCollectionVC.h"

@interface PullRefreshCollectionVC ()
{
    BOOL isDragging;
}
//顶部刷新view
@property(nonatomic,strong)UIView *refreshHeaderView;
@property(nonatomic,strong)UILabel *refreshLabel;
@property(nonatomic,strong)UIImageView *refreshArrow;
@property(nonatomic,strong)UIActivityIndicatorView *refreshSpinner;
//底部加载view
@property(nonatomic,strong)UIView *footerView;
@property(nonatomic,strong)UILabel *addmoreLab;
@property(nonatomic,strong)UIActivityIndicatorView *addmoreSpinner;
//无数据view
@property(nonatomic,strong)UIView *noDataView;
@property(nonatomic,strong)UIImageView *noImgView;
@property(nonatomic,strong)UILabel *noDataLab;
@end

@implementation PullRefreshCollectionVC
@synthesize mytable;

- (void)viewDidLoad
{
    isPullRefresh = YES;
    [super viewDidLoad];
    [self loadMySet];
    [self addPullToRefreshHeader];
    [self addPullFooterView];
    [self addNoDataView];
    [self loadData];
    [self loadSet];
}
-(void)loadMySet
{
    mytable = [[PSCollectionView alloc]initWithFrame:CGRectMake(0, 0, UI_View_Width, UI_View_Height)];
    mytable.collectionViewDelegate = self;
    mytable.collectionViewDataSource = self;
    mytable.backgroundColor=[UIColor clearColor];
    mytable.showsHorizontalScrollIndicator = NO;
    mytable.showsVerticalScrollIndicator = NO;
    mytable.numColsPortrait = 2;
    mytable.delegate = self;
    [self.view addSubview:mytable];
}
-(void)addPullToRefreshHeader
{
    _refreshHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, -REFRESH_HEADER_HEIGHT, UI_View_Width, REFRESH_HEADER_HEIGHT)];
    _refreshHeaderView.backgroundColor = [UIColor clearColor];
    
    _refreshLabel = [[UILabel alloc] initWithFrame:CGRectMake(UI_View_Width/2-10, 10, UI_View_Width/2, REFRESH_HEADER_HEIGHT-20)];
    _refreshLabel.backgroundColor = [UIColor clearColor];
    _refreshLabel.font = [UIFont systemFontOfSize:13];
    _refreshLabel.textAlignment = NSTextAlignmentLeft;
    _refreshLabel.textColor = RefreshFont;
    _refreshLabel.text = @"下拉刷新";
    
    _refreshArrow = [[UIImageView alloc] initWithImage:RefreshArrow];
    _refreshArrow.frame = CGRectMake(Pic_X, floorf((REFRESH_HEADER_HEIGHT-36)/2),19.5, 36);
    
    _refreshSpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _refreshSpinner.frame = CGRectMake(Pic_X, floorf((REFRESH_HEADER_HEIGHT-20)/2), 20, 20);
    _refreshSpinner.hidesWhenStopped = YES;
    
    [_refreshHeaderView addSubview:_refreshLabel];
    [_refreshHeaderView addSubview:_refreshArrow];
    [_refreshHeaderView addSubview:_refreshSpinner];
    [mytable addSubview:_refreshHeaderView];
}
-(void)addPullFooterView
{
    _footerView = [[UIView alloc]initWithFrame:CGRectMake(0,mytable.frame.size.height, UI_View_Width, 30)];
    
    _addmoreSpinner = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _addmoreSpinner.frame = CGRectMake(Pic_X, floorf((_footerView.frame.size.height-20)/2), 20, 20);
    _addmoreSpinner.hidesWhenStopped = YES;
    [_addmoreSpinner startAnimating];
    [_footerView addSubview:_addmoreSpinner];
    [_footerView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:_footerView];
    
    _addmoreLab = [[UILabel alloc]initWithFrame:CGRectMake(UI_View_Width/2-10,0, UI_View_Width/2, _footerView.frame.size.height)];
    _addmoreLab.backgroundColor = [UIColor clearColor];
    _addmoreLab.text = @"正在加载";
    _addmoreLab.font = [UIFont systemFontOfSize:13];
    _addmoreLab.textColor = RefreshFont;
    _addmoreLab.textAlignment = NSTextAlignmentLeft;
    [_footerView addSubview:_addmoreLab];
}
-(void)addNoDataView
{
    _noDataView = [[UIView alloc] initWithFrame:CGRectZero];
    [_noDataView setHidden:YES];
    [mytable insertSubview:_noDataView belowSubview:_refreshHeaderView];
    
    _noImgView = [[UIImageView alloc]init];
    [_noImgView setFrame:CGRectMake((UI_View_Width-66)/2, 71, 66, 66)];
    [_noDataView addSubview:_noImgView];
    
    _noDataLab = [[UILabel alloc] init];
    _noDataLab.numberOfLines = 0;
    _noDataLab.backgroundColor = [UIColor clearColor];
    _noDataLab.textAlignment = NSTextAlignmentCenter;
    _noDataLab.textColor = BB_Gray_Color;
    [_noDataView addSubview:_noDataLab];
}
-(void)reSetTableViewFrame:(CGRect)newFrame
{
    mytable.frame = newFrame;
    _footerView.frame = CGRectMake(0, mytable.frame.size.height, UI_View_Width, 30);
}
-(void)loadSet
{
    
}
-(void)loadData
{
    
}
#pragma mark- UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(isLoading)
    {
        if(scrollView.contentOffset.y > 0)
            mytable.contentInset = UIEdgeInsetsZero;
        else if(scrollView.contentOffset.y >= -REFRESH_HEADER_HEIGHT)
            mytable.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    }else if (isDragging && scrollView.contentOffset.y < 0)
    {
        if(isForbidRefresh)
            return;
        [UIView animateWithDuration:0.25 animations:^{
            if(scrollView.contentOffset.y < -REFRESH_HEADER_HEIGHT)
            {
                [_refreshLabel setText:@"松开刷新"];
                [_refreshArrow layer].transform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
            }else
            {
                [_refreshLabel setText:@"下拉刷新"];
                [_refreshArrow layer].transform = CATransform3DMakeRotation(M_PI * 2, 0, 0, 1);
            }
        }];
    }else
    {
        if(isForbidMore)
            return;
        if(mytable.contentSize.height<mytable.frame.size.height)
        {
            if(scrollView.contentOffset.y>ADDMORE_HEIGHT)
            {
                if(!isMore)
                {
                    isMore=YES;
                    [self startAddMore];
                }
            }
        }else
        {
            if(mytable.contentSize.height-scrollView.contentOffset.y<=mytable.frame.size.height-ADDMORE_HEIGHT)
            {
                if(!isMore)
                {
                    isMore=YES;
                    [self startAddMore];
                }
            }
        }
    }
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (isLoading)
        return;
    isDragging = YES;
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (isLoading)
        return;
    isDragging = NO;
    if (scrollView.contentOffset.y <= -REFRESH_HEADER_HEIGHT)
    {
        if(isForbidRefresh)
            return;
        [self startLoading];
    }
}
#pragma mark - PSCollectionViewDelegate and DataSource
- (NSInteger)numberOfRowsInCollectionView:(PSCollectionView *)collectionView
{
    return 0;
}
- (PSCollectionViewCell *)collectionView:(PSCollectionView *)collectionView cellForRowAtIndex:(NSInteger)index
{
    PSCollectionViewCell *cell = (PSCollectionViewCell*)[collectionView dequeueReusableViewForClass:[PSCollectionViewCell class]];
    if (!cell)
    {
        cell = [[PSCollectionViewCell alloc] initWithFrame:CGRectZero];
        cell.backgroundColor = [UIColor clearColor];
    }
    return cell;
}
- (CGFloat)collectionView:(PSCollectionView *)collectionView heightForRowAtIndex:(NSInteger)index
{
    return 0;
}
- (void)collectionView:(PSCollectionView *)collectionView didSelectCell:(PSCollectionViewCell *)cell atIndex:(NSInteger)index
{
    
}
#pragma mark- 上拉加载更多
-(void)startAddMore
{
    [_footerView setHidden:NO];
    [UIView animateWithDuration:0.3 animations:^{
        mytable.contentInset = UIEdgeInsetsMake(0, 0, _footerView.frame.size.height, 0);
        _footerView.frame=CGRectOffset(_footerView.frame, 0, -_footerView.frame.size.height);
        [_addmoreSpinner startAnimating];
        [_addmoreLab setTextAlignment:NSTextAlignmentLeft];
        _addmoreLab.text = @"正在加载";
    }];
    [self addMore];
}
-(void)addMore
{
    //开始请求加载更多数据，子类重写
}
-(void)stopAddMore
{
    [UIView animateWithDuration:0.7 animations:^{
        _footerView.frame = CGRectOffset(_footerView.frame, 0, _footerView.frame.size.height);
        mytable.contentInset = UIEdgeInsetsZero;
        isMore = NO;
    } completion:^(BOOL finished){
        [_footerView setHidden:YES];
    }];
}
-(void)forbidAddMore
{
    isForbidMore = YES;
}
-(void)canAddMore
{
    isForbidMore = NO;
}
#pragma mark- 刷新数据
//开始刷新数据
- (void)startLoading
{
    isLoading = YES;
    [UIView animateWithDuration:0.3 animations:^{
        mytable.contentInset = UIEdgeInsetsMake(REFRESH_HEADER_HEIGHT, 0, 0, 0);
        [_refreshArrow setHidden:YES];
        [_refreshLabel setText:@"正在刷新"];
        [_refreshSpinner startAnimating];
    }];
    [self refresh];
}
//刷新数据
- (void)refresh
{
    [self performSelector:@selector(stopLoading) withObject:nil afterDelay:0];
}
- (void)stopLoading
{
    isLoading = NO;
    
    [UIView animateWithDuration:0.3 animations:^{
        mytable.contentInset = UIEdgeInsetsZero;
        [_refreshArrow layer].transform = CATransform3DMakeRotation(M_PI * 2, 0, 0, 1);
    }completion:^(BOOL finished){
        [self performSelector:@selector(stopLoadingComplete)];
    }];
}
- (void)stopLoadingComplete
{
    [_refreshArrow setHidden:NO];
    [_refreshLabel setText:@"下拉刷新"];
    [_refreshSpinner stopAnimating];
}
#pragma mark- 返回数据情况
-(void)getNoMoreData
{
    [_addmoreSpinner stopAnimating];
    [_addmoreLab setFrame:CGRectMake(0, 0, _footerView.frame.size.width, _footerView.frame.size.height)];
    [_addmoreLab setTextAlignment:NSTextAlignmentCenter];
    _addmoreLab.text = @"无更多数据";
}
-(void)hideNoDataView
{
    [_noDataView setHidden:YES];
}
-(void)showNoDataView:(NSString*)str
{
    [_noDataView setHidden:NO];
    _noDataLab.text = str;
    _noDataLab.font = [UIFont systemFontOfSize:14];
    _noDataLab.frame = CGRectMake(0, 150, UI_View_Width, 16);
    
    if ([HemaFunction canConnectNet])
    {
        _noDataLab.text = str;
        [self showNoDataImg:RefreshNoData];
        [_noImgView setFrame:CGRectMake((UI_View_Width-66)/2, 71, 66, 66)];
    }else
    {
        _noDataLab.text = @"网络不给力，请到有网的条件下浏览";
        [self showNoDataImg:@"R无网图标"];
        [_noImgView setFrame:CGRectMake((UI_View_Width-90)/2, 71, 90, 65)];
    }
}
-(void)showNoDataImg:(NSString*)str
{
    [_noDataView setHidden:NO];
    if ([HemaFunction canConnectNet])
    {
        [_noImgView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png",str]]];
        [_noImgView setFrame:CGRectMake((UI_View_Width-66)/2, 71, 66, 66)];
    }else
    {
        [_noImgView setImage:[UIImage imageNamed:@"R无网图标"]];
        [_noImgView setFrame:CGRectMake((UI_View_Width-90)/2, 71, 90, 65)];
    }
}
#pragma mark- 无加载刷新
-(void)forbidPullRefresh
{
    isForbidMore = YES;
    isForbidRefresh = YES;
    
    [_refreshHeaderView setHidden:YES];
    [_footerView setHidden:YES];
}
@end
