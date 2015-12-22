//
//  RRouteMapVC.h
//  Hema
//
//  Created by LarryRodic on 15/10/7.
//  Copyright (c) 2015年 Hemaapp. All rights reserved.
//

#import "AllVC.h"

@interface RRouteMapVC : AllVC
@property(nonatomic,strong)NSMutableDictionary *dataSource;//路线信息
@property(nonatomic,strong)AMapRoute *route;//路线规划
@property(nonatomic,assign)NSInteger selectRow;//选择的第几行
@property(nonatomic,assign)NSInteger searchType;//0 公交车 1 汽车 2 步行
@property(nonatomic,assign)CLLocationCoordinate2D startCoodinate;//起点
@property(nonatomic,assign)CLLocationCoordinate2D endCoodinate;//终点
@end
