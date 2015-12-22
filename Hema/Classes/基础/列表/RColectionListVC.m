//
//  RColectionListVC.m
//  Hema
//
//  Created by LarryRodic on 15/10/7.
//  Copyright (c) 2015年 Hemaapp. All rights reserved.
//

#import "RColectionListVC.h"
#import "RCollectionCell.h"

#import "UIImageView+MJWebCache.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"

@interface RColectionListVC ()
@property(nonatomic,strong)NSMutableArray *dataSource;
@end

@implementation RColectionListVC
@synthesize dataSource;

-(void)loadSet
{
    [self.navigationItem setNewTitle:@"我的相册"];
    self.mytable.numColsPortrait = 4;
}
-(void)loadData
{
    [self refresh];
}
#pragma mark- 自定义
#pragma mark 事件
#pragma mark - PSCollectionViewDelegate and DataSource
- (NSInteger)numberOfRowsInCollectionView:(PSCollectionView *)collectionView
{
    return dataSource.count;
}
- (PSCollectionViewCell *)collectionView:(PSCollectionView *)collectionView cellForRowAtIndex:(NSInteger)index
{
    RCollectionCell *cell = (RCollectionCell *)[collectionView dequeueReusableViewForClass:[RCollectionCell class]];
    if (!cell)
    {
        cell = [[RCollectionCell alloc] initWithFrame:CGRectZero];
        cell.backgroundColor = [UIColor clearColor];
    }
    
    NSMutableDictionary *temDic = [dataSource objectAtIndex:index];
    
    cell.topImgView.tag = 100+index;
    [SystemFunction cashImgView:cell.topImgView url:[temDic objectForKey:@"imgurl"] firstImg:@"R图片默认背景.png"];
    
    return cell;
}
- (CGFloat)collectionView:(PSCollectionView *)collectionView heightForRowAtIndex:(NSInteger)index
{
    return (UI_View_Width-20)/4-5;
}
- (void)collectionView:(PSCollectionView *)collectionView didSelectCell:(PSCollectionViewCell *)cell atIndex:(NSInteger)index
{
    int count = (int)[dataSource count];
    // 1.封装图片数据
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i<count; i++)
    {
        // 替换为中等尺寸图片
        NSString *url = [[dataSource objectAtIndex:i] objectForKey:@"imgurlbig"];
        MJPhoto *photo = [[MJPhoto alloc] init];
        photo.url = [NSURL URLWithString:url]; // 图片路径
        photo.srcImageView = (UIImageView*)[self.mytable viewWithTag:100+i];
        [photos addObject:photo];
    }
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.currentPhotoIndex = index;
    browser.photos = photos;
    [browser show];
}
#pragma mark - 连接服务器
#pragma mark 相册列表
- (void)requestGoodsList
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    
    [dic setObject:@"18" forKey:@"keytype"];
    [dic setObject:[[[HemaManager sharedManager] myInfor] objectForKey:@"id"] forKey:@"keyid"];
    [dic setObject:[NSString stringWithFormat:@"%d",(int)currentPage] forKey:@"page"];
    
    [HemaRequest requestWithURL:[NSString stringWithFormat:@"%@%@",REQUEST_MAINLINK,REQUEST_IMG_LIST] target:self selector:@selector(responseGoodsList:) parameter:dic];
}
- (void)responseGoodsList:(NSDictionary*)info
{
    if(1 == [[info objectForKey:@"success"] intValue])
    {
        if (!dataSource)
            dataSource = [[NSMutableArray alloc]init];
        if(0 == currentPage)
            [dataSource removeAllObjects];
        NSString *val=[[info objectForKey:@"infor"]objectForKey:@"listItems"];
        if ([HemaFunction xfunc_check_strEmpty:val])
        {
            [self forbidAddMore];
            isEnd = YES;
            if(isMore)
                [self getNoMoreData];
        }else
        {
            NSArray *temArr = [[info objectForKey:@"infor"]objectForKey:@"listItems"];
            if ([temArr count] == 0)
            {
                [self forbidAddMore];
                isEnd = YES;
                if(isMore)
                    [self getNoMoreData];
            }else
            {
                if (temArr.count < 20)
                {
                    [self forbidAddMore];
                }else
                {
                    [self canAddMore];
                }
                for (int i = 0; i<temArr.count; i++)
                {
                    NSMutableDictionary *dict = [SystemFunction getDicFromDic:[temArr objectAtIndex:i]];
                    [dataSource addObject:dict];
                }
            }
        }
    }else
    {
        [HemaFunction openIntervalHUD:[info objectForKey:@"msg"]];
    }
    
    //此处特殊处理，因为此接口一次返回，没有分页
    [self forbidAddMore];
    
    [self reShowView];
    if(isMore)
    {
        [self stopAddMore];
    }
    if(isLoading)
    {
        [self stopLoading];
    }
}
#pragma mark 加载刷新
//刷新页面
-(void)reShowView
{
    if(0 == dataSource.count)
    {
        [self showNoDataView:@"暂无照片"];
    }
    else
    {
        [self hideNoDataView];
    }
    [self.mytable reloadData];
}
//继承的方法
- (void)refresh
{
    currentPage = 0;
    isEnd = NO;
    [self requestGoodsList];
}
-(void)addMore
{
    if (!isEnd)
    {
        currentPage++;
    }
    [self requestGoodsList];
}
@end
