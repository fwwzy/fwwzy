//
//  RPhotoBeautyChangeVC.h
//  Hema
//
//  Created by geyang on 15/11/19.
//  Copyright © 2015年 Hemaapp. All rights reserved.
//

#import "PullRefreshPlainVC.h"

@interface RPhotoBeautyChangeVC : PullRefreshPlainVC
@property(nonatomic,strong)NSMutableArray *dataImg;///<图片数组
@property(nonatomic,strong)NSMutableArray *assets;///<assets数组
@property(nonatomic,strong)void(^PhotoBeautyChangeOK)(NSMutableArray *dataImg,NSMutableArray *assets);
@end