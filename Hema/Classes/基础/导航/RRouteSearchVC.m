//
//  RouteSearchVC.m
//  PingChuan
//
//  Created by LarryRodic on 15/9/6.
//  Copyright (c) 2015年 平川嘉恒. All rights reserved.
//
#define TopHeight 134

#import "RRouteSearchVC.h"
#import "RMapGeoSelectVC.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchAPI.h>
#import "RRouteMapVC.h"

@interface RRouteSearchVC ()<UIActionSheetDelegate,MAMapViewDelegate,AMapSearchDelegate,MapGeoDelegate>
{
    NSInteger addressType;//0 我的位置 1 指定位置
    NSInteger startType;//0 起点：我的位置 1 终点：我的位置
    NSInteger searchType;//0 公交车 1 汽车 2 步行
    NSInteger searchCount;//列表的条数
    MBProgressHUD *waitMB;
}
@property(nonatomic,assign)CLLocationCoordinate2D selectCoodinate;//指定的位置
@property(nonatomic,copy)NSString *selectStr;//指定的位置所在的城市
//顶部
@property(nonatomic,strong)UILabel *oneLable;//我的位置或者指定位置
@property(nonatomic,strong)UILabel *twoLable;//目的地的位置
@property(nonatomic,strong)UIImageView *sanImgView;//我的位置右侧三角
@property(nonatomic,strong)NSMutableArray *logoArr;//车的图标

//导航
@property(nonatomic,strong)AMapSearchAPI *search;
@property(nonatomic,strong)AMapRoute *route;//路线规划

@end

@implementation RRouteSearchVC
@synthesize dataSource;
@synthesize myCoodinate;
@synthesize selectCoodinate;
@synthesize selectStr;
@synthesize oneLable;
@synthesize twoLable;
@synthesize sanImgView;
@synthesize logoArr;
@synthesize search;
@synthesize route;

