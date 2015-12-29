//
//  FAQVC.m
//  Hema
//
//  Created by MsTail on 15/12/29.
//  Copyright © 2015年 Hemaapp. All rights reserved.
//

#import "FAQVC.h"
#define FONTCOLOR RGB_UI_COLOR(83, 83, 83);
@interface FAQVC () <UIAlertViewDelegate>{
    float _autoSize;
}

@end

@implementation FAQVC

- (void)loadSet {
    [self.navigationItem setNewTitle:@"常见问题"];
    [self.navigationItem setLeftItemWithTarget:self action:@selector(leftbtnPressed:) image:@"lg_back"];
    [self.mytable setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
}

- (void)loadData {
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return _autoSize;
    }
    return 230;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 5;
    }
    return 1;

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"FAQCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        if (indexPath.section == 0) {
            
        //问题
        UILabel *questionLbl = [[UILabel alloc] init];
        questionLbl.frame = CGRectMake(15, 15, UI_View_Width - 30, 20);
        questionLbl.font = [UIFont systemFontOfSize:16];
        questionLbl.text = [NSString stringWithFormat:@"%zd、怎么查看我参与的商品有没有获得",indexPath.row + 1];
        
        //内容view
        HemaImgView *contentView = [[HemaImgView alloc] init];
        contentView.frame = CGRectMake(15, 45, UI_View_Width - 30, 40);
        contentView.image = [UIImage imageNamed:@"hp_view"];
        
        //内容label
        UILabel *contentLbl = [[UILabel alloc] init];
        contentLbl.frame = CGRectMake(5, 10, contentView.size.width - 10 , 20);
        contentLbl.font = [UIFont systemFontOfSize:14];
        contentLbl.textColor = FONTCOLOR;
        contentLbl.lineBreakMode = NSLineBreakByWordWrapping;
        contentLbl.numberOfLines = 0;
        contentLbl.text = @"每一期商品揭晓结果公布以后，登陆全民夺宝，进入'我的全民夺宝',其实你也不用看了，因为你肯定中不了";
        
        NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:14]};
        CGSize sizeTitle = [contentLbl.text boundingRectWithSize:CGSizeMake(contentView.size.width - 10, MAXFLOAT)  options:NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil].size;
        contentLbl.frame = CGRectMake(5, 10, contentView.size.width - 10, sizeTitle.height);
        contentView.frame = CGRectMake(15, 40, UI_View_Width - 30, 20 + sizeTitle.height);
        _autoSize = 70 + sizeTitle.height;
        
        [cell.contentView addSubview:questionLbl];
        [cell.contentView addSubview:contentView];
        [contentView addSubview:contentLbl];
            }
    }
    if (indexPath.section == 1) {
        cell = [[UITableViewCell alloc] init];
        cell.backgroundColor = RGB_UI_COLOR(248, 248, 248);
        //咨询方式
        UILabel *consultLbl = [[UILabel alloc] init];
        consultLbl.frame = CGRectMake(15, 25, UI_View_Width - 30, 20);
        consultLbl.font = [UIFont systemFontOfSize:15];
        consultLbl.text = @"全民一元夺宝，问题咨询方式";
        
        //客服热线
        UILabel *phoneLbl = [[UILabel alloc] init];
        phoneLbl.frame = CGRectMake(15, 55, UI_View_Width - 30, 20);
        phoneLbl.font = [UIFont systemFontOfSize:13];
        phoneLbl.textColor = FONTCOLOR;
        phoneLbl.text = @"客服热线:400-555123211";
        
        //客服QQ
        UILabel *qqLbl = [[UILabel alloc] init];
        qqLbl.frame = CGRectMake(15, 85, UI_View_Width - 30, 20);
        qqLbl.font = [UIFont systemFontOfSize:13];
        qqLbl.textColor = FONTCOLOR;
        qqLbl.text = @"客服热线:472601115";
        
        //微信公众号
        UILabel *wxLbl = [[UILabel alloc] init];
        wxLbl.frame = CGRectMake(15, 115, UI_View_Width - 30, 20);
        wxLbl.font = [UIFont systemFontOfSize:13];
        wxLbl.textColor = FONTCOLOR;
        wxLbl.text = @"微信公众账号:woyebuzhidao";
        
        //客服通知
        UILabel *serviceLbl = [[UILabel alloc] init];
        serviceLbl.frame = CGRectMake(15, 145, UI_View_Width - 30, 40);
        serviceLbl.font = [UIFont systemFontOfSize:13];
        serviceLbl.lineBreakMode = NSLineBreakByWordWrapping;
        serviceLbl.numberOfLines = 0;
        serviceLbl.textColor = FONTCOLOR;
        serviceLbl.text = @"客服工作时间为凌点到零点，有什么问题随便问，反正我们也不给你回复你就等着吧，啊哈哈哈哈啊哈哈，气煞你";
        
        //联系客服
        HemaButton *serviceBtn = [[HemaButton alloc] init];
        serviceBtn.frame = CGRectMake(self.view.width / 2 - 40, 190, 80, 25);
        [serviceBtn setImage:[UIImage imageNamed:@"hp_service"] forState:UIControlStateNormal];
        [serviceBtn addTarget:self action:@selector(serviceBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [cell.contentView addSubview:consultLbl];
        [cell.contentView addSubview:phoneLbl];
        [cell.contentView addSubview:qqLbl];
        [cell.contentView addSubview:wxLbl];
        [cell.contentView addSubview:serviceLbl];
        [cell.contentView addSubview:serviceBtn];
        
    }
    return cell;
}

//联系客服点击事件
- (void)serviceBtnClick:(HemaButton *)sender {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"客服电话\n400-02531453" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"一键联系", nil];
    alertView.delegate = self;
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != 0) {
        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",@"18660779930"];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
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
