//
//  RChartListVC.m
//  Hema
//
//  Created by LarryRodic on 15/10/24.
//  Copyright © 2015年 Hemaapp. All rights reserved.
//

#import "RChartListVC.h"
#import "ChatLineView.h"
#import "DrawView.h"
#import "iPhoneGraphViewController.h"
#import "TEAChart.h"
#import "VBPieChart.h"
#import "SHLineGraphView.h"

@interface RChartListVC ()<TEAContributionGraphDataSource>
@end

@implementation RChartListVC

-(void)loadSet
{
    [self.navigationItem setNewTitle:@"走势图绘制"];
    
    [SystemFunction setTableSeparatorInset:self.mytable left:10];
    [self forbidPullRefresh];
}
-(void)loadData
{
    
}
#pragma mark- TEAContributionGraphDataSource
- (void)dateTapped:(NSDictionary *)dict
{
    NSLog(@"点击日期：%@",dict);
}
- (NSDate *)monthForGraph
{
    return [NSDate date];
}
- (NSInteger)valueForDay:(NSUInteger)day
{
    return day % 6;
}
#pragma mark- TableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 6;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (2 == section||3 == section)
    {
        return 2;
    }
    if (1 == section)
    {
        return 3;
    }
    return 1;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"all";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.backgroundColor = BB_White_Color;
        cell.clipsToBounds = YES;
    }else
    {
        for(UIView *view in cell.contentView.subviews)
        {
            [view removeFromSuperview];
        }
    }
    
    //第一种
    if (0 == indexPath.section)
    {
        NSMutableArray *yearArr = [[NSMutableArray alloc]initWithObjects:@"2015",@"2014", nil];
        NSArray *valueArr1 = @[@"0",@"75",@"90",@"70",@"0",@"70",@"60",@"50",@"70",@"60",@"120",@"80"];
        NSArray *valueArr2 = @[@"90",@"70",@"80",@"60",@"80",@"0",@"70",@"80",@"0",@"90",@"110",@"130"];
        
        ChatLineView *chatLineView = [[ChatLineView alloc]initWithFrame:CGRectMake(0, 0, UI_View_Width, 200)];
        chatLineView.backgroundColor = [UIColor whiteColor];
        chatLineView.valueArr = @[valueArr1,valueArr2];
        chatLineView.yearArr = yearArr;
        chatLineView.xValueArr = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12"];
        [cell.contentView addSubview:chatLineView];
    }
    //第二种
    if (1 == indexPath.section)
    {
        NSMutableArray *myArr = [[NSMutableArray alloc]init];
        for (int i = 0; i<6; i++)
        {
            CoordinateItem *item = [[CoordinateItem alloc] initWithXValue:[NSString stringWithFormat:@"%d",i]
                                                               withYValue:[NSString stringWithFormat:@"%d",arc4random()%100]
                                                                withColor:[HemaFunction randomColor]];
            [myArr addObject:item];
        }
        DrawView *drawLineChartView = [[DrawView alloc] initWithFrame:CGRectMake(0, 0, UI_View_Width, 250)
                                                       withDataSource:myArr
                                                             withType:((indexPath.row == 0)?LineChartViewType:((indexPath.row == 1)?BarChartViewType:PieChartViewType))
                                                        withAnimation:YES];
        [cell.contentView addSubview:drawLineChartView];
    }
    //第三种
    if (2 == indexPath.section)
    {
        iPhoneGraphViewController *iPhoneGraph = [[iPhoneGraphViewController alloc]init];
        
        iPhoneGraph.fistArray = @[[NSNumber numberWithInt:12],[NSNumber numberWithInt:8],[NSNumber numberWithInt:1],[NSNumber numberWithInt:16],[NSNumber numberWithInt:19],[NSNumber numberWithInt:32],[NSNumber numberWithInt:22],[NSNumber numberWithInt:-12],[NSNumber numberWithInt:16],[NSNumber numberWithInt:19],[NSNumber numberWithInt:22],[NSNumber numberWithInt:32]];
        iPhoneGraph.secondArray = @[[NSNumber numberWithInt:2],[NSNumber numberWithInt:-18],[NSNumber numberWithInt:-5],[NSNumber numberWithInt:12],[NSNumber numberWithInt:13],[NSNumber numberWithInt:30],[NSNumber numberWithInt:19],[NSNumber numberWithInt:-10],[NSNumber numberWithInt:10],[NSNumber numberWithInt:10],[NSNumber numberWithInt:32],[NSNumber numberWithInt:12]];
        
        [iPhoneGraph setFrame:CGRectMake(20, 25, UI_View_Width-40, 150)];
        [iPhoneGraph setLinesGraph:(indexPath.row == 1)?YES:NO];
        [cell.contentView addSubview:iPhoneGraph];
    }
    //第四种
    if (3 == indexPath.section)
    {
        if (0 == indexPath.row)
        {
            TEABarChart *barChart = [[TEABarChart alloc]init];
            barChart.data = @[@3, @1, @4, @1, @5, @9, @2, @6, @5, @3];
            barChart.barSpacing = 10;
            barChart.barColors = @[[UIColor orangeColor], [UIColor yellowColor], [UIColor greenColor], [UIColor blueColor]];
            [barChart setFrame:CGRectMake(10, 25, UI_View_Width-20, 150)];
            [cell.contentView addSubview:barChart];
        }
        if (1 == indexPath.row)
        {
            TEABarChart *secondBarChart = [[TEABarChart alloc] initWithFrame:CGRectMake(10, 25, UI_View_Width/2-20, 150)];
            secondBarChart.data = @[@2, @7, @1, @8, @2, @8];
            secondBarChart.xLabels = @[@"A", @"B", @"C", @"D", @"E", @"F"];
            [cell.contentView addSubview:secondBarChart];
            
            TEAContributionGraph *secondContributionGraph = [[TEAContributionGraph alloc] initWithFrame:CGRectMake(UI_View_Width/2+10, 25, UI_View_Width/2-20, 150)];
            secondContributionGraph.showDayNumbers = YES;
            secondContributionGraph.delegate = self;
            [cell.contentView addSubview:secondContributionGraph];
        }
    }
    //第五种
    if (4 == indexPath.section)
    {
        VBPieChart *chart = [[VBPieChart alloc]init];
        [chart setFrame:CGRectMake(40, 40, UI_View_Width-80, UI_View_Width-80)];
        [chart setEnableStrokeColor:YES];
        [chart setHoleRadiusPrecent:0.3];
        [cell.contentView addSubview:chart];
        
        [chart.layer setShadowOffset:CGSizeMake(2, 2)];
        [chart.layer setShadowRadius:3];
        [chart.layer setShadowColor:[UIColor blackColor].CGColor];
        [chart.layer setShadowOpacity:0.7];
        
        NSDictionary *chartValues = @{
                                 @"first": @{@"value":@50, @"color":[UIColor colorWithHexString:@"#dd191d"]},
                                 @"second": @{@"value":@20, @"color":[UIColor colorWithHexString:@"#d81b60"]},
                                 @"third": @{@"value":@40, @"color":[UIColor colorWithHexString:@"#8e24aa"]},
                                 @"fourth 2": @{@"value":@70, @"color":[UIColor colorWithHexString:@"#3f51b5"]},
                                 @"fourth 3": @{@"value":@65, @"color":[UIColor colorWithHexString:@"#5677fc"]},
                                 @"fourth 4": @{@"value":@23, @"color":[UIColor colorWithHexString:@"#2baf2b"]},
                                 @"fourth 5": @{@"value":@34, @"color":[UIColor colorWithHexString:@"#b0bec5"]},
                                 @"fourth 6": @{@"value":@54, @"color":[UIColor colorWithHexString:@"#f57c00"]}
                                 };
        [chart setChartValues:chartValues animation:YES options:VBPieChartAnimationFanAll];
    }
    //第六种
    if (5 == indexPath.section)
    {
        SHLineGraphView *_lineGraph = [[SHLineGraphView alloc] initWithFrame:CGRectMake(0, 0, UI_View_Width, 200)];
        NSDictionary *_themeAttributes = @{
                                           kXAxisLabelColorKey : [UIColor colorWithRed:0.48 green:0.48 blue:0.49 alpha:0.4],
                                           kXAxisLabelFontKey : [UIFont fontWithName:@"TrebuchetMS" size:10],
                                           kYAxisLabelColorKey : [UIColor colorWithRed:0.48 green:0.48 blue:0.49 alpha:0.4],
                                           kYAxisLabelFontKey : [UIFont fontWithName:@"TrebuchetMS" size:10],
                                           kYAxisLabelSideMarginsKey : @20,
                                           kPlotBackgroundLineColorKye : [UIColor colorWithRed:0.48 green:0.48 blue:0.49 alpha:0.4]
                                           };
        _lineGraph.themeAttributes = _themeAttributes;
        _lineGraph.yAxisRange = @(98);
        _lineGraph.yAxisSuffix = @"K";
        _lineGraph.xAxisValues = @[
                                   @{ @1 : @"JAN" },
                                   @{ @2 : @"FEB" },
                                   @{ @3 : @"MAR" },
                                   @{ @4 : @"APR" },
                                   @{ @5 : @"MAY" },
                                   @{ @6 : @"JUN" },
                                   @{ @7 : @"JUL" },
                                   @{ @8 : @"AUG" },
                                   @{ @9 : @"SEP" },
                                   @{ @10 : @"OCT" },
                                   @{ @11 : @"NOV" },
                                   @{ @12 : @"DEC" }
                                   ];
        SHPlot *_plot1 = [[SHPlot alloc] init];
        _plot1.plottingValues = @[
                                  @{ @1 : @65.8 },
                                  @{ @2 : @20 },
                                  @{ @3 : @23 },
                                  @{ @4 : @22 },
                                  @{ @5 : @12.3 },
                                  @{ @6 : @45.8 },
                                  @{ @7 : @56 },
                                  @{ @8 : @97 },
                                  @{ @9 : @65 },
                                  @{ @10 : @10 },
                                  @{ @11 : @67 },
                                  @{ @12 : @23 }
                                  ];
        NSArray *arr = @[@"1", @"2", @"3", @"4", @"5", @"6" , @"7" , @"8", @"9", @"10", @"11", @"12"];
        _plot1.plottingPointsLabels = arr;
        
        NSDictionary *_plotThemeAttributes = @{
                                               kPlotFillColorKey : [UIColor colorWithRed:0.47 green:0.75 blue:0.78 alpha:0.5],
                                               kPlotStrokeWidthKey : @2,
                                               kPlotStrokeColorKey : [UIColor colorWithRed:0.18 green:0.36 blue:0.41 alpha:1],
                                               kPlotPointFillColorKey : [UIColor colorWithRed:0.18 green:0.36 blue:0.41 alpha:1],
                                               kPlotPointValueFontKey : [UIFont fontWithName:@"TrebuchetMS" size:18]
                                               };
        
        _plot1.plotThemeAttributes = _plotThemeAttributes;
        [_lineGraph addPlot:_plot1];
        [_lineGraph setupTheView];
        [cell.contentView addSubview:_lineGraph];
    }
    
    return cell;
}
#pragma mark- TableView delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (4 == indexPath.section)
    {
        return UI_View_Width;
    }
    if (1 == indexPath.section)
    {
        return 250;
    }
    return 200;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *) indexPath
{
    
}
@end
