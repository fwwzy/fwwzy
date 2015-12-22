//
//  HemaButton.h
//  Hema
//
//  Created by LarryRodic on 15/10/5.
//  Copyright (c) 2015年 Hemaapp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HemaButton : UIButton
@property(nonatomic,copy)NSString *btnId;
@property(nonatomic,assign)NSInteger btnRow;
@property(nonatomic,assign)NSInteger btnSection;
@end
