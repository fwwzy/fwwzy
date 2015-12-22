//
//  RSelectLocationVC.m
//  Hema
//
//  Created by geyang on 15/11/25.
//  Copyright © 2015年 Hemaapp. All rights reserved.
//

#import "RSelectLocationVC.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchAPI.h>
#import "RMapSearchBar.h"
#import "HemaLongGR.h"
#import "ReGeocodeAnnotation.h"
#import "HemaEditorVC.h"

@interface RSelectLocationVC ()<MAMapViewDelegate,AMapSearchDelegate,HemaEditorDelegate,UISearchBarDelegate,UISearchDisplayDelegate>
{
    CLLocationCoordinate2D touchMapCoordinate;
}
@property(nonatomic,strong)MAMapView *myMap;
@property(nonatomic,strong)NSMutableArray *dataSource;//长按出来的结果
@property(nonatomic,strong)ReGeocodeAnnotation *pointAnnotation;
@property(nonatomic,strong)UILabel *oneLable;//选中的位置

//搜索
@property(nonatomic,strong)AMapSearchAPI *mySearch;
@property(nonatomic,strong)RMapSearchBar *mySearchBar;
@property(nonatomic,strong)UISearchDisplayController *mySearchDisplayVC;
@property(nonatomic,strong)NSMutableArray *dataSearch;///<搜索出来的结果
@property(nonatomic,strong)AMapPlaceSearchRequest *poiRequest;
@end

@implementation RSelectLocationVC
@synthesize myMap;
@synthesize dataSource;
@synthesize mySearch;
@synthesize pointAnnotation;
@synthesize latitude;
@synthesize longitude;
@synthesize keytype;
@synthesize oneLable;
@synthesize dataSearch;
@synthesize mySearchBar;
@synthesize mySearchDisplayVC;
@synthesize poiRequest;

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    LCPanNavigationController *nav = (LCPanNavigationController*)self.navigationController;
    [nav.panGestureRecognizer setEnabled:NO];
    
    myMap.delegate = self;
}
-(void)viewWillDisappear:(BOOL)animated
{
    LCPanNavigationController *nav = (LCPanNavigationController*)self.navigationController;
    [nav.panGestureRecognizer setEnabled:YES];
    
    myMap.delegate = nil;
    [super viewWillDisappear:animated];
}
-(void)loadSet
{
    [self.navigationItem setNewTitle:@"详细地址"];
    [self.navigationItem setRightItemWithTarget:self action:@selector(rightbtnPressed:) title:@"保存"];
    self.view.backgroundColor = RGB_UI_COLOR(236, 236, 236);
    
    [self reSetTableViewFrame:CGRectMake(0, 336, UI_View_Width, UI_View_Height-336)];
    [self forbidPullRefresh];
    
    //创建地图视图，初始化参数
    UIView *backView = [[UIView alloc]init];
    [backView setFrame:CGRectMake(0, 0, UI_View_Width, 300)];
    [self.view addSubview:backView];
    
    [self initEditView];
    
    //创建地图
    myMap = [[MAMapView alloc]initWithFrame:CGRectMake(0, 0,UI_View_Width, 300)];
    myMap.delegate = self;
    myMap.zoomLevel = 17;
    myMap.showsUserLocation = YES;
    myMap.userTrackingMode = MAUserTrackingModeFollow;
    myMap.mapType = MAMapTypeStandard;
    [backView addSubview:myMap];
    
    //长按提示
    UILabel *labRight = [[UILabel alloc]init];
    labRight.backgroundColor = [UIColor clearColor];
    labRight.textAlignment = NSTextAlignmentCenter;
    labRight.textColor = BB_Red_Color;
    labRight.text = @"长按选取位置";
    labRight.font = [UIFont boldSystemFontOfSize:15];
    labRight.frame = CGRectMake(0, myMap.height-30, UI_View_Width, 30);
    [labRight setUserInteractionEnabled:NO];
    [self.view addSubview:labRight];
    
    mySearch = [[AMapSearchAPI alloc] initWithSearchKey:[MAMapServices sharedServices].apiKey Delegate:self];
    
    //定义一个iOS拍击手势
    HemaLongGR *gestureTap = [[HemaLongGR alloc] initWithTarget:self action:@selector(longPress:)];
    gestureTap.minimumPressDuration = 0.5;
    gestureTap.delegate = self;
    [backView addGestureRecognizer:gestureTap];
    
    if (keytype == 1)
    {
        //初始化详情弹出框对象
        if (!pointAnnotation)
            pointAnnotation = [[ReGeocodeAnnotation alloc] init];
        touchMapCoordinate = CLLocationCoordinate2DMake(latitude, longitude);
        myMap.centerCoordinate = touchMapCoordinate;
        [self searchReGeocodeWithCoordinate];
    }
    
    mySearchBar = [[RMapSearchBar alloc]initWithFrame:CGRectMake(0, 0, UI_View_Width, 44)];
    mySearchBar.delegate = self;
    mySearchBar.placeholder = @"搜索地点";
    mySearchBar.barStyle = UISearchBarStyleDefault;
    mySearchBar.backgroundColor = [UIColor clearColor];
    mySearchBar.barTintColor = Nav_Color;
    mySearchBar.backgroundImage = [HemaFunction getImageWithSize:mySearchBar.size color:[UIColor clearColor]];
    [self.view addSubview:mySearchBar];
    
    mySearchDisplayVC = [[UISearchDisplayController alloc]initWithSearchBar:mySearchBar contentsController:self];
    mySearchDisplayVC.delegate = self;
    mySearchDisplayVC.searchResultsDelegate = self;
    mySearchDisplayVC.searchResultsDataSource = self;
    mySearchDisplayVC.searchResultsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}
