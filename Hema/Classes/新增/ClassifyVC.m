//
//  ClassifyVC.m
//  Hema
//
//  Created by MsTail on 15/12/28.
//  Copyright © 2015年 Hemaapp. All rights reserved.
//

#import "ClassifyVC.h"
#import "ClassifyListVC.h"

@interface ClassifyVC ()

@end

@implementation ClassifyVC

- (void)loadData {
    
}

- (void)loadSet {
    [self.navigationItem setNewTitle:@"分类"];
    [self.navigationItem setLeftItemWithTarget:self action:@selector(leftbtnPressed:) image:@"lg_back"];
    [self.mytable setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"classifyCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        
        //图标
        HemaImgView *iconView = [[HemaImgView alloc] init];
        iconView.frame = CGRectMake(15, 15, 40, 40);
        iconView.image = [UIImage imageNamed:@"hp_wx"];
        
        //名称
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.frame = CGRectMake(70, 25, UI_View_Width - 85, 20);
        titleLabel.text = @"假肢只是一直戈偶";
        
        [cell.contentView addSubview:iconView];
        [cell.contentView addSubview:titleLabel];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ClassifyListVC *classifyListVC = [[ClassifyListVC alloc] init];
    classifyListVC.titleName = @"十元专区";
    [self.navigationController pushViewController:classifyListVC animated:YES];
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
