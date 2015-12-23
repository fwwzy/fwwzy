//
//  NewPublishCell.m
//  Hema
//
//  Created by Lsy on 15/12/23.
//  Copyright © 2015年 Hemaapp. All rights reserved.
//

#import "NewPublishCell.h"

@implementation NewPublishCell
//初始化方法
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        //图片
        _iconView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)/2)];
        [self addSubview:_iconView];
        //名称
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetHeight(self.frame)/2 + 5, CGRectGetWidth(self.frame)-20, 40)];
        _nameLabel.font = [UIFont systemFontOfSize:15];
        _nameLabel.numberOfLines = 2;
        [self addSubview:_nameLabel];
        //价格
        _priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(_nameLabel.frame)+5, 40, 15)];
        _priceLabel.font = [UIFont systemFontOfSize:11];
        _priceLabel.textColor = BB_Gray_Color;
        [self addSubview:_priceLabel];
        
        _numLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, CGRectGetMinY(_priceLabel.frame)-3, 100, 20)];
        _numLabel.textColor = BB_Red_Color;
        _numLabel.font = [UIFont systemFontOfSize:18];
        [self addSubview:_numLabel];
        
    }
    return self;
}
@end
