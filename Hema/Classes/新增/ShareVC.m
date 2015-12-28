//
//  ShareVC.m
//  Hema
//
//  Created by MsTail on 15/12/28.
//  Copyright © 2015年 Hemaapp. All rights reserved.
//

#import "ShareVC.h"
#import "ShareDetailVC.h"

@interface ShareVC ()

@end

@implementation ShareVC

- (void)loadData {
    
}

- (void)loadSet {
    [self.navigationItem setNewTitle:@"晒单"];
    [self.navigationItem setLeftItemWithTarget:self action:@selector(leftbtnPressed:) image:@"lg_back"];
    [self.mytable setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 280;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"shareCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        //头像
        HemaImgView *iconView = [[HemaImgView alloc] init];
        iconView.frame = CGRectMake(15, 15, 40, 40);
        [HemaFunction addbordertoView:iconView radius:20 width:0 color:nil];
        iconView.image = [UIImage imageNamed:@"newpulish"];
        
        //用户名
        UILabel *userName = [[UILabel alloc] init];
        userName.frame = CGRectMake(70, 30, UI_View_Width - 150, 20);
        userName.font = [UIFont systemFontOfSize:17];
        userName.text = @"亓化泽(假肢)";
        
        //时间
        UILabel *timeLbl = [[UILabel alloc] init];
        timeLbl.frame = CGRectMake(UI_View_Width - 150, 30, 140, 20);
        timeLbl.textAlignment = NSTextAlignmentRight;
        timeLbl.font = [UIFont systemFontOfSize:15];
        timeLbl.textColor = BB_Gray_Color;
        timeLbl.text = @"2014-02-25";
        
        //分享view
        HemaImgView *view = [[HemaImgView alloc] init];
        view.frame = CGRectMake(15, 60, UI_View_Width - 30, (130 + (UI_View_Width - 30) / 4.8));
        view.image = [UIImage imageNamed:@"hp_view"];
        view.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewClick:)];
        [view addGestureRecognizer:tapGR];
        
        //商品名称
        UILabel *goodsName = [[UILabel alloc] init];
        goodsName.frame = CGRectMake(15, 15, UI_View_Width - 100, 25);
        goodsName.font = [UIFont systemFontOfSize:20];
        goodsName.text = @"LOL无敌账号";
        
        //商品详情
        UILabel *goodsDetail = [[UILabel alloc] init];
        goodsDetail.frame = CGRectMake(15, 40, UI_View_Width - 100, 20);
        goodsDetail.font = [UIFont systemFontOfSize:15];
        goodsDetail.textColor = BB_Gray_Color;
        goodsDetail.text = @"(第2531期)英雄联盟全英雄全皮肤账号";
        
        //晒单评价
        UILabel *appraiseLbl = [[UILabel alloc] init];
        appraiseLbl.frame = CGRectMake(15, 75, UI_View_Width - 100, 20);
        appraiseLbl.font = [UIFont systemFontOfSize:18];
        appraiseLbl.text = @"太爽辣，我又可以装逼辣";
        
        NSArray *imgArr = @[@"newpulish",@"newpulish",@"newpulish",@"newpulish"];
        //晒单图片
        for (int i = 0; i < 4; i++) {
            HemaImgView *shareImg = [[HemaImgView alloc] init];
            shareImg.frame = CGRectMake(15 + view.size.width / 4.3 * i, 110, view.size.width / 4.8, view.size.width / 4.8);
            shareImg.image = [UIImage imageNamed:imgArr[i]];
            [view addSubview:shareImg];
        }
        
        [cell.contentView addSubview:iconView];
        [cell.contentView addSubview:userName];
        [cell.contentView addSubview:timeLbl];
        [view addSubview:goodsName];
        [view addSubview:goodsDetail];
        [view addSubview:appraiseLbl];
        [cell.contentView addSubview:view];
       
    }
    return cell;
}

//晒单view点击进入详情
- (void)viewClick:(UITapGestureRecognizer *)gesture {
    
    ShareDetailVC *shareDetailVC = [[ShareDetailVC alloc] init];
    [self.navigationController pushViewController:shareDetailVC animated:YES];
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
