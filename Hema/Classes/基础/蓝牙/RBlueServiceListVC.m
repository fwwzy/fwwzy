//
//  RBlueServiceListVC.m
//  Hema
//
//  Created by geyang on 15/10/22.
//  Copyright © 2015年 Hemaapp. All rights reserved.
//

#import "RBlueServiceListVC.h"
#import "RBlueCharacterListVC.h"

@interface RBlueServiceListVC ()<CBPeripheralDelegate>
@property(nonatomic,strong)CBService *service;
@end

@implementation RBlueServiceListVC
@synthesize dataSource;

-(void)loadSet
{
    [self.navigationItem setNewTitle:@"设备服务"];
    [SystemFunction setTableSeparatorInset:self.mytable left:10];
    [self forbidPullRefresh];
    
    _peripheral.delegate = self;
}
-(void)loadData
{
    if (!dataSource)
        dataSource = [[NSMutableArray alloc]init];
}
#pragma mark- CBPeripheralDelegate
-(void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    NSLog(@"获取特征:%@",service.characteristics);
    
    RBlueCharacterListVC *myVC = [[RBlueCharacterListVC alloc]init];
    myVC.peripheral = _peripheral;
    myVC.dataSource = [[NSMutableArray alloc]init];
    for (CBCharacteristic *characteristic in service.characteristics)
    {
        [myVC.dataSource addObject:characteristic];
    }
    [self.navigationController pushViewController:myVC animated:YES];
}
#pragma mark- TableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataSource.count;
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
    CBService *service = [dataSource objectAtIndex:indexPath.row];
    
    UILabel *labLeft = (UILabel*)[cell viewWithTag:10];
    labLeft.text = [NSString stringWithFormat:@"服务编码：%@",service.UUID.description];
    
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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    _service = [dataSource objectAtIndex:indexPath.row];
    [_peripheral discoverCharacteristics:nil forService:_service];
}
@end
