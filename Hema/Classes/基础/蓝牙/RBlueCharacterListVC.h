//
//  RBlueCharacterListVC.h
//  Hema
//
//  Created by geyang on 15/10/22.
//  Copyright © 2015年 Hemaapp. All rights reserved.
//

#import "PullRefreshGroupVC.h"

@interface RBlueCharacterListVC : PullRefreshGroupVC
@property(nonatomic,strong)CBPeripheral *peripheral;
@property(nonatomic,strong)NSMutableArray *dataSource;
@end
