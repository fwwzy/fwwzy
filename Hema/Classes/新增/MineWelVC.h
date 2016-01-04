//
//  MineWelVC.h
//  Hema
//
//  Created by Lsy on 16/1/4.
//  Copyright © 2016年 Hemaapp. All rights reserved.
//

#import "AllVC.h"

@interface MineWelVC : AllVC
@property(nonatomic,copy)void(^blockNum) (NSString *str);
@end
