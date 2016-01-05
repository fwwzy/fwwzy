//
//  MIneWritePlaceVC.m
//  Hema
//
//  Created by Lsy on 16/1/5.
//  Copyright © 2016年 Hemaapp. All rights reserved.
//

#import "MIneWritePlaceVC.h"
#import "AddressChoicePickerView.h"

@interface MIneWritePlaceVC ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>{
    UITableView *_tableView;
    UILabel *_addressLabel;
    NSMutableDictionary *_dataDic;
    NSString *_name;
    NSString *_phone;
    NSString *_place;
    UISwitch *_mySwitch;
    BOOL switchison;
}

@end

@implementation MIneWritePlaceVC

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
}

-(void)loadSet{
    [self.navigationItem setNewTitle:@"编辑收货地址"];
    
    _name = @"";
    _phone = @"";
    _place = @"";
    switchison = NO;
    //左按钮
    [self.navigationItem setLeftItemWithTarget:self action:@selector(leftbtnPressed:) image:@"lg_back"];
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, UI_View_Width, 250)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.scrollEnabled = NO;
    [self.view addSubview:_tableView];
    //背景色
    self.view.backgroundColor =[UIColor colorWithRed:252.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:0.8];
    //提交
    UIButton *finishBtn = [[UIButton alloc]initWithFrame:CGRectMake(30, 250+(UI_View_Height - 250 - 40)/2, UI_View_Width-60, 40)];
    finishBtn.backgroundColor = BB_Red_Color;
    [finishBtn setTitleColor:BB_White_Color forState:UIControlStateNormal];
    [finishBtn setTitle:@"提交" forState:UIControlStateNormal];
    finishBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [finishBtn addTarget:self action:@selector(finishBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:finishBtn];
}
#pragma mark - 代理
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = nil;
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"qqq"];
    }else{
        while ([cell.contentView.subviews lastObject]!=nil) {
            [(UIView *)[cell.contentView.subviews lastObject]removeFromSuperview];
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UILabel *titleLabel = [[UILabel alloc]init];
    if (indexPath.row == 0) {
        titleLabel.frame = CGRectMake(15, 15, 100, 20);
        titleLabel.text = @"收货人";
        titleLabel.textColor = BB_Gray_Color;
        titleLabel.font = [UIFont systemFontOfSize:17];
        
        _nameField = [[UITextField alloc]initWithFrame:CGRectMake(100, 15, 150, 20)];
        _nameField.delegate = self;
        _nameField.tag = 10000;
        _nameField.placeholder = @"请输入姓名";
        _nameField.text = _name;
        _nameField.font = [UIFont fontWithName:@"Arial" size:17.0f];
        [cell addSubview:_nameField];
    }
    if (indexPath.row == 1) {
        titleLabel.frame = CGRectMake(15, 15, 100, 20);
        titleLabel.text = @"联系方式";
        titleLabel.textColor = BB_Gray_Color;
        titleLabel.font = [UIFont systemFontOfSize:17];
        
        _phoneField = [[UITextField alloc]initWithFrame:CGRectMake(100, 15, 150, 20)];
        _phoneField.placeholder = @"请输入号码";
        _phoneField.font = [UIFont fontWithName:@"Arial" size:17.0f];
        _phoneField.keyboardType = UIKeyboardTypeNumberPad;
        _phoneField.tag = 10001;
        _phoneField.text = _phone;
        _phoneField.delegate = self;
        [cell addSubview:_phoneField];
    }
    if (indexPath.row == 2) {
        titleLabel.frame = CGRectMake(15, 15, 100, 20);
        titleLabel.text = @"地址";
        titleLabel.textColor = BB_Gray_Color;
        titleLabel.font = [UIFont systemFontOfSize:17];
        
        _addressLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 15, 200, 20)];
        _addressLabel.font = [UIFont systemFontOfSize:15];
        [cell addSubview:_addressLabel];
    }
    if (indexPath.row == 3) {
        titleLabel.frame = CGRectMake(15, 15, 100, 20);
        titleLabel.text = @"详细地址";
        titleLabel.textColor = BB_Gray_Color;
        titleLabel.font = [UIFont systemFontOfSize:17];
        
        _placeField = [[UITextField alloc]initWithFrame:CGRectMake(100, 15, 200, 20)];
        _placeField.placeholder = @"请输入地址";
        _placeField.font = [UIFont fontWithName:@"Arial" size:17.0f];
        _placeField.text = _place;
        _placeField.tag = 10002;
        _placeField.delegate = self;
        [cell addSubview:_placeField];
        
    }
    if (indexPath.row == 4) {
        titleLabel.frame = CGRectMake(15, 15, 100, 20);
        titleLabel.text = @"设置默认";
        titleLabel.textColor = BB_Gray_Color;
        titleLabel.font = [UIFont systemFontOfSize:17];
        
        _mySwitch = [[ UISwitch alloc]initWithFrame:CGRectMake(UI_View_Width - 70,10.0,0.0,0.0)];
        _mySwitch.tintColor = RGB_UI_COLOR(237, 88, 99);
        _mySwitch.onTintColor = RGB_UI_COLOR(237, 88, 99);
        _mySwitch.on = switchison;
        [cell addSubview:_mySwitch];
    }
    [cell addSubview:titleLabel];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 2) {
        AddressChoicePickerView *addressPickerView = [[AddressChoicePickerView alloc]init];
        addressPickerView.block = ^(AddressChoicePickerView *view,UIButton *btn,AreaObject *locate){
            _addressLabel.text = [NSString stringWithFormat:@"%@",locate];
            _addressLabel.textColor = [UIColor blackColor];
        };
        [addressPickerView show];
        if (_mySwitch.isOn) {
            switchison = YES;
        }else{
            switchison = NO;
        }
        [_tableView reloadData];
    }
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    
    if (textField.tag == 10001) {
        _phone = _phoneField.text;
        NSLog(@"%@",_phone);
    }
    if (textField.tag == 10000) {
        _name = _nameField.text;
        NSLog(@"%@",_name);
    }
    
    if (textField.tag == 10002) {
        _place = _placeField.text;
        NSLog(@"%@",_place);
    }
    
//    _dataDic = [[NSMutableDictionary alloc]init];
//    [_dataDic setObject:_nameField.text forKey:@"name"];
//    NSLog(@"%@",_dataDic);
    
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.tag == 10001) {
        if (textField.text.length > 11){
            return NO;
        }
    }
    
    return YES;
}
#pragma mark - 事件
-(void)finishBtnClick{
    _dataDic = [[NSMutableDictionary alloc]init];
    [_dataDic setObject:_name forKey:@"name"];
    [_dataDic setObject:_phone forKey:@"phone"];
    [_dataDic setObject:_place forKey:@"place"];
    [_dataDic setObject:_addressLabel.text forKey:@"address"];
    NSLog(@"%@",_addressLabel.text);
    if (_mySwitch.isOn) {
        [_dataDic setObject:@"1" forKey:@"switch"];
    }else{
        [_dataDic setObject:@"0" forKey:@"switch"];
    }
    self.blockDic(_dataDic);
    [self.navigationController popViewControllerAnimated:YES];
}
@end
