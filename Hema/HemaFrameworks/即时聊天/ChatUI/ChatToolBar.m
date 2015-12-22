//
//  ChatToolBar.m
//  Hema
//
//  Created by LarryRodic on 15/10/10.
//  Copyright (c) 2015年 Hemaapp. All rights reserved.
//

#import "ChatToolBar.h"

@implementation ChatToolBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        UIView *line = [[UIView alloc]init];
        [line setFrame:CGRectMake(0, 0, UI_View_Width, 0.5)];
        [line setBackgroundColor:BB_lineColor];
        [self addSubview:line];
    }
    return self;
}
@end