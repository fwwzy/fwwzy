//
//  NoticeVC.m
//  Hema
//
//  Created by MsTail on 15/12/30.
//  Copyright © 2015年 Hemaapp. All rights reserved.
//

#import "NoticeVC.h"
#import "LjjUISegmentedControl.h"

@interface NoticeVC ()

@end

@implementation NoticeVC

- (void)loadSet {
    [self.navigationItem setLeftItemWithTarget:self action:@selector(leftbtnPressed:) image:@"lg_back"];
    
    LjjUISegmentedControl *segmentedControl = [[LjjUISegmentedControl alloc] init];
    segmentedControl.frame = CGRectMake(0, 0, 130, 30);
    NSArray *segmentArr = [NSArray arrayWithObjects:@"公告",@"消息",nil];
    [segmentedControl AddSegumentArray:segmentArr];
    segmentedControl.backgroundColor = RGB_UI_COLOR(217, 29, 43);
    self.navigationItem.titleView = segmentedControl;
    
}

- (void)loadData {
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
