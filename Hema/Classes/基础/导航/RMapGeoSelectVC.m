//
//  CheGeoMapVC.m
//  PingChuan
//
//  Created by LarryRodic on 15/7/28.
//  Copyright (c) 2015年 平川嘉恒. All rights reserved.
//

#import "RMapGeoSelectVC.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchAPI.h>
#import "ReGeocodeAnnotation.h"
#import "HemaLongGR.h"

@interface RMapGeoSelectVC ()<MAMapViewDelegate,AMapSearchDelegate>
{
    CLLocationCoordinate2D touchMapCoordinate;
}
@property(nonatomic,strong)MAMapView *myMap;
@property(nonatomic,strong)AMapSearchAPI *mySearch;
@property(nonatomic,strong)ReGeocodeAnnotation *pointAnnotation;
@end

@implementation RMapGeoSelectVC
@synthesize myMap;
@synthesize mySearch;
@synthesize pointAnnotation;
@synthesize latitude;
@synthesize longitude;
@synthesize isEdit;
@synthesize delegate;
@synthesize keytype;

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    myMap.delegate = self;
    mySearch.delegate = self;
    
    [self.navigationController setNavigationBarHidden:NO];
    
    LCPanNavigationController *nav = (LCPanNavigationController*)self.navigationController;
    [nav.panGestureRecognizer setEnabled:NO];
}
-(void)viewWillDisappear:(BOOL)animated
{
    myMap.delegate = nil;
    mySearch.delegate = nil;
    
    LCPanNavigationController *nav = (LCPanNavigationController*)self.navigationController;
    [nav.panGestureRecognizer setEnabled:YES];
    [super viewWillDisappear:animated];
}
-(void)loadSet
{
    [self.navigationItem setRightItemWithTarget:self action:@selector(rightbtnPressed:) title:@"保存"];
    
    //创建地图视图，初始化参数
    UIView *backView = [[UIView alloc]init];
    [backView setFrame:CGRectMake(0, 0, UI_View_Width, UI_View_Height)];
    [self.view addSubview:backView];
    
    //创建地图
    myMap = [[MAMapView alloc]initWithFrame:CGRectMake(0, 0,UI_View_Width, UI_View_Height)];
    myMap.delegate = self;
    myMap.zoomLevel = 17;
    myMap.showsUserLocation = YES;
    myMap.userTrackingMode = MAUserTrackingModeFollow;
    myMap.mapType = MAMapTypeStandard;
    [backView addSubview:myMap];
    
    mySearch = [[AMapSearchAPI alloc] initWithSearchKey:[MAMapServices sharedServices].apiKey Delegate:self];
    
    //定义一个iOS拍击手势
    HemaLongGR *gestureTap = [[HemaLongGR alloc] initWithTarget:self action:@selector(longPress:)];
    gestureTap.minimumPressDuration = 0.5;
    gestureTap.delegate = self;
    [backView addGestureRecognizer:gestureTap];
    
    //长按提示
    UILabel *labRight = [[UILabel alloc]init];
    labRight.backgroundColor = [UIColor clearColor];
    labRight.textAlignment = NSTextAlignmentCenter;
    labRight.textColor = BB_Red_Color;
    labRight.text = @"长按选取位置";
    labRight.font = [UIFont boldSystemFontOfSize:15];
    labRight.frame = CGRectMake(0, UI_View_Height-30, UI_View_Width, 30);
    labRight.tag = 11;
    [labRight setUserInteractionEnabled:NO];
    [self.view addSubview:labRight];
    
    if (keytype == 1)
    {
        //初始化详情弹出框对象
        pointAnnotation = [[ReGeocodeAnnotation alloc] init];
        touchMapCoordinate = CLLocationCoordinate2DMake(latitude, longitude);
        [self searchReGeocodeWithCoordinate];
    }
    if (keytype == 2)
    {
        [myMap setCenterCoordinate:CLLocationCoordinate2DMake(latitude, longitude)];
    }
}
#pragma mark- 自定义
#pragma mark 事件
-(void)rightbtnPressed:(id)sender
{
    [self showDetails:nil];
}
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
#pragma mark 方法
//逆地理编译
- (void)searchReGeocodeWithCoordinate
{
    AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc] init];
    
    regeo.location = [AMapGeoPoint locationWithLatitude:touchMapCoordinate.latitude longitude:touchMapCoordinate.longitude];
    regeo.requireExtension = YES;
    
    [mySearch AMapReGoecodeSearch:regeo];
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
        poiAnnotationView.canShowCallout            = YES;
        poiAnnotationView.image = [UIImage imageNamed:@"R地图定位点图标@2x.png"];
        //添加导航按钮
        if (isEdit)
        {
            UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            [rightButton addTarget:self action:@selector(showDetails:) forControlEvents:UIControlEventTouchUpInside];
            poiAnnotationView.rightCalloutAccessoryView = rightButton;
        }
        return poiAnnotationView;
    }
    return nil;
}
#pragma mark- AMapSearchDelegate
/* 逆地理编码回调. */
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
    NSLog(@"已回调");
    if (response.regeocode != nil)
    {
        [myMap removeAnnotations:myMap.annotations];
        [myMap removeOverlays:myMap.overlays];
        
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(request.location.latitude, request.location.longitude);
        pointAnnotation = [[ReGeocodeAnnotation alloc] initWithCoordinate:coordinate reGeocode:response.regeocode];
        [myMap addAnnotation:pointAnnotation];
        [myMap selectAnnotation:pointAnnotation animated:YES];
        
        NSLog(@"坐标：%lf,%lf",request.location.latitude,request.location.longitude);
    }
}
#pragma mark 选取位置时操作
- (void)showDetails:(UIButton*)sender
{
    if (isEdit)
    {
        if ([HemaFunction xfunc_check_strEmpty:pointAnnotation.subtitle])
        {
            UIAlertView *locationServiceAlert = [[UIAlertView alloc] initWithTitle:nil message:@"此位置地址未知，确定退出吗？" delegate:self cancelButtonTitle:nil otherButtonTitles:@"取消",@"确定",nil];
            [locationServiceAlert show];
            return;
        }
        if (keytype == 1)
        {
            [delegate MapGeoName:pointAnnotation.subtitle lat:[NSString stringWithFormat:@"%f",touchMapCoordinate.latitude] lng:[NSString stringWithFormat:@"%f",touchMapCoordinate.longitude]];
        }
        if (keytype == 2)
        {
            [delegate MapGeoName:pointAnnotation.reGeocode.addressComponent.city lat:[NSString stringWithFormat:@"%f",touchMapCoordinate.latitude] lng:[NSString stringWithFormat:@"%f",touchMapCoordinate.longitude]];
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark- AlertViewDalagete
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
@end
