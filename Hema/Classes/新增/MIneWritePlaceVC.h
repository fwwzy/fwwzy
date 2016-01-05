//
//  MIneWritePlaceVC.h
//  Hema
//
//  Created by Lsy on 16/1/5.
//  Copyright © 2016年 Hemaapp. All rights reserved.
//

#import "AllVC.h"

@interface MIneWritePlaceVC : AllVC
@property(nonatomic,strong)UITextField *nameField;
@property(nonatomic,strong)UITextField *phoneField;
@property(nonatomic,strong)UITextField *placeField;
@property(nonatomic,copy)void(^blockDic) (NSMutableDictionary *date);
@end
