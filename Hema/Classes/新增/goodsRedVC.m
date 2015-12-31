//
//  goodsRedVC.m
//  Hema
//
//  Created by MsTail on 15/12/28.
//  Copyright © 2015年 Hemaapp. All rights reserved.
//

#import "goodsRedVC.h"

@interface goodsRedVC () {
    UIImageView *_backView;
    float _autoHeight;
}

@end

@implementation goodsRedVC

- (void)loadData {
    
}

- (void)loadSet {
    [self.navigationItem setNewTitle:@"分类"];
    [self.navigationItem setLeftItemWithTarget:self action:@selector(leftbtnPressed:) image:@"lg_back"];
    self.view.backgroundColor = BB_White_Color;
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.frame = CGRectMake(0, 0, UI_View_Width, UI_View_Height);
    
    //红包view
    HemaImgView *redView = [[HemaImgView alloc] init];
    redView.frame = CGRectMake(0, 0, UI_View_Width, self.view.height / 3);
    redView.image = [UIImage imageNamed:@"hp_redview"];
    
    //红包累计总额
    UILabel *redTotal = [[UILabel alloc] init];
    redTotal.frame = CGRectMake(0, 0, UI_View_Width, 40);
    redTotal.backgroundColor = BB_Blake_Color;
    redTotal.textColor = BB_White_Color;
    redTotal.textAlignment = NSTextAlignmentCenter;
    redTotal.text = @"红包累计总额:9999999￥";
    redTotal.alpha = 0.7;
    
    //抢红包
    HemaImgView *grabView = [[HemaImgView alloc] init];
    grabView.frame = CGRectMake(15, redView.origin.y + redView.size.height + 15, 60, 15);
    grabView.image = [UIImage imageNamed:@"hp_hongbao"];
    
    //时间
    UILabel *timeLbl = [[UILabel alloc] init];
    timeLbl.frame = CGRectMake(UI_View_Width - 150, grabView.origin.y, 140, 20);
    timeLbl.textAlignment = NSTextAlignmentRight;
    timeLbl.font = [UIFont systemFontOfSize:15];
    timeLbl.textColor = BB_Gray_Color;
    timeLbl.text = @"2014-02-25";
    
    //中奖信息
    UILabel *prizeLbl = [[UILabel alloc] init];
    prizeLbl.frame = CGRectMake(15, grabView.origin.y + grabView.size.height + 15, UI_View_Width - 30, 20);
    prizeLbl.font = [UIFont systemFontOfSize:14];
    prizeLbl.textColor = BB_Blake_Color;
    NSString *NubString = [NSString stringWithFormat:@"182****%zd",arc4random()%9999];
    NSString *prizeText =[NSString stringWithFormat:@"%@  获得超级无敌牛逼电视",NubString];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:prizeText];
    NSRange range = [prizeText rangeOfString:NubString];
    UIColor *color = BB_Blue_Color;
    [attrString addAttribute:NSForegroundColorAttributeName value:color range:range];
    prizeLbl.attributedText = attrString;
    
    //抢一抢
    HemaButton *grabBtn = [[HemaButton alloc] init];
    grabBtn.frame = CGRectMake(UI_View_Width / 2 - 40, prizeLbl.origin.y + prizeLbl.size.height + 20, 80, 30);
    [grabBtn setImage:[UIImage imageNamed:@"hp_qiang"] forState:UIControlStateNormal];
    [grabBtn addTarget:self action:@selector(grabBtbClick:) forControlEvents:UIControlEventTouchUpInside];
    
    //活动规则
    UIView *ruleView = [[UIView alloc] init];
    ruleView.frame = CGRectMake(0, grabBtn.origin.y + grabBtn.size.height + 30, UI_View_Width, self.view.height / 2.5);
    ruleView.backgroundColor = RGB_UI_COLOR(245, 245, 245);
    
    HemaImgView *ruleImg = [[HemaImgView alloc] init];
    ruleImg.frame = CGRectMake(UI_View_Width / 2 - 85, 20, 170, 18);
    ruleImg.image = [UIImage imageNamed:@"hp_redrule"];
    
    //标志
    HemaImgView *ruleFlag = [[HemaImgView alloc] init];
    ruleFlag.frame = CGRectMake(15, 60, 8, 8);
    ruleFlag.image = [UIImage imageNamed:@"hp_ruleflag"];
    
    //活动时间
    UILabel *timeLabel = [[UILabel alloc] init];
    timeLabel.frame = CGRectMake(27, 55, 200, 20);
    timeLabel.text = @"活动时间";
    timeLabel.font = [UIFont systemFontOfSize:14];
    
    UILabel *timeContent = [[UILabel alloc] init];
    timeContent.frame = CGRectMake(37, 85, UI_View_Width - 50, 20);
    timeContent.font = [UIFont systemFontOfSize:14];
    timeContent.lineBreakMode = NSLineBreakByWordWrapping;
    timeContent.numberOfLines = 0;
    timeContent.text = @"活动时间我也不知道";
    
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:14]};
    CGSize sizeTitle = [timeContent.text boundingRectWithSize:CGSizeMake(UI_View_Height - 50, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil].size;
    timeContent.frame = CGRectMake(37, 85, UI_View_Width - 50, sizeTitle.height);
    _autoHeight += sizeTitle.height;
    
    //标志
    HemaImgView *rule2Flag = [[HemaImgView alloc] init];
    rule2Flag.frame = CGRectMake(15, 120, 8, 8);
    rule2Flag.image = [UIImage imageNamed:@"hp_ruleflag"];
    
    UILabel *joinLabel = [[UILabel alloc] init];
    joinLabel.frame = CGRectMake(27, 115, 200, 20);
    joinLabel.text = @"参与资格";
    joinLabel.font = [UIFont systemFontOfSize:14];
    
    UILabel *joinContent = [[UILabel alloc] init];
    joinContent.frame = CGRectMake(37, 145, UI_View_Width - 50, 20);
    joinContent.font = [UIFont systemFontOfSize:14];
    joinContent.lineBreakMode = NSLineBreakByWordWrapping;
    joinContent.numberOfLines = 0;
    joinContent.text = @"随便都行";
    
    NSDictionary *attr = @{NSFontAttributeName: [UIFont systemFontOfSize:14]};
    CGSize size = [joinContent.text boundingRectWithSize:CGSizeMake(UI_View_Height - 50, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attr context:nil].size;
    joinContent.frame = CGRectMake(37, 145, UI_View_Width - 50, size.height);
    _autoHeight += size.height;
    
    scrollView.contentSize = CGSizeMake(0,20 + ruleView.origin.y + self.view.height / 3 + _autoHeight);
    ruleView.frame = CGRectMake(0, grabBtn.origin.y + grabBtn.size.height + 30, UI_View_Width, self.view.height / 2.5 + _autoHeight);
    scrollView.showsVerticalScrollIndicator = NO;


    [redView addSubview:redTotal];
    [scrollView addSubview:redView];
    [scrollView addSubview:grabView];
    [scrollView addSubview:timeLbl];
    [scrollView addSubview:prizeLbl];
    [scrollView addSubview:grabBtn];
    [scrollView addSubview:ruleView];
    [ruleView addSubview:ruleImg];
    [ruleView addSubview:ruleFlag];
    [ruleView addSubview:rule2Flag];
    [ruleView addSubview:timeLabel];
    [ruleView addSubview:timeContent];
    [ruleView addSubview:joinLabel];
    [ruleView addSubview:joinContent];
    [scrollView addSubview:ruleView];
    [self.view addSubview:scrollView];
    
}

//抢一抢点击事件
- (void)grabBtbClick:(HemaButton *)sender {
    _backView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, UI_View_Width, UI_View_Height+80)];
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    _backView.image = [UIImage imageNamed:@"np_blackView"];
    [window addSubview:_backView];
    _backView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeBackView:)];
    [_backView addGestureRecognizer:tapGR];
    
    //成功
    UIImageView *redView = [[UIImageView alloc] init];
    redView.frame = CGRectMake(0, 0, UI_View_Width / 1.5, self.view.height / 3);
    redView.center = CGPointMake(self.view.width / 2, self.view.height / 2);
    redView.image = [UIImage imageNamed:@"hp_qiangred"];
    redView.userInteractionEnabled = YES;
    
    //失败
    UIImageView *failView = [[UIImageView alloc] init];
    failView.frame = CGRectMake(0, 0, UI_View_Width / 1.5, self.view.height / 3.5);
    failView.center = CGPointMake(self.view.width / 2, self.view.height / 2);
    failView.image = [UIImage imageNamed:@"hp_fail"];
    failView.userInteractionEnabled = YES;
    
    UILabel *titleLbl = [[UILabel alloc] init];
    titleLbl.frame = CGRectMake(0, redView.size.height - 40, redView.size.width, 40);
    titleLbl.font = [UIFont systemFontOfSize:13];
    titleLbl.textColor = BB_Blake_Color;
    titleLbl.textAlignment = NSTextAlignmentCenter;
    NSString *replaceStr = [NSString stringWithFormat:@"%zd",1000];
    NSString *totalStr = [NSString stringWithFormat:@"红包金额%@元",replaceStr];
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:totalStr];
    NSRange range = [totalStr rangeOfString:replaceStr];
    [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:19] range:range];
    [attrStr addAttribute:NSForegroundColorAttributeName value:BB_Red_Color range:range];
    titleLbl.attributedText = attrStr;
    
    [redView addSubview:titleLbl];
    [_backView addSubview:redView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)closeBackView:(UITapGestureRecognizer *)gesture {
    [_backView removeFromSuperview];
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
