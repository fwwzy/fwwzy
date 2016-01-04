//
//  MineNameVC.h
//  Hema
//
//  Created by Lsy on 16/1/4.
//  Copyright © 2016年 Hemaapp. All rights reserved.
//

#import "AllVC.h"

@interface MineNameVC : AllVC

@property(nonatomic,copy)void(^blockName) (NSString *str);

@end
