//
//  HemaWebVC.h
//  Hema
//
//  Created by LarryRodic on 15/10/7.
//  Copyright (c) 2015年 Hemaapp. All rights reserved.
//

#import "AllVC.h"

@interface HemaWebVC : AllVC
@property(nonatomic,copy)NSString *urlPath;
@property(nonatomic,copy)NSString *objectTitle;
@property(nonatomic,assign)BOOL isAdgust;//是否要调整
@end
