//
//  RBlueCharacterListVC.m
//  Hema
//
//  Created by geyang on 15/10/22.
//  Copyright © 2015年 Hemaapp. All rights reserved.
//

#import "RBlueCharacterListVC.h"

@interface RBlueCharacterListVC ()<CBPeripheralDelegate>
@property(nonatomic,strong)CBCharacteristic *characteristic;
@end

@implementation RBlueCharacterListVC
@synthesize dataSource;

-(void)loadSet
{
    [self.navigationItem setNewTitle:@"服务特征"];
    [SystemFunction setTableSeparatorInset:self.mytable left:10];
    [self forbidPullRefresh];
    
    _peripheral.delegate = self;
}
-(void)loadData
{
    if (!dataSource)
        dataSource = [[NSMutableArray alloc]init];
}
#pragma mark- 自定义
#pragma mark 事件

#pragma mark 方法
//发送指令
-(void)sendOrder
{
    MMPopupItemHandler block = ^(NSInteger index)
    {
        if (index == 0)
        {
            [self oneOrder];
        }
        if (index == 1)
        {
            [self twoOrder];
        }
        if (index == 2)
        {
            [[[MMAlertView alloc] initWithInputTitle:@"指令" detail:@"请输入指令" placeholder:@"请小心输入哦~" handler:^(NSString *text)
              {
                  NSLog(@"输入:%@，自己拼凑吧",text);
              }]
             showWithBlock:nil];
        }
    };
    NSArray *items =
    @[MMItemMake(@"指令：4142430d0a", MMItemTypeNormal, block),
      MMItemMake(@"指令：4143420d0a", MMItemTypeNormal, block),
      MMItemMake(@"点击输入指令", MMItemTypeHighlight, block),
      MMItemMake(@"取消", MMItemTypeNormal, block)];
    
    MMAlertView *alertView = [[MMAlertView alloc] initWithTitle:@"指令"
                                                         detail:@"用来控制设备"
                                                          items:items];
    alertView.attachedView = self.view;
    [alertView show];
}
//第一种指令
-(void)oneOrder
{
    char ucCommandSend[5];
    ucCommandSend[0]= 0X41;
    ucCommandSend[1]= 0x42;
    ucCommandSend[2]= 0x43;
    ucCommandSend[3]= 0x0d;
    ucCommandSend[4]= 0x0a;
    NSData *content=[NSData dataWithBytes:ucCommandSend length:5];
    [_peripheral writeValue:content forCharacteristic:_characteristic type:CBCharacteristicWriteWithResponse];
}
//第二种指令
-(void)twoOrder
{
    char ucCommandSend[5];
    ucCommandSend[0]= 0X41;
    ucCommandSend[1]= 0x43;
    ucCommandSend[2]= 0x42;
    ucCommandSend[3]= 0x0d;
    ucCommandSend[4]= 0x0a;
    NSData *content=[NSData dataWithBytes:ucCommandSend length:5];
    [_peripheral writeValue:content forCharacteristic:_characteristic type:CBCharacteristicWriteWithResponse];
}
#pragma mark- CBPeripheralDelegate
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForDescriptor:(CBDescriptor *)descriptor error:(NSError *)error
{
    NSLog(@"蓝牙发过来数据接收");
}
- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForDescriptor:(CBDescriptor *)descriptor error:(NSError *)error
{
    NSLog(@"给蓝牙发数据回调");
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
    CBCharacteristic *characteristic = [dataSource objectAtIndex:indexPath.row];
    
    UILabel *labLeft = (UILabel*)[cell viewWithTag:10];
    labLeft.text = [NSString stringWithFormat:@"特征编码：%@",characteristic.UUID.description];
    
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
    
    _characteristic = [dataSource objectAtIndex:indexPath.row];
    [self sendOrder];
}
@end
