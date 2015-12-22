//
//  RHomeVC.m
//  Hema
//
//  Created by LarryRodic on 15/10/5.
//  Copyright (c) 2015年 Hemaapp. All rights reserved.
//

#import "RHomeVC.h"
#import "RInforVC.h"

#import "SGFocusImageFrame.h"
#import "SGFocusImageItem.h"
#import "HemaWebVC.h"
#import "RWDropdownMenu.h"

@interface RHomeVC ()<SGFocusImageFrameDelegate>
@property(nonatomic,strong)NSMutableArray *dataImg;//轮播图片
@property(nonatomic,strong)NSArray *menuItems;//分享菜单样式
@end

@implementation RHomeVC
@synthesize dataImg;

-(void)loadSet
{
    [self.navigationItem setNewTitle:@"首页"];
    [self.navigationItem setLeftItemWithTarget:self action:@selector(leftbtnPressed:) title:@"通知"];
    [self.navigationItem setRightItemWithTarget:self action:@selector(rightbtnPressed:) image:@"shareBig.png"];
}
-(void)loadData
{
    [self requestQualityList];
}
#pragma mark- 自定义
#pragma mark 事件
-(void)leftbtnPressed:(id)sender
{
    NSString *myStr = @"有所思而已";
    [SystemFunction postMessage:myStr];
    
    //语言播报
    AVSpeechSynthesizer *synthesizer = [[AVSpeechSynthesizer alloc] init];
    AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:@"收拾起大地山河一担装，四大皆空相。历尽了渺渺程途，漠漠平林，叠叠高山，滚滚长江。但见那寒云惨雾和愁织，受不尽苦雨凄风带怨长。雄城壮，看江山无恙，谁识我一瓢一笠到襄阳？"];
    utterance.rate = 0.1;
    utterance.pitchMultiplier = 1;
    [synthesizer speakUtterance:utterance];
}
-(void)rightbtnPressed:(id)sender
{
    if (!_menuItems)
    {
        _menuItems =
        @[
          [RWDropdownMenuItem itemWithText:@"Twitter" image:[UIImage imageNamed:@"share_twitter.png"] action:nil],
          [RWDropdownMenuItem itemWithText:@"Facebook" image:[UIImage imageNamed:@"share_facebook.png"] action:nil],
          [RWDropdownMenuItem itemWithText:@"Message" image:[UIImage imageNamed:@"share_message.png"] action:nil],
          [RWDropdownMenuItem itemWithText:@"Email" image:[UIImage imageNamed:@"share_email.png"] action:nil],
          [RWDropdownMenuItem itemWithText:@"Save to Photo Album" image:[UIImage imageNamed:@"share_album.png"] action:nil],
          ];
    }
    RWDropdownMenuCellAlignment alignment = RWDropdownMenuCellAlignmentRight;
    [RWDropdownMenu presentFromViewController:self withItems:self.menuItems align:alignment style:RWDropdownMenuStyleBlackGradient navBarImage:[UIImage imageNamed:@"share.png"] completion:nil];
    
}
#pragma mark 方法
//广告位添加
-(void)createAdView
{
    UIView *myView = [[UIView alloc]init];
    [myView setFrame:CGRectMake(0, 0, UI_View_Width, 165*UI_View_Width/320)];
    
    //创建无限循环轮播图
    SGFocusImageFrame *bannerView = [[SGFocusImageFrame alloc] initWithFrame:CGRectMake(0, 0, myView.width, myView.height) delegate:self imageItems:nil isAuto:YES];
    [myView addSubview:bannerView];
    [self.view addSubview:myView];
    
    int length = (int)dataImg.count;
    NSMutableArray *tempArray = [NSMutableArray array];
    for (int i = 0 ; i < length; i++)
    {
        NSMutableDictionary *dict = [dataImg objectAtIndex:i];
        [tempArray addObject:dict];
    }
    
    NSMutableArray *itemArray = [NSMutableArray arrayWithCapacity:length+2];
    //添加最后一张图 用于循环
    if (length > 1)
    {
        NSMutableDictionary *dict = [tempArray objectAtIndex:length-1];
        SGFocusImageItem *item = [[SGFocusImageItem alloc] initWithDict:dict tag:-1];
        [itemArray addObject:item];
    }
    for (int i = 0; i < length; i++)
    {
        NSMutableDictionary *dict = [tempArray objectAtIndex:i];
        SGFocusImageItem *item = [[SGFocusImageItem alloc] initWithDict:dict tag:i];
        [itemArray addObject:item];
    }
    //添加第一张图 用于循环
    if (length >1)
    {
        NSMutableDictionary *dict = [tempArray objectAtIndex:0];
        SGFocusImageItem *item = [[SGFocusImageItem alloc] initWithDict:dict tag:length];
        [itemArray addObject:item];
    }
    
    [bannerView changeImageViewsContent:itemArray];
}
#pragma mark - SGFocusImageFrameDelegate
- (void)foucusImageFrame:(SGFocusImageFrame *)imageFrame didSelectItem:(SGFocusImageItem *)item
{
    HemaWebVC *web = [[HemaWebVC alloc]init];
    web.urlPath = [NSString stringWithFormat:@"%@webview/parm/ad/id/%@",[[[HemaManager sharedManager] myInitInfor] objectForKey:@"sys_web_service"],[item.myDic objectForKey:@"id"]];
    web.objectTitle = @"详情";
    web.isAdgust = NO;
    [self.navigationController pushViewController:web animated:YES];
}
#pragma mark- 连接服务器
#pragma mark 广告位
- (void)requestQualityList
{
    NSString *token = [[HemaManager sharedManager] userToken];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:token forKey:@"token"];
    [dic setObject:@"1" forKey:@"keytype"];
    
    [HemaRequest requestWithURL:[NSString stringWithFormat:@"%@%@",REQUEST_MAINLINK,REQUEST_AD_LIST] target:self selector:@selector(responseQualityList:) parameter:dic];
}
- (void)responseQualityList:(NSDictionary*)info
{
    if(1 == [[info objectForKey:@"success"] intValue])
    {
        if(![HemaFunction xfunc_check_strEmpty:[[info objectForKey:@"infor"]objectForKey:@"listItems"]])
        {
            if (!dataImg)
                dataImg = [[NSMutableArray alloc]init];
            [dataImg removeAllObjects];
            
            NSMutableArray *temArr = [[info objectForKey:@"infor"]objectForKey:@"listItems"];
            
            for (int i = (int)(temArr.count-1); i<temArr.count; i--)
            {
                NSMutableDictionary *dict = [SystemFunction getDicFromDic:[temArr objectAtIndex:i]];
                [dataImg addObject:dict];
            }
        }
        if (dataImg.count != 0)
        {
            [self createAdView];
        }
    }else
    {
        [HemaFunction openIntervalHUD:[info objectForKey:@"msg"]];
    }
}
@end
