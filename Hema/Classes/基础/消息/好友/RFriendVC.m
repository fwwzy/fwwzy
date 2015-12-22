//
//  RFriendVC.m
//  Hema
//
//  Created by LarryRodic on 15/10/8.
//  Copyright (c) 2015年 Hemaapp. All rights reserved.
//

#import "RFriendVC.h"
#import "RInforVC.h"
#import "RFriendSearchVC.h"
#import "RNewFriendListVC.h"
#import "RInviteAddressVC.h"
#import "RGroupListVC.h"

@interface RFriendVC ()
@property(nonatomic,strong)NSMutableArray *suoyinCityList;//右侧索引数组
@property(nonatomic,strong)NSMutableDictionary *dataSource;
@end

@implementation RFriendVC
@synthesize suoyinCityList;
@synthesize dataSource;
@synthesize keyword;

-(void)loadSet
{
    if ([HemaFunction xfunc_check_strEmpty:keyword])
    {
        [self initTopView];
    }else
    {
        [self.mytable setFrame:CGRectMake(0, 0, UI_View_Width, UI_View_Height)];
    }
    self.mytable.sectionIndexBackgroundColor = [UIColor clearColor];
    self.mytable.sectionIndexTrackingBackgroundColor = [UIColor clearColor];
    [self forbidAddMore];
}
-(void)loadData
{
    suoyinCityList = [[NSMutableArray alloc]init];
    [self requestGetFriendList];
}
//顶部
-(void)initTopView
{
    UIView *topView = [[UIView alloc]init];
    [topView setFrame:CGRectMake(0, 0, UI_View_Width, 192)];
    self.mytable.tableHeaderView = topView;
    
    //搜索相关
    UISearchBar *searcher = [[UISearchBar alloc] initWithFrame:CGRectZero];
    searcher.barStyle = UIBarButtonItemStylePlain;
    searcher.placeholder = @"搜索";
    [searcher setTintColor:[UIColor blackColor]];
    searcher.translucent = NO;
    searcher.backgroundColor = [UIColor clearColor];
    [searcher sizeToFit];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    [imageView setFrame:CGRectMake(0, -20, UI_View_Width, 64)];
    imageView.backgroundColor = RGB_UI_COLOR(227, 227, 227);
    [searcher insertSubview:imageView atIndex:1];
    
    [searcher setFrame:CGRectMake(0, 5, UI_View_Width, 44)];
    [topView addSubview:searcher];
    
    //点击跳页的按钮
    UIButton *temBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [temBtn setFrame:CGRectMake(0, 0, UI_View_Width, 44)];
    [temBtn addTarget:self action:@selector(searchPressed:) forControlEvents:UIControlEventTouchUpInside];
    [searcher addSubview:temBtn];
    
    //两行
    UIView *myView = [[UIView alloc]init];
    [myView setFrame:CGRectMake(0, 54, UI_View_Width, 138)];
    [myView setBackgroundColor:BB_White_Color];
    [topView addSubview:myView];
    
    for (int i = 0; i<3; i++)
    {
        UILabel *labLeft = [[UILabel alloc]init];
        labLeft.backgroundColor = [UIColor clearColor];
        labLeft.textAlignment = NSTextAlignmentLeft;
        labLeft.font = [UIFont systemFontOfSize:14];
        labLeft.textColor = BB_Blake_Color;
        labLeft.frame = CGRectMake(10, 46*i, 200, 46);
        labLeft.text = (i == 0)?@"群组":((i == 1)?@"添加好友":@"新的好友");
        [myView addSubview:labLeft];
        
        UIView *line = [[UIView alloc]init];
        [line setFrame:CGRectMake(0, 46*i, UI_View_Width, 0.5)];
        [line setBackgroundColor:BB_lineColor];
        [myView addSubview:line];
        
        HemaButton *myBtn = [HemaButton buttonWithType:UIButtonTypeCustom];
        [myBtn setFrame:CGRectMake(0, 46*i, UI_View_Width, 46)];
        myBtn.btnRow = i;
        [myBtn addTarget:self action:@selector(topPressed:) forControlEvents:UIControlEventTouchUpInside];
        [myView addSubview:myBtn];
    }
    
    UIView *line = [[UIView alloc]init];
    [line setFrame:CGRectMake(0, 137.5, UI_View_Width, 0.5)];
    [line setBackgroundColor:BB_lineColor];
    [myView addSubview:line];
}
#pragma mark- 自定义
#pragma mark 事件
//顶部三个按钮
-(void)topPressed:(HemaButton*)sender
{
    if (0 == sender.btnRow)
    {
        RGroupListVC *myVC = [[RGroupListVC alloc]init];
        [[SystemFunction getFirstVCFromVC:self].navigationController pushViewController:myVC animated:YES];
    }
    if (1 == sender.btnRow)
    {
        RInviteAddressVC *myVC = [[RInviteAddressVC alloc]init];
        [[SystemFunction getFirstVCFromVC:self].navigationController pushViewController:myVC animated:YES];
    }
    if (2 == sender.btnRow)
    {
        RNewFriendListVC *myVC = [[RNewFriendListVC alloc]init];
        [[SystemFunction getFirstVCFromVC:self].navigationController pushViewController:myVC animated:YES];
    }
}
//搜索
-(void)searchPressed:(id)sender
{
    RFriendSearchVC *myVC = [[RFriendSearchVC alloc]init];
    myVC.searchType = 1;
    [[SystemFunction getFirstVCFromVC:self].navigationController pushViewController:myVC animated:NO];
}
#pragma mark 方法
//调整索引
-(void)adJustMember
{
    //按key进行排序
    NSArray* arr = [dataSource allKeys];
    arr = [arr sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2){
        NSComparisonResult result = [obj1 compare:obj2];
        return result==NSOrderedDescending;
    }];
    
    if (!suoyinCityList)
        suoyinCityList = [[NSMutableArray alloc]init];
    [suoyinCityList removeAllObjects];
    for(NSString *key in arr)
    {
        NSMutableDictionary *temDi = [[NSMutableDictionary alloc]init];
        [temDi setValue:[dataSource objectForKey:key] forKey:key];
        [suoyinCityList addObject:key];
    }
}
#pragma mark- TableView DataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return dataSource.allKeys.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[dataSource objectForKey:[suoyinCityList objectAtIndex:section]]count];
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //列表
    static NSString *CellIdentifier = @"nicai";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.backgroundColor = BB_White_Color;
        
        //图标
        HemaImgView *leftImgView = [[HemaImgView alloc]init];
        [leftImgView setFrame:CGRectMake(10, 12, 35, 35)];
        [HemaFunction addbordertoView:leftImgView radius:4 width:0 color:[UIColor clearColor]];
        leftImgView.tag = 8;
        [cell.contentView addSubview:leftImgView];
        
        //名称
        UILabel *labLeft = [[UILabel alloc]init];
        labLeft.backgroundColor = [UIColor clearColor];
        labLeft.textAlignment = NSTextAlignmentLeft;
        labLeft.font = [UIFont systemFontOfSize:15];
        labLeft.textColor = BB_Gray_Color;
        labLeft.frame = CGRectMake(54, 0, UI_View_Width-90, 59);
        labLeft.tag = 9;
        [cell.contentView addSubview:labLeft];
        
        UIView *line = [[UIView alloc]init];
        [line setFrame:CGRectMake(0, 0, UI_View_Width, 0.5)];
        [line setBackgroundColor:BB_lineColor];
        line.tag = 10;
        [cell.contentView addSubview:line];
        
        UIImageView *picImgView = [[UIImageView alloc]init];
        [picImgView setImage:[UIImage imageNamed:@"R红色对勾选中.png"]];
        [picImgView setFrame:CGRectMake(UI_View_Width-54, 12, 21, 21)];
        picImgView.tag = 12;
        [cell.contentView addSubview:picImgView];
        
        UIView *linedown = [[UIView alloc]init];
        [linedown setBackgroundColor:BB_lineColor];
        linedown.tag = 13;
        [cell.contentView addSubview:linedown];
    }
    NSMutableDictionary *temDic = [[dataSource objectForKey:[suoyinCityList objectAtIndex:indexPath.section]]objectAtIndex:indexPath.row];
    
    UILabel *labLeft = (UILabel*)[cell viewWithTag:9];
    labLeft.text = [temDic objectForKey:@"nickname"];
    
    UIView *line = (UIView*)[cell viewWithTag:10];
    UIView *linedown = (UIView*)[cell viewWithTag:13];
    [line setHidden:YES];
    [linedown setHidden:NO];
    
    if (0 == indexPath.row)
    {
        [line setHidden:NO];
    }
    
    if ([[dataSource objectForKey:[suoyinCityList objectAtIndex:indexPath.section]]count]-1 == indexPath.row)
    {
        [linedown setFrame:CGRectMake(0, 59.5, UI_View_Width, 0.5)];
    }else
    {
        [linedown setFrame:CGRectMake(10, 59.5, UI_View_Width-10, 0.5)];
    }
    
    UIImageView *picImgView = (UIImageView*)[cell viewWithTag:12];
    [picImgView setHidden:YES];
    [labLeft setTextColor:BB_Gray_Color];
    
    //图标
    HemaImgView *leftImgView = (HemaImgView*)[cell viewWithTag:8];
    [SystemFunction cashImgView:leftImgView url:[temDic objectForKey:@"avatar"] firstImg:@"R默认小头像.png"];
    
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = [[UIView alloc]init];
    headView.backgroundColor = BB_Back_Color_Here;
    
    //标题文字
    UILabel *lblBiaoti = [[UILabel alloc]init];
    lblBiaoti.backgroundColor = [UIColor clearColor];
    lblBiaoti.textAlignment = NSTextAlignmentLeft;
    lblBiaoti.font = [UIFont systemFontOfSize:15];
    lblBiaoti.textColor = [UIColor blackColor];
    lblBiaoti.frame = CGRectMake(10, 0, UI_View_Width-20, 33);
    lblBiaoti.text = [suoyinCityList objectAtIndex:section];
    [headView addSubview:lblBiaoti];
    
    return headView;
}
//添加索引列
-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return suoyinCityList;
}
//索引列点击事件
-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    //点击索引，列表跳转到对应索引的行
    [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    return index;
}
#pragma mark- TableView Delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 33;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *) indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    NSMutableDictionary *temDic = [[dataSource objectForKey:[suoyinCityList objectAtIndex:indexPath.section]]objectAtIndex:indexPath.row];
    
    RInforVC *myVC = [[RInforVC alloc]init];
    myVC.userId = [temDic objectForKey:@"client_id"];
    [[SystemFunction getFirstVCFromVC:self].navigationController pushViewController:myVC animated:YES];
}
#pragma mark - 连接服务器
#pragma mark 获取列表
- (void)requestGetFriendList
{
    NSString *token = [[HemaManager sharedManager] userToken];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:token forKey:@"token"];
    [dic setObject:@"5" forKey:@"keytype"];
    [dic setObject:@"0" forKey:@"keyid"];
    [dic setObject:@"0" forKey:@"page"];
    
    [HemaRequest requestWithURL:[NSString stringWithFormat:@"%@%@",REQUEST_MAINLINK,REQUEST_CLIENT_LIST] target:self selector:@selector(responseGetFriendList:) parameter:dic];
}
- (void)responseGetFriendList:(NSDictionary*)info
{
    if(1 == [[info objectForKey:@"success"] intValue])
    {
        if (!dataSource)
            dataSource = [[NSMutableDictionary alloc]init];
        [dataSource removeAllObjects];
        
        NSArray *temArr = [[info objectForKey:@"infor"]objectForKey:@"listItems"];
        //添加所有
        if (![HemaFunction xfunc_check_strEmpty:[[info objectForKey:@"infor"]objectForKey:@"listItems"]])
        {
            for (int i = 0; i<temArr.count; i++)
            {
                NSMutableDictionary *dict = [SystemFunction getDicFromDic:[temArr objectAtIndex:i]];
                
                //搜索好友
                if (![HemaFunction xfunc_check_strEmpty:keyword])
                {
                    if ([[dict objectForKey:@"uid"] rangeOfString:keyword].location == NSNotFound)
                    {
                        if ([[dict objectForKey:@"nickname"] rangeOfString:keyword].location == NSNotFound)
                        {
                            continue;
                        }
                    }
                }
                
                //获取首字母
                NSString *first = [dict objectForKey:@"charindex"];
                //存取字母下的数组
                if ([HemaFunction xfunc_check_strEmpty:[dataSource objectForKey:first]])
                {
                    NSMutableArray *contentArray = [[NSMutableArray alloc]init];
                    [contentArray addObject:dict];
                    [dataSource setValue:contentArray forKey:first];
                }
                else
                {
                    NSMutableArray *contentArray = [[NSMutableArray alloc]initWithArray:[dataSource objectForKey:first]];
                    [contentArray addObject:dict];
                    [dataSource setValue:contentArray forKey:first];
                }
            }
        }
        [self adJustMember];
        [self.mytable reloadData];
    }
    else
    {
        [HemaFunction openIntervalHUD:[info objectForKey:@"msg"]];
    }
}
@end
