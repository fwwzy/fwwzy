//
//  RExpandFunctionVC.m
//  Hema
//
//  Created by geyang on 15/11/13.
//  Copyright © 2015年 Hemaapp. All rights reserved.
//

#import "RExpandFunctionVC.h"
#import "RViewExpandVC.h"

@interface RExpandFunctionVC ()
@property(nonatomic,strong)NSMutableArray *listArr;
@end

@implementation RExpandFunctionVC

-(void)loadSet
{
    [self.navigationItem setNewTitle:@"类库扩展模块"];
    [self.navigationItem setRightItemWithTarget:self action:@selector(rightbtnPressed:) image:@"R聊天右导航设置按钮.png"];
    [SystemFunction setTableSeparatorInset:self.mytable left:10];
    [self forbidPullRefresh];
}
-(void)loadData
{
    _listArr = [[NSMutableArray alloc]initWithObjects:
                @"UIView",@"UIImage",@"UIImageView",nil];
}
#pragma mark- 自定义
#pragma mark 事件
-(void)rightbtnPressed:(id)sender
{
    [SVProgressHUD showErrorWithStatus:@"请详细查阅类库扩展文件夹" maskType:SVProgressHUDMaskTypeBlack];
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
    labLeft.text = [_listArr objectAtIndex:indexPath.row];
    
    return cell;
}
#pragma mark- TableView delegate
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
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    RViewExpandVC *myVC = [[RViewExpandVC alloc]init];
    myVC.keytype = indexPath.row+1;
    [myVC.navigationItem setNewTitle:[_listArr objectAtIndex:indexPath.row]];
    [self.navigationController pushViewController:myVC animated:YES];
}
@end
