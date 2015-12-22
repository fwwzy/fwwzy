//
//  HemaTextView.h
//  Hema
//
//  Created by LarryRodic on 15/10/7.
//  Copyright (c) 2015年 Hemaapp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HemaTextView : UITextView
@property(nonatomic,strong)UILabel *placeHolderLabel;
@property(nonatomic,copy)NSString *placeholder;
@property(nonatomic,strong)UIColor *placeholderColor;
@end
