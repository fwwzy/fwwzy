//
//  RMoreSelectItemVC.m
//  Hema
//
//  Created by LarryRodic on 15/10/19.
//  Copyright (c) 2015年 Hemaapp. All rights reserved.
//

#import "RMoreSelectItemVC.h"
#import "JSDropDownMenu.h"

@interface RMoreSelectItemVC ()<JSDropDownMenuDelegate,JSDropDownMenuDataSource>
{
    //筛选的
    NSInteger currentFiltIndex1;
    NSInteger currentFiltIndex2;
    NSInteger currentFiltIndex3;
    NSInteger currentFiltItem1;
}
///筛选的数据
@property(nonatomic,strong)NSMutableArray *filt1Source;
@property(nonatomic,strong)NSMutableArray *filt2Source;
@property(nonatomic,strong)NSMutableArray *filt3Source;
@property(nonatomic,strong)NSMutableArray *filt1Item;
@end

@implementation RMoreSelectItemVC
@synthesize filt1Source;
@synthesize filt2Source;
@synthesize filt3Source;
@synthesize filt1Item;

-(void)loadSet
{
    //导航
    [self.navigationItem setNewTitle:@"多级类型筛选"];
    
    //筛选菜单
    JSDropDownMenu *menu = [[JSDropDownMenu alloc] initWithOrigin:CGPointMake(0, 0) andHeight:45];
    menu.indicatorColor = [UIColor colorWithRed:175.0f/255.0f green:175.0f/255.0f blue:175.0f/255.0f alpha:1.0];
    menu.separatorColor = [UIColor colorWithRed:210.0f/255.0f green:210.0f/255.0f blue:210.0f/255.0f alpha:1.0];
    menu.textColor = [UIColor colorWithRed:83.f/255.0f green:83.f/255.0f blue:83.f/255.0f alpha:1.0f];
    menu.dataSource = self;
    menu.delegate = self;
    [self.view addSubview:menu];
}
-(void)loadData
{
    self.filt1Source = [[NSMutableArray alloc]initWithObjects:@"全部",@"动漫",@"图书",@"朝代",@"国家", nil];
    self.filt2Source = [[NSMutableArray alloc]initWithObjects:@"全部",@"北京",@"上海",@"广州",@"深圳",@"济南",@"秦皇岛", nil];
    self.filt3Source = [[NSMutableArray alloc]initWithObjects:@"全部",@"优等",@"良好",@"及格",@"下品", nil];
    self.filt1Item = [[NSMutableArray alloc]initWithObjects:@"火影忍者",@"大力水手",@"葫芦娃",@"海尔兄弟",@"四驱小子",@"神探狄仁杰", nil];
    
    currentFiltIndex1 = 0;
    currentFiltIndex2 = 0;
    currentFiltIndex3 = 0;
    currentFiltItem1 = 0;
}
#pragma mark- 自定义
#pragma mark 事件
#pragma mark - JSDropDownMenu Delegate
- (void)menu:(JSDropDownMenu *)menu didSelectRowAtIndexPath:(JSIndexPath *)indexPath
{
    if (indexPath.column == 0)
    {
        currentFiltIndex1 = indexPath.leftRow;
        if(indexPath.leftOrRight==1)
        {
            currentFiltItem1 = indexPath.row;
        }
    }
    if (indexPath.column == 1)
    {
        currentFiltIndex2 = indexPath.row;
    }
    if (indexPath.column == 2)
    {
        currentFiltIndex3 = indexPath.row;
    }
}
#pragma mark - JSDropDownMenu Datasource
- (NSInteger)numberOfColumnsInMenu:(JSDropDownMenu *)menu
{
    return 3;
}
-(BOOL)displayByCollectionViewInColumn:(NSInteger)column
{
    return NO;
}
- (BOOL)haveRightTableViewInColumn:(NSInteger)column
{
    if (column == 0)
    {
        return YES;
    }
    return NO;
}
-(CGFloat)widthRatioOfLeftColumn:(NSInteger)column
{
    if (column == 0)
    {
        return 0.3;
    }
    return 1;
}
-(NSInteger)currentLeftSelectedRow:(NSInteger)column
{
    if (column == 0)
    {
        return currentFiltIndex1;
    }
    if (column == 1)
    {
        return currentFiltIndex2;
    }
    return currentFiltIndex3;
}
- (NSInteger)menu:(JSDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column leftOrRight:(NSInteger)leftOrRight leftRow:(NSInteger)leftRow
{
    if (column == 0)
    {
        if (leftOrRight == 0)
        {
            return filt1Source.count;
        }
        return filt1Item.count;
    }
    if (column == 1)
    {
        return filt2Source.count;
    }
    return filt3Source.count;
}
- (NSString *)menu:(JSDropDownMenu *)menu titleForColumn:(NSInteger)column
{
    if (column == 0)
    {
        return @"分类";
    }
    if (column == 1)
    {
        return @"地区";
    }
    return @"品质";
}
- (NSString *)menu:(JSDropDownMenu *)menu titleForRowAtIndexPath:(JSIndexPath *)indexPath
{
    if (indexPath.column == 0)
    {
        if (indexPath.leftOrRight == 0)
        {
            return [filt1Source objectAtIndex:indexPath.row];
        }
        return [filt1Item objectAtIndex:indexPath.row];
    }
    if (indexPath.column == 1)
    {
        return [filt2Source objectAtIndex:indexPath.row];
    }
    return [filt3Source objectAtIndex:indexPath.row];
}
@end
