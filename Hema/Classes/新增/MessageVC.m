//
//  MessageVC.m
//  Hema
//
//  Created by MsTail on 15/12/24.
//  Copyright © 2015年 Hemaapp. All rights reserved.
//

#import "MessageVC.h"

@interface MessageVC ()
@end

@implementation MessageVC

//消息声明页面父类  继承

- (void)loadSet {
    
}

- (void)createContentLabel {
    
     [self.navigationItem setLeftItemWithTarget:self action:@selector(leftbtnPressed:) image:@"lg_back"];
    _contentLabel = [[UILabel alloc] init];
    _contentLabel.font = [UIFont systemFontOfSize:16];
    _contentLabel.numberOfLines = 0;
    _contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    CGSize contentSize  = [self.contentText boundingRectWithSize:CGSizeMake(UI_View_Width - 20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;
    
    [_contentLabel setFrame:CGRectMake(10, 10, UI_View_Width - 10, contentSize.height)];
    _contentLabel.text = self.contentText;
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.frame = CGRectMake(0, 0, UI_View_Width, self.view.height);
    scrollView.contentSize = CGSizeMake(0, _contentLabel.size.height + 80);
    scrollView.showsVerticalScrollIndicator = NO;
    [scrollView addSubview:_contentLabel];
    [self.view addSubview:scrollView];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
