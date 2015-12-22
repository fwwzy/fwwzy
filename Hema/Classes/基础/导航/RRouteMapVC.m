//
//  RouteMapVC.m
//  PingChuan
//
//  Created by LarryRodic on 15/9/7.
//  Copyright (c) 2015年 平川嘉恒. All rights reserved.
//

#import "RRouteMapVC.h"
#import "CommonUtility.h"
#import "MANaviRoute.h"
#import <MAMapKit/MAMapKit.h>

#import "HemaTapGR.h"
#import "HemaSwipeGR.h"

@interface RRouteMapVC ()<MAMapViewDelegate,UIGestureRecognizerDelegate,UITableViewDataSource,UITableViewDelegate>
{
    BOOL isUpState;//是否上去状态
}
@property(nonatomic,strong)UITableView *myTableView;
@property(nonatomic,strong)MAMapView *myMap;
@property(nonatomic,strong)UIView *downView;
@property(nonatomic,assign)CLLocationCoordinate2D myCoodinate;//我的位置
@property(nonatomic,strong)MANaviRoute *naviRoute;//路线方案
@property(nonatomic,strong)UIImageView *sanImgView;//三角
@property(nonatomic,strong)NSMutableArray *dataArr;//路线列表数组
@end

@implementation RRouteMapVC
@synthesize myTableView;
@synthesize dataSource;
@synthesize myMap;
@synthesize downView;
@synthesize myCoodinate;
@synthesize naviRoute;
@synthesize route;
@synthesize searchType;
@synthesize selectRow;
@synthesize startCoodinate;
@synthesize endCoodinate;
@synthesize sanImgView;
@synthesize dataArr;

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    LCPanNavigationController *nav = (LCPanNavigationController*)self.navigationController;
    [nav.panGestureRecognizer setEnabled:NO];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [self.navigationController setNavigationBarHidden:YES];
    myMap.delegate = self;
}
-(void)viewWillDisappear:(BOOL)animated
{
    LCPanNavigationController *nav = (LCPanNavigationController*)self.navigationController;
    [nav.panGestureRecognizer setEnabled:YES];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self.navigationController setNavigationBarHidden:NO];
    myMap.delegate = nil;
    [super viewWillDisappear:animated];
}
-(void)loadSet
{
    //---------创建地图
    UIView *backView = [[UIView alloc]init];
    [backView setFrame:CGRectMake(0, 0, UI_View_Width, UI_View_Height+64-80)];
    [self.view addSubview:backView];
    
    myMap = [[MAMapView alloc]initWithFrame:CGRectMake(0, 0, UI_View_Width, UI_View_Height+64-80)];
    myMap.delegate = self;
    myMap.zoomLevel = 10;
    myMap.showsUserLocation = YES;
    myMap.userTrackingMode = MAUserTrackingModeFollow;
    myMap.mapType = MAMapTypeStandard;
    [backView addSubview:myMap];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setFrame:CGRectMake(10, 25, 68, 46)];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"R地图导航返回按钮.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(leftbtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:backBtn];
    
    UIButton *locationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [locationBtn setFrame:CGRectMake(UI_View_Width-78, 25, 68, 46)];
    [locationBtn setBackgroundImage:[UIImage imageNamed:@"R地图导航定位按钮.png"] forState:UIControlStateNormal];
    [locationBtn addTarget:self action:@selector(locationPressed:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:locationBtn];
    
    //---------底部视图
    downView = [[UIView alloc]init];
    [downView setFrame:CGRectMake(0, UI_View_Height+64-80, UI_View_Width, 280)];
    [HemaFunction dropShadowWithOffset:CGSizeMake(-1, -1) radius:1.0f color:BB_lineColor opacity:1 view:downView];
    [downView setBackgroundColor:BB_White_Color];
    [self.view addSubview:downView];
    
    //table
    myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 80, UI_View_Width, 200) style:UITableViewStylePlain];
    [myTableView setBackgroundColor:[UIColor clearColor]];
    [myTableView setBackgroundView:nil];
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    myTableView.dataSource = self;
    myTableView.delegate = self;
    [downView addSubview:myTableView];
    
    //箭头
    UIImageView *middleImgView = [[UIImageView alloc]init];
    middleImgView.image = [UIImage imageNamed:@"R下拉框.png"];
    middleImgView.frame = CGRectMake((UI_View_Width-49)/2, 0, 49, 12);
    [downView addSubview:middleImgView];
    
    sanImgView = [[UIImageView alloc]init];
    sanImgView.image = [UIImage imageNamed:@"R小三角上.png"];
    sanImgView.frame = CGRectMake(19.5, 3, 10, 5.5);
    [middleImgView addSubview:sanImgView];
    
    //名称
    UILabel*lblName = [[UILabel alloc]init];
    lblName.frame = CGRectMake(17, 32, UI_View_Width-34, 16);
    lblName.backgroundColor = [UIColor clearColor];
    lblName.textColor = BB_Blake_Color;
    lblName.textAlignment = NSTextAlignmentLeft;
    lblName.font = [UIFont systemFontOfSize:14];
    lblName.text=[dataSource objectForKey:@"name"];
    [downView addSubview:lblName];
    
    //分钟信息
    UILabel*lblInfor = [[UILabel alloc]init];
    lblInfor.frame = CGRectMake(17, 54, UI_View_Width-34, 14);
    lblInfor.backgroundColor = [UIColor clearColor];
    lblInfor.textColor = BB_Gray_Color;
    lblInfor.textAlignment = NSTextAlignmentLeft;
    lblInfor.font = [UIFont systemFontOfSize:12];
    lblInfor.text=[dataSource objectForKey:@"content"];
    [downView addSubview:lblInfor];
    
    UIView *line = [[UIView alloc]init];
    [line setFrame:CGRectMake(17, 80, UI_View_Width-34, 0.5)];
    [line setBackgroundColor:BB_lineColor];
    [downView addSubview:line];
    
    //-------手势添加
    UIView *gesView = [[UIView alloc]init];
    [gesView setFrame:CGRectMake(0, 0, UI_View_Width, 80)];
    [downView addSubview:gesView];
    
    //点击
    HemaTapGR *temTap = [[HemaTapGR alloc] initWithTarget:self action:@selector(TapPressed:)];
    temTap.numberOfTapsRequired = 1;
    temTap.numberOfTouchesRequired = 1;
    temTap.delegate = self;
    [gesView addGestureRecognizer:temTap];
    
    //滑动
    HemaSwipeGR *temSwipeUp = [[HemaSwipeGR alloc]init];
    [temSwipeUp setDirection:UISwipeGestureRecognizerDirectionUp];
    [temSwipeUp addTarget:self action:@selector(swipePressed:)];
    [gesView addGestureRecognizer:temSwipeUp];
    
    HemaSwipeGR *temSwipeDown = [[HemaSwipeGR alloc]init];
    [temSwipeDown setDirection:UISwipeGestureRecognizerDirectionDown];
    [temSwipeDown addTarget:self action:@selector(swipePressed:)];
    [gesView addGestureRecognizer:temSwipeDown];
    
    //拖动
    UIPanGestureRecognizer *temPan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panPressed:)];
    [gesView addGestureRecognizer:temPan];
    
    /*
     拖动与滑动手势冲突，二选一，目前选中的是拖动
     */
    
    //延迟动画
    [self performSelector:@selector(startUpDown) withObject:nil afterDelay:0.5];
    
    //路线导航
    [self presentCurrentCourse];
}
-(void)loadData
{
    isUpState = NO;
    if (!dataArr)
        dataArr = [[NSMutableArray alloc]init];
    [self getTableData];
}
#pragma mark- 自定义
#pragma mark 事件
//定位
-(void)locationPressed:(id)sender
{
    [myMap setZoomLevel:17];
    [myMap setCenterCoordinate:CLLocationCoordinate2DMake(myCoodinate.latitude, myCoodinate.longitude)];
}
//点击手势
-(void)TapPressed:(HemaTapGR*)sender
{
    [self startUpDown];
}
//滑动手势
-(void)swipePressed:(HemaSwipeGR*)sender
{
    if (sender.direction == UISwipeGestureRecognizerDirectionUp)
    {
        if (!isUpState)
        {
            [self startUpDown];
        }
    }
    if (sender.direction == UISwipeGestureRecognizerDirectionDown)
    {
        if (isUpState)
        {
            [self startUpDown];
        }
    }
}
//拖动手势
-(void)panPressed:(UIPanGestureRecognizer*)sender
{
    CGPoint translatedPoint = [sender translationInView:self.view];
    NSLog(@"gesture translatedPoint  is %@", NSStringFromCGPoint(translatedPoint));
    
    if (sender.state == UIGestureRecognizerStateChanged)
    {
        if (isUpState)
        {
            if (translatedPoint.y<=200)
            {
                if (translatedPoint.y>=0)
                {
                    [downView setFrame:CGRectMake(0, UI_View_Height+64-280+translatedPoint.y, UI_View_Width, 280)];
                }
            }
            return;
        }else
        {
            if (translatedPoint.y>=-200)
            {
                if (translatedPoint.y<=0)
                {
                    [downView setFrame:CGRectMake(0, UI_View_Height+64-80+translatedPoint.y, UI_View_Width, 280)];
                }
            }
        }
    }
    if (sender.state == UIGestureRecognizerStateEnded)
    {
        if (isUpState)
        {
            if (translatedPoint.y>20)
            {
                [self startUpDown];
            }else
            {
                [self actionActive];
                [downView setFrame:CGRectMake(0, UI_View_Height+64-280, UI_View_Width, 280)];
                [UIView commitAnimations];
            }
            return;
        }else
        {
            if (translatedPoint.y<-20)
            {
                [self startUpDown];
            }else
            {
                [self actionActive];
                [downView setFrame:CGRectMake(0, UI_View_Height+64-80, UI_View_Width, 280)];
                [UIView commitAnimations];
            }
        }
    }
}
#pragma mark 方法
//开启动画
-(void)actionActive
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.25f];
    [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:nil cache:NO];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:nil];
}
//上去或者下来
-(void)startUpDown
{
    isUpState = !isUpState;
    
    [self actionActive];
    if (isUpState)
    {
        [downView setFrame:CGRectMake(0, UI_View_Height+64-280, UI_View_Width, 280)];
        [sanImgView setTransform:CGAffineTransformMakeRotation(M_PI)];
    }else
    {
        [downView setFrame:CGRectMake(0, UI_View_Height+64-80, UI_View_Width, 280)];
        [sanImgView setTransform:CGAffineTransformIdentity];
    }
    [UIView commitAnimations];
}
//导航
- (void)presentCurrentCourse
{
    MAPointAnnotation *startAnnotation = [[MAPointAnnotation alloc] init];
    startAnnotation.coordinate = startCoodinate;
    startAnnotation.title      = @"起点";
    
    MAPointAnnotation *destinationAnnotation = [[MAPointAnnotation alloc] init];
    destinationAnnotation.coordinate = endCoodinate;
    destinationAnnotation.title      = @"终点";
    
    [myMap addAnnotation:startAnnotation];
    [myMap addAnnotation:destinationAnnotation];
    
    if (searchType == 0)
    {
        //公交导航
        naviRoute = [MANaviRoute naviRouteForTransit:[route.transits objectAtIndex:selectRow]];
    }
    else
    {
        //步行、驾车导航
        MANaviAnnotationType type = (searchType == 1)? MANaviAnnotationTypeDrive : MANaviAnnotationTypeWalking;
        naviRoute = [MANaviRoute naviRouteForPath:[route.paths objectAtIndex:selectRow] withNaviType:type];
    }
    [naviRoute addToMapView:myMap];
    
    //缩放地图使其适应polylines的展示
    [myMap setVisibleMapRect:[CommonUtility mapRectForOverlays:naviRoute.routePolylines] animated:NO];
}
//获取路线数据
-(void)getTableData
{
    if (searchType == 0)
    {
        AMapTransit *infor = [route.transits objectAtIndex:selectRow];
        for (AMapSegment *segment in infor.segments)
        {
            NSMutableDictionary *myDic = [[NSMutableDictionary alloc]init];
            
            if (![HemaFunction xfunc_check_strEmpty:segment.busline.name])
            {
                NSString *cheName = [[segment.busline.name componentsSeparatedByString:@"("]objectAtIndex:0];
                NSString *startName = segment.busline.departureStop.name;
                NSString *endName = segment.busline.arrivalStop.name;
                NSString *name = [NSString stringWithFormat:@"乘坐%@，在%@站上车，经过%d站，到达%@站下车",cheName,startName,(int)segment.busline.busStops.count,endName];
                
                [myDic setObject:@"0" forKey:@"type"];
                [myDic setObject:name forKey:@"name"];
            }else
            {
                NSString *name = @"";
                for (AMapStep *step in segment.walking.steps)
                {
                    if ([HemaFunction xfunc_check_strEmpty:name])
                    {
                        name = step.instruction;
                    }else
                    {
                        name = [NSString stringWithFormat:@"%@,%@",name,step.instruction];
                    }
                }
                [myDic setObject:@"2" forKey:@"type"];
                [myDic setObject:name forKey:@"name"];
            }
            [dataArr addObject:myDic];
        }
    }else
    {
        AMapPath *infor = [route.paths objectAtIndex:selectRow];
        for (AMapStep *step in infor.steps)
        {
            NSMutableDictionary *myDic = [[NSMutableDictionary alloc]init];
            [myDic setObject:[NSString stringWithFormat:@"%d",(int)searchType] forKey:@"type"];
            [myDic setObject:step.instruction forKey:@"name"];
            [dataArr addObject:myDic];
        }
    }
    NSLog(@"总数据:%@",dataArr);
}
#pragma mark- MAMapViewDelegate
- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation
{
    if (userLocation.location.coordinate.latitude != 0)
    {
        myCoodinate = userLocation.location.coordinate;
    }
}
- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id<MAOverlay>)overlay
{
    if ([overlay isKindOfClass:[LineDashPolyline class]])
    {
        MAPolylineRenderer *polylineRenderer = [[MAPolylineRenderer alloc] initWithPolyline:((LineDashPolyline *)overlay).polyline];
        
        polylineRenderer.lineWidth   = 6;
        polylineRenderer.strokeColor = [UIColor magentaColor];
        polylineRenderer.lineDashPattern = @[@5, @10];
        
        return polylineRenderer;
    }
    if ([overlay isKindOfClass:[MANaviPolyline class]])
    {
        MANaviPolyline *naviPolyline = (MANaviPolyline *)overlay;
        MAPolylineRenderer *polylineRenderer = [[MAPolylineRenderer alloc] initWithPolyline:naviPolyline.polyline];
        
        polylineRenderer.lineWidth = 8;
        
        if (naviPolyline.type == MANaviAnnotationTypeWalking)
        {
            polylineRenderer.strokeColor = naviRoute.walkingColor;
        }
        else
        {
            polylineRenderer.strokeColor = naviRoute.routeColor;
        }
        
        return polylineRenderer;
    }
    
    return nil;
}
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    NSLog(@"标注：%@",[annotation class]);
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *navigationCellIdentifier = @"navigationCellIdentifier";
        
        MAAnnotationView *poiAnnotationView = (MAAnnotationView*)[myMap dequeueReusableAnnotationViewWithIdentifier:navigationCellIdentifier];
        if (poiAnnotationView == nil)
        {
            poiAnnotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:navigationCellIdentifier];
        }
        poiAnnotationView.canShowCallout = YES;
        
        if ([annotation isKindOfClass:[MANaviAnnotation class]])
        {
            switch (((MANaviAnnotation*)annotation).type)
            {
                case MANaviAnnotationTypeBus:
                    poiAnnotationView.image = [UIImage imageNamed:@"R公交图标.png"];
                    break;
                    
                case MANaviAnnotationTypeDrive:
                    poiAnnotationView.image = [UIImage imageNamed:@"R汽车图标.png"];
                    break;
                    
                case MANaviAnnotationTypeWalking:
                    poiAnnotationView.image = [UIImage imageNamed:@"R步行图标.png"];
                    break;
                    
                default:
                    break;
            }
        }
        else
        {
            /* 起点. */
            if ([[annotation title] isEqualToString:@"起点"])
            {
                poiAnnotationView.image = [UIImage imageNamed:@"Rstart.png"];
            }
            /* 终点. */
            else if([[annotation title] isEqualToString:@"终点"])
            {
                poiAnnotationView.image = [UIImage imageNamed:@"Rend.png"];
            }
        }
        
        return poiAnnotationView;
    }
    return nil;
}
#pragma mark- TableView DataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArr.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"all";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        
        //图标
        UIImageView *leftImgView = [[UIImageView alloc]init];
        leftImgView.tag = 9;
        [cell.contentView addSubview:leftImgView];
        
        //内容
        UILabel *lblName = [[UILabel alloc]init];
        lblName.backgroundColor = [UIColor clearColor];
        lblName.textColor = BB_Blake_Color;
        lblName.tag = 10;
        lblName.numberOfLines = 0;
        lblName.textAlignment = NSTextAlignmentLeft;
        lblName.font = [UIFont systemFontOfSize:13];
        [cell.contentView addSubview:lblName];
    }
    NSMutableDictionary *temDic = [dataArr objectAtIndex:indexPath.row];
    
    UIImageView *leftImgView = (UIImageView*)[cell viewWithTag:9];
    UILabel *lblName = (UILabel*)[cell viewWithTag:10];
    
    //处理数据
    [lblName setText:[temDic objectForKey:@"name"]];
    CGSize mySize = [HemaFunction getSizeWithStrNo:lblName.text width:UI_View_Width-67 font:13];
    [lblName setFrame:CGRectMake(50, 0, UI_View_Width-67, mySize.height+20)];
    
    NSMutableArray *logoArr = [[NSMutableArray alloc]initWithObjects:@"R公交.png",@"R汽车.png",@"R步行.png", nil];
    [leftImgView setImage:[UIImage imageNamed:[logoArr objectAtIndex:[[temDic objectForKey:@"type"]integerValue]]]];
    [leftImgView setFrame:CGRectMake(17, (mySize.height+20-16)/2, 16, 16)];
    
    return cell;
}
#pragma mark - Table view delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *temDic = [dataArr objectAtIndex:indexPath.row];
    CGSize mySize = [HemaFunction getSizeWithStrNo:[temDic objectForKey:@"name"] width:UI_View_Width-67 font:13];
    return 20+mySize.height;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *) indexPath
{
    
}
@end
