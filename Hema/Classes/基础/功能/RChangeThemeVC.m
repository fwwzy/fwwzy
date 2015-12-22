//
//  RChangeThemeVC.m
//  Hema
//
//  Created by geyang on 15/11/4.
//  Copyright © 2015年 Hemaapp. All rights reserved.
//

#import "RChangeThemeVC.h"

@interface RChangeThemeVC ()
@property(nonatomic,strong)NSArray *arData;
@end

@implementation RChangeThemeVC

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:RELOADIMAGE object:nil];
}

-(void)loadSet
{
    [self.navigationItem setNewTitle:@"更换主题"];
    
    [self forbidPullRefresh];
    
    [self observerReloadImage:nil];
    
    //更换主题的通知，全局所做的话就放在AllVC里面进行操作，这儿只是个演示demo。
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(observerReloadImage:) name:RELOADIMAGE object:nil];
}
-(void)loadData
{
    _arData = @[@[@"默认", @"", @"theme_icon.png"],
                @[@"海洋", @"com.skin.1110", @"theme_icon_sea.png"],
                @[@"外星人", @"com.skin.1114", @"theme_icon_universe.png"],
                @[@"小黄鸭", @"com.skin.1108", @"theme_icon_yellowduck.png"],
                @[@"企鹅", @"com.skin.1098", @"theme_icon_penguin.png"]];
}
#pragma mark- 更换主题通知
- (void)observerReloadImage:(NSNotificationCenter *)notif
{
    UIImage *image = [QHCommonUtil imageNamed:@"header_bg.png"];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithPatternImage:image]];
}
#pragma mark- TableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
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
        cell.backgroundColor = [UIColor clearColor];
        
        HemaImgView *backImgView = [[HemaImgView alloc]init];
        [backImgView setFrame:CGRectMake((UI_View_Width-100)/2, 20, 100, 100)];
        [HemaFunction addbordertoView:backImgView radius:10 width:1.0 color:BB_Red_Color];
        backImgView.tag = 10;
        [cell.contentView addSubview:backImgView];
    }
    HemaImgView *backImgView = (HemaImgView*)[cell viewWithTag:10];
    [backImgView setImage:[UIImage imageNamed:[[_arData objectAtIndex:indexPath.row]objectAtIndex:2]]];
    
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
    return 120;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *) indexPath
{
    NSArray *ar = [_arData objectAtIndex:indexPath.row];
    [QHConfiguredObj defaultConfigure].nThemeIndex = (int)indexPath.row;
    [QHConfiguredObj defaultConfigure].themefold = [ar objectAtIndex:1];
    
    if ([ar objectAtIndex:1] != nil && ((NSString *)[ar objectAtIndex:1]).length > 0)
        [QHCommonUtil unzipFileToDocument:[ar objectAtIndex:1]];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:RELOADIMAGE object:nil];
}
@end
