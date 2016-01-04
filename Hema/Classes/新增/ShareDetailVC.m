//
//  ShareDetailVC.m
//  Hema
//
//  Created by MsTail on 15/12/28.
//  Copyright © 2015年 Hemaapp. All rights reserved.
//

#import "ShareDetailVC.h"

@interface ShareDetailVC ()
@property (nonatomic,strong) UIScrollView *scrollView;
@end

@implementation ShareDetailVC

- (void)loadData {
    
}

- (void)loadSet {
    [self.navigationItem setNewTitle:@"晒单详情"];
    [self.navigationItem setLeftItemWithTarget:self action:@selector(leftbtnPressed:) image:@"lg_back"];
    self.view.backgroundColor = BB_White_Color;
    
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.frame = CGRectMake(0, 0, UI_View_Width, UI_View_Height);
    
    //头像
    HemaImgView *iconView = [[HemaImgView alloc] init];
    iconView.frame = CGRectMake(15, 15, 40, 40);
    [HemaFunction addbordertoView:iconView radius:20 width:0 color:nil];
    iconView.image = [UIImage imageNamed:@"newpulish"];
    
    //用户名
    UILabel *userName = [[UILabel alloc] init];
    userName.frame = CGRectMake(70, 30, UI_View_Width - 150, 20);
    userName.font = [UIFont systemFontOfSize:17];
    userName.text = @"夺宝王者";
    
    //时间
    UILabel *timeLbl = [[UILabel alloc] init];
    timeLbl.frame = CGRectMake(UI_View_Width - 150, 30, 140, 20);
    timeLbl.textAlignment = NSTextAlignmentRight;
    timeLbl.font = [UIFont systemFontOfSize:15];
    timeLbl.textColor = BB_Gray_Color;
    timeLbl.text = @"2014-02-25";
    
    UIColor *textColor = RGB_UI_COLOR(97, 97, 97);
    //分享view
    HemaImgView *view = [[HemaImgView alloc] init];
    view.frame = CGRectMake(15, 60, UI_View_Width - 30, 140);
    view.image = [UIImage imageNamed:@"hp_view"];
    
    //获奖奖品
    UILabel *prizeName = [[UILabel alloc] init];
    prizeName.frame = CGRectMake(15, 15, view.size.width - 30, 20);
    prizeName.textColor = textColor;
    
    NSString *repPrizeStr = @"(第2531期)小米智能秤";
    NSString *prizeStr = [NSString stringWithFormat:@"获奖奖品:%@",repPrizeStr];
    NSMutableAttributedString *attrPrizeStr = [[NSMutableAttributedString alloc] initWithString:prizeStr];
    UIColor *colorPrize = RGB_UI_COLOR(1, 182, 159);
    [attrPrizeStr addAttribute:NSForegroundColorAttributeName value:colorPrize range:NSMakeRange(5, repPrizeStr.length)];
    prizeName.attributedText = attrPrizeStr;
    
    //本期参与
    UILabel *participateLbl = [[UILabel alloc] init];
    participateLbl.frame = CGRectMake(15, 45, view.size.width - 30, 20);
    participateLbl.textColor = textColor;
    
    NSString *repPartStr = @"1";
    NSString *participateStr = [NSString stringWithFormat:@"本期参与:%@人次",repPartStr];
    NSMutableAttributedString *attrPartStr = [[NSMutableAttributedString alloc] initWithString:participateStr];
    UIColor *colorPart = BB_Red_Color;
    [attrPartStr addAttribute:NSForegroundColorAttributeName value:colorPart range:NSMakeRange(5, repPartStr.length)];
    participateLbl.attributedText = attrPartStr;
    
    //幸运号码
    UILabel *luckNumLbl = [[UILabel alloc] init];
    luckNumLbl.frame = CGRectMake(15, 75, view.size.width - 30, 20);
    luckNumLbl.textColor = textColor;
    
    NSString *repluckNumStr = @"1000000145";
    NSString *luckNumStr = [NSString stringWithFormat:@"幸运号码:%@",repluckNumStr];
    NSMutableAttributedString *attrluckNumStr = [[NSMutableAttributedString alloc] initWithString:luckNumStr];
    UIColor *colorluckNum = BB_Red_Color;
    [attrluckNumStr addAttribute:NSForegroundColorAttributeName value:colorluckNum range:NSMakeRange(5, repluckNumStr.length)];
    luckNumLbl.attributedText = attrluckNumStr;
    
    //揭晓时间
    UILabel *publishTimeLbl = [[UILabel alloc] init];
    publishTimeLbl.frame = CGRectMake(15, 105, view.size.width - 30, 20);
    publishTimeLbl.text = @"揭晓时间:2015-12-08 12:35:25:102";
    publishTimeLbl.textColor = textColor;
    
    //分割线
    UILabel *sepLabel = [[UILabel alloc] init];
    sepLabel.frame = CGRectMake(15, 215, UI_View_Width - 30, 1);
    sepLabel.backgroundColor = BB_Gray_Color;
    sepLabel.alpha = 0.5;
    
    //描述
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.frame = CGRectMake(15, 230, UI_View_Width - 30, 20);
    contentLabel.font = [UIFont systemFontOfSize:16];
    contentLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    contentLabel.numberOfLines = 0;
    contentLabel.text = @"花了1000000中了个这个，运气太TM差了，劳资准备在冲5000W看看能不能中个手电筒，太想要那个手电筒了，楼下小卖部5块钱一个，但我觉得那个一点意义都没有，不如花钱抢这个来的有意义，感谢上帝我要中个手电筒";
    
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:16]};
    CGSize contentSize = [contentLabel.text boundingRectWithSize:CGSizeMake(UI_View_Width - 30  , MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil].size;
    contentLabel.frame = CGRectMake(15, 230, UI_View_Width - 30, contentSize.height);
    
    for (int i = 0; i < 4; i ++) {
        HemaImgView *goodsImg = [[HemaImgView alloc] init];
        goodsImg.frame = CGRectMake(15, 245 + contentSize.height + i * 215 , UI_View_Width - 30, 200 );
        goodsImg.image = [UIImage imageNamed:@"newpulish"];
        [_scrollView addSubview:goodsImg];
    }
    
    _scrollView.contentSize = CGSizeMake(0, contentLabel.origin.y + contentLabel.size.height + 4 * 217);
    _scrollView.showsVerticalScrollIndicator = NO;
    
    [_scrollView addSubview:iconView];
    [_scrollView addSubview:userName];
    [_scrollView addSubview:timeLbl];
    [_scrollView addSubview:view];
    [_scrollView addSubview:sepLabel];
    [view addSubview:prizeName];
    [view addSubview:participateLbl];
    [view addSubview:luckNumLbl];
    [view addSubview:publishTimeLbl];
    [_scrollView addSubview:contentLabel];
    [self.view addSubview:_scrollView];
    
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
