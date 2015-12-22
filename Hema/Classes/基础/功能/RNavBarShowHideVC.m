//
//  RNavBarShowHideVC.m
//  Hema
//
//  Created by geyang on 15/11/3.
//  Copyright © 2015年 Hemaapp. All rights reserved.
//
#define NAVBAR_CHANGE_POINT 50

#import "RNavBarShowHideVC.h"

@interface RNavBarShowHideVC ()

@end

@implementation RNavBarShowHideVC
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self scrollViewDidScroll:self.mytable];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController.navigationBar lt_reset];
    [self.navigationController.navigationBar setTranslucent:NO];
    [super viewWillDisappear:animated];
}
-(void)loadSet
{
    [self.navigationItem setNewTitle:@"导航隐藏与显示"];
    
    [SystemFunction setTableSeparatorInset:self.mytable left:10];
    
    [self forbidPullRefresh];
    [self reSetTableViewFrame:CGRectMake(0, -64, UI_View_Width, UI_View_Height+64*2)];
    
    self.edgesForExtendedLayout= UIRectEdgeAll;
    [self.navigationController.navigationBar setTranslucent:YES];
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor clearColor]];
}
-(void)loadData
{
    
}
#pragma mark- UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    UIColor * color = BB_Red_Color;
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY > NAVBAR_CHANGE_POINT)
    {
        CGFloat alpha = MIN(1, 1 - ((NAVBAR_CHANGE_POINT + 64 - offsetY) / 64));
        [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:alpha]];
    }else
    {
        [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:0]];
    }
}
#pragma mark- TableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
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
        
        HemaImgView *backImgView = [[HemaImgView alloc]init];
        [backImgView setFrame:CGRectMake(0, 0, UI_View_Width, UI_View_Width*254/320)];
        [backImgView setImage:[UIImage imageNamed:@"R绝对大图片.jpg"]];
        [cell.contentView addSubview:backImgView];
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
    return 0.1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UI_View_Width*254/320;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *) indexPath
{
    
}
@end
