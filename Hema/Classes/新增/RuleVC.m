//
//  RuleVC.m
//  Hema
//
//  Created by MsTail on 16/1/4.
//  Copyright © 2016年 Hemaapp. All rights reserved.
//

#import "RuleVC.h"

@interface RuleVC ()

@end

@implementation RuleVC

- (void)viewWillDisappear:(BOOL)animated {
    self.navigationController.navigationBarHidden = YES;
}
- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = NO;
}

- (void)loadSet {
    [self.navigationItem setNewTitle:@"开奖规则"];
    [self.navigationItem setLeftItemWithTarget:self action:@selector(leftbtnPressed:) image:@"lg_back"];
}

- (void)loadData {
    self.contentText = @"假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗假肢是只狗";
    [self createContentLabel];
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
