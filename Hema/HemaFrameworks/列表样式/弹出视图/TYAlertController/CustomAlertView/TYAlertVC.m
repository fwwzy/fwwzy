//
//  TYAlertVC.m
//  Hema
//
//  Created by LarryRodic on 15/11/8.
//  Copyright © 2015年 Hemaapp. All rights reserved.
//

#import "TYAlertVC.h"
#import "UIView+TYAlertView.h"
#import "TYAlertController+BlurEffects.h"
#import "SettingModelView.h"
#import "ShareView.h"

@interface TYAlertVC ()
@property(nonatomic,strong)NSMutableArray *listArr;
@end

@implementation TYAlertVC

-(void)loadSet
{
    [self.navigationItem setNewTitle:@"TY弹出视图"];
    [SystemFunction setTableSeparatorInset:self.mytable left:10];
    [self forbidPullRefresh];
}
-(void)loadData
{
    _listArr = [[NSMutableArray alloc]initWithObjects:
                @"TwoInput弹框",@"BlurEffect弹框",@"DropDown动画弹框",@"ActionSheet弹框",@"底部View弹框",@"AlertViewInWindow弹框",@"ViewInWindow弹框",nil];
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
    
    //TwoInput弹框
    if (0 == indexPath.row)
    {
        TYAlertView *alertView = [TYAlertView alertViewWithTitle:@"国家安全局" message:@"请验证您的身份"];
        
        [alertView addAction:[TYAlertAction actionWithTitle:@"取消" style:TYAlertActionStyleCancle handler:^(TYAlertAction *action)
        {
            NSLog(@"%@",action.title);
        }]];
        
        [alertView addAction:[TYAlertAction actionWithTitle:@"确定" style:TYAlertActionStyleDestructive handler:^(TYAlertAction *action)
        {
            NSLog(@"%@",action.title);
        }]];
        
        [alertView addTextFieldWithConfigurationHandler:^(UITextField *textField)
        {
            textField.placeholder = @"请输入账号";
        }];
        [alertView addTextFieldWithConfigurationHandler:^(UITextField *textField)
        {
            textField.placeholder = @"请输入密码";
        }];
        
        TYAlertController *alertController = [TYAlertController alertControllerWithAlertView:alertView preferredStyle:TYAlertControllerStyleAlert];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
    //BlurEffect弹框
    if (1 == indexPath.row)
    {
        ShareView *shareView = [ShareView createViewFromNib];
        TYAlertController *alertController = [TYAlertController alertControllerWithAlertView:shareView preferredStyle:TYAlertControllerStyleAlert];
        
        [alertController setBlurEffectWithView:self.view];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    //DropDown动画弹框
    if (2 == indexPath.row)
    {
        TYAlertView *alertView = [TYAlertView alertViewWithTitle:@"重要说明" message:@"请大家详细阅读“类库扩展”这个文件夹！"];
        
        [alertView addAction:[TYAlertAction actionWithTitle:@"确定" style:TYAlertActionStyleDefault handler:^(TYAlertAction *action)
        {
            NSLog(@"%@",action.title);
        }]];
        
        TYAlertController *alertController = [TYAlertController alertControllerWithAlertView:alertView preferredStyle:TYAlertControllerStyleAlert transitionAnimation:TYAlertTransitionAnimationDropDown];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    //ActionSheet弹框
    if (3 == indexPath.row)
    {
        TYAlertView *alertView = [TYAlertView alertViewWithTitle:@"请你选择" message:@"你确定你还爱着她么？"];
        
        [alertView addAction:[TYAlertAction actionWithTitle:@"确定" style:TYAlertActionStyleDefault handler:^(TYAlertAction *action)
        {
            NSLog(@"%@",action.title);
        }]];
        
        [alertView addAction:[TYAlertAction actionWithTitle:@"非常确定" style:TYAlertActionStyleDefault handler:^(TYAlertAction *action)
        {
            NSLog(@"%@",action.title);
        }]];
        
        [alertView addAction:[TYAlertAction actionWithTitle:@"删除记忆" style:TYAlertActionStyleDestructive handler:^(TYAlertAction *action)
        {
            NSLog(@"%@",action.title);
        }]];
        [alertView addAction:[TYAlertAction actionWithTitle:@"不想选择" style:TYAlertActionStyleCancle handler:^(TYAlertAction *action)
        {
            NSLog(@"%@",action.title);
        }]];
        
        TYAlertController *alertController = [TYAlertController alertControllerWithAlertView:alertView preferredStyle:TYAlertControllerStyleActionSheet];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    //底部View弹框
    if (4 == indexPath.row)
    {
        SettingModelView *settingModelView = [SettingModelView createViewFromNib];
        
        TYAlertController *alertController = [TYAlertController alertControllerWithAlertView:settingModelView preferredStyle:TYAlertControllerStyleActionSheet];
        alertController.backgoundTapDismissEnable = YES;
        [self presentViewController:alertController animated:YES completion:nil];
    }
    //AlertViewInWindow弹框
    if (5 == indexPath.row)
    {
        TYAlertView *alertView = [TYAlertView alertViewWithTitle:@"秋之为气也" message:@"萧瑟兮草木摇落而变衰"];
        [alertView addAction:[TYAlertAction actionWithTitle:@"取消" style:TYAlertActionStyleCancle handler:^(TYAlertAction *action)
        {
            
        }]];
        [alertView addAction:[TYAlertAction actionWithTitle:@"确定" style:TYAlertActionStyleDestructive handler:^(TYAlertAction *action)
        {
            
        }]];
        [alertView showInWindowWithOriginY:200 backgoundTapDismissEnable:YES];
    }
    //ViewInWindow弹框
    if (6 == indexPath.row)
    {
        ShareView *shareView = [ShareView createViewFromNib];
        [shareView showInWindow];
    }
}
@end
