//
//  SearchResultVC.m
//  Hema
//
//  Created by MsTail on 15/12/30.
//  Copyright © 2015年 Hemaapp. All rights reserved.
//

#import "SearchResultVC.h"

@interface SearchResultVC () {
    NSMutableArray *_dataSource;
}

@end

@implementation SearchResultVC

- (void)loadSet {
    
    [self.navigationItem setNewTitle:@"搜索结果"];
    [self.navigationItem setLeftItemWithTarget:self action:@selector(leftbtnPressed:) image:@"lg_back"];
    
    
}

- (void)loadData {
    _dataSource = [[NSMutableArray alloc] init];
    
    if (_dataSource.count > 0) {
        
    } else {
        HemaImgView *imgView = [[HemaImgView alloc] init];
        imgView.frame = CGRectMake(0, 0, UI_View_Width / 2, self.view.height / 4);
        imgView.center = CGPointMake(self.view.width / 2, self.view.height / 2 - 70);
        imgView.image = [UIImage imageNamed:@"hp_searchfail"];
        self.view.backgroundColor = RGB_UI_COLOR(255, 245, 241);
        [self.view addSubview:imgView];
    }
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
