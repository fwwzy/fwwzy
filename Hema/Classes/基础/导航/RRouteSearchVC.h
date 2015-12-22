//
//  RRouteSearchVC.h
//  Hema
//
//  Created by LarryRodic on 15/10/7.
//  Copyright (c) 2015年 Hemaapp. All rights reserved.
//

#import "PullRefreshPlainVC.h"

@interface RRouteSearchVC : PullRefreshPlainVC
@property(nonatomic,strong)NSMutableDictionary *dataSource;//商家信息
@property(nonatomic,assign)CLLocationCoordinate2D myCoodinate;//我的位置
@end
