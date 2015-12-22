//
//  RMapGeoSelectVC.h
//  Hema
//
//  Created by LarryRodic on 15/10/7.
//  Copyright (c) 2015年 Hemaapp. All rights reserved.
//

#import "AllVC.h"

@protocol MapGeoDelegate;
@interface RMapGeoSelectVC : AllVC
@property(nonatomic,assign)NSObject<MapGeoDelegate>*delegate;
@property(nonatomic,assign)float latitude;
@property(nonatomic,assign)float longitude;
@property(nonatomic,assign)BOOL isEdit;//是否可以进行坐标编辑
@property(nonatomic,assign)NSInteger keytype;//1 普通的选取地点 2 查看线路的选取指定地点
@end

@protocol MapGeoDelegate <NSObject>
@optional
-(void)MapGeoName:(NSString *)name lat:(NSString *)lat lng:(NSString *)lng;

@end
