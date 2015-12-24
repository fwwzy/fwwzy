//
//  MessageVC.h
//  Hema
//
//  Created by MsTail on 15/12/24.
//  Copyright © 2015年 Hemaapp. All rights reserved.
//

#import "AllVC.h"

@interface MessageVC : AllVC

@property (nonatomic,strong) UILabel *contentLabel;
@property (nonatomic,copy)  NSString *contentText;

- (void)createContentLabel;
@end
