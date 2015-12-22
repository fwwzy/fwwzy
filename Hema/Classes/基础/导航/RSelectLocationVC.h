//
//  RSelectLocationVC.h
//  Hema
//
//  Created by geyang on 15/11/25.
//  Copyright © 2015年 Hemaapp. All rights reserved.
//

#import "PullRefreshPlainVC.h"

@interface RSelectLocationVC : PullRefreshPlainVC
@property(nonatomic,assign)float latitude;
@property(nonatomic,assign)float longitude;
@property(nonatomic,assign)NSInteger keytype;//1 普通的选取地点 2 待扩展
@property(nonatomic,strong)void (^confirmCoordinate)(CGFloat lat,CGFloat lng,NSString *address);
@end
