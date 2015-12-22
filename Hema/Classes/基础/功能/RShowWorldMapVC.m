//
//  RShowWorldMapVC.m
//  Hema
//
//  Created by LarryRodic on 15/10/17.
//  Copyright (c) 2015年 Hemaapp. All rights reserved.
//

#import "RShowWorldMapVC.h"
#import "MRWorldMapView.h"

@interface RShowWorldMapVC ()<MRWorldMapViewDelegate,UIScrollViewDelegate>
@property(nonatomic,strong)MRWorldMapView *mapView;
@property(nonatomic,strong)UIScrollView *myScrollView;
@property(nonatomic,strong)NSMutableDictionary *colorDic;//存放国家颜色的字典
@end

@implementation RShowWorldMapVC

-(void)loadSet
{
    [self.navigationItem setNewTitle:@"全球地图"];
    
    _myScrollView = [[UIScrollView alloc]init];
    [_myScrollView setFrame:CGRectMake(0, 0, UI_View_Width, UI_View_Height)];
    _myScrollView.contentSize = CGSizeMake(600, 400);
    _myScrollView.minimumZoomScale = 1.0f;
    _myScrollView.maximumZoomScale = 4.0f;
    _myScrollView.scrollEnabled = YES;
    _myScrollView.delegate = self;
    [self.view addSubview:_myScrollView];
    
    _mapView = [[MRWorldMapView alloc]init];
    _mapView.frame = CGRectMake(0, 0, 600, 400);
    _mapView.backgroundColor = BB_Back_Color_Here;
    _mapView.delegate = self;
    [_myScrollView addSubview:_mapView];
}
-(void)loadData
{
    _colorDic = [[NSMutableDictionary alloc]init];
}
#pragma mark- 自定义
#pragma mark 方法

#pragma mark- MRWorldMapViewDelegate
- (void)worldMap:(MRWorldMapView *)map didHighlightCountry:(NSString *)code
{
    if (code)
    {
        NSLog(@"高亮的国家: %@", code);
    }
}
- (void)worldMap:(MRWorldMapView *)map didSelectCountry:(NSString *)code
{
    NSLocale *locale = NSLocale.currentLocale;
    NSString *countryName = [locale displayNameForKey:NSLocaleCountryCode
                                                value:code];
    NSLog(@"选择的国家：%@",countryName);
}
- (UIColor *)worldMap:(MRWorldMapView *)map colorForCountry:(NSString *)code
{
    if (code)
    {
        if ([code isEqualToString:@"CN"])
        {
            return BB_Red_Color;
        }
        if ([_colorDic objectForKey:code])
        {
            return [_colorDic objectForKey:code];
        }
        [_colorDic setObject:[HemaFunction randomColor] forKey:code];
        return [HemaFunction randomColor];
    }
    return BB_Gray_Color;
}
#pragma mark- UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _mapView;
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
    {
        _mapView.highlightedCountry = nil;
        [_mapView setNeedsDisplay];
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    _mapView.highlightedCountry = nil;
    [_mapView setNeedsDisplay];
}
@end
