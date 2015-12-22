//
//  RGetFontListVC.m
//  Hema
//
//  Created by geyang on 15/11/18.
//  Copyright © 2015年 Hemaapp. All rights reserved.
//

#import "RGetFontListVC.h"

@interface RGetFontListVC ()
@property(nonatomic,strong)NSMutableArray *listArr;
@end

@implementation RGetFontListVC

-(void)loadSet
{
    //导航
    [self.navigationItem setNewTitle:@"改变字体"];
    [self.navigationItem setLeftItemWithTarget:self action:@selector(leftbtnPressed:) image:BackImgName];
    
    [self forbidPullRefresh];
    [SystemFunction setTableSeparatorInset:self.mytable left:10];
}
-(void)loadData
{
    _listArr = [NSMutableArray arrayWithArray:[[UIFont familyNames] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2)
                {
                    return [obj1 compare:obj2];
                }]];
}
#pragma mark- 自定义
#pragma mark 事件
-(void)leftbtnPressed:(id)sender
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark 方法
//获取每个section的字体数组
-(NSArray *)fontNamesOfSection:(NSInteger)section
{
    NSString *familyName = [_listArr objectAtIndex:(section)];
    NSArray *ret = [UIFont fontNamesForFamilyName:familyName];
    
    return ret;
}
//获取每个字体的名字
-(NSString *)fontNameOfIndexPath:(NSIndexPath *)indexPath
{
    NSArray *arr = [self fontNamesOfSection:indexPath.section];
    if (arr && indexPath.row < arr.count)
    {
        return [arr objectAtIndex:indexPath.row];
    }else
    {
        return nil;
    }
}
#pragma mark- TableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _listArr.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self fontNamesOfSection:section] count];
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"all";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.backgroundColor = BB_White_Color;
    }
    NSString *fontName = [self fontNameOfIndexPath:indexPath];
    cell.textLabel.text = @"字体样式---CocoaChina Here";
    cell.textLabel.font = [UIFont fontWithName:fontName size:15];
    cell.detailTextLabel.text = fontName;
    
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = [[UIView alloc]init];
    headView.backgroundColor = [UIColor clearColor];
    
    UILabel *lblBiaoti = [[UILabel alloc]init];
    lblBiaoti.backgroundColor = [UIColor clearColor];
    lblBiaoti.textAlignment = NSTextAlignmentLeft;
    lblBiaoti.font = [UIFont systemFontOfSize:15];
    lblBiaoti.textColor = [UIColor blackColor];
    lblBiaoti.frame = CGRectMake(10, 0, UI_View_Width-20, 33);
    lblBiaoti.text = [_listArr objectAtIndex:section];
    [headView addSubview:lblBiaoti];
    
    return headView;
}
#pragma mark- TableView delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 33;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *fontName = [_listArr objectAtIndex:indexPath.section];
    if (fontName && [fontName isEqualToString:@"Zapfino"])
    {
        return 80;
    }
    return 50;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *) indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (_fontSuccessBlock)
    {
        NSString *fontName = [self fontNameOfIndexPath:indexPath];
        
        if (![HemaFunction xfunc_check_strEmpty:fontName])
        {
            [self leftbtnPressed:nil];
            _fontSuccessBlock(YES, fontName);
        }
    }
}
@end
