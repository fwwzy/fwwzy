//
//  REditCardVC.m
//  Hema
//
//  Created by LarryRodic on 15/10/8.
//  Copyright (c) 2015年 Hemaapp. All rights reserved.
//

#import "REditCardVC.h"
#import "HemaEditorVC.h"

@interface REditCardVC ()<HemaEditorDelegate>
@property(nonatomic,strong)NSMutableArray *dataBank;//银行列表
@end

@implementation REditCardVC
@synthesize dataSource;
@synthesize dataBank;

-(void)loadSet
{
    [self.navigationItem setNewTitle:@"编辑银行卡"];
    [self.navigationItem setRightItemWithTarget:self action:@selector(rightbtnPressed:) title:@"保存"];
    
    [SystemFunction setTableSeparatorInset:self.mytable left:10];
    [self forbidPullRefresh];
}
-(void)loadData
{
    if (!dataSource)
        dataSource = [[NSMutableDictionary alloc]init];
    [self requestGetBankList];
}
#pragma mark- 自定义
#pragma mark 事件
-(void)rightbtnPressed:(id)sender
{
    if ([HemaFunction xfunc_check_strEmpty:[dataSource objectForKey:@"bankname"]])
    {
        [HemaFunction openIntervalHUD:@"请选择银行"];
        return;
    }
    if ([HemaFunction xfunc_check_strEmpty:[dataSource objectForKey:@"bankuser"]])
    {
        [HemaFunction openIntervalHUD:@"请填写户主名称"];
        return;
    }
    if ([HemaFunction xfunc_check_strEmpty:[dataSource objectForKey:@"bankcard"]])
    {
        [HemaFunction openIntervalHUD:@"请填写银行卡号"];
        return;
    }
    if ([HemaFunction xfunc_check_strEmpty:[dataSource objectForKey:@"bankaddress"]])
    {
        [HemaFunction openIntervalHUD:@"请填写开户行"];
        return;
    }
    [self requestSaveClient];
}
#pragma mark- HemaEditorDelegate
-(void)HemaEditorOK:(HemaEditorVC*)editor backValue:(NSString*)value
{
    if(editor.key)
    {
        if(!value)
            value = @"";
        [dataSource setObject:value forKey:editor.key];
        [self.mytable reloadData];
    }
}
#pragma mark- TableView DataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"BWMyInforCell";
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
        labLeft.textColor = BB_Blake_Color;
        labLeft.frame = CGRectMake(10, 0, 80, 50);
        labLeft.tag = 10;
        [cell.contentView addSubview:labLeft];
        
        //右侧
        UILabel *labRight = [[UILabel alloc]init];
        labRight.backgroundColor = [UIColor clearColor];
        labRight.textAlignment = NSTextAlignmentRight;
        labRight.textColor = BB_Gray_Color;
        labRight.font = [UIFont systemFontOfSize:15];
        labRight.frame = CGRectMake(100, 0, UI_View_Width-130, 50);
        labRight.tag = 11;
        [cell.contentView addSubview:labRight];
        
        UIImageView *arrowImgView = [[UIImageView alloc]init];
        [arrowImgView setImage:[UIImage imageNamed:@"R右侧蓝色箭头.png"]];
        [arrowImgView setFrame:CGRectMake(UI_View_Width-25, 16.5, 11, 17)];
        arrowImgView.tag = 13;
        [cell.contentView addSubview:arrowImgView];
    }
    NSMutableArray *temArr = [[NSMutableArray alloc]initWithObjects:@"选择银行：",@"户主姓名：",@"银行卡号：",@"开户行：",nil];
    
    UILabel *labLeft = (UILabel*)[cell viewWithTag:10];
    labLeft.text = [temArr objectAtIndex:indexPath.row];
    
    UILabel *labRight = (UILabel*)[cell viewWithTag:11];
    
    if (0 == indexPath.row)
    {
        [labRight setText:[dataSource objectForKey:@"bankname"]];
    }
    if (1 == indexPath.row)
    {
        [labRight setText:[dataSource objectForKey:@"bankuser"]];
    }
    if (2 == indexPath.row)
    {
        [labRight setText:[dataSource objectForKey:@"bankcard"]];
    }
    if (3 == indexPath.row)
    {
        [labRight setText:[dataSource objectForKey:@"bankaddress"]];
    }
    
    return cell;
}
#pragma mark- TableView Delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *) indexPath
{
    if (0 == indexPath.row)
    {
        HemaEditorVC *editor = [[HemaEditorVC alloc]init];
        editor.editorType = EditorTypeNormalPick;
        editor.key = @"bankname";
        editor.title = @"选择银行";
        if ([HemaFunction xfunc_check_strEmpty:[dataSource objectForKey:@"bankname"]])
        {
            editor.content = @"中国工商银行";
        }else
        {
            editor.content = [dataSource objectForKey:@"bankname"];
        }
        editor.explanation = @"";
        editor.mymaxlength = 8;
        editor.keyBoardType = UIKeyboardTypeDefault;
        editor.dataSource = [[NSMutableArray alloc]init];
        for (int i = 0; i<dataBank.count; i++)
        {
            [editor.dataSource addObject:[[dataBank objectAtIndex:i] objectForKey:@"name"]];
        }
        editor.delegate = self;
        [self.navigationController pushViewController:editor animated:YES];
    }
    if (1 == indexPath.row)
    {
        HemaEditorVC *editor = [[HemaEditorVC alloc]init];
        editor.editorType = EditorTypeSinleInput;
        editor.key = @"bankuser";
        editor.title = @"户主姓名";
        editor.content = [dataSource objectForKey:@"bankuser"];
        editor.explanation = @"";
        editor.mymaxlength = 100;
        editor.keyBoardType = UIKeyboardTypeDefault;
        editor.delegate = self;
        [self.navigationController pushViewController:editor animated:YES];
    }
    if (2 == indexPath.row)
    {
        HemaEditorVC *editor = [[HemaEditorVC alloc]init];
        editor.editorType = EditorTypeSinleInput;
        editor.key = @"bankcard";
        editor.title = @"银行卡号";
        editor.content = [dataSource objectForKey:@"bankcard"];
        editor.explanation = @"";
        editor.mymaxlength = 30;
        editor.keyBoardType = UIKeyboardTypePhonePad;
        editor.delegate = self;
        [self.navigationController pushViewController:editor animated:YES];
    }
    if (3 == indexPath.row)
    {
        HemaEditorVC *editor = [[HemaEditorVC alloc]init];
        editor.editorType = EditorTypeSinleInput;
        editor.key = @"bankaddress";
        editor.title = @"开户行";
        editor.content = [dataSource objectForKey:@"bankaddress"];
        editor.explanation = @"";
        editor.mymaxlength = 50;
        editor.keyBoardType = UIKeyboardTypeDefault;
        editor.delegate = self;
        [self.navigationController pushViewController:editor animated:YES];
    }
}
#pragma mark - 连接服务器
#pragma mark 保存银行卡信息
- (void)requestSaveClient
{
    NSString *token = [[HemaManager sharedManager] userToken];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:token forKey:@"token"];
    [dic setObject:[dataSource objectForKey:@"bankuser"] forKey:@"bankuser"];
    [dic setObject:[dataSource objectForKey:@"bankname"] forKey:@"bankname"];
    [dic setObject:[dataSource objectForKey:@"bankcard"] forKey:@"bankcard"];
    [dic setObject:[dataSource objectForKey:@"bankaddress"] forKey:@"bankaddress"];
    
    [HemaRequest requestWithURL:[NSString stringWithFormat:@"%@%@",REQUEST_MAINLINK,REQUEST_BANK_SAVE] target:self selector:@selector(responseSaveClient:) parameter:dic];
}
- (void)responseSaveClient:(NSDictionary*)info
{
    if(1 == [[info objectForKey:@"success"] intValue])
    {
        [HemaFunction openIntervalHUDOK:@"已保存成功"];
        [self.navigationController popViewControllerAnimated:YES];
    }else
    {
        [HemaFunction openIntervalHUD:[info objectForKey:@"msg"]];
    }
}
#pragma mark 获得银行列表
- (void)requestGetBankList
{
    NSString *token = [[HemaManager sharedManager] userToken];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:token forKey:@"token"];
    [dic setObject:@"0" forKey:@"page"];
    
    [HemaRequest requestWithURL:[NSString stringWithFormat:@"%@%@",REQUEST_MAINLINK,REQUEST_BANK_LIST] target:self selector:@selector(responseGetBankList:) parameter:dic];
}
- (void)responseGetBankList:(NSDictionary*)info
{
    if(1 == [[info objectForKey:@"success"] intValue])
    {
        if(![HemaFunction xfunc_check_strEmpty:[[info objectForKey:@"infor"]objectForKey:@"listItems"]])
        {
            if (!dataBank)
                dataBank = [[NSMutableArray alloc]init];
            [dataBank removeAllObjects];
            
            NSMutableArray *temArr = [[info objectForKey:@"infor"]objectForKey:@"listItems"];
            
            for (int i = 0; i<temArr.count; i++)
            {
                [dataBank addObject:[temArr objectAtIndex:i]];
            }
            
            [self.mytable reloadData];
        }
    }else
    {
        [HemaFunction openIntervalHUD:[info objectForKey:@"msg"]];
    }
}
@end
