//
//  RWeiChatCell.h
//  Hema
//
//  Created by LarryRodic on 15/10/10.
//  Copyright (c) 2015年 Hemaapp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RWeiChatCell : UITableViewCell
@property(nonatomic,strong)HemaButton *messageButton;//消息按钮
@property(nonatomic,strong)UILabel *messageContentView;//消息内容
@property(nonatomic,strong)HemaButton *avatarButton;//头像按钮
@property(nonatomic,strong)UILabel *timeLabel;//时间

@property(nonatomic,strong)UIActivityIndicatorView *waitIndicator;//发送等待菊花
@property(nonatomic,strong)HemaButton *reSendButton;//重新发送按钮
@property(nonatomic,strong)HemaImgView *messageImgView;

@property(nonatomic,strong)UILabel *nameLabel;//名称
@property(nonatomic,strong)UILabel *deptLabel;//部门
@end
