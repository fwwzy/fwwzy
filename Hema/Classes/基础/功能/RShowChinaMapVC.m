//
//  RShowChinaMapVC.m
//  Hema
//
//  Created by LarryRodic on 15/10/17.
//  Copyright (c) 2015年 Hemaapp. All rights reserved.
//

#import "RShowChinaMapVC.h"
#import "FSInteractiveMapView.h"

@interface RShowChinaMapVC ()<UIScrollViewDelegate>
@property(nonatomic,strong)FSInteractiveMapView *mapView;
@property(nonatomic,strong)UIScrollView *myScrollView;
@property(nonatomic,weak)CAShapeLayer *oldClickedLayer;//上一次点击的
@end

@implementation RShowChinaMapVC

-(void)loadSet
{
    [self.navigationItem setNewTitle:@"中国地图"];
    
    _myScrollView = [[UIScrollView alloc]init];
    [_myScrollView setFrame:CGRectMake(0, 0, UI_View_Width, UI_View_Height)];
    _myScrollView.contentSize = CGSizeMake(UI_View_Width, UI_View_Height);
    _myScrollView.minimumZoomScale = 1.0f;
    _myScrollView.maximumZoomScale = 4.0f;
    _myScrollView.scrollEnabled = YES;
    _myScrollView.delegate = self;
    [self.view addSubview:_myScrollView];
    
    [self createChina];
}
-(void)loadData
{
    /*
     代码 名    称          代码     名    称
     11       北京市          43       湖南省
     12       天津市          44       广东省
     13       河北省          45       广西壮族自治区
     14       山西省          46       海南省
     15       内蒙古自治区    50       重庆市
     21       辽宁省          51       四川省
     22       吉林省          52       贵州省
     23       黑龙江省        53       云南省
     31       上海市          54       西藏自治区
     32       江苏省          61       陕西省
     33       浙江省          62       甘肃省
     34       安徽省          63       青海省
     35       福建省          64       宁夏回族自治区
     36       江西省          65       新疆维吾尔自治区
     37       山东省          71       台湾省
     41       河南省          81       香港特别行政区
     42       湖北省          82       澳门特别行政区
     */
}
#pragma mark- 自定义
#pragma mark 方法
//中国地图点击选择省份
-(void)createChina
{
    //中国地图
    _mapView = [[FSInteractiveMapView alloc]init];
    _mapView.frame = CGRectMake(10, 100, UI_View_Width-20, UI_View_Height-20);
    _mapView.backgroundColor = BB_Back_Color_Here;
    
    NSMutableDictionary *colorDic = [[NSMutableDictionary alloc]init];
    for (int i = 11; i<100; i++)
    {
        [colorDic setObject:[HemaFunction randomColor] forKey:[NSString stringWithFormat:@"CN-%d",i]];
    }
    
    [_mapView loadMap:@"china-low" withColors:colorDic];
    
    __block CAShapeLayer *oldClickedLayer = _oldClickedLayer;
    
    [_mapView setClickHandler:^(NSString* identifier, CAShapeLayer* layer)
     {
         if(oldClickedLayer)
         {
             oldClickedLayer.zPosition = 0;
             oldClickedLayer.shadowOpacity = 0;
         }
         oldClickedLayer = layer;
         
         layer.zPosition = 10;
         layer.shadowOpacity = 0.5;
         layer.shadowColor = [UIColor blackColor].CGColor;
         layer.shadowRadius = 5;
         layer.shadowOffset = CGSizeMake(0, 0);
         
         NSLog(@"点击的标识符：%@",identifier);
     }];
    [_myScrollView addSubview:_mapView];
}
//欧洲地图
-(void)createEurope
{
    NSDictionary* data = @{@"fr" : @12,
                           @"it" : @2,
                           @"de" : @9,
                           @"pl" : @24,
                           @"uk" : @17
                           };
    
    _mapView = [[FSInteractiveMapView alloc] initWithFrame:CGRectMake(-1, 64, self.view.frame.size.width + 2, 500)];
    [_mapView loadMap:@"europe" withData:data colorAxis:@[[UIColor blueColor], [UIColor greenColor], [UIColor yellowColor], [UIColor redColor]]];
    
    [_myScrollView addSubview:_mapView];
}
//全球地图
-(void)createWorld
{
    NSDictionary* data = @{@"asia" : @12,
                           @"australia" : @2,
                           @"north_america" : @5,
                           @"south_america" : @14,
                           @"africa" : @5,
                           @"europe" : @20
                           };
    _mapView = [[FSInteractiveMapView alloc] initWithFrame:CGRectMake(16, 96, self.view.frame.size.width - 32, self.view.frame.size.height)];
    [_mapView loadMap:@"world-continents-low" withData:data colorAxis:@[[UIColor lightGrayColor], [UIColor darkGrayColor]]];
    [_mapView setClickHandler:^(NSString* identifier, CAShapeLayer* layer)
     {
         NSLog(@"点击的标识符：%@",identifier);
     }];
    [_myScrollView addSubview:_mapView];
}
#pragma mark- UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _mapView;
}
@end
