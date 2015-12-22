//
//  HemaReplyVC.h
//  Hema
//
//  Created by LarryRodic on 15/10/7.
//  Copyright (c) 2015年 Hemaapp. All rights reserved.
//
//多行文本输入

#import "AllVC.h"

@protocol HemaReplyDelegate;
@interface HemaReplyVC : AllVC
{
    BOOL isCanNull;//输入内容是否可以为空
}
@property(nonatomic,assign)NSObject<HemaReplyDelegate>* delegate;
@property(nonatomic,copy)NSString *keyName;//关键字
@property(nonatomic,copy)NSString *publishContent;//传递过来的文本内容
@property(nonatomic,copy)NSString *titleName;//导航标题
@property(nonatomic,copy)NSString *placeholder;//提示语
@end

@protocol HemaReplyDelegate <NSObject>
@optional
-(void)HemaReplyOK:(HemaReplyVC*)reply content:(NSString*)content;
@end