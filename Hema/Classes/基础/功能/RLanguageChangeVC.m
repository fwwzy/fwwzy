//
//  RLanguageChangeVC.m
//  Hema
//
//  Created by geyang on 15/10/22.
//  Copyright © 2015年 Hemaapp. All rights reserved.
//

#import "RLanguageChangeVC.h"

@interface RLanguageChangeVC ()
@property(nonatomic,strong)NSMutableArray *listArr;
@end

@implementation RLanguageChangeVC

-(void)loadSet
{
    [self.navigationItem setNewTitle:LOCALIZATION(@"多语言切换")];
    [SystemFunction setTableSeparatorInset:self.mytable left:10];
    [self forbidPullRefresh];
}
-(void)loadData
{
    _listArr = [[NSMutableArray alloc]initWithObjects:
                @"zh-Hans",@"en",@"fr",nil];
}
#pragma mark- 自定义
#pragma mark 事件

#pragma mark 方法
//配置多语言
-(void)configureViewFromLocalisation
{
    [self.navigationItem setNewTitle:LOCALIZATION(@"多语言切换")];
    [self.mytable reloadData];
}
#pragma mark- TableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _listArr.count;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"all";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.backgroundColor = BB_White_Color;
        
        //左侧
        UILabel *labLeft = [[UILabel alloc]init];
        labLeft.backgroundColor = [UIColor clearColor];
        labLeft.textAlignment = NSTextAlignmentLeft;
        labLeft.font = [UIFont systemFontOfSize:15];
        labLeft.tag = 10;
        labLeft.frame = CGRectMake(10, 0, UI_View_Width-50, 55);
        labLeft.textColor = BB_Blake_Color;
        [cell.contentView addSubview:labLeft];
    }
    UILabel *labLeft = (UILabel*)[cell viewWithTag:10];
    labLeft.text = LOCALIZATION([_listArr objectAtIndex:indexPath.row]);
    
    return cell;
}
#pragma mark - Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 7;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *) indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([[Localisator sharedInstance] setLanguage:[_listArr objectAtIndex:indexPath.row]])
    {
        
    }
}
@end
