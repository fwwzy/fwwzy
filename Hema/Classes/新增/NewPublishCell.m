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
        //中奖
        _winerLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(_priceLabel.frame) + 20, 40, 15)];
        _winerLabel.textColor = BB_Gray_Color;
        _winerLabel.font = [UIFont systemFontOfSize:11];
        [self addSubview:_winerLabel];
        //小头像
        _winView = [[UIImageView alloc]initWithFrame:CGRectMake(50, CGRectGetMinY(_winerLabel.frame), 15, 15)];
        [self addSubview:_winView];
        //号码
        _phoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(70, CGRectGetMinY(_winerLabel.frame), 100, 15)];
        _phoneLabel.textColor = BB_Orange_Color;
        _phoneLabel.font = [UIFont systemFontOfSize:11];
        [self addSubview:_phoneLabel];
        //本期夺宝
        _curLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(_winerLabel.frame), 150, 15)];
        _curLabel.font = [UIFont systemFontOfSize:11];
        _curLabel.textColor = BB_Gray_Color;
        [self addSubview:_curLabel];
        //揭晓时间
        _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(_curLabel.frame), 150, 15)];
        _timeLabel.font = [UIFont systemFontOfSize:11];
        _timeLabel.textColor = BB_Gray_Color;
        [self addSubview:_timeLabel];
    }
    return self;
}
@end