-(void)loadData
{
    if (!dataSource)
        dataSource = [[NSMutableArray alloc]init];
    if (!dataSearch)
        dataSearch = [[NSMutableArray alloc]init];
    
    if (latitude == 0)
    {
        latitude = [HemaFunction xfuncGetAppdelegate].myCoordinate.latitude;
        longitude = [HemaFunction xfuncGetAppdelegate].myCoordinate.longitude;
    }
}
//中间编辑视图
-(void)initEditView
{
    UIView *editView = [[UIView alloc]init];
    [editView setFrame:CGRectMake(0, 300, UI_View_Width, 36)];
    [editView setBackgroundColor:RGB_UI_COLOR(236, 236, 236)];
    [HemaFunction dropShadowWithOffset:CGSizeMake(-1, -1) radius:1.0f color:BB_lineColor opacity:1 view:editView];
    [self.view addSubview:editView];
    
    UIView *nameView = [[UIView alloc]init];
    [nameView setFrame:CGRectMake(16, 4, UI_View_Width-52, 28)];
    [nameView setBackgroundColor:RGB_UI_COLOR(202, 225, 232)];
    [editView addSubview:nameView];
    
    oneLable = [[UILabel alloc]init];
    oneLable.frame = CGRectMake(5, 0, nameView.width-10, nameView.height);
    oneLable.backgroundColor = [UIColor clearColor];
    oneLable.textColor = RGB_UI_COLOR(141, 164, 171);
    oneLable.textAlignment = NSTextAlignmentLeft;
    oneLable.font = [UIFont boldSystemFontOfSize:12];
    [nameView addSubview:oneLable];
    
    HemaButton *editBtn = [HemaButton buttonWithType:UIButtonTypeCustom];
    [editBtn setFrame:CGRectMake(UI_View_Width-32, 4, 28, 28)];
    [editBtn setBackgroundImage:[UIImage imageNamed:@"R地图位置编辑.png"] forState:UIControlStateNormal];
    [editBtn addTarget:self action:@selector(editPressed:) forControlEvents:UIControlEventTouchUpInside];
    [editView addSubview:editBtn];
    
    UIView *oneline = [[UIView alloc]init];
    [oneline setFrame:CGRectMake(16, editView.height-0.5, editView.width-16, 0.5)];
    [oneline setBackgroundColor:RGB_UI_COLOR(226, 226, 226)];
    [editView addSubview:oneline];
}
#pragma mark- 自定义
#pragma mark 事件
-(void)rightbtnPressed:(id)sender
{
    if ([HemaFunction xfunc_check_strEmpty:oneLable.text])
    {
        [HemaFunction openIntervalHUD:@"请选择地点"];
        return;
    }
    if (_confirmCoordinate)
    {
        _confirmCoordinate(pointAnnotation.coordinate.latitude,pointAnnotation.coordinate.longitude,oneLable.text);
        [self leftbtnPressed:nil];
    }
}
//长按
- (void)longPress:(HemaLongGR*)gestureRecognizer
{
    if(gestureRecognizer.state == UIGestureRecognizerStateBegan)
    {
        //取地图上的长按的点坐标
        CGPoint touchPoint = [gestureRecognizer locationInView:myMap.superview];
        
        //将点坐标转换为经纬度坐标
        touchMapCoordinate = [myMap convertPoint:touchPoint toCoordinateFromView:myMap];
        
        [self searchReGeocodeWithCoordinate];
    }
}
//编辑
-(void)editPressed:(id)sender
{
    HemaEditorVC *editor = [[HemaEditorVC alloc]init];
    editor.editorType = EditorTypeSinleInput;
    editor.key = @"address";
    editor.title = @"编辑地点";
    editor.content = oneLable.text;
    editor.mymaxlength = 100;
    editor.keyBoardType = UIKeyboardTypeDefault;
    editor.delegate = self;
    [self.navigationController pushViewController:editor animated:YES];
}
#pragma mark 方法
//逆地理编译
- (void)searchReGeocodeWithCoordinate
{
    AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc] init];
    
    regeo.location = [AMapGeoPoint locationWithLatitude:touchMapCoordinate.latitude longitude:touchMapCoordinate.longitude];
    regeo.requireExtension = YES;
    
    myRow = 0;
    [mySearch AMapReGoecodeSearch:regeo];
}
//请求搜索结果
- (void)requestSearch
{
    if (!poiRequest)
        poiRequest = [[AMapPlaceSearchRequest alloc] init];
    poiRequest.searchType = AMapSearchType_PlaceKeyword;
    poiRequest.keywords = mySearchBar.text;
    poiRequest.city = @[[HemaFunction xfuncGetAppdelegate].mycity];
    poiRequest.requireExtension = NO;
    [mySearch AMapPlaceSearch: poiRequest];
}
#pragma mark- HemaEditorDelegate
-(void)HemaEditorOK:(HemaEditorVC*)editor backValue:(NSString*)value
{
    if(editor.key)
    {
        if(!value)
            value = @"";
        [oneLable setText:value];
    }
}
#pragma mark- UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}
#pragma mark- MAMapViewDelegate
- (MAAnnotationView*)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[ReGeocodeAnnotation class]])
    {
        static NSString *invertGeoIdentifier = @"invertGeoIdentifier";
        
        MAAnnotationView *poiAnnotationView = (MAAnnotationView*)[myMap dequeueReusableAnnotationViewWithIdentifier:invertGeoIdentifier];
        if (poiAnnotationView == nil)
        {
            poiAnnotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:invertGeoIdentifier];
        }
        poiAnnotationView.image = [UIImage imageNamed:@"R地图定位点图标@2x.png"];
        return poiAnnotationView;
    }
    return nil;
}
#pragma mark- AMapSearchDelegate
/* 逆地理编码回调. */
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
    [dataSource removeAllObjects];
    if (response.regeocode != nil)
    {
        [myMap removeAnnotations:myMap.annotations];
        [myMap removeOverlays:myMap.overlays];
        
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(request.location.latitude, request.location.longitude);
        pointAnnotation = [[ReGeocodeAnnotation alloc] initWithCoordinate:coordinate reGeocode:response.regeocode];
        [myMap addAnnotation:pointAnnotation];
        [myMap selectAnnotation:pointAnnotation animated:YES];
        
        [oneLable setText:pointAnnotation.subtitle];
        
        NSMutableDictionary *myDic = [[NSMutableDictionary alloc]initWithObjectsAndKeys:oneLable.text,@"address",[NSString stringWithFormat:@"%f",request.location.latitude],@"lat",[NSString stringWithFormat:@"%f",request.location.longitude],@"lng", nil];
        [dataSource addObject:myDic];
        [dataSource addObjectsFromArray:response.regeocode.pois];
        [self.mytable reloadData];
    }
}
//实现POI搜索对应的回调函数
- (void)onPlaceSearchDone:(AMapPlaceSearchRequest *)request response:(AMapPlaceSearchResponse *)response
{
    [dataSearch removeAllObjects];
    for (AMapPOI *poi in response.pois)
    {
        [dataSearch addObject:poi];
        if (dataSearch.count > 100)
        {
            break;
        }
    }
    [mySearchDisplayVC.searchResultsTableView reloadData];
}
#pragma mark - UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    if (searchBar.text.length > 0)
    {
        [self requestSearch];
        [searchBar resignFirstResponder];
    }else
    {
        [searchBar resignFirstResponder];
    }
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (![HemaFunction xfunc_check_strEmpty:searchText])
    {
        [self requestSearch];
    }
}
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    searchBar.showsCancelButton = YES;
    
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
                [cancelButton setTitleEdgeInsets:UIEdgeInsetsMake(3, 0, 0, 0)];
                [cancelButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
                break;
            }
        }
    }
    
    return YES;
}
#pragma mark - UISearchDisplayDelegate
-(void)searchDisplayController:(UISearchDisplayController *)controller willShowSearchResultsTableView:(UITableView *)tableView
{
    [tableView setContentInset:UIEdgeInsetsZero];
    [tableView setScrollIndicatorInsets:UIEdgeInsetsZero];
}
#pragma mark - UITableView dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.mytable == tableView)
    {
        return dataSource.count;
    }
    return dataSearch.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"all";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        
        //标题
        UILabel *nameLabel = [[UILabel alloc]init];
        nameLabel.textColor = RGB_UI_COLOR(38, 67, 74);
        nameLabel.font = [UIFont boldSystemFontOfSize:15];
        nameLabel.frame = CGRectMake(16, 9, UI_View_Width-60, 17);
        nameLabel.tag = 10;
        [cell.contentView addSubview:nameLabel];
        
        //详细地址
        UILabel *addressLabel = [[UILabel alloc]init];
        addressLabel.frame = CGRectMake(15, 33, UI_View_Width-60, 12);
        addressLabel.font = [UIFont boldSystemFontOfSize:10];
        addressLabel.textColor = RGB_UI_COLOR(165, 165, 165);
        addressLabel.tag = 11;
        [cell.contentView addSubview:addressLabel];
        
        //选中的对勾
        UIImageView *selectImv = [[UIImageView alloc]init];
        selectImv.image = [UIImage imageNamed:@"R地图选择对勾.png"];
        selectImv.frame = CGRectMake(UI_View_Width-32, 22, 14.5, 10.5);
        selectImv.tag = 12;
        [cell.contentView addSubview:selectImv];
        
        //定位小图标
        UIImageView *locationIcon = [[UIImageView alloc]init];
        locationIcon.image = [UIImage imageNamed:@"R地图绿色小图标.png"];
        locationIcon.frame = CGRectMake(16, 10, 11.5, 16.5);
        locationIcon.tag = 13;
        [cell.contentView addSubview:locationIcon];
        
        //横线
        UIView *oneline = [[UIView alloc]init];
        [oneline setFrame:CGRectMake(16, 54.5, UI_View_Width-16, 0.5)];
        [oneline setBackgroundColor:RGB_UI_COLOR(226, 226, 226)];
        [cell.contentView addSubview:oneline];
    }
    UILabel *nameLabel = (UILabel*)[cell viewWithTag:10];
    UILabel *addressLabel = (UILabel*)[cell viewWithTag:11];
    UIImageView *selectImv = (UIImageView*)[cell viewWithTag:12];
    UIImageView *locationIcon = (UIImageView*)[cell viewWithTag:13];
    
    [nameLabel setFrame:CGRectMake(16, 9, UI_View_Width-60, 17)];
    [selectImv setHidden:YES];
    [locationIcon setHidden:YES];
    
    if (self.mytable == tableView)
    {
        if (0 == indexPath.row)
        {
            [nameLabel setText:@"当前位置"];
            [addressLabel setText:[dataSource[0]objectForKey:@"address"]];
            
            [nameLabel setFrame:CGRectMake(31, 9, UI_View_Width-75, 17)];
            [locationIcon setHidden:NO];
        }else
        {
            AMapPOI *poi = dataSource[indexPath.row];
            [nameLabel setText:poi.name];
            [addressLabel setText:poi.address];
        }
        if (myRow == indexPath.row)
        {
            [selectImv setHidden:NO];
        }
    }else
    {
        AMapPOI *poi = dataSearch[indexPath.row];
        [nameLabel setText:poi.name];
        [addressLabel setText:poi.address];
    }
    
    return cell;
}
#pragma mark - UITableView delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *) indexPath
{
    if (self.mytable == tableView)
    {
        myRow = indexPath.row;
        
        if (0 == myRow)
        {
            [oneLable setText:[dataSource[0]objectForKey:@"address"]];
            pointAnnotation.coordinate = CLLocationCoordinate2DMake([dataSource[0][@"lat"] floatValue], [dataSource[0][@"lng"] floatValue]);
        }else
        {
            AMapPOI *poi = dataSource[indexPath.row];
            [oneLable setText:poi.address];
            if (poi.address.length == 0)
            {
                [oneLable setText:poi.name];
            }
            pointAnnotation.coordinate = CLLocationCoordinate2DMake(poi.location.latitude, poi.location.longitude);
        }
        myMap.centerCoordinate = pointAnnotation.coordinate;
        [self.mytable reloadData];
    }else
    {
        AMapPOI *poi = dataSearch[indexPath.row];
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(poi.location.latitude, poi.location.longitude);
        touchMapCoordinate = coordinate;
        myMap.centerCoordinate = touchMapCoordinate;
        [self searchReGeocodeWithCoordinate];
        
        [mySearchDisplayVC setActive:NO animated:YES];
    }
}
@end
