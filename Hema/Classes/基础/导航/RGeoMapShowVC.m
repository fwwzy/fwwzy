//
//  GeoMapShowVC.m
//  PingChuan
//
//  Created by LarryRodic on 15/9/5.
//  Copyright (c) 2015年 平川嘉恒. All rights reserved.
//

#import "RGeoMapShowVC.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchAPI.h>
#import "RRouteSearchVC.h"

@interface RGeoMapShowVC ()<MAMapViewDelegate,AMapSearchDelegate>
@property(nonatomic,strong)MAMapView *myMap;
@property(nonatomic,assign)CLLocationCoordinate2D myCoodinate;//我的位置
@end

@implementation RGeoMapShowVC
@synthesize dataSource;
@synthesize myMap;
@synthesize myCoodinate;

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
    [backView setFrame:CGRectMake(0, 0, UI_View_Width, UI_View_Height+64-110)];
    [self.view addSubview:backView];
    
    myMap = [[MAMapView alloc]initWithFrame:CGRectMake(0, 0, UI_View_Width, UI_View_Height+64-110)];
    myMap.delegate = self;
    myMap.zoomLevel = 17;
    myMap.showsUserLocation = YES;
    myMap.userTrackingMode = MAUserTrackingModeFollow;
    myMap.mapType = MAMapTypeStandard;
    [backView addSubview:myMap];
    
    MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
    pointAnnotation.coordinate = CLLocationCoordinate2DMake([[dataSource objectForKey:@"lat"]doubleValue], [[dataSource objectForKey:@"lng"]doubleValue]);
    pointAnnotation.title = @"地图位置";
    pointAnnotation.subtitle = [dataSource objectForKey:@"name"];
    [myMap setCenterCoordinate:pointAnnotation.coordinate];
    [myMap addAnnotation:pointAnnotation];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setFrame:CGRectMake(10, 25, 68, 46)];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"R地图导航返回按钮.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(leftbtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:backBtn];
    
    UIButton *locationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [locationBtn setFrame:CGRectMake(10, UI_View_Height+64-165, 68, 46)];
    [locationBtn setBackgroundImage:[UIImage imageNamed:@"R地图导航定位按钮.png"] forState:UIControlStateNormal];
    [locationBtn addTarget:self action:@selector(locationPressed:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:locationBtn];
    
    //---------底部
    UIView *downView = [[UIView alloc]init];
    [downView setFrame:CGRectMake(0, UI_View_Height+64-110, UI_View_Width, 110)];
    [HemaFunction dropShadowWithOffset:CGSizeMake(-1, -1) radius:1.0f color:BB_lineColor opacity:1 view:downView];
    [downView setBackgroundColor:BB_White_Color];
    [self.view addSubview:downView];
    
    UIView *line = [[UIView alloc]init];
    [line setFrame:CGRectMake(0, 0, UI_View_Width, 0.5)];
    [line setBackgroundColor:BB_lineColor];
    [downView addSubview:line];
    
    //名称
    UILabel*lblName = [[UILabel alloc]init];
    lblName.frame = CGRectMake(15, 2, UI_View_Width-30, 54);
    lblName.backgroundColor = [UIColor clearColor];
    lblName.textColor = BB_Blake_Color;
    lblName.textAlignment = NSTextAlignmentLeft;
    lblName.font = [UIFont systemFontOfSize:16];
    lblName.numberOfLines = 0;
    lblName.text = [dataSource objectForKey:@"district_name"];
    [downView addSubview:lblName];
    
    UIButton *addressBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addressBtn setFrame:CGRectMake(10, 58, UI_View_Width-20, 41)];
    [addressBtn setBackgroundImage:[UIImage imageNamed:@"R查看路线按钮.png"] forState:UIControlStateNormal];
    [addressBtn addTarget:self action:@selector(addressPressed:) forControlEvents:UIControlEventTouchUpInside];
    [downView addSubview:addressBtn];
    
    UILabel *lblAddress = [[UILabel alloc]init];
    [lblAddress setFont:[UIFont boldSystemFontOfSize:14]];
    [lblAddress setBackgroundColor:[UIColor clearColor]];
    [lblAddress setTextAlignment:NSTextAlignmentLeft];
    [lblAddress setTextColor:BB_Green_Color];
    [lblAddress setText:@"查看路线"];
    [lblAddress setFrame:CGRectMake(10, 0 ,UI_View_Width-20, 41)];
    [addressBtn addSubview:lblAddress];
}
-(void)loadData
{
    if (!dataSource)
        dataSource = [[NSMutableDictionary alloc]init];
    
    //测试专用，移到项目中时请屏蔽
    myCoodinate = [HemaFunction xfuncGetAppdelegate].myCoordinate;
    [dataSource setObject:@"36.687387" forKey:@"lat"];
    [dataSource setObject:@"117.120158" forKey:@"lng"];
    [dataSource setObject:@"山东河马信息技术有限公司" forKey:@"name"];
    [dataSource setObject:@"山东省济南市玉兰广场" forKey:@"district_name"];
}
#pragma mark- 自定义
#pragma mark 事件
//定位
-(void)locationPressed:(id)sender
{
    [myMap setZoomLevel:17];
    [myMap setCenterCoordinate:CLLocationCoordinate2DMake(myCoodinate.latitude, myCoodinate.longitude)];
}
//查看路线
-(void)addressPressed:(id)sender
{
    RRouteSearchVC *myVC = [[RRouteSearchVC alloc]init];
    myVC.myCoodinate = myCoodinate;
    myVC.dataSource = dataSource;
    [self.navigationController pushViewController:myVC animated:YES];
}
#pragma mark- MAMapViewDelegate
- (MAAnnotationView*)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *invertGeoIdentifier = @"invertGeoIdentifier";
        
        MAAnnotationView *poiAnnotationView = (MAAnnotationView*)[myMap dequeueReusableAnnotationViewWithIdentifier:invertGeoIdentifier];
        if (poiAnnotationView == nil)
        {
            poiAnnotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:invertGeoIdentifier];
        }
        poiAnnotationView.image = [UIImage imageNamed:@"R地图定位点图标@2x.png"];
        poiAnnotationView.canShowCallout = NO;
        return poiAnnotationView;
    }
    return nil;
}
- (void)mapView:(MAMapView *)mapView regionWillChangeAnimated:(BOOL)animated
{
    NSLog(@"比例：%lf",mapView.zoomLevel);
}
- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation
{
    NSLog(@"定位：%lf,%lf",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    if (userLocation.location.coordinate.latitude != 0)
    {
        myCoodinate = userLocation.location.coordinate;
    }
}
- (void)mapView:(MAMapView *)mapView didChangeUserTrackingMode:(MAUserTrackingMode)mode animated:(BOOL)animated
{
    NSLog(@"定位模式：%d",(int)mode);
}
@end
