//
//  RLanguageChangeVC.m
//  Hema
//
//  Created by geyang on 15/10/22.
//  Copyright © 2015年 Hemaapp. All rights reserved.
//

#import "RBlueDeviceListVC.h"
#import "RBlueServiceListVC.h"

@interface RBlueDeviceListVC ()<CBCentralManagerDelegate,CBPeripheralDelegate>
@property(nonatomic,strong)NSMutableArray *dataSource;
@property(nonatomic,strong)CBCentralManager *manager;//蓝牙管理器
@property(nonatomic,strong)CBPeripheral *peripheral;
@end

@implementation RBlueDeviceListVC
@synthesize dataSource;

-(void)loadSet
{
    [self.navigationItem setNewTitle:@"蓝牙设备"];
    [SystemFunction setTableSeparatorInset:self.mytable left:10];
    [self forbidPullRefresh];
    
    [self.navigationItem setRightItemWithTarget:self action:@selector(rightbtnPressed:) title:@"搜索"];
    
    _manager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
}
-(void)loadData
{
    dataSource = [[NSMutableArray alloc]init];
}
#pragma mark- 自定义
#pragma mark 事件
//重新搜索设备
-(void)rightbtnPressed:(id)sender
{
    if(_manager.state != 5)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"请打开手机蓝牙" delegate:nil cancelButtonTitle:@"好" otherButtonTitles: nil];
        [alert show];
        return;
    }
    [dataSource removeAllObjects];
    [self.mytable reloadData];
    
    [_manager stopScan];
    if (_peripheral)
    {
        [_manager cancelPeripheralConnection:_peripheral];
    }
    [_manager scanForPeripheralsWithServices:nil options:nil];
}
#pragma mark 方法

#pragma mark- CBCentralManagerDelegate
- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    NSLog(@"蓝牙状态：%d",(int)central.state);
    [self rightbtnPressed:nil];
}
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    NSLog(@"发现的外围设备:%@", peripheral);
    NSLog(@"设备信息:%@", advertisementData);
    
    BOOL isHave = NO;
    for (int i = 0; i<dataSource.count; i++)
    {
        NSMutableDictionary *myDic = [dataSource objectAtIndex:i];
        if ([peripheral.identifier.UUIDString isEqualToString:[myDic objectForKey:@"uuid"]])
        {
            isHave = YES;
            break;
        }
    }
    if (!isHave)
    {
        NSMutableDictionary *myDic = [[NSMutableDictionary alloc]init];
        [myDic setObject:peripheral.identifier.UUIDString?peripheral.identifier.UUIDString:@"" forKey:@"uuid"];
        [myDic setObject:peripheral.name?peripheral.name:@"" forKey:@"name"];
        [myDic setObject:peripheral forKey:@"peripheral"];
        [dataSource addObject:myDic];
        [self.mytable reloadData];
    }
}
#pragma mark- CBPeripheralDelegate
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    NSLog(@"已成功连接");
    _peripheral.delegate = self;
    [_peripheral discoverServices:nil];
    return;
}
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"连接失败");
}
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"已断开连接");
}
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error;
{
    NSLog(@"获取服务:%@",peripheral.services);
    
    RBlueServiceListVC *myVC = [[RBlueServiceListVC alloc]init];
    myVC.peripheral = _peripheral;
    myVC.dataSource = [[NSMutableArray alloc]init];
    for (CBService *service in peripheral.services)
    {
        [myVC.dataSource addObject:service];
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
    UILabel *labLeft = (UILabel*)[cell viewWithTag:10];
    labLeft.text = [NSString stringWithFormat:@"设备名称：%@",[dataSource[indexPath.row] objectForKey:@"name"]];
    
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
    [_manager stopScan];
    _peripheral = [dataSource[indexPath.row]objectForKey:@"peripheral"];
    [_manager connectPeripheral:_peripheral options:nil];
}
@end
