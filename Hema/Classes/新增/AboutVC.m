//
//  AboutVC.m
//  Hema
//
//  Created by MsTail on 16/1/4.
//  Copyright © 2016年 Hemaapp. All rights reserved.
//

#import "AboutVC.h"

@interface AboutVC ()

@end

@implementation AboutVC

- (void)loadSet {
    
    [self.navigationItem setNewTitle:@"关于我们"];
    [self.navigationItem setLeftItemWithTarget:self action:@selector(leftbtnPressed:) image:@"lg_back"];
    self.view.backgroundColor = RGB_UI_COLOR(255, 246, 246);
    
    UIView *iconView = [[UIView alloc] init];
    iconView.frame = CGRectMake(0, 0, UI_View_Width, 200);
    iconView.backgroundColor = BB_White_Color;
    
    //icon
    UIImageView *iconImg = [[UIImageView alloc] init];
    iconImg.frame = CGRectMake(0, 0, 56, 58);
    iconImg.center = CGPointMake(self.view.width / 2, 100);
    iconImg.image = [UIImage imageNamed:@"sz_icon"];
    
    //版本
    UILabel *versionLbl = [[UILabel alloc] init];
    versionLbl.frame = CGRectMake(0, 0, 200, 20);
    versionLbl.center = CGPointMake(self.view.width / 2, iconImg.center.y + 60);
    versionLbl.font = [UIFont systemFontOfSize:16];
    versionLbl.textAlignment = NSTextAlignmentCenter;
    versionLbl.text = @"版本号1.0.1";
    
    [iconView addSubview:iconImg];
    [iconView addSubview:versionLbl];
    [self.view addSubview:iconView];
    
    //text
    UIView *textView = [[UIView alloc] init];
    textView.frame = CGRectMake(0, 210, UI_View_Width, 200);
    textView.backgroundColor = BB_White_Color;
    UILabel *textLbl = [[UILabel alloc] init];
    textLbl.frame = CGRectMake(15, 15, UI_View_Width - 30, 170);
    textLbl.font = [UIFont systemFontOfSize:16];
    textLbl.lineBreakMode = NSLineBreakByWordWrapping;
    textLbl.numberOfLines = 0;
    textLbl.backgroundColor = BB_White_Color;
    
    textLbl.text = @"是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗";
    [textView addSubview:textLbl];
    [self.view addSubview:textView];
   
}

- (void)loadData {
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
