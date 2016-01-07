//
//  SearchVC.m
//  Hema
//
//  Created by MsTail on 15/12/30.
//  Copyright © 2015年 Hemaapp. All rights reserved.
//

#import "SearchVC.h"
#import "SearchResultVC.h"
#import "SettingVC.h"
#import "RechargeVC.h"

@interface SearchVC () <UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate> {
    UITextField *_textField;
    UITableView *_tableView;
    NSMutableArray *_dataSource;
}

@end

@implementation SearchVC

- (void)viewWillAppear:(BOOL)animated {
    [self loadData];
}

- (void)loadSet {
    
    self.view.backgroundColor = RGB_UI_COLOR(255, 247, 249);
    //设置导航条搜索框
    self.navigationItem.leftBarButtonItem = nil;
    
    UIImageView *tfImg = [[UIImageView alloc] init];
    tfImg.frame = CGRectMake(0, 0, UI_View_Width - 100, 30);
    tfImg.image = [UIImage imageNamed:@"hp_textfield"];
    
    UIImageView *searchImg = [[UIImageView alloc] init];
    searchImg.frame = CGRectMake(5, 5, 20, 20);
    searchImg.image = [UIImage imageNamed:@"hp_search"];

    _textField = [[UITextField alloc] init];
    _textField.frame = CGRectMake(40, 7, UI_View_Width - 150, 20);
    _textField.backgroundColor = RGB_UI_COLOR(217, 29, 43);
    _textField.textColor = BB_White_Color;
    _textField.delegate = self;
    _textField.returnKeyType = UIReturnKeySearch;
    _textField.placeholder = @"请输入关键词";
    [_textField setValue:BB_White_Color forKeyPath:@"_placeholderLabel.textColor"];
    [_textField setValue:[UIFont systemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
    
    //搜索tableView
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, UI_View_Width, (44 * _dataSource.count) + 80) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_tableView];

    
    [tfImg addSubview:searchImg];
    [tfImg addSubview:_textField];
    
    UIBarButtonItem *searchItem = [[UIBarButtonItem alloc] initWithCustomView:tfImg];
    [self.navigationItem setLeftBarButtonItem:searchItem];
    
    //导航条取消按钮
    [self.navigationItem setRightItemWithTarget:self action:@selector(leftbtnPressed:) title:@"取消"];
    
}

- (void)loadData {
    
    _dataSource = [[NSMutableArray alloc] init];
    for (int i = 0; i < 100; i++) {
         if (![HemaFunction xfunc_check_strEmpty:[[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%d",i]]] ) {
        [_dataSource addObject:[[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%d",i]]];
         }
    }
    if (_dataSource.count > 0) {
        _tableView.hidden = NO;
         [_tableView reloadData];
        } else {
        _tableView.hidden = YES;
    }
    _tableView.frame = CGRectMake(0, 0, UI_View_Width, (44 * _dataSource.count) + 80);
   
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 50;
    }
    return 80;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = [[UIView alloc]init];
    headView.backgroundColor = [UIColor clearColor];
    return headView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footView = [[UIView alloc]init];
    footView.backgroundColor = [UIColor clearColor];
    return footView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
            NSLog(@"%zd",_dataSource.count);
            return _dataSource.count;      
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellId = @"searchCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    } else{
        while ([cell.contentView.subviews lastObject]!=nil) {
            [(UIView *)[cell.contentView.subviews lastObject]removeFromSuperview];
        }
    }
    
        if (indexPath.section == 0) {
            //名称
            UILabel *searchLbl = [[UILabel alloc] init];
            searchLbl.frame = CGRectMake(15, 15, UI_View_Width - 30, 20);
            searchLbl.textColor = RGB_UI_COLOR(157, 157, 157);
            searchLbl.tag = 1;
            
            [cell.contentView addSubview:searchLbl];
            
            //分割线
            UILabel *sepLbl = [[UILabel alloc] init];
            sepLbl.frame = CGRectMake(15, 49, UI_View_Width - 30, 1);
            sepLbl.backgroundColor = BB_Gray_Color;
            sepLbl.alpha = 0.3;
            
            [cell.contentView addSubview:sepLbl];
        }
        if (indexPath.section == 1) {
            //清空搜索记录
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.userInteractionEnabled = NO;
            UIButton *removeBtn = [[UIButton alloc] init];
            removeBtn.frame = CGRectMake(UI_View_Width / 2 - UI_View_Width / 4, 20, UI_View_Width / 2, 40) ; 
             [removeBtn setTitle:@"清空搜索记录" forState:UIControlStateNormal];
            removeBtn.layer.borderColor = RGB_UI_COLOR(150, 150, 150).CGColor;
            removeBtn.layer.borderWidth = 1;
            [removeBtn addTarget:self action:@selector(removeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [removeBtn setTitleColor:RGB_UI_COLOR(150, 150, 150) forState:UIControlStateNormal];
            [cell.contentView addSubview:removeBtn];
        }
    
    UILabel *searchLbl = (UILabel *)[cell viewWithTag:1];
    if (_dataSource.count > 0) {
    searchLbl.text = _dataSource[indexPath.row];
    } else {
    searchLbl.text = @"";
    }
    
    return cell;
}


//textfield代理事件
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    SearchResultVC *searchResultVC = [[SearchResultVC alloc] init];
    
    if ([HemaFunction xfunc_check_strEmpty:_textField.text]) {
        
    } else {
    for (int i = 0; i < 100; i ++) {
        if ([HemaFunction xfunc_check_strEmpty:[[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%d",i]]] ) {
            [[NSUserDefaults standardUserDefaults] setObject:_textField.text forKey:[NSString stringWithFormat:@"%d",i]];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [_textField resignFirstResponder];
            [self.navigationController pushViewController:searchResultVC animated:YES];
            goto loop;
            }
        }
    }
loop:
    return YES;
}


- (void)removeBtnClick:(UIButton *)sender {
    for (int i = 0; i < 100; i ++) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:[NSString stringWithFormat:@"%d",i]];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    _tableView.hidden = YES;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SearchResultVC *searchResultVC = [[SearchResultVC alloc] init];
    [self.navigationController pushViewController:searchResultVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
