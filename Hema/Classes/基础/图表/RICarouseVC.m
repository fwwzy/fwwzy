//
//  RICarouseVC.m
//  Hema
//
//  Created by geyang on 15/11/6.
//  Copyright © 2015年 Hemaapp. All rights reserved.
//

#import "RICarouseVC.h"
#import "iCarousel.h"

@interface RICarouseVC ()<iCarouselDataSource,iCarouselDelegate>
{
    BOOL wrap;//是否环绕一圈
    NSInteger type;//样式
}
@property(nonatomic,strong)NSMutableArray *listArr;
@property(nonatomic,strong)iCarousel *carousel;
@property(nonatomic,strong)HemaButton *wrapBtn;//环绕按钮
@property(nonatomic,strong)HemaButton *directBtn;//方向按钮
@end

@implementation RICarouseVC

-(void)loadSet
{
    [self.navigationItem setNewTitle:@"旋转视图"];
    [self.navigationItem setRightItemWithTarget:self action:@selector(rightbtnPressed:) title:@"样式"];
    
    _carousel = [[iCarousel alloc]init];
    _carousel.delegate = self;
    _carousel.dataSource = self;
    [_carousel setFrame:CGRectMake(0, 0, UI_View_Width, UI_View_Height-44)];
    _carousel.type = iCarouselTypeCoverFlow2;
    [self.view addSubview:_carousel];
    
    //各种设置
    UIView *downView = [[UIView alloc]initWithFrame:CGRectMake(0, UI_View_Height-44, UI_View_Width, 44)];
    [self.view addSubview:downView];
    
    HemaButton *insertBtn = [HemaButton buttonWithType:UIButtonTypeCustom];
    [insertBtn setFrame:CGRectMake(10, 0, 60, 44)];
    [insertBtn setTitle:@"插入一条" forState:UIControlStateNormal];
    [insertBtn setTitleColor:BB_Red_Color forState:UIControlStateNormal];
    [insertBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [insertBtn addTarget:self action:@selector(insertPressed:) forControlEvents:UIControlEventTouchUpInside];
    [downView addSubview:insertBtn];
    
    HemaButton *deleteBtn = [HemaButton buttonWithType:UIButtonTypeCustom];
    [deleteBtn setFrame:CGRectMake(80, 0, 60, 44)];
    [deleteBtn setTitle:@"删除一条" forState:UIControlStateNormal];
    [deleteBtn setTitleColor:BB_Red_Color forState:UIControlStateNormal];
    [deleteBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [deleteBtn addTarget:self action:@selector(deletePressed:) forControlEvents:UIControlEventTouchUpInside];
    [downView addSubview:deleteBtn];
    
    _wrapBtn = [HemaButton buttonWithType:UIButtonTypeCustom];
    [_wrapBtn setFrame:CGRectMake(150, 0, 60, 44)];
    [_wrapBtn setTitle:@"环绕" forState:UIControlStateNormal];
    [_wrapBtn setTitleColor:BB_Red_Color forState:UIControlStateNormal];
    [_wrapBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [_wrapBtn addTarget:self action:@selector(wrapPressed:) forControlEvents:UIControlEventTouchUpInside];
    [downView addSubview:_wrapBtn];
    
    _directBtn = [HemaButton buttonWithType:UIButtonTypeCustom];
    [_directBtn setFrame:CGRectMake(220, 0, 60, 44)];
    [_directBtn setTitle:@"水平方向" forState:UIControlStateNormal];
    [_directBtn setTitleColor:BB_Red_Color forState:UIControlStateNormal];
    [_directBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [_directBtn addTarget:self action:@selector(directPressed:) forControlEvents:UIControlEventTouchUpInside];
    [downView addSubview:_directBtn];
}
-(void)loadData
{
    _listArr = [[NSMutableArray alloc]init];
    for (int i = 0; i < 10; i++)
    {
        [_listArr addObject:@(i)];
    }
    wrap = YES;
    type = iCarouselTypeCoverFlow2;
}
#pragma mark- 自定义
#pragma mark 事件
-(void)rightbtnPressed:(id)sender
{
    if (type == 11)
    {
        type = 0;
    }else
    {
        type++;
    }
    [UIView beginAnimations:nil context:nil];
    _carousel.type = type;
    [UIView commitAnimations];
}
//插入数据
-(void)insertPressed:(id)sender
{
    NSInteger index = MAX(0, _carousel.currentItemIndex);
    [_listArr insertObject:@(_carousel.numberOfItems) atIndex:(NSUInteger)index];
    [_carousel insertItemAtIndex:index animated:YES];
}
//删除数据
-(void)deletePressed:(id)sender
{
    if (self.carousel.numberOfItems > 0)
    {
        NSInteger index = _carousel.currentItemIndex;
        [_listArr removeObjectAtIndex:(NSUInteger)index];
        [_carousel removeItemAtIndex:index animated:YES];
    }
}
//环绕设置
-(void)wrapPressed:(id)sender
{
    wrap = !wrap;
    [_wrapBtn setTitle:wrap?@"环绕":@"不环绕" forState:UIControlStateNormal];
    [_carousel reloadData];
}
//方向
-(void)directPressed:(id)sender
{
    [UIView beginAnimations:nil context:nil];
    _carousel.vertical = !_carousel.vertical;
    [UIView commitAnimations];
    [_directBtn setTitle:!_carousel.vertical?@"水平方向":@"垂直方向" forState:UIControlStateNormal];
}
#pragma mark- iCarouselDataSource
- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return _listArr.count;
}
- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    UILabel *label = nil;
    
    if (view == nil)
    {
        view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 200, 200)];
        
        UIImageView *backImgView = [[UIImageView alloc]init];
        [backImgView setFrame:view.frame];
        [backImgView setImage:[UIImage imageNamed:@"ICpage.png"]];
        backImgView.contentMode = UIViewContentModeCenter;
        [view addSubview:backImgView];
        
        label = [[UILabel alloc] initWithFrame:view.bounds];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [label.font fontWithSize:20];
        label.textColor = BB_Blue_Color;
        label.tag = 10;
        [view addSubview:label];
    }else
    {
        label = (UILabel *)[view viewWithTag:10];
    }
    label.text = [NSString stringWithFormat:@"%@",[_listArr[(NSUInteger)index] stringValue]];
    
    return view;
}
- (NSInteger)numberOfPlaceholdersInCarousel:(iCarousel *)carousel
{
    return 2;
}
- (UIView *)carousel:(iCarousel *)carousel placeholderViewAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    UILabel *label = nil;
    
    if (view == nil)
    {
        view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 200, 200)];
        
        UIImageView *backImgView = [[UIImageView alloc]init];
        [backImgView setFrame:view.frame];
        [backImgView setImage:[UIImage imageNamed:@"ICpage.png"]];
        backImgView.contentMode = UIViewContentModeCenter;
        [view addSubview:backImgView];
        
        label = [[UILabel alloc] initWithFrame:view.bounds];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [label.font fontWithSize:20];
        label.textColor = BB_Red_Color;
        label.tag = 10;
        [view addSubview:label];
    }else
    {
        label = (UILabel *)[view viewWithTag:10];
    }
    label.text = (index == 0)? @"[": @"]";
    
    return view;
}
#pragma mark- iCarouselDelegate
- (CATransform3D)carousel:(__unused iCarousel *)carousel itemTransformForOffset:(CGFloat)offset baseTransform:(CATransform3D)transform
{
    transform = CATransform3DRotate(transform, M_PI / 8.0f, 0.0f, 1.0f, 0.0f);
    return CATransform3DTranslate(transform, 0.0f, 0.0f, offset * self.carousel.itemWidth);
}
- (CGFloat)carousel:(__unused iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    switch (option)
    {
        case iCarouselOptionWrap:
        {
            return wrap;
        }
        case iCarouselOptionSpacing:
        {
            return value * 1.05f;
        }
        case iCarouselOptionFadeMax:
        {
            if (self.carousel.type == iCarouselTypeCustom)
            {
                return 0.0f;
            }
            return value;
        }
        case iCarouselOptionShowBackfaces:
        case iCarouselOptionRadius:
        case iCarouselOptionAngle:
        case iCarouselOptionArc:
        case iCarouselOptionTilt:
        case iCarouselOptionCount:
        case iCarouselOptionFadeMin:
        case iCarouselOptionFadeMinAlpha:
        case iCarouselOptionFadeRange:
        case iCarouselOptionOffsetMultiplier:
        case iCarouselOptionVisibleItems:
        {
            return value;
        }
    }
}
- (void)carousel:(__unused iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index
{
    NSNumber *item = (_listArr)[(NSUInteger)index];
    NSLog(@"点击的是第几个: %@", item);
}
- (void)carouselCurrentItemIndexDidChange:(__unused iCarousel *)carousel
{
    NSLog(@"索引: %@", @(self.carousel.currentItemIndex));
}
@end
