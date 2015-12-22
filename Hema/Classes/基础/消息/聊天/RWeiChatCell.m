//
//  RWeiChatCell.m
//  Hema
//
//  Created by LarryRodic on 15/10/10.
//  Copyright (c) 2015年 Hemaapp. All rights reserved.
//

#import "RWeiChatCell.h"

@implementation RWeiChatCell
@synthesize messageButton;
@synthesize messageContentView;
@synthesize timeLabel;
@synthesize avatarButton;
@synthesize waitIndicator;
@synthesize reSendButton;
@synthesize messageImgView;

@synthesize nameLabel;
@synthesize deptLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        //背景按钮
        self.messageButton = [HemaButton buttonWithType:UIButtonTypeCustom];
        [self.contentView addSubview:messageButton];
        
        //头像
        self.avatarButton = [HemaButton buttonWithType:UIButtonTypeCustom];
        [self.contentView addSubview:avatarButton];
        [HemaFunction addbordertoView:avatarButton radius:24.0f width:2.0f color:BB_White_Color];
        
        //图片
        messageImgView = [[HemaImgView alloc] init];
        messageImgView.contentMode = UIViewContentModeScaleAspectFill;
        [HemaFunction addbordertoView:messageImgView radius:6 width:0.5 color:[UIColor lightGrayColor]];
        [self.contentView addSubview:messageImgView];
        
        //聊天消息
        messageContentView = [[UILabel alloc] init];
        messageContentView.lineBreakMode = NSLineBreakByWordWrapping;
        messageContentView.numberOfLines = 0;
        messageContentView.backgroundColor = [UIColor clearColor];
        messageContentView.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:messageContentView];
        
        //时间
        timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 17.5, 100, 18)];
        timeLabel.backgroundColor = [UIColor clearColor];
        timeLabel.textColor = BB_Gray_Color;
        timeLabel.font = [UIFont systemFontOfSize:10];
        timeLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:timeLabel];
        
        //菊花
        waitIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        waitIndicator.center = CGPointMake(160, 30);
        [waitIndicator startAnimating];
        waitIndicator.hidesWhenStopped = YES;
        [self.contentView addSubview:waitIndicator];
        
        //重新发送按钮
        reSendButton = [HemaButton buttonWithType:UIButtonTypeCustom];
        [reSendButton setBackgroundImage:[UIImage imageNamed:@"R发送失败.png"] forState:UIControlStateNormal];
        reSendButton.bounds = CGRectMake(0, 0, 30, 30);
        reSendButton.hidden = YES;
        [self.contentView addSubview:reSendButton];
        
        //昵称
        nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(68, 5, 200, 13)];
        nameLabel.font = [UIFont systemFontOfSize:11];
        nameLabel.textColor = BB_Blake_Color;
        nameLabel.textAlignment = NSTextAlignmentCenter;
        nameLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:nameLabel];
        
        //部门
        deptLabel = [[UILabel alloc] initWithFrame:CGRectMake(68, 5, 200, 11)];
        deptLabel.font = [UIFont systemFontOfSize:8];
        deptLabel.hidden = YES;
        deptLabel.textColor = BB_Gray_Color;
        deptLabel.textAlignment = NSTextAlignmentCenter;
        deptLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:deptLabel];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}
@end
