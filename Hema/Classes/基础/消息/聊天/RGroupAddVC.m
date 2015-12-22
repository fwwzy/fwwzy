//
//  RGroupAddVC.m
//  Hema
//
//  Created by LarryRodic on 15/10/11.
//  Copyright (c) 2015年 Hemaapp. All rights reserved.
//

#import "RGroupAddVC.h"

@interface RGroupAddVC ()
@property(nonatomic,strong)NSMutableArray *dataSource;
@end

@implementation RGroupAddVC
@synthesize dataSource;
@synthesize delegate;
@synthesize dataHave;

-(void)loadSet
{
    [self.navigationItem setNewTitle:@"添加成员"];
    [self.mytable setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 0)];
    [self forbidPullRefresh];
}
-(void)loadData
{
    [self requestTypeList];
}
#pragma mark- 自定义
#pragma mark 事件
-(void)rightbtnPressed:(id)sender
{
    NSMutableArray *temArr = [[NSMutableArray alloc]init];
    
    for (int i = 0; i<dataSource.count; i++)
    {
        if ([[[dataSource objectAtIndex:i] objectForKey:@"isall"]integerValue] == 1)
        {
            NSMutableDictionary *dict = [SystemFunction getDicFromDic:[dataSource objectAtIndex:i]];
            [temArr addObject:dict];
        }
    }
    if (temArr.count == 0)
    {
        [HemaFunction openIntervalHUD:@"还未选择"];
        return;
    }else
    {
        [delegate RGroupAddOK:temArr];
        [self leftbtnPressed:nil];
    }
}
#pragma mark - UITableView dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"all";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.backgroundColor = BB_White_Color;
        
        //左侧
        UILabel *labLeft = [[UILabel alloc]init];
        labLeft.backgroundColor = [UIColor clearColor];
        labLeft.textAlignment = NSTextAlignmentLeft;
        labLeft.font = [UIFont systemFontOfSize:15];
        [labLeft setTextColor:BB_Blake_Color];
        labLeft.frame = CGRectMake(15, 0, UI_View_Width-70, 48);
        labLeft.tag = 11;
        [cell.contentView addSubview:labLeft];
        
        //右侧按钮
        UIImageView *rightImgView = [[UIImageView alloc]init];
        [rightImgView setFrame:CGRectMake(UI_View_Width-43, 14, 20, 20)];
        rightImgView.tag = 12;
        [cell.contentView addSubview:rightImgView];
    }
    NSMutableDictionary *temDic = [dataSource objectAtIndex:indexPath.row];
    
    UILabel *labLeft = (UILabel*)[cell viewWithTag:11];
    [labLeft setText:[temDic objectForKey:@"nickname"]];
    
    //右侧按钮
    UIImageView *rightImgView = (UIImageView*)[cell viewWithTag:12];
    
    if ([[temDic objectForKey:@"isall"]integerValue] == 1)
    {
        [rightImgView setImage:[UIImage imageNamed:@"R蓝色对勾选中.png"]];
    }else
    {
        [rightImgView setImage:[UIImage imageNamed:@"R对勾未选中.png"]];
    }
    
    return cell;
}
#pragma mark - Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 48;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *) indexPath
{
    NSMutableDictionary *temDic = [dataSource objectAtIndex:indexPath.row];
    if ([[temDic objectForKey:@"isall"]integerValue] == 1)
    {
        [temDic setObject:@"0" forKey:@"isall"];
        [self.mytable reloadData];
        return;
    }else
    {
        [temDic setObject:@"1" forKey:@"isall"];
        [self.mytable reloadData];
        return;
    }
}
#pragma mark - 连接服务器
#pragma mark 好友列表
- (void)requestTypeList
{
    NSString *token = [[HemaManager sharedManager] userToken];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:token forKey:@"token"];
    [dic setObject:@"5" forKey:@"keytype"];
    [dic setObject:@"0" forKey:@"keyid"];
    [dic setObject:@"0" forKey:@"page"];
    
    [HemaRequest requestWithURL:[NSString stringWithFormat:@"%@%@",REQUEST_MAINLINK,REQUEST_CLIENT_LIST] target:self selector:@selector(responseTypeList:) parameter:dic];
}
- (void)responseTypeList:(NSDictionary*)info
{
    if(1 == [[info objectForKey:@"success"] intValue])
    {
        if(![HemaFunction xfunc_check_strEmpty:[[info objectForKey:@"infor"]objectForKey:@"listItems"]])
        {
            if (!dataSource)
                dataSource = [[NSMutableArray alloc]init];
            [dataSource removeAllObjects];
            
            NSMutableArray *temArr = [[info objectForKey:@"infor"]objectForKey:@"listItems"];
            
            for (int i = 0; i<temArr.count; i++)
            {
                NSMutableDictionary *dict = [SystemFunction getDicFromDic:[temArr objectAtIndex:i]];
                [dict setObject:@"0" forKey:@"isall"];
                
                //匹配 把已存在的删除掉
                BOOL isHave = NO;
                for (int y = 0; y<dataHave.count; y++)
                {
                    NSMutableDictionary *myDic = [dataHave objectAtIndex:y];
                    if ([[myDic objectForKey:@"client_id"]isEqualToString:[dict objectForKey:@"client_id"]])
                    {
                        isHave = YES;
                        break;
                    }
                }
                if (!isHave)
                {
                    [dataSource addObject:dict];
                }
            }
            if (0 != dataSource.count)
            {
                [self.navigationItem setRightItemWithTarget:self action:@selector(rightbtnPressed:) title:@"完成"];
            }
            [self reShowView];
        }
    }else
    {
        [HemaFunction openIntervalHUD:[info objectForKey:@"msg"]];
    }
}
#pragma mark 加载刷新
//刷新页面
-(void)reShowView
{
    if(0 == dataSource.count)
    {
        [self showNoDataView:@"暂无可添加成员"];
    }else
    {
        [self hideNoDataView];
    }
    [self.mytable reloadData];
}
@end
