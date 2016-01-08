//
//  SYCell.m
//  Hema
//
//  Created by Lsy on 16/1/7.
//  Copyright © 2016年 Hemaapp. All rights reserved.
//

#import "SYCell.h"

@implementation SYCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.contentView addSubview:_button];
        
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:_nameLabel];
    }
    return self;
}


@end
