//
//  HomePageVC.m
//  Hema
//
//  Created by MsTail on 15/12/23.
//  Copyright © 2015年 Hemaapp. All rights reserved.
//

#import "HomePageVC.h"
#import "PrizeMsgVC.h"
#import "ShareVC.h"
#import "ClassifyVC.h"
#import "goodsRedVC.h"
#import "FAQVC.h"
#import "SumbitOrderVC.h"
#import "SearchVC.h"
#import "NoticeVC.h"

@interface HomePageVC ()

@property (nonatomic,copy) NSMutableArray *dataSource;
@property (nonatomic,copy) NSMutableArray *imgSource;
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,strong) NSTimer *prizeTimer;


@end

@implementation HomePageVC
@synthesize dataSource;
@synthesize imgSource;



- (void)loadSet {
    
    //导航item设置
    [self.navigationItem setRightItemWithTarget:self action:@selector(msgClick:) image:@"hp_msg"];
    [self.navigationItem setLeftItemWithTarget:self action:@selector(searchClick:) image:@"hp_search"];
    
    //titleView
    HemaImgView *titleImg = [[HemaImgView alloc] init];
    titleImg.frame = CGRectMake(0, 0, 50, 20);
    titleImg.image = [UIImage imageNamed:@"lg_title"];
    [self.navigationItem setTitleView:titleImg];
    
    [self.mytable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.mytable setBackgroundColor:BB_Back_Color_Here];
    [self reSetTableViewFrame:CGRectMake(0, 0, UI_View_Width, self.view.height - 100)];
    //轮播定时器
    _timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(topScrollViewPass) userInfo:nil repeats:YES];
    _prizeTimer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(prizeViewPass) userInfo:nil repeats:YES];
}

- (void)loadData {
    
    imgSource = [[NSMutableArray alloc] init];
    [imgSource addObjectsFromArray:@[@"newpulish",@"newpulish",@"newpulish",@"newpulish"]];
    [self.mytable reloadData];
}