-(void)loadSet
{
    [self.navigationItem setNewTitle:@"查看路线"];
    //-----顶部
    [self initTop];
    
    //搜索
    search = [[AMapSearchAPI alloc]initWithSearchKey:BB_GEO_APIKEY Delegate:self];
    [self SearchNaviWithType:searchType];
    
    [self forbidPullRefresh];
    [self reSetTableViewFrame:CGRectMake(0, TopHeight, UI_View_Width, UI_View_Height-TopHeight)];
}
-(void)loadData
{
    startType = 0;
    addressType = 0;
    searchType = 0;
    logoArr = [[NSMutableArray alloc]initWithObjects:@"R公交.png",@"R汽车.png",@"R步行.png",@"R公交2.png",@"R汽车2.png",@"R步行2.png", nil];
    if (!dataSource)
        dataSource = [[NSMutableDictionary alloc]init];
}
//顶部
-(void)initTop
{
    UIView *topView = [[UIView alloc]init];
    [topView setFrame:CGRectMake(0, 0, UI_View_Width, TopHeight)];
    [topView setBackgroundColor:BB_White_Color];
    [HemaFunction dropShadowWithOffset:CGSizeMake(1, 1) radius:1.0f color:BB_lineColor opacity:1 view:topView];
    [self.view addSubview:topView];
    
    UIImageView *leftImgView = [[UIImageView alloc]init];
    leftImgView.image = [UIImage imageNamed:@"R我的位置.png"];
    leftImgView.frame = CGRectMake(17, 20, 10, 56);
    [topView addSubview:leftImgView];
    
    //我的位置
    oneLable = [[UILabel alloc]init];
    oneLable.frame = CGRectMake(44, 19, 58, 16);
    oneLable.backgroundColor = [UIColor clearColor];
    oneLable.textColor = BB_Blake_Color;
    oneLable.textAlignment = NSTextAlignmentLeft;
    oneLable.font = [UIFont systemFontOfSize:14];
    oneLable.text = @"我的位置";
    [topView addSubview:oneLable];
    
    sanImgView = [[UIImageView alloc]init];
    sanImgView.image = [UIImage imageNamed:@"R小三角下.png"];
    sanImgView.frame = CGRectMake(104, 23, 10, 5.5);
    [topView addSubview:sanImgView];
    
    twoLable = [[UILabel alloc]init];
    twoLable.frame = CGRectMake(44, 61, 242, 16);
    twoLable.backgroundColor = [UIColor clearColor];
    twoLable.textColor = BB_Gray_Color;
    twoLable.textAlignment = NSTextAlignmentLeft;
    twoLable.font = [UIFont systemFontOfSize:14];
    twoLable.text = [dataSource objectForKey:@"district_name"];
    [topView addSubview:twoLable];
    
    //横线
    UIView *oneline = [[UIView alloc]init];
    [oneline setFrame:CGRectMake(44, 48, UI_View_Width-78, 0.5)];
    [oneline setBackgroundColor:BB_lineColor];
    [topView addSubview:oneline];
    
    UIView *twoline = [[UIView alloc]init];
    [twoline setFrame:CGRectMake(0, 90, UI_View_Width, 0.5)];
    [twoline setBackgroundColor:BB_lineColor];
    [topView addSubview:twoline];
    
    //切换
    UIImageView *rightImgView = [[UIImageView alloc]init];
    rightImgView.image = [UIImage imageNamed:@"R切换.png"];
    rightImgView.frame = CGRectMake(UI_View_Width-26, 38, 19, 19);
    [topView addSubview:rightImgView];
    
    HemaButton *changeBtn = [HemaButton buttonWithType:UIButtonTypeCustom];
    [changeBtn setFrame:CGRectMake(UI_View_Width-34, 10, 34, 70)];
    [changeBtn addTarget:self action:@selector(changePressed:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:changeBtn];
    
    HemaButton *oneBtn = [HemaButton buttonWithType:UIButtonTypeCustom];
    [oneBtn setFrame:CGRectMake(44, 6, UI_View_Width-78, 42)];
    oneBtn.btnRow = 0;
    [oneBtn addTarget:self action:@selector(onePressed:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:oneBtn];
    
    HemaButton *twoBtn = [HemaButton buttonWithType:UIButtonTypeCustom];
    [twoBtn setFrame:CGRectMake(44, 48, UI_View_Width-78, 42)];
    twoBtn.btnRow = 1;
    [twoBtn addTarget:self action:@selector(onePressed:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:twoBtn];
    
    float myWidth = UI_View_Width/3;
    
    for (int i = 0; i<3; i++)
    {
        UIImageView *typeImgView = [[UIImageView alloc]init];
        typeImgView.frame = CGRectMake((myWidth-22)/2+myWidth*i, 101, 22, 22);
        typeImgView.tag = 90+i;
        [topView addSubview:typeImgView];
        
        if (i == searchType)
        {
            [typeImgView setImage:[UIImage imageNamed:[logoArr objectAtIndex:i+3]]];
        }else
        {
            [typeImgView setImage:[UIImage imageNamed:[logoArr objectAtIndex:i]]];
        }
        
        HemaButton *searchBtn = [HemaButton buttonWithType:UIButtonTypeCustom];
        [searchBtn setFrame:CGRectMake(myWidth*i, 90, myWidth, 44)];
        searchBtn.tag = 100+i;
        searchBtn.btnRow = i;
        [searchBtn addTarget:self action:@selector(searchPressed:) forControlEvents:UIControlEventTouchUpInside];
        [topView addSubview:searchBtn];
    }
}
#pragma mark- 自定义
#pragma mark 事件
//我的位置点击
-(void)onePressed:(HemaButton*)sender
{
    if (startType == sender.btnRow)
    {
        UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"我的位置",@"地图上选择",@"取消", nil];
        [SystemFunction setActionSheet:actionSheet index:2 myVC:self];
    }
}
//切换
-(void)changePressed:(id)sender
{
    if (startType == 0)
    {
        startType = 1;
        [oneLable setFrame:CGRectMake(44, 61, 58, 14)];
        [twoLable setFrame:CGRectMake(44, 19, UI_View_Width-78, 14)];
        [sanImgView setFrame:CGRectMake(104, 65, 10, 5.5)];
        [self SearchNaviWithType:searchType];
        return;
    }else
    {
        startType = 0;
        [oneLable setFrame:CGRectMake(44, 19, 58, 14)];
        [twoLable setFrame:CGRectMake(44, 61, UI_View_Width-78, 14)];
        [sanImgView setFrame:CGRectMake(104, 23, 10, 5.5)];
        [self SearchNaviWithType:searchType];
    }
}
//搜索按钮
-(void)searchPressed:(HemaButton*)sender
{
    searchType = sender.btnRow;
    
    for (int i = 0; i<3; i++)
    {
        UIImageView *typeImgView = (UIImageView*)[self.view viewWithTag:90+i];
        if (i == searchType)
        {
            [typeImgView setImage:[UIImage imageNamed:[logoArr objectAtIndex:i+3]]];
        }else
        {
            [typeImgView setImage:[UIImage imageNamed:[logoArr objectAtIndex:i]]];
        }
    }
    [self SearchNaviWithType:searchType];
}
#pragma mark 方法
//搜索
- (void)SearchNaviWithType:(NSInteger)myType
{
    [self clearData];
    //公交
    if (myType == 0)
    {
        [self searchNaviBus];
    }
    //驾车
    if (myType == 1)
    {
        [self searchNaviDrive];
    }
    //步行
    if (myType == 2)
    {
        [self searchNaviWalk];
    }
}
//公交导航搜索
- (void)searchNaviBus
{
    AMapNavigationSearchRequest *navi = [[AMapNavigationSearchRequest alloc] init];
    navi.searchType = AMapSearchType_NaviBus;
    navi.requireExtension = YES;
    if (addressType == 0)
    {
        navi.city = [HemaFunction xfuncGetAppdelegate].mycity;
    }else
    {
        navi.city = selectStr;
    }
    [self getFromTo:navi];
    
    NSLog(@"公交：%@,%@",navi,navi.city);
    
    [search AMapNavigationSearch:navi];
}
//驾车导航搜索
- (void)searchNaviDrive
{
    AMapNavigationSearchRequest *navi = [[AMapNavigationSearchRequest alloc] init];
    navi.searchType = AMapSearchType_NaviDrive;
    navi.requireExtension = YES;
    [self getFromTo:navi];
    
    NSLog(@"驾车：%@",navi);
    
    [search AMapNavigationSearch:navi];
}
//步行导航搜索
- (void)searchNaviWalk
{
    AMapNavigationSearchRequest *navi = [[AMapNavigationSearchRequest alloc] init];
    navi.searchType = AMapSearchType_NaviWalking;
    navi.requireExtension = YES;
    [self getFromTo:navi];
    
    NSLog(@"步行：%@",navi);
    
    [search AMapNavigationSearch:navi];
}
//获得始发地与目的地
-(void)getFromTo:(AMapNavigationSearchRequest*)navi
{
    if (startType == 0)
    {
        if (addressType == 0)
        {
            navi.origin = [AMapGeoPoint locationWithLatitude:myCoodinate.latitude longitude:myCoodinate.longitude];
        }else
        {
            navi.origin = [AMapGeoPoint locationWithLatitude:selectCoodinate.latitude longitude:selectCoodinate.longitude];
        }
        navi.destination = [AMapGeoPoint locationWithLatitude:[[dataSource objectForKey:@"lat"]doubleValue]longitude:[[dataSource objectForKey:@"lng"]doubleValue]];
    }else
    {
        navi.origin = [AMapGeoPoint locationWithLatitude:[[dataSource objectForKey:@"lat"]doubleValue]longitude:[[dataSource objectForKey:@"lng"]doubleValue]];
        if (addressType == 0)
        {
            navi.destination = [AMapGeoPoint locationWithLatitude:myCoodinate.latitude longitude:myCoodinate.longitude];
        }else
        {
            navi.destination = [AMapGeoPoint locationWithLatitude:selectCoodinate.latitude longitude:selectCoodinate.longitude];
        }
    }
}
//清空数据
-(void)clearData
{
    searchCount = 0;
    route = nil;
    [self.mytable reloadData];
}
//获取时间
-(NSString*)getTime:(int)duration
{
    NSLog(@"时间：%d",duration);
    if (duration<60)
    {
        return [NSString stringWithFormat:@"%d秒",duration];
    }
    if (duration<60*60)
    {
        return [NSString stringWithFormat:@"%d分钟",duration/60];
    }
    return [NSString stringWithFormat:@"%d小时%d分钟",duration/3600,(duration%3600)/60];
}
#pragma mark - AMapSearchDelegate
//导航搜索回调
- (void)onNavigationSearchDone:(AMapNavigationSearchRequest *)request response:(AMapNavigationSearchResponse *)response
{
    if (response.route == nil)
    {
        NSLog(@"无导航数据");
        return;
    }
    //NSLog(@"返回的导航数据：%@",response);
    if (request.searchType == AMapSearchType_NaviBus&&searchType == 0)
    {
        NSLog(@"公交导航");
    }
    if (request.searchType == AMapSearchType_NaviDrive&&searchType == 1)
    {
        NSLog(@"驾车导航");
    }
    if (request.searchType == AMapSearchType_NaviWalking&&searchType == 1)
    {
        NSLog(@"步行导航");
    }
    searchCount = response.count;
    route = response.route;
    [self.mytable reloadData];
}
- (void)searchRequest:(id)request didFailWithError:(NSError *)error
{
    NSLog(@"导航请求错误：%@",error);
}
#pragma mark- UIActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString*title = [actionSheet buttonTitleAtIndex:buttonIndex];
    if([title isEqualToString:@"我的位置"])
    {
        addressType = 0;
        [oneLable setText:@"我的位置"];
        [self SearchNaviWithType:searchType];
        return;
    }
    if([title isEqualToString:@"地图上选择"])
    {
        RMapGeoSelectVC *map = [[RMapGeoSelectVC alloc]init];
        map.keytype = 2;
        map.delegate = self;
        map.isEdit = YES;
        if ([HemaFunction xfunc_check_strEmpty:[dataSource objectForKey:@"lat"]])
        {
            map.latitude = myCoodinate.latitude;
            map.longitude = myCoodinate.longitude;
        }else
        {
            map.latitude = [[dataSource objectForKey:@"lat"] floatValue];
            map.longitude = [[dataSource objectForKey:@"lng"] floatValue];
        }
        [map.navigationItem setNewTitle:@"选取位置"];
        [self.navigationController pushViewController:map animated:YES];
        return;
    }
}
#pragma mark- MapGeoDelegate
-(void)MapGeoName:(NSString *)name lat:(NSString *)lat lng:(NSString *)lng
{
    addressType = 1;
    selectStr = name;
    [oneLable setText:@"指定位置"];
    selectCoodinate = CLLocationCoordinate2DMake([lat doubleValue], [lng doubleValue]);
    [self SearchNaviWithType:searchType];
}
#pragma mark- TableView DataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return searchCount;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"all";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.backgroundColor = [UIColor clearColor];
        
        //左侧
        UILabel *labNum = [[UILabel alloc]init];
        labNum.backgroundColor = [UIColor clearColor];
        labNum.textAlignment = NSTextAlignmentLeft;
        labNum.font = [UIFont systemFontOfSize:14];
        labNum.textColor = BB_Green_Color;
        labNum.tag = 10;
        [labNum setFrame:CGRectMake(17, 0, 25, 50)];
        [cell.contentView addSubview:labNum];
        
        //名称
        UILabel *labLeft = [[UILabel alloc]init];
        labLeft.backgroundColor = [UIColor clearColor];
        labLeft.textAlignment = NSTextAlignmentLeft;
        labLeft.font = [UIFont systemFontOfSize:14];
        labLeft.textColor = BB_Blake_Color;
        labLeft.tag = 11;
        [labLeft setFrame:CGRectMake(47, 9, UI_View_Width-77, 16)];
        [cell.contentView addSubview:labLeft];
        
        //详情
        UILabel *labRight = [[UILabel alloc]init];
        labRight.backgroundColor = [UIColor clearColor];
        labRight.textAlignment = NSTextAlignmentLeft;
        labRight.font = [UIFont systemFontOfSize:12];
        labRight.textColor = BB_Gray_Color;
        labRight.tag = 12;
        [labRight setFrame:CGRectMake(47, 30, UI_View_Width-77, 14)];
        [cell.contentView addSubview:labRight];
        
        UIView *oneline = [[UIView alloc]init];
        [oneline setFrame:CGRectMake(0, 49.5, UI_View_Width, 0.5)];
        [oneline setBackgroundColor:BB_lineColor];
        [cell.contentView addSubview:oneline];
    }
    UILabel *labNum = (UILabel*)[cell viewWithTag:10];
    if (indexPath.row<9)
    {
        [labNum setText:[NSString stringWithFormat:@"0%d",(int)indexPath.row+1]];
    }else
    {
        [labNum setText:[NSString stringWithFormat:@"%d",(int)indexPath.row+1]];
    }
    
    UILabel *labLeft = (UILabel*)[cell viewWithTag:11];
    UILabel *labRight = (UILabel*)[cell viewWithTag:12];
    
    if (searchType == 0)
    {
        NSArray *transits = route.transits;
        AMapTransit *infor = [transits objectAtIndex:indexPath.row];
        
        NSLog(@"此处：\n\n%@",infor);
        
        NSString *leftStr = @"";
        NSInteger myCount = 0;
        
        for (AMapSegment *segment in infor.segments)
        {
            NSLog(@"步行距离：%d",(int)segment.walking.distance);
            NSLog(@"公交距离：%f,%@,%@,%@",segment.busline.distance,segment.busline.name,segment.enterName,segment.exitName);
            double distance = [HemaFunction distanceBetweenOrderBy:segment.enterLocation.latitude :segment.enterLocation.longitude :segment.exitLocation.latitude :segment.exitLocation.longitude];
            NSLog(@"距离：%lf",distance);
            
            if (![HemaFunction xfunc_check_strEmpty:segment.busline.name])
            {
                if ([HemaFunction xfunc_check_strEmpty:leftStr])
                {
                    leftStr = [[segment.busline.name componentsSeparatedByString:@"("]objectAtIndex:0];
                }else
                {
                    leftStr = [NSString stringWithFormat:@"%@ - %@",leftStr,[[segment.busline.name componentsSeparatedByString:@"("]objectAtIndex:0]];
                }
                myCount = myCount+segment.busline.busStops.count;
            }
        }
        NSLog(@"\n\n换行%d",(int)indexPath.row);
        
        [labLeft setText:leftStr];
        [labRight setText:[NSString stringWithFormat:@"%@  |  途径%d站  |  步行%d米",[self getTime:(int)infor.duration],(int)myCount,(int)infor.walkingDistance]];
    }else
    {
        NSArray *paths = route.paths;
        AMapPath *infor = [paths objectAtIndex:indexPath.row];
        
        NSLog(@"此处：\n\n%@",infor);
        
        for (AMapStep *step in infor.steps)
        {
            NSLog(@"途径：%@",step.road);
        }
        NSString *leftStr = @"途径";
        NSMutableArray *myArr = [[NSMutableArray alloc]init];
        
        for (AMapStep *step in infor.steps)
        {
            if (![HemaFunction xfunc_check_strEmpty:step.road])
            {
                [myArr addObject:step.road];
            }
        }
        
        for (int i = 0; i < myArr.count; i++)
        {
            if (i == 0)
            {
                leftStr = [NSString stringWithFormat:@"%@%@",leftStr,[myArr objectAtIndex:i]];
            }
            if (myArr.count > 1)
            {
                if (i == myArr.count-1)
                {
                    leftStr = [NSString stringWithFormat:@"%@和%@",leftStr,[myArr objectAtIndex:i]];
                }
            }
        }
        
        [labLeft setText:leftStr];
        [labRight setText:[NSString stringWithFormat:@"%@  |  %.1f公里",[self getTime:(int)infor.duration],infor.distance/1000.0]];
    }
    
    return cell;
}
#pragma mark - Table view delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *) indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    UITableViewCell *cell = (UITableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    UILabel *labLeft = (UILabel*)[cell viewWithTag:11];
    UILabel *labRight = (UILabel*)[cell viewWithTag:12];
    
    NSMutableDictionary *myDic = [[NSMutableDictionary alloc]init];
    [myDic setObject:labLeft.text forKey:@"name"];
    [myDic setObject:labRight.text forKey:@"content"];
    
    RRouteMapVC *myVC = [[RRouteMapVC alloc]init];
    myVC.dataSource = myDic;
    myVC.route = route;
    myVC.selectRow = indexPath.row;
    myVC.searchType = searchType;
    if (startType == 0)
    {
        if (addressType == 0)
        {
            myVC.startCoodinate = myCoodinate;
        }else
        {
            myVC.startCoodinate = selectCoodinate;
        }
        myVC.endCoodinate = CLLocationCoordinate2DMake([[dataSource objectForKey:@"lat"]doubleValue],[[dataSource objectForKey:@"lng"]doubleValue]);
    }else
    {
        myVC.startCoodinate = CLLocationCoordinate2DMake([[dataSource objectForKey:@"lat"]doubleValue],[[dataSource objectForKey:@"lng"]doubleValue]);
        if (addressType == 0)
        {
            myVC.endCoodinate = myCoodinate;
        }else
        {
            myVC.endCoodinate = selectCoodinate;
        }
    }
    [self.navigationController pushViewController:myVC animated:YES];
}
@end
