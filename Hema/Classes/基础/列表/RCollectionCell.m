//
//  RCollectionCell.m
//  Hema
//
//  Created by LarryRodic on 15/10/7.
//  Copyright (c) 2015年 Hemaapp. All rights reserved.
//

#import "RCollectionCell.h"

@implementation RCollectionCell
@synthesize topImgView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        topImgView = [[HemaImgView alloc]init];
        [topImgView setFrame:CGRectMake(0, 0, (UI_View_Width-20)/4-5, (UI_View_Width-20)/4-5)];
        topImgView.contentMode = UIViewContentModeScaleAspectFill;
        [HemaFunction addbordertoView:topImgView radius:4.0f width:0.5f color:BB_lineColor];
        [topImgView setClipsToBounds:YES];
        [self addSubview:topImgView];
    }
    return self;
}

@end