#pragma mark - tableView代理事件

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 3;
    }
    if (section == 2) {
        return 2;
    }
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *sepView = [[UIView alloc] init];
    sepView.frame = CGRectMake(0, 0, UI_View_Width, 5);
    sepView.backgroundColor = [UIColor colorWithRed:255.0/255 green:245.0/255 blue:243.0/255 alpha:1];
    return sepView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if  (indexPath.row == 0) {
            return 210;
        }
        if (indexPath.row == 1) {
            return 101;
        }
        if (indexPath.row == 2) {
            return 80;
        }
    }
    if (indexPath.section == 1) {
        return 40;
    }
    return 230;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell  = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //轮播cell
    switch (indexPath.section) {
        case 0:{
            if (indexPath.row == 0) {
                //添加scrollView和pageControl
                UIScrollView *top = [[UIScrollView alloc] init];
                [top setFrame:CGRectMake(0, 0, UI_View_Width, 210)];
                top.contentSize = CGSizeMake(UI_View_Width * 4, 0);
                top.tag = 1;
                top.pagingEnabled = YES;
                top.showsHorizontalScrollIndicator = NO;
                top.delegate = self;
                
                UIPageControl *topControl = [[UIPageControl alloc] init];
                
                [topControl setFrame:CGRectMake(self.view.width / 2 - 45, 180 , 90, 30)];
                topControl.numberOfPages = 4;
                topControl.currentPage = 0;
                topControl.tag = 2;
                topControl.currentPageIndicatorTintColor = BB_Orange_Color;
                topControl.pageIndicatorTintColor = BB_Gray_Color;
                [cell.contentView addSubview:top];
                [cell.contentView addSubview:topControl];
                
                //添加轮播图片
                for (int i = 0; i < imgSource.count; i++) {
                    UIImageView *img = [[UIImageView alloc] init];
                    [img setFrame:CGRectMake(i * UI_View_Width, 0, UI_View_Width, 210)];
                    [img setImage:[UIImage imageNamed:imgSource[i]]];
                    [top addSubview:img];
                }
            }
            if (indexPath.row == 1) {
                //添加分类按钮
                NSArray *typeArr = @[@"hp_type",@"hp_red",@"hp_share",@"hp_quest"];
                for (int i = 0; i < 4; i++) {
                    
                    HemaButton *typeBtn = [[HemaButton alloc] init];
                    typeBtn.frame = CGRectMake(self.view.width / 10 + i * self.view.width / 4.5 , 15, 45, 70);
                    if (i == 3) {
                        typeBtn.frame = CGRectMake(self.view.width / 10 + i * self.view.width / 4.5 , 15, 50, 70);
                    }
                    [typeBtn setImage:[UIImage imageNamed:typeArr[i]] forState:UIControlStateNormal];
                    typeBtn.tag = 50 + i;
                    [typeBtn addTarget:self action:@selector(typeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                    [cell.contentView addSubview:typeBtn];
                }
                //分割线
                UILabel *sepLbl = [[UILabel alloc] init];
                sepLbl.frame = CGRectMake(10, 100, UI_View_Width, 1);
                sepLbl.backgroundColor = BB_Gray_Color;
                sepLbl.alpha = 0.5;
                [cell.contentView addSubview:sepLbl];
            }
            if (indexPath.row == 2) {
                cell.userInteractionEnabled = NO;
                HemaImgView *prizeImg = [[HemaImgView alloc] init];
                prizeImg.frame = CGRectMake(15, 15, 65, 17);
                prizeImg.image = [UIImage imageNamed:@"hp_prize"];
                [cell.contentView addSubview:prizeImg];
                
                UILabel *prizeTime = [[UILabel alloc] init];
                prizeTime.frame = CGRectMake(self.view.width - 100, 15, 90, 20);
                prizeTime.text = @"2015-12-03";
                prizeTime.font = [UIFont systemFontOfSize:15];
                prizeTime.textColor = BB_Gray_Color;
                [cell.contentView addSubview:prizeTime];
                
                //中奖轮播Cell
                UIScrollView *prizeView = [[UIScrollView alloc] init];
                prizeView.frame = CGRectMake(15, 45, UI_View_Width - 30, 20);
                prizeView.contentSize = CGSizeMake(0, 20 * 5);
                prizeView.pagingEnabled = YES;
                prizeView.showsVerticalScrollIndicator = NO;
                prizeView.delegate = self;
                prizeView.tag = 3;
                [cell.contentView addSubview:prizeView];
                
                //中奖信息Label 属性字符串
                for (int i = 0; i < 5; i++) {
                    UILabel *prizeLbl = [[UILabel alloc] init];
                    prizeLbl.frame = CGRectMake(0, i * 20, UI_View_Width - 30, 20);
                    prizeLbl.font = [UIFont systemFontOfSize:14];
                    prizeLbl.textColor = BB_Blake_Color;
                    NSString *NubString = [NSString stringWithFormat:@"182****%zd",arc4random()%9999];
                    NSString *prizeText =[NSString stringWithFormat:@"%@  获得超级无敌牛逼%d英寸电视",NubString,i];
                    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:prizeText];
                    NSRange range = [prizeText rangeOfString:NubString];
                    UIColor *color = BB_Blue_Color;
                    [attrString addAttribute:NSForegroundColorAttributeName value:color range:range];
                    prizeLbl.attributedText = attrString;
                    [prizeView addSubview:prizeLbl];
                }
            }
            
            }
            
            break;
            
        //排序Item
        case 1:{
            
            NSArray * titleArr = @[@"人气",@"剩余",@"最新",@"总需"];
            for (int i = 0; i < 4; i++) {
                
                HemaButton *itemBtn = [[HemaButton alloc] init];
                itemBtn.frame = CGRectMake(self.view.width / 10 + i * self.view.width / 4.5 , -7, 45, 50);
                [itemBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
                [itemBtn setTitleColor:BB_Gray_Color forState:UIControlStateNormal];
                if (i == 0) {
                     [itemBtn setTitleColor:BB_Red_Color forState:UIControlStateNormal];
                }
                if (i == 3) {
                    HemaImgView *upImg = [[HemaImgView alloc] init];
                    upImg.frame = CGRectMake(itemBtn.origin.x + itemBtn.size.width, 12, 7, 4);
                    upImg.image = [UIImage imageNamed:@"hp_up"];
                    HemaImgView *downImg = [[HemaImgView alloc] init];
                    downImg.frame = CGRectMake(itemBtn.origin.x + itemBtn.size.width, 19, 7, 4);
                    downImg.image = [UIImage imageNamed:@"hp_down"];
                    [cell.contentView addSubview:upImg];
                    [cell.contentView addSubview:downImg];
                }
                [itemBtn setTitle:titleArr[i] forState:UIControlStateNormal];
                itemBtn.tag = 10 + i;
                [itemBtn addTarget:self action:@selector(itemBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                [cell.contentView addSubview:itemBtn];
            }
        }
            break;
        case 2:{
            
            cell.backgroundColor = [UIColor colorWithRed:255.0/255 green:245.0/255 blue:243.0/255 alpha:1];
            //左右视图
            UIView *leftView = [[UIView alloc] init];
            UIView *rightView = [[UIView alloc] init];
            leftView.userInteractionEnabled = YES;
            rightView.userInteractionEnabled = YES;
            [leftView setBackgroundColor:[UIColor whiteColor]];
            [rightView setBackgroundColor:[UIColor whiteColor]];
            [leftView setFrame:CGRectMake(UI_View_Width / 32, 0, UI_View_Width / 2.2, 220)];
            [rightView setFrame:CGRectMake(UI_View_Width / 2.2 + UI_View_Width / 17, 0, UI_View_Width / 2.2, 220)];
            
            //iconView
            HemaImgView *limgView = [[HemaImgView alloc] init];
            [limgView setFrame:CGRectMake(0, 0, leftView.bounds.size.width, 150)];
            limgView.image = [UIImage imageNamed:@"newpulish"];
            
            //名称label
            UILabel *lnameLabel = [[UILabel alloc] init];
            [lnameLabel setFrame:CGRectMake(10, 155, UI_View_Width / 3, 20)];
            [lnameLabel setFont:[UIFont systemFontOfSize:14]];
            lnameLabel.text = @"超级无敌手机";
            
            //开奖进度label
            UILabel *lprizeLabel = [[UILabel alloc] init];
            [lprizeLabel setFrame:CGRectMake(10, 180, UI_View_Width / 3, 20)];
            [lprizeLabel setFont:[UIFont systemFontOfSize:12]];
            [lprizeLabel setTextColor:[UIColor grayColor]];
            
            NSString *prizeText = @"开奖进度83%";
            NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:prizeText];
            NSRange range = [prizeText rangeOfString:@"开奖进度"];
            NSRange replaceRange = NSMakeRange(range.location + range.length, 3);
            UIColor *color = BB_Blue_Color;
            [attrString addAttribute:NSForegroundColorAttributeName value:color range:replaceRange];
            lprizeLabel.attributedText = attrString;
            
            //开奖进度条
            UIView *backView = [[UIView alloc] init];
            backView.frame = CGRectMake(10, 200, UI_View_Width / 5, 5);
            backView.backgroundColor = RGB_UI_COLOR(208, 208, 208);
            backView.alpha = 0.5;
            
            UIView *frontView = [[UIView alloc] init];
            frontView.frame = CGRectMake(10, 200, (UI_View_Width / 5) * 0.83, 5);
            frontView.backgroundColor = RGB_UI_COLOR(248, 190, 24);
            frontView.alpha = 0.5;
            
            //购物车图标
            HemaButton *cartBtn = [[HemaButton alloc] init];
            cartBtn.frame = CGRectMake(leftView.size.width - 42, 180, 32, 32);
            [cartBtn setBackgroundImage:[UIImage imageNamed:@"hp_cart"] forState:UIControlStateNormal];
            
            HemaImgView *rimgView = [[HemaImgView alloc] init];
            [rimgView setFrame:CGRectMake(0, 0, rightView.bounds.size.width, 150)];
            rimgView.image = [UIImage imageNamed:@"newpulish"];
            
            UILabel *rnameLabel = [[UILabel alloc] init];
            [rnameLabel setFrame:CGRectMake(10, 155, UI_View_Width / 3, 20)];
            [rnameLabel setFont:[UIFont systemFontOfSize:14]];
            rnameLabel.text = @"超级辣鸡手机";
            
            //开奖进度label
            UILabel *rprizeLabel = [[UILabel alloc] init];
            [rprizeLabel setFrame:CGRectMake(10, 180, UI_View_Width / 3, 20)];
            rprizeLabel.font = [UIFont systemFontOfSize:12];
            [rprizeLabel setTextColor:[UIColor grayColor]];
            
            NSString *rprizeText = @"开奖进度83%";
            NSMutableAttributedString *rattrString = [[NSMutableAttributedString alloc] initWithString:rprizeText];
            NSRange rrange = [rprizeText rangeOfString:@"开奖进度"];
            NSRange rreplaceRange = NSMakeRange(rrange.location + rrange.length, 3);
            UIColor *rcolor = BB_Blue_Color;
            [rattrString addAttribute:NSForegroundColorAttributeName value:rcolor range:rreplaceRange];
            rprizeLabel.attributedText = rattrString;
            
            //开奖进度条
            UIView *rbackView = [[UIView alloc] init];
            rbackView.frame = CGRectMake(10, 200, UI_View_Width / 5, 5);
            rbackView.backgroundColor = RGB_UI_COLOR(208, 208, 208);
            rbackView.alpha = 0.5;
            
            UIView *rfrontView = [[UIView alloc] init];
            rfrontView.frame = CGRectMake(10, 200, (UI_View_Width / 5) * 0.83, 5);
            rfrontView.backgroundColor =  RGB_UI_COLOR(248, 190, 24);
            rfrontView.alpha = 0.5;
            
            //购物车图标
            HemaButton *rcartBtn = [[HemaButton alloc] init];
            rcartBtn.frame = CGRectMake(leftView.size.width - 42, 180, 32, 32);
            [rcartBtn setBackgroundImage:[UIImage imageNamed:@"hp_cart"] forState:UIControlStateNormal];
            
            [leftView addSubview:limgView];
            [leftView addSubview:lnameLabel];
            [leftView addSubview:lprizeLabel];
            [leftView addSubview:backView];
            [leftView addSubview:frontView];
            [leftView addSubview:cartBtn];
            
            [rightView addSubview:rimgView];
            [rightView addSubview:rnameLabel];
            [rightView addSubview:rprizeLabel];
            [rightView addSubview:rbackView];
            [rightView addSubview:rfrontView];
            [rightView addSubview:rcartBtn];
            
            [cell.contentView addSubview:leftView];
            [cell.contentView addSubview:rightView];
            
            if (HM_ISIPHONE4 || HM_ISIPHONE5) {
                [lprizeLabel setFont:[UIFont systemFontOfSize:12]];
                [rprizeLabel setFont:[UIFont systemFontOfSize:12]];
            }
            
            UITapGestureRecognizer *leftTapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(leftViewClick:)];
            [leftView addGestureRecognizer:leftTapGR];
            UITapGestureRecognizer *rightTapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rightViewClick:)];
            [rightView addGestureRecognizer:rightTapGR];
        }
            break;
}
    return cell;
}

