//
//  RGroupListVC.m
//  Hema
//
//  Created by LarryRodic on 15/10/11.
//  Copyright (c) 2015年 Hemaapp. All rights reserved.
//

#import "RGroupListVC.h"
#import "HemaEditorVC.h"
#import "RMyChatVC.h"

@interface RGroupListVC ()<HemaEditorDelegate>
@property(nonatomic,strong)NSMutableArray *dataSource;
@end

@implementation RGroupListVC
@synthesize dataSource;

-(void)loadSet
{
    [self.navigationItem setNewTitle:@"群组"];
    [self.navigationItem setRightItemWithTarget:self action:@selector(rightbtnPressed:) title:@"发起"];
    
    [self.mytable setSeparatorInset:UIEdgeInsetsMake(0, 69, 0, 0)];
}
-(void)loadData
{
    [self refresh];
}
#pragma mark- 自定义
#pragma mark 事件
-(void)rightbtnPressed:(id)sender
{
    HemaEditorVC *editor = [[HemaEditorVC alloc]init];
    editor.editorType = EditorTypeSinleInput;
    editor.key = @"name";
    editor.title = @"发起群组";
    editor.mymaxlength = 8;
    editor.content = @"";
    editor.explanation = @"群组名称不得超过八个字";
    editor.keyBoardType = UIKeyboardTypeDefault;
    editor.delegate = self;
    [self.navigationController pushViewController:editor animated:YES];
}

#pragma mark- HemaEditorDelegate
-(void)HemaEditorOK:(HemaEditorVC*)editor backValue:(NSString*)value
{
    if(editor.key)
    {
        if(!value)
            value = @"";
        if ([HemaFunction xfunc_check_strEmpty:value])
        {
            [HemaFunction openIntervalHUD:@"群组名称不能为空"];
            return;
        }
        //保存群组
        [self requestCreateGroup:value];
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
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.backgroundColor = BB_White_Color;
        
        UIImageView *picImgView = [[UIImageView alloc]init];
        [picImgView setFrame:CGRectMake(10, 15, 45, 45)];
        picImgView.image = [UIImage imageNamed:@"R群组logo.png"];
        [cell.contentView addSubview:picImgView];
        
        //标题
        UILabel *labOne = [[UILabel alloc]init];
        labOne.backgroundColor = [UIColor clearColor];
        labOne.textAlignment = NSTextAlignmentLeft;
        labOne.font = [UIFont systemFontOfSize:15];
        labOne.textColor = BB_Blake_Color;
        labOne.tag = 9;
        labOne.frame = CGRectMake(69, 0, UI_View_Width-99, 75);
        [cell.contentView addSubview:labOne];
        
        UIImageView *arrowImgView = [[UIImageView alloc]init];
        [arrowImgView setImage:[UIImage imageNamed:@"R右侧蓝色箭头.png"]];
        [arrowImgView setFrame:CGRectMake(UI_View_Width-25, 29, 11, 17)];
        arrowImgView.tag = 13;
        [cell.contentView addSubview:arrowImgView];
    }
    NSMutableDictionary *temDic = [dataSource objectAtIndex:indexPath.row];
    
    UILabel *labOne = (UILabel*)[cell viewWithTag:9];
    [labOne setText:[temDic objectForKey:@"name"]];
    
    return cell;
}
#pragma mark - Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 8;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *) indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    NSMutableDictionary *temDic = [dataSource objectAtIndex:indexPath.row];
    
    RMyChatVC *chatVC = [[RMyChatVC alloc]initWithChatter:[temDic objectForKey:@"group_id"]];
    chatVC.isChatGroup = YES;
    chatVC.dataSource = [[NSMutableDictionary alloc]initWithObjectsAndKeys:[temDic objectForKey:@"group_id"],@"id",[temDic objectForKey:@"name"],@"name",nil];
    [self.navigationController pushViewController:chatVC animated:YES];
}
#pragma mark - 连接服务器
#pragma mark 创建群组
- (void)requestCreateGroup:(NSString*)name
{
    NSString *token = [[HemaManager sharedManager] userToken];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:token forKey:@"token"];
    [dic setObject:name forKey:@"name"];
    
    waitMB = [HemaFunction openHUD:@"正在创建"];
    
    [HemaRequest requestWithURL:[NSString stringWithFormat:@"%@%@",REQUEST_MAINLINK,REQUEST_GROUP_ADD] target:self selector:@selector(responseCreateGroup:) parameter:dic];
}
- (void)responseCreateGroup:(NSDictionary*)info
{
    [HemaFunction closeHUD:waitMB];
    if(1 == [[info objectForKey:@"success"] intValue])
    {
        [self refresh];
    }else
    {
        [HemaFunction openIntervalHUD:[info objectForKey:@"msg"]];
    }
}
#pragma mark 列表
- (void)requestChapterList
{
    NSString *token = [[HemaManager sharedManager] userToken];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:token forKey:@"token"];
    [dic setObject:[NSString stringWithFormat:@"%d",(int)currentPage] forKey:@"page"];
    
    [HemaRequest requestWithURL:[NSString stringWithFormat:@"%@%@",REQUEST_MAINLINK,REQUEST_GROUP_LIST] target:self selector:@selector(responseChapterList:) parameter:dic];
}
- (void)responseChapterList:(NSDictionary*)info
{
    if(1 == [[info objectForKey:@"success"] intValue])
    {
        if (!dataSource)
            dataSource = [[NSMutableArray alloc]init];
        if(0 == currentPage)
            [dataSource removeAllObjects];
        
        NSString *val=[[info objectForKey:@"infor"]objectForKey:@"listItems"];
        if ([HemaFunction xfunc_check_strEmpty:val])
        {
            [self forbidAddMore];
            isEnd = YES;
            if(isMore)
                [self getNoMoreData];
        }else
        {
            NSArray *temArr = [[info objectForKey:@"infor"]objectForKey:@"listItems"];
            if ([temArr count] == 0)
            {
                [self forbidAddMore];
                isEnd = YES;
                if(isMore)
                    [self getNoMoreData];
            }else
            {
                if (temArr.count < 20)
                {
                    [self forbidAddMore];
                }else
                {
                    [self canAddMore];
                }
                for (int i = 0; i<temArr.count; i++)
                {
                    NSMutableDictionary *dict = [SystemFunction getDicFromDic:[temArr objectAtIndex:i]];
                    [dataSource addObject:dict];
                }
            }
        }
    }else
    {
        [HemaFunction openIntervalHUD:[info objectForKey:@"msg"]];
    }
    [self reShowView];
    
    if(isMore)
    {
        [self stopAddMore];
    }
    if(isLoading)
    {
        [self stopLoading];
    }
}
#pragma mark 加载刷新
//刷新页面
-(void)reShowView
{
    if(0 == dataSource.count)
    {
        [self showNoDataView:@"暂无群组"];
    }else
    {
        [self hideNoDataView];
    }
    [self.mytable reloadData];
}
//继承的方法
- (void)refresh
{
    currentPage = 0;
    isEnd = NO;
    [self requestChapterList];
}
-(void)addMore
{
    if (!isEnd)
    {
        currentPage++;
    }
    [self requestChapterList];
}
@end
