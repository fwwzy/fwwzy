//
//  RNormalListVC.m
//  Hema
//
//  Created by LarryRodic on 15/10/6.
//  Copyright (c) 2015年 Hemaapp. All rights reserved.
//

#import "RNormalListVC.h"

@interface RNormalListVC ()
@property(nonatomic,strong)NSMutableArray *dataSource;
@end

@implementation RNormalListVC
@synthesize dataSource;

-(void)loadSet
{
    [self.navigationItem setNewTitle:@"列表"];
    
    [self.mytable setSeparatorInset:UIEdgeInsetsMake(0, 61, 0, 0)];
}
-(void)loadData
{
    [self refresh];
}
#pragma mark- 自定义
#pragma mark 事件
#pragma mark - UITableView dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"all";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.backgroundColor = BB_White_Color;
        
        //头像
        HemaButton *leftBtn = [HemaButton buttonWithType:UIButtonTypeCustom];
        [leftBtn setFrame:CGRectMake(10, 10, 40, 40)];
        leftBtn.tag = 8;
        [HemaFunction addbordertoView:leftBtn radius:4 width:0.0f color:[UIColor clearColor]];
        [cell.contentView addSubview:leftBtn];
        
        //标题
        UILabel *labOne = [[UILabel alloc]init];
        labOne.backgroundColor = [UIColor clearColor];
        labOne.textAlignment = NSTextAlignmentLeft;
        labOne.font = [UIFont systemFontOfSize:14];
        labOne.textColor = BB_Blake_Color;
        labOne.tag = 9;
        labOne.frame = CGRectMake(61, 13, UI_View_Width-171, 16);
        [cell.contentView addSubview:labOne];
        
        //日期
        UILabel *labTime = [[UILabel alloc]init];
        labTime.backgroundColor = [UIColor clearColor];
        labTime.textColor = BB_Gray_Color;
        labTime.textAlignment = NSTextAlignmentRight;
        labTime.font = [UIFont systemFontOfSize:11];
        labTime.frame = CGRectMake(UI_View_Width-100, 13, 90, 13);
        labTime.tag = 11;
        [cell.contentView addSubview:labTime];
        
        //内容
        UILabel *lableft = [[UILabel alloc]init];
        lableft.backgroundColor = [UIColor clearColor];
        lableft.textAlignment = NSTextAlignmentLeft;
        lableft.font = [UIFont systemFontOfSize:14];
        lableft.textColor = BB_Gray_Color;
        lableft.frame = CGRectMake(61, 39, UI_View_Width-71, 14);
        lableft.tag = 10;
        lableft.numberOfLines = 0;
        [cell.contentView addSubview:lableft];
    }
    NSMutableDictionary *temDic = [dataSource objectAtIndex:indexPath.row];
    
    //头像
    HemaButton *leftBtn = (HemaButton*)[cell viewWithTag:8];
    [leftBtn setUserInteractionEnabled:NO];
    [SystemFunction cashButton:leftBtn url:[temDic objectForKey:@"avatar"] firstImg:@"R默认小头像.png"];
    
    UILabel *labOne = (UILabel*)[cell viewWithTag:9];
    [labOne setText:[temDic objectForKey:@"nickname"]];
    
    UILabel *labTime = (UILabel*)[cell viewWithTag:11];
    UILabel *lableft = (UILabel*)[cell viewWithTag:10];
    
    [labTime setText:[HemaFunction getTimeFromDate:[temDic objectForKey:@"regdate"]]];
    [lableft setText:[temDic objectForKey:@"content"]];
    
    CGSize temSize = [HemaFunction getSizeWithStrNo:lableft.text width:UI_View_Width-71 font:14];
    [lableft setFrame:CGRectMake(61, 39, UI_View_Width-71, temSize.height)];
    
    return cell;
}
#pragma mark - Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 8;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *temDic = [dataSource objectAtIndex:indexPath.row];
    
    CGSize temSize = [HemaFunction getSizeWithStrNo:[temDic objectForKey:@"content"] width:UI_View_Width-71 font:14];
    return 39+temSize.height+12;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *) indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [ShareFunction share:2 dataDic:[dataSource objectAtIndex:indexPath.row] myVC:self];
}
#pragma mark - 连接服务器
#pragma mark 列表
- (void)requestChapterList
{
    NSString *token = [[HemaManager sharedManager] userToken];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:token forKey:@"token"];
    [dic setObject:@"6" forKey:@"keytype"];
    [dic setObject:[NSString stringWithFormat:@"%f,%f",[HemaFunction xfuncGetAppdelegate].myCoordinate.latitude,[HemaFunction xfuncGetAppdelegate].myCoordinate.longitude] forKey:@"keyid"];
    [dic setObject:[NSString stringWithFormat:@"%d",(int)currentPage] forKey:@"page"];
    
    [HemaRequest requestWithURL:[NSString stringWithFormat:@"%@%@",REQUEST_MAINLINK,REQUEST_BLOG_LIST] target:self selector:@selector(responseChapterList:) parameter:dic];
}
- (void)responseChapterList:(NSDictionary*)info
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
        [self showNoDataView:@"暂无数据"];
    }else
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
    [self requestChapterList];
}
-(void)addMore
{
    if (!isEnd)
    {
        currentPage++;
    }
    [self requestChapterList];
}
@end