#pragma mark - 自定义事件

//导航消息item点击事件
- (void)msgClick:(HemaButton *)sender {
    NoticeVC *noticeVC = [[NoticeVC alloc] init];
    [self.navigationController pushViewController:noticeVC animated:YES];
//    PrizeMsgVC *msgVC = [[PrizeMsgVC alloc] init];
//    [self.navigationController pushViewController:msgVC animated:YES];
}

//导航搜索item点击事件
- (void)searchClick:(HemaButton *)sender {
    SearchVC *searchVC = [[SearchVC alloc] init];
    [self.navigationController pushViewController:searchVC animated:YES];
}

//分类按钮点击事件
- (void)typeBtnClick:(HemaButton *)sender {
    switch (sender.tag - 50) {
        case 0:{
            ClassifyVC *classifyVC = [[ClassifyVC alloc] init];
            [self.navigationController pushViewController:classifyVC animated:YES];
        }
            break;
        case 1:{
            goodsRedVC *RedVC = [[goodsRedVC alloc] init];
            [self.navigationController pushViewController:RedVC animated:YES];
        }
            break;
        case 2:{
            ShareVC *shareVC = [[ShareVC alloc] init];
            [self.navigationController pushViewController:shareVC animated:YES];
        }
            break;
        case 3:{
            FAQVC *faqVC = [[FAQVC alloc] init];
            [self.navigationController pushViewController:faqVC animated:YES];
        }
            break;
        default:
            break;
    }
}

//排序Item点击事件
- (void)itemBtnClick:(HemaButton *)sender {
    HemaButton *itemOne = (HemaButton *)[self.view viewWithTag:10];
    HemaButton *itemTwo = (HemaButton *)[self.view viewWithTag:11];
    HemaButton *itemThree = (HemaButton *)[self.view viewWithTag:12];
    HemaButton *itemFour = (HemaButton *)[self.view viewWithTag:13];
    switch (sender.tag) {
            //人气
        case 10:{
            [sender setTitleColor:BB_Red_Color forState:UIControlStateNormal];
            [itemTwo setTitleColor:BB_Gray_Color forState:UIControlStateNormal];
            [itemThree setTitleColor:BB_Gray_Color forState:UIControlStateNormal];
            [itemFour setTitleColor:BB_Gray_Color forState:UIControlStateNormal];
        }
            break;
            //剩余
        case 11:{
            [sender setTitleColor:BB_Red_Color forState:UIControlStateNormal];
            [itemOne setTitleColor:BB_Gray_Color forState:UIControlStateNormal];
            [itemThree setTitleColor:BB_Gray_Color forState:UIControlStateNormal];
            [itemFour setTitleColor:BB_Gray_Color forState:UIControlStateNormal];
        }
            break;
            //最新
        case 12:{
            [sender setTitleColor:BB_Red_Color forState:UIControlStateNormal];
            [itemOne setTitleColor:BB_Gray_Color forState:UIControlStateNormal];
            [itemTwo setTitleColor:BB_Gray_Color forState:UIControlStateNormal];
            [itemFour setTitleColor:BB_Gray_Color forState:UIControlStateNormal];
        }
            break;
            //总需
        case 13:{
            [sender setTitleColor:BB_Red_Color forState:UIControlStateNormal];
            [itemOne setTitleColor:BB_Gray_Color forState:UIControlStateNormal];
            [itemTwo setTitleColor:BB_Gray_Color forState:UIControlStateNormal];
            [itemThree setTitleColor:BB_Gray_Color forState:UIControlStateNormal];
          
        }
            break;

    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



//定时器广告轮播方法
- (void)topScrollViewPass {
    
    UIPageControl *control = (id)[self.view viewWithTag:2];
    UIScrollView *scrollView = (id)[self.view viewWithTag:1];
    [UIView animateWithDuration:1 animations:^{
        CGPoint contentSet = CGPointMake(scrollView.contentOffset.x + UI_View_Width, 0);
        scrollView.contentOffset = contentSet;
        
        control.currentPage = scrollView.contentOffset.x / UI_View_Width;
        if (contentSet.x == scrollView.contentSize.width) {
            scrollView.contentOffset = CGPointMake(0, 0);
        }
    }];
}

//定时器中奖信息轮播
- (void)prizeViewPass {
    
    UIScrollView *prizeView = (id)[self.view viewWithTag:3];
    
    [UIView animateWithDuration:1 animations:^{
        CGPoint prizeSet = CGPointMake(0, prizeView.contentOffset.y + 20);
        prizeView.contentOffset = prizeSet;
        if (prizeSet.y == prizeView.contentSize.height) {
            prizeView.contentOffset = CGPointMake(0, 0);
        }
    }];

}

#pragma mark - scrollView代理方法

//停止定时器
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [super scrollViewWillBeginDragging:scrollView];
    
    if (1 == scrollView.tag) {
        [_timer invalidate];
    }
}

//拖动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [super scrollViewDidScroll:scrollView];
    
    if (1 == scrollView.tag) {
        UIPageControl *control = (id)[self.view viewWithTag:2];
        if (scrollView.contentOffset.x + UI_View_Width > scrollView.contentSize.width) {
//            scrollView.contentOffset = CGPointMake(0, 0);
//            control.currentPage = 0;
        } else {
        control.currentPage = scrollView.contentOffset.x / UI_View_Width;
        }
    }
    
}

//开启定时器

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (1 == scrollView.tag) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(topScrollViewPass) userInfo:nil repeats:YES];
    }
    
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
