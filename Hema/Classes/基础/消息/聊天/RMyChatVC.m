//
//  RMyChatVC.m
//  Hema
//
//  Created by LarryRodic on 15/10/10.
//  Copyright (c) 2015年 Hemaapp. All rights reserved.
//
#define padding 10//列表里面的左右推进距离
#define myPad 15//列表里面的上下推进距离
#define kDefaultToolbarHeight 44//默认的toolbar的高度
#define PageNum 3//表情键盘的页数
#define downHeight 121//底部高度

#import "RMyChatVC.h"
#import "RWeiChatCell.h"

#import "UIImageView+MJWebCache.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"

#import "HPGrowingTextView.h"
#import "ChatToolBar.h"
#import "FacialView.h"
#import "HemaTapGR.h"
#import "HemaSwipeGR.h"
#import "HemaLongGR.h"
#import "RRecordView.h"
#import "RInforVC.h"
#import "RChatSetVC.h"
#import "RGroupSetVC.h"

#import <sqlite3.h>
#import "lame.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <MediaPlayer/MPMoviePlayerController.h>
#import <QuartzCore/QuartzCore.h>

@interface RMyChatVC ()<AVAudioPlayerDelegate,facialViewDelegate,UITextViewDelegate,HPGrowingTextViewDelegate>
{
    NSInteger myCount;//列表的个数 refresh方法时调用
    NSInteger rowClick;//点击的按钮第几个
    NSInteger mySecond;//音频、视频时长
    
    BOOL isPlay;//是否有音频在播放
    NSInteger audioRow;//播放音频的是哪个row
    
    BOOL isWillRefresh;//加载测试用
    NSInteger numberCopy;//复制的row
    
    BOOL isVoice;//是否切换到录音界面
    NSTimer *mytime;//录音定时器
}
@property(nonatomic,copy)NSString *databasePath;
@property(nonatomic,strong)NSMutableArray *dataSourceChat;//数据源
@property(nonatomic,strong)ChatToolBar *bottomToolBar;//底部条
@property(nonatomic,strong)HPGrowingTextView *myTextView;//输入框
@property(nonatomic,copy)NSString *chatter;//聊天对象的jid
@property(nonatomic,copy)NSString *chatterJidStr;//聊天对象的jid字符串 形如:18660180519@124.128.23.75

//以下暂时未封装到ChatToolBar里面 以后慢慢封装 现在没时间弄
@property(nonatomic,strong)UIView *downView;//底部的view
@property(nonatomic,strong)AVAudioPlayer *myaudioPlayer;//音频播放器

@property(nonatomic,strong)UIScrollView *emoScrollView;//表情滚动视图
@property(nonatomic,strong)UIPageControl *emoPageControl;

@property(nonatomic,strong)UIButton *voiceBtn;//语音按钮
@property(nonatomic,strong)UIButton *okBtn;//发送按钮
@property(nonatomic,strong)UIButton *middleBtn;//中间长按录音的按钮
@property(nonatomic,strong)AVAudioRecorder *audioRecorder;//录音
@property(nonatomic,strong)RRecordView *middleView;//录音时中间显示的状态view 可以单独写一个类进行控制
@end

@implementation RMyChatVC
@synthesize dataSource;
@synthesize dataSourceChat;
@synthesize bottomToolBar;
@synthesize myTextView;
@synthesize chatter;
@synthesize chatterJidStr;
@synthesize isChatGroup;
@synthesize downView;
@synthesize myaudioPlayer;
@synthesize emoScrollView;
@synthesize emoPageControl;
@synthesize voiceBtn;
@synthesize okBtn;
@synthesize middleBtn;
@synthesize audioRecorder;
@synthesize middleView;

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:BB_NOTIFICATION_GET_MESSAGE object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:BB_NOTIFICATION_SEND_MESSAGE object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:BB_NOTIFICATION_NOSEND_MESSAGE object:nil];
}
- (instancetype)initWithChatter:(NSString *)p_chatter
{
    self = [super initWithNibName:nil bundle:nil];
    if (self)
    {
        chatter = p_chatter;
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *server = [defaults objectForKey:BB_XCONST_Chat_Server];
        chatterJidStr = [NSString stringWithFormat:@"%@@%@",chatter,server];
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //监听键盘通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    [dataSourceChat removeAllObjects];
    [self refresh];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [self setLocalIsRead];
    
    if (isPlay)
    {
        [self stopPlay];
    }
    [self touchesAction];
    [super viewWillDisappear:animated];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadSet];
    [self loadData];
}
-(void)loadSet
{
    //导航
    [self.navigationItem setRightItemWithTarget:self action:@selector(rightbtnPressed:) image:@"R聊天右导航设置按钮.png"];
    
    if (isChatGroup)
    {
        [self.navigationItem setNewTitle:[dataSource objectForKey:@"name"]];
    }else
    {
        [self.navigationItem setNewTitle:[dataSource objectForKey:@"nickname"]];
    }
    
    [self.mytable setFrame:CGRectMake(0, 0, UI_View_Width, UI_View_Height-kDefaultToolbarHeight)];
    
    //---------------------------添加底部功具栏---------------------------
    bottomToolBar = [[ChatToolBar alloc] initWithFrame:CGRectMake(0, UI_View_Height-kDefaultToolbarHeight, UI_View_Width, kDefaultToolbarHeight)];
    [bottomToolBar setBackgroundColor:RGB_UI_COLOR(237, 237, 237)];
    [bottomToolBar setUserInteractionEnabled:YES];
    [self.view addSubview:bottomToolBar];
    
    //可以自适应高度的文本输入框
    myTextView = [[HPGrowingTextView alloc] initWithFrame:CGRectMake(53, (kDefaultToolbarHeight-32)/2, UI_View_Width-146, 32)];
    myTextView.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(4.0f, 0.0f, 10.0f, 0.0f);
    myTextView.delegate = self;
    myTextView.internalTextView.returnKeyType = UIReturnKeySend;
    myTextView.maxNumberOfLines = 5;
    [myTextView setBackgroundColor:BB_White_Color];
    myTextView.internalTextView.enablesReturnKeyAutomatically = YES;
    [bottomToolBar addSubview:myTextView];
    
    //加号按钮
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addBtn setFrame:CGRectMake(UI_View_Width-40, 6, 30, 30)];
    [addBtn setBackgroundImage:[UIImage imageNamed:@"R聊天之加号按钮.png"] forState:UIControlStateNormal];
    [addBtn addTarget:self action:@selector(gotoAdd:) forControlEvents:UIControlEventTouchUpInside];
    [bottomToolBar addSubview:addBtn];
    
    //表情按钮
    UIButton *smileBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [smileBtn setFrame:CGRectMake(UI_View_Width-82, 6, 30, 30)];
    [smileBtn setBackgroundImage:[UIImage imageNamed:@"R聊天之切换表情按钮.png"] forState:UIControlStateNormal];
    [smileBtn addTarget:self action:@selector(gotoEmo:) forControlEvents:UIControlEventTouchUpInside];
    [bottomToolBar addSubview:smileBtn];
    
    //语音按钮
    voiceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [voiceBtn setFrame:CGRectMake(10, 6, 30, 30)];
    [voiceBtn setBackgroundImage:[UIImage imageNamed:@"R聊天之切换语音按钮.png"] forState:UIControlStateNormal];
    [voiceBtn addTarget:self action:@selector(gotoVoice:) forControlEvents:UIControlEventTouchUpInside];
    [bottomToolBar addSubview:voiceBtn];
    
    //添加收到消息的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getMessage:) name:BB_NOTIFICATION_GET_MESSAGE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendMessage:) name:BB_NOTIFICATION_SEND_MESSAGE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshMessage:) name:BB_NOTIFICATION_NOSEND_MESSAGE object:nil];
    
    //----------------底部View
    downView = [[UIView alloc]init];
    [downView setFrame:CGRectMake(0, UI_View_Height, UI_View_Width, downHeight)];
    [downView setBackgroundColor:BB_Back_Color_Here];
    [self.view addSubview:downView];
    
    UIView *line = [[UIView alloc]init];
    [line setFrame:CGRectMake(0, 0, UI_View_Width, 0.5)];
    [line setBackgroundColor:BB_lineColor];
    [downView addSubview:line];
    
    NSMutableArray *picArr = [[NSMutableArray alloc]initWithObjects:@"R聊天之图片.png",@"R聊天之拍照.png",@"R聊天之短视频.png",@"R聊天之录像.png", nil];
    NSMutableArray *nameArr = [[NSMutableArray alloc]initWithObjects:@"图片",@"拍照",@"视频",@"录像", nil];
    
    float middlewidth = (UI_View_Width-63*4)/5;
    for (int i = 0; i<4; i++)
    {
        HemaButton *downBtn = [HemaButton buttonWithType:UIButtonTypeCustom];
        downBtn.btnRow = i;
        [downBtn setFrame:CGRectMake(middlewidth+(63+middlewidth)*(i%4), 15+(63+43)*(i/4), 63, 63)];
        [downBtn addTarget:self action:@selector(bottomBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        [downView addSubview:downBtn];
        
        UIImageView *temImgView = [[UIImageView alloc]init];
        [temImgView setImage:[UIImage imageNamed:[picArr objectAtIndex:i]]];
        [temImgView setFrame:CGRectMake(0, 0, 63, 63)];
        [downBtn addSubview:temImgView];
        
        UILabel *labDown = [[UILabel alloc]init];
        [labDown setFont:[UIFont boldSystemFontOfSize:14]];
        [labDown setBackgroundColor:[UIColor clearColor]];
        [labDown setTextAlignment:NSTextAlignmentCenter];
        [labDown setTextColor:BB_Gray_Color];
        [labDown setText:[nameArr objectAtIndex:i]];
        [labDown setFrame:CGRectMake(middlewidth+(63+middlewidth)*(i%4), 87+(63+43)*(i/4) ,63, 16)];
        [downView addSubview:labDown];
    }
}
-(void)loadData
{
    audioRow = 0;
    _databasePath = [SystemFunction openDataBase];
    if (!dataSourceChat)
        dataSourceChat = [[NSMutableArray alloc]init];
    if (isChatGroup)
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *server = [defaults objectForKey:BB_XCONST_Chat_Server];
        chatterJidStr = [NSString stringWithFormat:@"%@@broadcast.%@",chatter,server];
    }
    //id与client_id相同
    if ([HemaFunction xfunc_check_strEmpty:[dataSource objectForKey:@"id"]])
    {
        if (![HemaFunction xfunc_check_strEmpty:[dataSource objectForKey:@"client_id"]])
        {
            [dataSource setObject:[dataSource objectForKey:@"client_id"] forKey:@"id"];
        }
    }
    [self refresh];
}
- (BOOL)canBecomeFirstResponder
{
    return YES;
}
#pragma mark- 自定义
#pragma mark 事件
-(void)rightbtnPressed:(id)sender
{
    if (isChatGroup)
    {
        RGroupSetVC *myVC = [[RGroupSetVC alloc]init];
        myVC.groupId = [dataSource objectForKey:@"id"];
        [self.navigationController pushViewController:myVC animated:YES];
    }else
    {
        RChatSetVC *myVC = [[RChatSetVC alloc]init];
        myVC.userId = [dataSource objectForKey:@"id"];
        [self.navigationController pushViewController:myVC animated:YES];
    }
}
//右侧加号按钮
-(void)gotoAdd:(id)sender
{
    [self voiceNoShow];
    
    [self.mytable setUserInteractionEnabled:NO];
    [myTextView resignFirstResponder];
    
    [SystemFunction actionActive];
    bottomToolBar.frame = CGRectMake(0, UI_View_Height-bottomToolBar.frame.size.height-downHeight,UI_View_Width,bottomToolBar.frame.size.height);
    downView.frame = CGRectMake(0, UI_View_Height-downHeight,UI_View_Width,downHeight);
    [UIView commitAnimations];
    
    [self tableViewMoved];
    
    [emoScrollView setFrame:CGRectMake(0, 0, UI_View_Width, 216)];
    [emoPageControl setFrame:CGRectMake(0, 216-30, UI_View_Width, 30)];
    [emoScrollView setHidden:YES];
    [emoPageControl setHidden:YES];
    [okBtn setHidden:YES];
}
//切换语音与键盘
-(void)gotoVoice:(id)sender
{
    if (isVoice)
    {
        [self voiceNoShow];
        [myTextView becomeFirstResponder];
        return;
    }else
    {
        isVoice = YES;
        [self touchesAction];
        
        if (!middleBtn)
        {
            middleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [middleBtn setFrame:CGRectMake(53, 6, UI_View_Width-146, 32)];
            [middleBtn setBackgroundColor:RGB_UI_COLOR(237, 237, 237)];
            [middleBtn setTitle:@"按住  说话" forState:UIControlStateNormal];
            [middleBtn setTitleColor:RGB_UI_COLOR(107, 105, 106) forState:UIControlStateNormal];
            [middleBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
            [HemaFunction addbordertoView:middleBtn radius:4.0 width:0.5 color:BB_Blake_Color];
            [bottomToolBar addSubview:middleBtn];
            
            HemaLongGR *myLong = [[HemaLongGR alloc]initWithTarget:self action:@selector(voiceLongPress:)];
            myLong.minimumPressDuration = 0.5;
            [middleBtn addGestureRecognizer:myLong];
        }
        
        [myTextView setHidden:YES];
        [middleBtn setHidden:NO];
        
        [voiceBtn setBackgroundImage:[UIImage imageNamed:@"R聊天之切换键盘按钮.png"] forState:UIControlStateNormal];
    }
}
//回复确定按钮
-(void)gotoOK:(id)sender
{
    if ([HemaFunction xfunc_check_strEmpty:myTextView.text])
    {
        return;
    }
    NSString *myStr = myTextView.text;
    [myTextView setText:@""];
    [self sendText:myStr];
}
//单击去个人资料
-(void)gotoOwnerTap:(HemaTapGR*)sender
{
    NSMutableDictionary *dict  = [dataSourceChat objectAtIndex:sender.touchRow];
    
    RInforVC *infor = [[RInforVC alloc]init];
    infor.userId = [dict objectForKey:@"fromjid"];
    [self.navigationController pushViewController:infor animated:YES];
}
//长按@某人
-(void)atMember:(HemaLongGR*)sender
{
    if(sender.state == UIGestureRecognizerStateBegan)
    {
        if (isVoice)
        {
            [self voiceNoShow];
            [myTextView becomeFirstResponder];
        }
        NSMutableDictionary *dict  = [dataSourceChat objectAtIndex:sender.touchRow];
        myTextView.text = [NSString stringWithFormat:@"%@@%@",myTextView.text,[dict objectForKey:@"dxclientname"]];
        [myTextView becomeFirstResponder];
    }
}
//长按录音
-(void)voiceLongPress:(HemaLongGR*)sender
{
    CGPoint point = [sender locationInView:self.middleBtn];
    if(sender.state == UIGestureRecognizerStateBegan)
    {
        if (!middleView)
        {
            middleView = [[RRecordView alloc]initWithFrame:CGRectMake((UI_View_Width-140)/2, 130, 140, 140)];
            [HemaFunction addbordertoView:middleView radius:6 width:0 color:[UIColor clearColor]];
            [self.view addSubview:middleView];
        }
        [middleView setHidden:NO];
        [middleView recordButtonTouchDown];
        
        [middleBtn setBackgroundColor:RGB_UI_COLOR(200, 200, 200)];
        [middleBtn setTitle:@"松开  发送" forState:UIControlStateNormal];
        
        mySecond = 0;
        mytime = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerSet:) userInfo:nil repeats:YES];
        [self startRecording];
    }
    if(sender.state == UIGestureRecognizerStateChanged)
    {
        if (point.y<-150)
        {
            [middleBtn setBackgroundColor:RGB_UI_COLOR(237, 237, 237)];
            [middleBtn setTitle:@"按住  说话" forState:UIControlStateNormal];
            
            [middleView recordButtonDragOutside];
        }else
        {
            [middleBtn setBackgroundColor:RGB_UI_COLOR(200, 200, 200)];
            [middleBtn setTitle:@"松开  发送" forState:UIControlStateNormal];
            
            [middleView recordButtonDragInside];
        }
    }
    if(sender.state == UIGestureRecognizerStateEnded)
    {
        [middleView setHidden:YES];
        [mytime invalidate];mytime = nil;
        
        [middleBtn setBackgroundColor:RGB_UI_COLOR(237, 237, 237)];
        [middleBtn setTitle:@"按住  说话" forState:UIControlStateNormal];
        
        if (point.y<-150)
        {
            //取消发送
            [audioRecorder stop];
            [middleView recordButtonTouchUpOutside];
        }else
        {
            //发送
            [middleView recordButtonTouchUpInside];
            if (mySecond == 0)
            {
                [HemaFunction openIntervalHUD:@"录音时间太短"];
            }else
            {
                rowClick = 0;
                waitMB = [HemaFunction openHUD:@"正在发送"];
                [self performSelector:@selector(audio_PCMtoMP3) withObject:nil afterDelay:0.2];
            }
        }
    }
}
//长按内容（复制、删除）
-(void)longPress:(HemaLongGR*)sender
{
    if(sender.state == UIGestureRecognizerStateBegan)
    {
        numberCopy = sender.touchRow;
        [self becomeFirstResponder];
        
        if (sender.touchI == 1)
        {
            UIMenuItem *flag = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(mycopy:)];
            UIMenuItem *flag1 = [[UIMenuItem alloc] initWithTitle:@"删除" action:@selector(myDelete:)];
            UIMenuController *menu = [UIMenuController sharedMenuController];
            [menu setMenuItems:[NSArray arrayWithObjects:flag,flag1, nil]];
            [menu setTargetRect:sender.view.frame inView:sender.view.superview];
            [menu setMenuVisible:YES animated:YES];
        }else
        {
            UIMenuItem *flag1 = [[UIMenuItem alloc] initWithTitle:@"删除" action:@selector(myDelete:)];
            UIMenuController *menu = [UIMenuController sharedMenuController];
            [menu setMenuItems:[NSArray arrayWithObjects:flag1, nil]];
            [menu setTargetRect:sender.view.frame inView:sender.view.superview];
            [menu setMenuVisible:YES animated:YES];
        }
    }
}
//列表点击
-(void)tapPress:(HemaTapGR*)sender
{
    if (sender.touchI == 1)
    {
        //文字无处理
    }
    if (sender.touchI == 2)
    {
        int count = 1;
        // 1.封装图片数据
        NSMutableArray *photos = [NSMutableArray arrayWithCapacity:count];
        
        RWeiChatCell *cell = (RWeiChatCell *)[self.mytable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:sender.touchRow inSection:0]];
        
        // 替换为中等尺寸图片
        NSString *url = [[dataSourceChat objectAtIndex:sender.touchRow] objectForKey:@"dxdetail"];
        MJPhoto *photo = [[MJPhoto alloc] init];
        photo.url = [NSURL URLWithString:url]; // 图片路径
        photo.srcImageView = (UIImageView*)cell.messageImgView; // 来源于哪个UIImageView
        [photos addObject:photo];
        
        // 2.显示相册
        MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
        browser.currentPhotoIndex = 0; // 弹出相册时显示的第一张图片是？
        browser.photos = photos; // 设置所有的图片
        [browser show];
    }
    if (sender.touchI == 3)//音频
    {
        if (isPlay)
        {
            [self stopPlay];
            if (sender.touchRow == audioRow)
            {
                return;
            }
        }
        audioRow = sender.touchRow;
        mySecond = 0;
        
        NSString *audiourl = [[dataSourceChat objectAtIndex:audioRow] objectForKey:@"body"];
        if(![HemaFunction xfunc_check_strEmpty:audiourl])
        {
            //检测本地缓存是否存在 不存在就缓存 然后播放在线流
            NSString *document = [NSString stringWithFormat:@"%@/%@",BB_CASH_DOCUMENT,BB_CASH_AUDIO];
            BOOL ismyExist = [[HemaCashManager sharedManager] downloadAVFromDocumentORURL:document url:audiourl];
            if (ismyExist)
            {
                [self playRecordingExist:audioRow];
            }else
            {
                //下载音频
                [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(downloadOK:) userInfo:nil repeats:NO];
            }
        }
    }
    if (sender.touchI == 4)//视频
    {
        NSMutableDictionary *temDic = [dataSourceChat objectAtIndex:sender.touchRow];
        
        //播放在线流
        MPMoviePlayerViewController* playerView = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL URLWithString:[temDic objectForKey:@"body"]]];
        [playerView shouldAutorotate];
        [self presentViewController:playerView animated:YES completion:nil];
    }
}
//重新发送
-(void)reSendButtonPressed:(HemaButton*)sender
{
    NSMutableDictionary *dict = [dataSourceChat objectAtIndex:sender.btnRow];
    
    //先删除源数据
    NSString *deleteSQL = [NSString stringWithFormat:@"delete from message where ID = '%@'",[dict objectForKey:@"id"]];
    [SystemFunction exceSQL:deleteSQL];
    
    [dataSourceChat removeObjectAtIndex:sender.btnRow];
    
    //文字
    if ([[dict objectForKey:@"dxpacktype"]integerValue] == 1)
    {
        NSString *msg = [dict objectForKey:@"dxdetail"];
        [self sendText:msg];
    }
    //图片
    if ([[dict objectForKey:@"dxpacktype"]integerValue] == 2)
    {
        [self sendAll:[dict objectForKey:@"dxdetail"] temUrl:[dict objectForKey:@"body"] packtype:@"2"];
    }
    //语音
    if ([[dict objectForKey:@"dxpacktype"]integerValue] == 3)
    {
        [self sendAll:[dict objectForKey:@"dxdetail"] temUrl:[dict objectForKey:@"body"] packtype:@"3"];
    }
    //视频
    if ([[dict objectForKey:@"dxpacktype"]integerValue] == 4)
    {
        [self sendAll:[dict objectForKey:@"dxdetail"] temUrl:[dict objectForKey:@"body"] packtype:@"4"];
    }
}
//底部选项
-(void)bottomBtnPressed:(HemaButton*)sender
{
    rowClick = sender.btnRow+1;
    switch (sender.btnRow)
    {
        case 0://图片
        {
            [SystemFunction pickerAlbums:self allowsEditing:NO];
            break;
        }
        case 1://拍照
        {
            [SystemFunction pickerCamere:self allowsEditing:NO];
            break;
        }
        case 2://视频
        {
            [SystemFunction pickerMedia:self];
            break;
        }
        case 3://录像
        {
            [SystemFunction pickerVideo:self];
            break;
        }
        default:
            break;
    }
}
//查看大图与播放音频
-(void)gotoBig:(HemaButton*)sender
{
    if ([sender.btnId integerValue] == 1)
    {
        //复制文字
        numberCopy = sender.btnRow;
        [self becomeFirstResponder];
        UIMenuItem *flag = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(mycopy:)];
        UIMenuItem *flag1 = [[UIMenuItem alloc] initWithTitle:@"删除" action:@selector(myDelete:)];
        UIMenuController *menu = [UIMenuController sharedMenuController];
        [menu setMenuItems:[NSArray arrayWithObjects:flag,flag1, nil]];
        [menu setTargetRect:sender.frame inView:sender.superview];
        [menu setMenuVisible:YES animated:YES];
    }
    if ([sender.btnId integerValue] == 2)
    {
        int count = 1;
        NSMutableArray *photos = [NSMutableArray arrayWithCapacity:count];
        
        NSString *url = [[dataSourceChat objectAtIndex:sender.btnRow] objectForKey:@"dxdetail"];
        MJPhoto *photo = [[MJPhoto alloc] init];
        photo.url = [NSURL URLWithString:url];
        photo.srcImageView = (UIImageView*)[self.mytable viewWithTag:sender.btnRow+100];
        [photos addObject:photo];
        
        MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
        browser.currentPhotoIndex = 0;
        browser.photos = photos;
        [browser show];
    }
    if ([sender.btnId integerValue] == 3)//音频
    {
        if (isPlay)
        {
            [self stopPlay];
            if (sender.btnRow == audioRow)
            {
                return;
            }
        }
        audioRow = sender.btnRow;
        mySecond = 0;
        
        NSString *audiourl = [[dataSourceChat objectAtIndex:audioRow] objectForKey:@"body"];
        if(![HemaFunction xfunc_check_strEmpty:audiourl])
        {
            //检测本地缓存是否存在 不存在就缓存
            NSString *document = [NSString stringWithFormat:@"%@/%@",BB_CASH_DOCUMENT,BB_CASH_AUDIO];
            BOOL ismyExist = [[HemaCashManager sharedManager] downloadAVFromDocumentORURL:document url:audiourl];
            if (ismyExist)
            {
                [self playRecordingExist:audioRow];
            }else
            {
                //下载音频
                [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(downloadOK:) userInfo:nil repeats:NO];
            }
        }
    }
    if ([sender.btnId integerValue] == 4)//视频
    {
        NSMutableDictionary *temDic = [dataSourceChat objectAtIndex:sender.btnRow];
        
        MPMoviePlayerViewController* playerView = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL URLWithString:[temDic objectForKey:@"body"]]];
        [playerView shouldAutorotate];
        [self presentViewController:playerView animated:YES completion:nil];
    }
}
//下载音频计时器
-(void)downloadOK:(NSTimer*)sender
{
    [sender invalidate];
    NSString *audiourl = [[dataSourceChat objectAtIndex:audioRow] objectForKey:@"body"];
    if(![HemaFunction xfunc_check_strEmpty:audiourl])
    {
        //检测本地缓存是否存在 不存在就缓存 然后播放在线流
        NSString *document = [NSString stringWithFormat:@"%@/%@",BB_CASH_DOCUMENT,BB_CASH_AUDIO];
        BOOL ismyExist = [[HemaCashManager sharedManager] downloadAVFromDocumentORURL:document url:audiourl];
        if (ismyExist)
        {
            [self playRecordingExist:audioRow];
        }else
        {
            //下载音频
            [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(downloadOK:) userInfo:nil repeats:YES];
        }
    }
}
//拷贝
-(void)mycopy:(UIMenuItem*)sender
{
    [[UIPasteboard generalPasteboard] setString:[[dataSourceChat objectAtIndex:numberCopy] objectForKey:@"body"]];
    
    UIMenuController *menu = [UIMenuController sharedMenuController];
    [menu setMenuItems:nil];
}
//删除
-(void)myDelete:(UIMenuItem*)sender
{
    NSMutableDictionary *temDic = [dataSourceChat objectAtIndex:numberCopy];
    NSString *insertSQL = [NSString stringWithFormat:@"DELETE FROM message WHERE rowid = '%@'",[temDic objectForKey:@"rowid"]];
    [SystemFunction exceSQL:insertSQL];
    
    //后续动作
    [dataSourceChat removeObjectAtIndex:numberCopy];
    [self.mytable deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:numberCopy inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    numberCopy = -1;
    [NSTimer scheduledTimerWithTimeInterval:0.4 target:self selector:@selector(timerSetNotice:) userInfo:nil repeats:NO];
    
    UIMenuController *menu = [UIMenuController sharedMenuController];
    [menu setMenuItems:nil];
}
//定时器
-(void)timerSetNotice:(NSTimer*)sender
{
    [self reShowView];
}
//定时器方法
-(void)timerSet:(NSTimer*)sender
{
    mySecond++;
}
//去选择表情
-(void)gotoEmo:(id)sender
{
    [self voiceNoShow];
    [self.mytable setUserInteractionEnabled:NO];
    [myTextView resignFirstResponder];
    
    [SystemFunction actionActive];
    bottomToolBar.frame = CGRectMake(0, UI_View_Height-bottomToolBar.frame.size.height-216,UI_View_Width,bottomToolBar.frame.size.height);
    downView.frame = CGRectMake(0, UI_View_Height-216,UI_View_Width,216);
    [UIView commitAnimations];
    
    [self tableViewMoved];
    
    if (!emoScrollView)
    {
        [self createEmo];
    }
    
    [emoScrollView setFrame:CGRectMake(0, 0, UI_View_Width, 216)];
    [emoPageControl setFrame:CGRectMake(0, 216-30, UI_View_Width, 30)];
    [emoScrollView setHidden:NO];
    [emoPageControl setHidden:NO];
    [okBtn setHidden:NO];
}
//切换表情
-(void)changeEmoPage:(id)sender
{
    int page = (int)emoPageControl.currentPage;
    [emoScrollView setContentOffset:CGPointMake(UI_View_Width * page, 0)];
}
#pragma mark 方法
//语音状态消失
-(void)voiceNoShow
{
    isVoice = NO;
    [myTextView setHidden:NO];
    [middleBtn setHidden:YES];
    
    [voiceBtn setBackgroundImage:[UIImage imageNamed:@"R聊天之切换语音按钮.png"] forState:UIControlStateNormal];
}
//创建表情
-(void)createEmo
{
    //创建表情键盘
    if (emoScrollView == nil)
    {
        emoScrollView=[[UIScrollView alloc] init];
        [emoScrollView setBackgroundColor:RGB_UI_COLOR(246, 246, 248)];
        for (int i = 0; i < PageNum; i++)
        {
            FacialView *fview = [[FacialView alloc] initWithFrame:CGRectMake(12+UI_View_Width*i, 15, UI_View_Width-24, 170)];
            [fview setBackgroundColor:[UIColor clearColor]];
            [fview loadFacialView:i size:CGSizeMake((UI_View_Width-23)/9, 43)];
            fview.delegate = self;
            [emoScrollView addSubview:fview];
        }
    }
    [emoScrollView setShowsVerticalScrollIndicator:NO];
    [emoScrollView setShowsHorizontalScrollIndicator:NO];
    emoScrollView.contentSize = CGSizeMake(UI_View_Width*PageNum, 216);
    emoScrollView.pagingEnabled = YES;
    emoScrollView.delegate = self;
    [downView addSubview:emoScrollView];
    
    if (emoPageControl == nil)
    {
        emoPageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, 216-30, UI_View_Width, 30)];
        [emoPageControl setCurrentPage:0];
        emoPageControl.pageIndicatorTintColor = RGB_UI_COLOR(195, 179, 163);
        emoPageControl.currentPageIndicatorTintColor = RGB_UI_COLOR(132, 104, 77);
        emoPageControl.numberOfPages = PageNum;
        [emoPageControl setBackgroundColor:[UIColor clearColor]];
        [emoPageControl addTarget:self action:@selector(changeEmoPage:)forControlEvents:UIControlEventValueChanged];
        [downView addSubview:emoPageControl];
    }
    
    [emoScrollView setFrame:CGRectMake(0, 0, UI_View_Width, 216)];
    [emoPageControl setFrame:CGRectMake(0, 216-30, UI_View_Width, 30)];
    
    //发送按钮
    if (!okBtn)
    {
        okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [okBtn setFrame:CGRectMake(UI_View_Width-56, 184, 50, 25)];
        [okBtn setBackgroundColor:BB_White_Color];
        [HemaFunction addbordertoView:okBtn radius:3.0f width:0.5f color:BB_Gray_Color];
        [okBtn addTarget:self action:@selector(gotoOK:) forControlEvents:UIControlEventTouchUpInside];
        [downView addSubview:okBtn];
        
        UILabel *labLogin = [[UILabel alloc]init];
        [labLogin setFont:[UIFont systemFontOfSize:14]];
        [labLogin setBackgroundColor:[UIColor clearColor]];
        [labLogin setTextAlignment:NSTextAlignmentCenter];
        [labLogin setTextColor:BB_Gray_Color];
        [labLogin setText:@"发送"];
        [labLogin setFrame:CGRectMake(0, 0 ,50, 25)];
        [okBtn addSubview:labLogin];
    }
}
//停止播放
-(void)stopPlay
{
    [myaudioPlayer stop];myaudioPlayer = nil;
    
    [[dataSourceChat objectAtIndex:audioRow] setObject:@"0" forKey:@"isPlayRecord"];
    [self.mytable reloadData];
    
    isPlay = NO;
}
//播放录音 本地
-(void)playRecordingExist:(NSInteger)HereRow
{
    NSString *temAudioName = [[HemaCashManager sharedManager] liGetImgNameFromURL:[[dataSourceChat objectAtIndex:HereRow] objectForKey:@"body"]];
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [paths objectAtIndex:0];
    NSString *soundFilePath = [docsDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%@/%@",BB_CASH_DOCUMENT,BB_CASH_AUDIO,temAudioName]];
    NSURL *url = [NSURL fileURLWithPath:soundFilePath];
    
    NSError *error;
    myaudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    myaudioPlayer.numberOfLoops = 0;
    myaudioPlayer.delegate = self;
    [myaudioPlayer play];
    isPlay = YES;
    
    [[dataSourceChat objectAtIndex:audioRow] setObject:@"1" forKey:@"isPlayRecord"];
    [self.mytable reloadData];
}
//置本地为已读
- (void)setLocalIsRead
{
    NSString *updateSQL = nil;
    if (isChatGroup)
    {
        updateSQL = [NSString stringWithFormat:@"update message set isread = 1 where dxgroupid = '%@' and owner = '%@'",[dataSource objectForKey:@"id"],[HemaFunction xfuncGetAppdelegate].xmppStream.myJID.user];
    }else
    {
        updateSQL = [NSString stringWithFormat:@"update message set isread = 1 where talker = '%@' and owner = '%@'",[dataSource objectForKey:@"id"],[HemaFunction xfuncGetAppdelegate].xmppStream.myJID.user];
    }
    [SystemFunction exceSQL:updateSQL];
}
//table 移动 到最底部
- (void)tableViewMoved
{
    [self.mytable reloadData];
    CGRect rect = bottomToolBar.frame;
    self.mytable.contentInset = UIEdgeInsetsMake(0, 0, UI_View_Height- rect.origin.y-kDefaultToolbarHeight, 0);
    
    if(dataSourceChat.count>0)
        [self.mytable selectRowAtIndexPath:[NSIndexPath indexPathForRow:dataSourceChat.count-1 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionBottom];
}
//获取当前xmpp
- (XMPPStream*)getCurrentXmpp
{
    AppDelegate*appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    XMPPStream *xmppStream = appDelegate.xmppStream;
    return xmppStream;
}
//产生随机数
- (NSString*)generateUUID
{
    AppDelegate*appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSString *uuid = [appDelegate.xmppStream generateUUID];
    return uuid;
}
//录音格式的转换 从caf转换成mp3
- (void)audio_PCMtoMP3
{
    if (!waitMB)
    {
        waitMB = [HemaFunction openHUD:@"正在发送"];
    }
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [paths objectAtIndex:0];
    NSString *cafFilePath = [docsDir stringByAppendingPathComponent:@"recordTest.caf"];;
    NSString *mp3FilePath = [docsDir stringByAppendingPathComponent:@"myupload.mp3"];
    
    NSFileManager* fileManager=[NSFileManager defaultManager];
    if([fileManager removeItemAtPath:mp3FilePath error:nil])
    {
        
    }
    @try {
        int read, write;
        
        FILE *pcm = fopen([cafFilePath cStringUsingEncoding:1], "rb");  //source 被转换的音频文件位置
        fseek(pcm, 4*1024, SEEK_CUR);                                   //skip file header
        FILE *mp3 = fopen([mp3FilePath cStringUsingEncoding:1], "wb");  //output 输出生成的Mp3文件位置
        
        const int PCM_SIZE = 8192;
        const int MP3_SIZE = 8192;
        short int pcm_buffer[PCM_SIZE*2];
        unsigned char mp3_buffer[MP3_SIZE];
        
        lame_t lame = lame_init();
        lame_set_in_samplerate(lame, 11025.0);
        lame_set_VBR(lame, vbr_default);
        lame_init_params(lame);
        do {
            read = (int)fread(pcm_buffer, 2*sizeof(short int), PCM_SIZE, pcm);
            if (read == 0)
                write = lame_encode_flush(lame, mp3_buffer, MP3_SIZE);
            else
                write = lame_encode_buffer_interleaved(lame, pcm_buffer, read, mp3_buffer, MP3_SIZE);
            
            fwrite(mp3_buffer, write, 1, mp3);
            
        } while (read != 0);
        
        lame_close(lame);
        fclose(mp3);
        fclose(pcm);
    }
    @catch (NSException *exception)
    {
        [HemaFunction closeHUD:waitMB];
    }
    @finally
    {
        NSData *temData = [NSData dataWithContentsOfFile:mp3FilePath];
        [self requestPublishFile:@"8" keyid:@"0" orderby:@"0" data:temData];
    }
}
//视频格式转换
-(void)encodeToMp4:(NSURL*)temUrl
{
    waitMB = [HemaFunction openHUD:@"正在发送"];
    
    //删除视频
    NSArray *dirPaths1 = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *docsDir1 = [dirPaths1 objectAtIndex:0];
    
    NSString *cafFilePath1 = [docsDir1 stringByAppendingPathComponent:@"videoTest.mp4"];;
    NSFileManager* fileManager=[NSFileManager defaultManager];
    if([fileManager removeItemAtPath:cafFilePath1 error:nil])
    {
        
    }
    NSURL *videoURL = temUrl;
    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:videoURL options:nil];
    AVAssetExportSession *exportSession = [[AVAssetExportSession alloc]initWithAsset:avAsset presetName:AVAssetExportPresetMediumQuality];
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    NSString *mp4Path = [docsDir stringByAppendingPathComponent:@"videoTest.mp4"];;
    
    exportSession.outputURL = [NSURL fileURLWithPath: mp4Path];
    exportSession.shouldOptimizeForNetworkUse = YES;
    exportSession.outputFileType = AVFileTypeMPEG4;
    [exportSession exportAsynchronouslyWithCompletionHandler:^{
        switch ([exportSession status]) {
            case AVAssetExportSessionStatusFailed:
            {
                [HemaFunction closeHUD:waitMB];
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                message:[[exportSession error] localizedDescription]
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles: nil];
                [alert show];
                break;
            }
            case AVAssetExportSessionStatusCancelled:
            {
                [HemaFunction closeHUD:waitMB];
                break;
            }
            case AVAssetExportSessionStatusCompleted:
            {
                AVAudioSession *audioSession = [AVAudioSession sharedInstance];
                [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
                
                NSData *temData = [NSData dataWithContentsOfFile:mp4Path];
                [self performSelectorOnMainThread:@selector(converted:) withObject:temData waitUntilDone:NO];
                break;
            }
            default:
            {
                [HemaFunction closeHUD:waitMB];
                break;
            }
        }
    }];
}
//视频格式转换结束
-(void)converted:(NSData*)temData
{
    [self requestPublishFile:@"9" keyid:@"0" orderby:@"0" data:temData];
}
//开始录音
-(void)startRecording
{
    [self deleteRecord];
    
    audioRecorder = nil;
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryRecord error:nil];
    
    NSMutableDictionary *recordSettings = [[NSMutableDictionary alloc] initWithCapacity:10];
    NSNumber *formatObject = [NSNumber numberWithInt: kAudioFormatMPEG4AAC];
    [recordSettings setObject:formatObject forKey: AVFormatIDKey];
    [recordSettings setObject:[NSNumber numberWithFloat:44100.0] forKey: AVSampleRateKey];
    [recordSettings setObject:[NSNumber numberWithInt:2] forKey:AVNumberOfChannelsKey];
    [recordSettings setObject:[NSNumber numberWithInt:12800] forKey:AVEncoderBitRateKey];
    [recordSettings setObject:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
    [recordSettings setObject:[NSNumber numberWithInt: AVAudioQualityHigh] forKey: AVEncoderAudioQualityKey];
    
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    
    NSString *soundFilePath = [docsDir stringByAppendingPathComponent:@"recordTest.caf"];
    
    NSURL *url = [NSURL fileURLWithPath:soundFilePath];
    
    NSError *error = nil;
    
    //录音设置
    NSMutableDictionary *settings = [[NSMutableDictionary alloc] init];
    //录音格式 无法使用
    [settings setValue :[NSNumber numberWithInt:kAudioFormatLinearPCM] forKey: AVFormatIDKey];
    //采样率
    [settings setValue :[NSNumber numberWithFloat:11025.0] forKey: AVSampleRateKey];//44100.0
    //通道数
    [settings setValue :[NSNumber numberWithInt:2] forKey: AVNumberOfChannelsKey];
    //线性采样位数
    //[recordSettings setValue :[NSNumber numberWithInt:16] forKey: AVLinearPCMBitDepthKey];
    //音频质量,采样质量
    [settings setValue:[NSNumber numberWithInt:AVAudioQualityMin] forKey:AVEncoderAudioQualityKey];
    
    audioRecorder = [[ AVAudioRecorder alloc] initWithURL:url settings:settings error:&error];
    audioRecorder.meteringEnabled = YES;
    if ([audioRecorder prepareToRecord] == YES)
    {
        audioRecorder.meteringEnabled = YES;
        [audioRecorder record];
        middleView.recorder = audioRecorder;
    }
}
//删除录音文件
-(void)deleteRecord
{
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    NSString *MapLayerDataPath = [docsDir stringByAppendingPathComponent:@"recordTest.caf"];
    BOOL bRet = [fileMgr fileExistsAtPath:MapLayerDataPath];
    if (bRet)
    {
        NSError *err;
        [fileMgr removeItemAtPath:MapLayerDataPath error:&err];
    }
}
#pragma mark - FacialViewDelegate
-(void)selectedFacialView:(NSString*)str
{
    NSString *newStr;
    if ([str isEqualToString:@"删除"])
    {
        if (myTextView.text.length > 0)
        {
            if ([[Emoji allEmoji] containsObject:[myTextView.text substringFromIndex:myTextView.text.length-2]])
            {
                newStr = [myTextView.text substringToIndex:myTextView.text.length-2];
            }else
            {
                newStr = [myTextView.text substringToIndex:myTextView.text.length-1];
            }
            myTextView.text = newStr;
        }
    }else
    {
        int location = (int)myTextView.selectedRange.location;
        NSString *content = myTextView.text;
        NSString *result = [NSString stringWithFormat:@"%@%@%@",[content substringToIndex:location],str,[content substringFromIndex:location]];
        myTextView.text = result;
        [myTextView setSelectedRange:NSMakeRange(location+2, 0)];
    }
}
#pragma mark- 声音播放委托
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [self stopPlay];
}
- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error
{
    [self stopPlay];
}
#pragma mark- UIImagePicker Delegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [SystemFunction fixPick:navigationController myVC:viewController];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //图片or拍照
    if (1 == rowClick||2 == rowClick)
    {
        waitMB = [HemaFunction openHUD:@"正在发送"];
        
        UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        image = [HemaFunction getImage:image];
        NSData *temData = UIImageJPEGRepresentation(image, 0.8);
        [self requestPublishFile:@"7" keyid:@"0" orderby:@"0" data:temData];
    }
    //视频or拍摄
    if (3 == rowClick||4 == rowClick)
    {
        NSURL *temUrl = info[UIImagePickerControllerMediaURL];
        mySecond = [HemaFunction getVideoDuration:temUrl];
        
        [self encodeToMp4:temUrl];
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
}
#pragma mark - 消息通知
//获取了消息
- (void)getMessage:(NSNotification*)notification
{
    NSDictionary *temDic = [notification userInfo];
    if(isChatGroup)
    {
        NSString *temTopicID = [temDic objectForKey:@"dxgroupid"];
        if([temTopicID isEqualToString:[dataSource objectForKey:@"id"]])
            [self loadNewMessage];
    }else
    {
        NSString *temMobile = [temDic objectForKey:@"talker"];
        if([temMobile isEqualToString:[dataSource objectForKey:@"id"]])
        {
            [self loadNewMessage];
        }
    }
}
//发送成功了消息
- (void)sendMessage:(NSNotification*)notification
{
    NSDictionary *temDic = [notification userInfo];
    for (NSMutableDictionary *myDic in dataSourceChat)
    {
        if ([[myDic objectForKey:@"id"] isEqualToString:[temDic objectForKey:@"temID"]])
        {
            [myDic setObject:@"1" forKey:@"issend"];
            break;
        }
    }
    //更新页面
    [self.mytable reloadData];
}
//发送失败
- (void)refreshMessage:(NSNotification*)notification
{
    NSDictionary *temDic = [notification userInfo];
    for (NSMutableDictionary *myDic in dataSourceChat)
    {
        if ([[myDic objectForKey:@"id"] isEqualToString:[temDic objectForKey:@"temID"]])
        {
            [myDic setObject:@"2" forKey:@"issend"];
            break;
        }
    }
    [self.mytable reloadData];
}
#pragma mark- 图片/语音/视频 发送处理
//发送图片/语音/视频
-(void)sendAll:(NSString*)temUrlBig temUrl:(NSString*)temUrl packtype:(NSString*)packtype
{
    //封装
    NSString *nickName = [[[HemaManager sharedManager]myInfor]objectForKey:@"nickname"];
    NSString *avatar = [[[HemaManager sharedManager]myInfor]objectForKey:@"avatar"];
    
    NSMutableDictionary *paraDic = [[NSMutableDictionary alloc] init];
    if (isChatGroup)
    {
        [paraDic setObject:packtype forKey:@"dxpacktype"];
        [paraDic setObject:@"1" forKey:@"dxclientype"];
        [paraDic setObject:nickName?nickName:@"" forKey:@"dxclientname"];
        [paraDic setObject:avatar?avatar:@"" forKey:@"dxclientavatar"];
        [paraDic setObject:[dataSource objectForKey:@"id"] forKey:@"dxgroupid"];
        [paraDic setObject:[dataSource objectForKey:@"name"] forKey:@"dxgroupname"];
        [paraDic setObject:@"" forKey:@"dxgroupavatar"];
        [paraDic setObject:temUrlBig forKey:@"dxdetail"];
        [paraDic setObject:[NSString stringWithFormat:@"%@,",[[[HemaManager sharedManager]myInfor]objectForKey:@"team_id"]?[[[HemaManager sharedManager]myInfor]objectForKey:@"team_id"]:@""] forKey:@"dxextend"];
    }else
    {
        [paraDic setObject:packtype forKey:@"dxpacktype"];
        [paraDic setObject:@"1" forKey:@"dxclientype"];
        [paraDic setObject:nickName?nickName:@"" forKey:@"dxclientname"];
        [paraDic setObject:avatar?avatar:@"" forKey:@"dxclientavatar"];
        [paraDic setObject:@"0" forKey:@"dxgroupid"];
        [paraDic setObject:@"" forKey:@"dxgroupname"];
        [paraDic setObject:@"" forKey:@"dxgroupavatar"];
        [paraDic setObject:temUrlBig forKey:@"dxdetail"];
        [paraDic setObject:[NSString stringWithFormat:@"%@,",[[[HemaManager sharedManager]myInfor]objectForKey:@"team_id"]?[[[HemaManager sharedManager]myInfor]objectForKey:@"team_id"]:@""] forKey:@"dxextend"];
    }
    [self sendAll:temUrlBig properties:paraDic temUrl:temUrl packtype:packtype];
}
- (void)sendAll:(NSString*)msg properties:(NSMutableDictionary*)properties temUrl:(NSString*)temUrl packtype:(NSString*)packtype
{
    XMPPStream *temStream = [self getCurrentXmpp];
    
    NSXMLElement *message = [NSXMLElement elementWithName:@"message"];
    [message addAttributeWithName:@"type" stringValue:@"chat"];
    XMPPJID *myJID = temStream.myJID;//fromJID
    NSString* myJidStr = [myJID full];
    [message addAttributeWithName:@"from" stringValue:myJidStr];
    NSString *uuid = [self generateUUID];//messageID
    NSString *temID = [uuid substringToIndex:8];
    [message addAttributeWithName:@"id" stringValue:temID];
    [message addAttributeWithName:@"to" stringValue:chatterJidStr];
    
    NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
    [body setStringValue:temUrl];
    [message addChild:body];
    NSXMLElement *pro = [self generateProperties:properties];
    [message addChild:pro];
    
    [temStream sendElement:message];
    
    NSString *insertSQL = nil;
    //存入数据库
    if(isChatGroup)//如果群聊
    {
        insertSQL = [NSString stringWithFormat:@"INSERT INTO message (id,owner,talker,fromjid,tojid,body,regdate,dxpacktype,dxclientype,dxclientname,dxclientavatar,dxgroupid,dxgroupname,dxgroupavatar,dxdetail,dxextend,isread,issend,talkername,talkeravatar,isdelete) VALUES('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')",temID,[[[HemaManager sharedManager]myInfor]objectForKey:@"id"],[dataSource objectForKey:@"id"],[[[HemaManager sharedManager]myInfor]objectForKey:@"id"],@"",temUrl,[HemaFunction getStringNow],packtype,@"1",[[[HemaManager sharedManager]myInfor]objectForKey:@"nickname"],[[[HemaManager sharedManager]myInfor]objectForKey:@"avatar"],[dataSource objectForKey:@"id"],[dataSource objectForKey:@"name"],@"",msg,[NSString stringWithFormat:@"%@,",[[[HemaManager sharedManager]myInfor]objectForKey:@"team_id"]?[[[HemaManager sharedManager]myInfor]objectForKey:@"team_id"]:@""],@"1",@"0",@"",@"",@"0"];
    }else
    {
        insertSQL = [NSString stringWithFormat:@"INSERT INTO message (id,owner,talker,fromjid,tojid,body,regdate,dxpacktype,dxclientype,dxclientname,dxclientavatar,dxgroupid,dxgroupname,dxgroupavatar,dxdetail,dxextend,isread,issend,talkername,talkeravatar,isdelete) VALUES('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')",temID,[[[HemaManager sharedManager]myInfor]objectForKey:@"id"],[dataSource objectForKey:@"id"],[[[HemaManager sharedManager]myInfor]objectForKey:@"id"],[dataSource objectForKey:@"id"],temUrl,[HemaFunction getStringNow],packtype,@"1",[[[HemaManager sharedManager]myInfor]objectForKey:@"nickname"],[[[HemaManager sharedManager]myInfor]objectForKey:@"avatar"],@"0",@"",@"",msg,[NSString stringWithFormat:@"%@,",[[[HemaManager sharedManager]myInfor]objectForKey:@"team_id"]?[[[HemaManager sharedManager]myInfor]objectForKey:@"team_id"]:@""],@"1",@"0",[dataSource objectForKey:@"nickname"],[dataSource objectForKey:@"avatar"],@"0"];
    }
    [SystemFunction exceSQL:insertSQL];
    
    if (isChatGroup)
    {
        [self requestChatPush:packtype content:@"无" recv_id:@"0" group_id:[dataSource objectForKey:@"id"] group_name:[dataSource objectForKey:@"name"]];
    }else
    {
        [self requestChatPush:packtype content:@"无" recv_id:[dataSource objectForKey:@"id"] group_id:@"0" group_name:@"无"];
    }
    
    NSLog(@"图片/语音/视频 语句：%@",insertSQL);
    //读取数据库
    [self loadNewMessage];
}
#pragma mark - 文字发送处理
//发送文字
-(void)sendText:(NSString*)mymsg
{
    NSString *msg = [mymsg stringByReplacingOccurrencesOfString:@"'" withString:@"\'"];
    //封装
    NSString *nickName = [[[HemaManager sharedManager]myInfor]objectForKey:@"nickname"];
    NSString *avatar = [[[HemaManager sharedManager]myInfor]objectForKey:@"avatar"];
    
    NSMutableDictionary *paraDic = [[NSMutableDictionary alloc] init];
    if (isChatGroup)
    {
        [paraDic setObject:@"1" forKey:@"dxpacktype"];
        [paraDic setObject:@"1" forKey:@"dxclientype"];
        [paraDic setObject:nickName?nickName:@"" forKey:@"dxclientname"];
        [paraDic setObject:avatar?avatar:@"" forKey:@"dxclientavatar"];
        [paraDic setObject:[dataSource objectForKey:@"id"] forKey:@"dxgroupid"];
        [paraDic setObject:[dataSource objectForKey:@"name"] forKey:@"dxgroupname"];
        [paraDic setObject:@"" forKey:@"dxgroupavatar"];
        [paraDic setObject:msg forKey:@"dxdetail"];
        [paraDic setObject:[NSString stringWithFormat:@"%@,",[[[HemaManager sharedManager]myInfor]objectForKey:@"team_id"]?[[[HemaManager sharedManager]myInfor]objectForKey:@"team_id"]:@""] forKey:@"dxextend"];
    }else
    {
        [paraDic setObject:@"1" forKey:@"dxpacktype"];
        [paraDic setObject:@"1" forKey:@"dxclientype"];
        [paraDic setObject:nickName?nickName:@"" forKey:@"dxclientname"];
        [paraDic setObject:avatar?avatar:@"" forKey:@"dxclientavatar"];
        [paraDic setObject:@"0" forKey:@"dxgroupid"];
        [paraDic setObject:@"" forKey:@"dxgroupname"];
        [paraDic setObject:@"" forKey:@"dxgroupavatar"];
        [paraDic setObject:msg forKey:@"dxdetail"];
        [paraDic setObject:[NSString stringWithFormat:@"%@,",[[[HemaManager sharedManager]myInfor]objectForKey:@"team_id"]?[[[HemaManager sharedManager]myInfor]objectForKey:@"team_id"]:@""] forKey:@"dxextend"];
    }
    [myTextView setText:@""];
    //发送
    [self sendMessage:msg properties:paraDic];
}
//文本
- (void)sendMessage:(NSString*)msg properties:(NSMutableDictionary*)properties
{
    /*
     <message type='chat' from='lp@192.168.1.50/Iphone|Android|Web' id='dsw71gj3' to='test@192.168.1.50/Iphone|Android|Web'>
     <body>msgcontentstr</body>
     <properties>
     <property><name>dxpacktype</name><value type="string">1</value></property>//1：文本 2：图片 3：音频 4：视频）
     <property><name>dxclientype</name><value type="string">发送用户类型，赋值规则: 1：A型用户 2：B型用户（随业务而异，否则固定传1）</value></property>
     <property><name>dxclientname</name><value type="string">我的昵称</value></property>
     <property><name>dxclientavatar</name><value type="integer">我的图片绝对地址</value></property>
     <property><name>dxdetail</name><value type="string">当dxpacktype=3或4时，封装相关属性串，多个以英文逗号分隔</value></property>
     <property><name>dxextend</name><value type="integer">业务耦合扩展属性存储区，多个以英文逗号分隔</value></property>
     <property><name>dxgroupid</name><value type="integer">0</value></property>
     <property><name>dxgroupname</name><value type="integer">群组标题</value></property>
     <property><name>dxgroupavatar</name><value type="string">群组图片</value></property>
     </properties>
     </message>
     */
    
    /*
     [公司聊天系统XMPP内部扩展协议版本号:2014.8.18]
     
     ■ 公司自定义XMPP数据包示例:
     
     <message type='chat' from='lp@192.168.1.50/Iphone|Android|Web' id='dsw71gj3' to='test@192.168.1.50/Iphone|Android|Web'>
     <body>聊天内容或多媒体（图片，音频，视频）地址</body>
     <properties>
     <property><name>dxpacktype</name><value type="string">text</value></property>
     <property><name>dxpackid</name><value type="string">20130626141032133410</value></property>
     <property><name>dxclientid</name><value type="string">1</value></property>
     <property><name>dxclienttype</name><value type="string">1</value></property>
     <property><name>dxclientname</name><value type="string">whbname</value></property>
     <property><name>dxclientavatar</name><value type="string">http://avatar.png</value></property>
     <property><name>dxgroupid</name><value type="string">1</value></property>
     <property><name>dxgroupname</name><value type="string">话题标题</value></property>
     <property><name>dxgroupavatar</name><value type="string">http://topic.png</value></property>
     <property><name>dxdetail</name><value type="string">音频（视频）时长</value></property>
     <property><name>dxextend</name><value type="string">业务扩展1,业务扩展2,,,</value></property>
     </properties>
     </message>
     
     ■ 重点难点：
     （1）单点登录机制（2）断线重连机制（3）获取离线消息（4）缓存聊天纪录
     
     ■ 公司自定义XMPP协议说明(2014.8.21修正):
     
     单聊时（dxgroupid=0）需要固定传递7个自定义节点：
     (01) dxpacktype  :自定义数据包类型，赋值规则：（1：文本 2：图片 3：音频 4：视频）
     说明：当dxpacktype>1时，多媒体资源以http绝对地址的形式存储在message的body节点中。
     (02) dxclientype :发送用户类型，赋值规则: 1：A型用户 2：B型用户（随业务而异，否则固定传1）
     (03) dxclientname :发送用户昵称，赋值规则: 名称字符串
     (04) dxclientavatar	  :发送用户头像，赋值规则: http://图片绝对地址
     (05) dxdetail: 多媒体属性字符串，多个以英文逗号分隔；
     当dxpacktype=3时，第1个元素为音频时长（单位：秒）；
     当dxpacktype=4时，第1个元素为视频时长（单位：秒）；
     (06) dxextend: 业务耦合扩展属性存储区，多个以英文逗号分隔
     (07) dxgroupid :群组主键ID (单聊时固定为0，群聊时即为群组主键；客户端可以根据此值是否为0来判断是单聊还是群聊)
     
     群聊时（dxgroupid>0）需要附加传递2个自定义节点：
     (01) dxgroupname :群组标题
     (02) dxgroupavatar:群组图片
     
     ■ 群聊方法
     如果想群发消息，请先设置dxgroupid=话题主键ID，然后toJID设置为"群组主键ID@broadcast.[ServerIP]"即可。
     */
    
    XMPPStream *temStream = [self getCurrentXmpp];
    
    NSXMLElement *message = [NSXMLElement elementWithName:@"message"];
    [message addAttributeWithName:@"type" stringValue:@"chat"];
    XMPPJID *myJID = temStream.myJID;//fromJID
    NSString* myJidStr = [myJID full];
    [message addAttributeWithName:@"from" stringValue:myJidStr];
    NSString *uuid = [self generateUUID];//messageID
    NSString *temID = [uuid substringToIndex:8];
    [message addAttributeWithName:@"id" stringValue:temID];
    [message addAttributeWithName:@"to" stringValue:chatterJidStr];
    
    NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
    [body setStringValue:msg];
    [message addChild:body];
    
    NSXMLElement *pro = [self generateProperties:properties];
    [message addChild:pro];
    
    [temStream sendElement:message];
    
    NSString *insertSQL = nil;
    //存入数据库
    if(isChatGroup)//如果群聊
    {
        insertSQL = [NSString stringWithFormat:@"INSERT INTO message (id,owner,talker,fromjid,tojid,body,regdate,dxpacktype,dxclientype,dxclientname,dxclientavatar,dxgroupid,dxgroupname,dxgroupavatar,dxdetail,dxextend,isread,issend,talkername,talkeravatar,isdelete) VALUES('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')",temID,[[[HemaManager sharedManager]myInfor]objectForKey:@"id"],[dataSource objectForKey:@"id"],[[[HemaManager sharedManager]myInfor]objectForKey:@"id"],@"",msg,[HemaFunction getStringNow],@"1",@"1",[[[HemaManager sharedManager]myInfor]objectForKey:@"nickname"],[[[HemaManager sharedManager]myInfor]objectForKey:@"avatar"],[dataSource objectForKey:@"id"],[dataSource objectForKey:@"name"],@"",msg,[NSString stringWithFormat:@"%@,",[[[HemaManager sharedManager]myInfor]objectForKey:@"team_id"]?[[[HemaManager sharedManager]myInfor]objectForKey:@"team_id"]:@""],@"1",@"0",@"",@"",@"0"];
    }else
    {
        insertSQL = [NSString stringWithFormat:@"INSERT INTO message (id,owner,talker,fromjid,tojid,body,regdate,dxpacktype,dxclientype,dxclientname,dxclientavatar,dxgroupid,dxgroupname,dxgroupavatar,dxdetail,dxextend,isread,issend,talkername,talkeravatar,isdelete) VALUES('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')",temID,[[[HemaManager sharedManager]myInfor]objectForKey:@"id"],[dataSource objectForKey:@"id"],[[[HemaManager sharedManager]myInfor]objectForKey:@"id"],[dataSource objectForKey:@"id"],msg,[HemaFunction getStringNow],@"1",@"1",[[[HemaManager sharedManager]myInfor]objectForKey:@"nickname"],[[[HemaManager sharedManager]myInfor]objectForKey:@"avatar"],@"0",@"",@"",msg,[NSString stringWithFormat:@"%@,",[[[HemaManager sharedManager]myInfor]objectForKey:@"team_id"]?[[[HemaManager sharedManager]myInfor]objectForKey:@"team_id"]:@""],@"1",@"0",[dataSource objectForKey:@"nickname"],[dataSource objectForKey:@"avatar"],@"0"];
    }
    [SystemFunction exceSQL:insertSQL];
    
    NSString *content = msg;
    if (content.length>=50)
    {
        content = [content substringToIndex:49];
    }
    if (isChatGroup)
    {
        [self requestChatPush:@"1" content:content recv_id:@"0" group_id:[dataSource objectForKey:@"id"] group_name:[dataSource objectForKey:@"name"]];
    }else
    {
        [self requestChatPush:@"1" content:content recv_id:[dataSource objectForKey:@"id"] group_id:@"0" group_name:@"无"];
    }
    //读取数据库
    [self loadNewMessage];
}
#pragma mark - 聊天方法处理
//产生streamID
- (NSString*)generateStreamID
{
    NSDate *now = [HemaFunction getDateNow];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMddHHmmss"];
    NSString *nowStr = [formatter stringFromDate:now];
    
    NSString *uuid = [[[HemaFunction xfuncGetAppdelegate] xmppStream] generateUUID];
    uuid = [uuid substringToIndex:6];
    
    uuid = [NSString stringWithFormat:@"%@%@",nowStr,uuid];
    return uuid;
}
//加载新的消息
- (void)loadNewMessage
{
    NSString *temID = @"0";
    if([dataSourceChat lastObject])
    {
        NSMutableDictionary *temDic = [dataSourceChat lastObject];
        temID = [temDic objectForKey:@"rowid"];
    }
    [self readFromSqlWithID:temID isAfter:YES];
}
- (DDXMLElement*)generateProperties:(NSDictionary*)properties
{
    NSXMLElement *propertiesElement = [NSXMLElement elementWithName:@"properties"];
    [propertiesElement addAttributeWithName:@"xmlns" stringValue:@"http://www.jivesoftware.com/xmlns/xmpp/properties"];
    for(id key in [[properties allKeys] sortedArrayUsingSelector:@selector(compare:)])
    {
        NSXMLElement *propertyElement = [self generateElementWithName:key value:[properties objectForKey:key]];
        [propertiesElement addChild:propertyElement];
    }
    return propertiesElement;
}
- (DDXMLElement*)generateElementWithName:(NSString*)name value:(NSString*)value
{
    NSXMLElement *nameElement = [NSXMLElement elementWithName:@"name" stringValue:name];
    NSXMLElement *valueElement = [NSXMLElement elementWithName:@"value" stringValue:value];
    [valueElement addAttributeWithName:@"type" stringValue:@"string"];
    
    NSXMLElement *property = [NSXMLElement elementWithName:@"property"];
    [property addChild:nameElement];
    [property addChild:valueElement];
    
    return property;
}
#pragma mark- UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == emoScrollView)
    {
        NSInteger index = (emoScrollView.contentOffset.x+UI_View_Width-1)/UI_View_Width;
        emoPageControl.currentPage = index;
    }
    if (!isWillRefresh&& scrollView.contentOffset.y < 0)
    {
        isWillRefresh = YES;
        [self refresh];
    }
    [super scrollViewDidScroll:scrollView];
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [super scrollViewWillBeginDragging:scrollView];
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    isWillRefresh = NO;
    [super scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
}
#pragma mark- UITouch Delegate
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    UIView *view = [touch view];
    if (view == self.view)
    {
        [self touchesAction];
    }
}
-(void)touchesAction
{
    [self.mytable setUserInteractionEnabled:YES];
    [myTextView resignFirstResponder];
    
    [SystemFunction actionActive];
    bottomToolBar.frame = CGRectMake(0, UI_View_Height-bottomToolBar.frame.size.height,UI_View_Width,bottomToolBar.frame.size.height);
    downView.frame = CGRectMake(0, UI_View_Height,UI_View_Width,downView.frame.size.height);
    [UIView commitAnimations];
    
    [self tableViewMoved];
}
#pragma mark- HPGrowingTextViewDelegate
- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height
{
    float diff = (growingTextView.frame.size.height - height);
    
    if (diff == 0)
    {
        return;
    }
    
    CGRect r = bottomToolBar.frame;
    r.origin.y += diff;
    r.size.height -= diff;
    bottomToolBar.frame = r;
    
    [self tableViewMoved];
}
- (BOOL)growingTextViewShouldReturn:(HPGrowingTextView *)growingTextView
{
    [self gotoOK:nil];
    return YES;
}
#pragma mark- 键盘通知
-(void)keyboardWillShow:(NSNotification *)notification
{
    [self.mytable setUserInteractionEnabled:NO];
    
    CGFloat animationTime = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:animationTime animations:^{
        CGRect keyBoardFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
        bottomToolBar.frame = CGRectMake(0, UI_View_Height-bottomToolBar.frame.size.height-keyBoardFrame.size.height,UI_View_Width,bottomToolBar.frame.size.height);
        downView.frame = CGRectMake(0, UI_View_Height,UI_View_Width,downView.frame.size.height);
    }];
    [self tableViewMoved];
}
-(void)keyboardWillHide:(NSNotification *)notification
{
    [self tableViewMoved];
}
#pragma mark- UITableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataSourceChat.count;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //时间
    NSMutableDictionary *dict  = [dataSourceChat objectAtIndex:indexPath.row];
    
    if (5 == [[dict objectForKey:@"dxpacktype"]integerValue])
    {
        static NSString *CellIdentifier = @"QKSY01";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if(cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.backgroundColor = BB_Back_Color_Here;
            
            //日期
            UILabel *labTime = [[UILabel alloc]init];
            labTime.backgroundColor = RGB_UI_COLOR(193, 195, 194);
            labTime.textColor = BB_White_Color;
            labTime.textAlignment = NSTextAlignmentCenter;
            labTime.font = [UIFont systemFontOfSize:11];
            labTime.tag = 12;
            [cell.contentView addSubview:labTime];
        }
        //日期
        UILabel *labTime = (UILabel*)[cell viewWithTag:12];
        labTime.text = [HemaFunction getTimeFromDate:[dict objectForKey:@"regdate"]];
        
        CGSize mySize = [HemaFunction getSizeWithStrNo:labTime.text width:UI_View_Width font:11];
        [labTime setFrame:CGRectMake((UI_View_Width-(mySize.width+10))/2, 8, mySize.width+10, 22)];
        
        [HemaFunction addbordertoView:labTime radius:4.0f width:0.0f color:[UIColor clearColor]];
        
        return cell;
    }
    NSString *customCellIdentify = @"chatCell";
    RWeiChatCell *cell = [tableView dequeueReusableCellWithIdentifier:customCellIdentify];
    if(nil == cell)
    {
        cell = [[RWeiChatCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:customCellIdentify];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        
        //头像手势
        HemaTapGR *avatemTap = [[HemaTapGR alloc] initWithTarget:self action:@selector(gotoOwnerTap:)];
        [cell.avatarButton addGestureRecognizer:avatemTap];
        avatemTap.numberOfTapsRequired = 1;
        avatemTap.numberOfTouchesRequired = 1;
        avatemTap.delegate = self;
        
        HemaLongGR *avamyLong = [[HemaLongGR alloc]initWithTarget:self action:@selector(atMember:)];
        avamyLong.minimumPressDuration = 0.5;
        [cell.avatarButton addGestureRecognizer:avamyLong];
        
        //消息手势
        HemaTapGR *temTap = [[HemaTapGR alloc] initWithTarget:self action:@selector(tapPress:)];
        [cell.messageButton addGestureRecognizer:temTap];
        temTap.numberOfTapsRequired = 1;
        temTap.numberOfTouchesRequired = 1;
        temTap.delegate = self;
        
        HemaLongGR *myLong = [[HemaLongGR alloc]initWithTarget:self action:@selector(longPress:)];
        myLong.minimumPressDuration = 0.5;
        [cell.messageButton addGestureRecognizer:myLong];
    }
    NSString *sender = [dict objectForKey:@"fromjid"];
    NSString *me = [HemaFunction xfuncGetAppdelegate].xmppStream.myJID.user;
    
    //头像
    [cell.avatarButton setBackgroundImage:nil forState:UIControlStateNormal];
    [cell.avatarButton setBackgroundImage:nil forState:UIControlStateDisabled];
    
    cell.avatarButton.btnId = [dict objectForKey:@"fromjid"];
    
    [SystemFunction cashButton:cell.avatarButton url:[dict objectForKey:@"dxclientavatar"] firstImg:@"R默认小头像.png"];
    
    //手势
    HemaTapGR *avatemTap = (HemaTapGR*)[cell.avatarButton.gestureRecognizers objectAtIndex:0];
    HemaLongGR *avamyLong = (HemaLongGR*)[cell.avatarButton.gestureRecognizers objectAtIndex:1];
    
    avatemTap.touchRow = indexPath.row;
    avatemTap.touchI = 0;
    avamyLong.touchRow = indexPath.row;
    
    HemaTapGR *temTap = (HemaTapGR*)[cell.messageButton.gestureRecognizers objectAtIndex:0];
    HemaLongGR *myLong = (HemaLongGR*)[cell.messageButton.gestureRecognizers objectAtIndex:1];
    
    temTap.touchRow = indexPath.row;
    myLong.touchRow = indexPath.row;
    
    [cell.messageButton setEnabled:YES];
    [cell.messageContentView setTextAlignment:NSTextAlignmentLeft];
    
    [cell.avatarButton setHidden:YES];
    [cell.messageButton setHidden:YES];
    [cell.messageContentView setHidden:YES];
    [cell.waitIndicator stopAnimating];
    [cell.reSendButton setHidden:YES];
    cell.reSendButton.btnRow = indexPath.row;
    cell.messageButton.btnRow = indexPath.row;
    cell.avatarButton.btnRow = indexPath.row;
    [cell.deptLabel setHidden:YES];
    [cell.messageImgView setImage:nil];
    
    [cell.timeLabel setText:[HemaFunction getTimeFromDate:[dict objectForKey:@"regdate"]]];
    [cell.nameLabel setText:[dict objectForKey:@"dxclientname"]];
    
    cell.messageContentView.font = [UIFont systemFontOfSize:14];
    
    //图片
    if (2 == [[dict objectForKey:@"dxpacktype"]integerValue])
    {
        [cell.messageContentView setHidden:YES];
        [cell.messageImgView setHidden:NO];
        
        CGSize size = CGSizeMake(100, 100);
        UIImage *bgImage = nil;
        if([sender isEqualToString:me])
        {
            bgImage = [[UIImage imageNamed:@"chat_sender_bg.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:15];
            [cell.messageButton setFrame:CGRectMake(UI_View_Width-62-(size.width+2*padding), myPad, size.width+2*padding, size.height+2*padding)];
            cell.waitIndicator.center = CGPointMake(UI_View_Width-62-(size.width+2*padding)-20, cell.messageButton.center.y>10?cell.messageButton.center.y:10);
            [cell.messageImgView setFrame:CGRectMake(UI_View_Width-62-(size.width+2*padding)+padding-3, padding+myPad, size.width, size.height)];
            [cell.avatarButton setFrame:CGRectMake(UI_View_Width-48- 6.5, myPad, 48, 48)];
            [cell.nameLabel setFrame:CGRectMake(UI_View_Width-48- 6.5, 48+myPad, 48, 17)];
            
            [cell.timeLabel setTextAlignment:NSTextAlignmentRight];
            [cell.timeLabel setFrame:CGRectMake(UI_View_Width-170, size.height+2*padding+myPad, 100, 14)];
        }
        else
        {
            bgImage = [[UIImage imageNamed:@"chat_receiver_bg.png"] stretchableImageWithLeftCapWidth:15 topCapHeight:15];
            [cell.messageButton setFrame:CGRectMake(62, myPad, size.width+2*padding, size.height+2*padding)];
            [cell.messageImgView setFrame:CGRectMake(62+padding+3, padding+myPad, size.width, size.height)];
            [cell.avatarButton setFrame:CGRectMake(6.5, myPad, 48, 48)];
            [cell.nameLabel setFrame:CGRectMake(6.5, 48+myPad, 48, 17)];
            
            [cell.timeLabel setTextAlignment:NSTextAlignmentLeft];
            [cell.timeLabel setFrame:CGRectMake(69, size.height+2*padding+myPad, 151, 14)];
        }
        [cell.messageButton setBackgroundImage:bgImage forState:UIControlStateNormal];
        cell.messageButton.btnRow = indexPath.row;
        cell.messageImgView.tag = 100+indexPath.row;
        [SystemFunction cashImgView:cell.messageImgView url:[dict objectForKey:@"body"] firstImg:@"R图片默认背景.png"];
        myLong.touchI = 2;
        temTap.touchI = 2;
    }else if (3 == [[dict objectForKey:@"dxpacktype"]integerValue])//音频
    {
        [cell.messageContentView setHidden:NO];
        [cell.messageImgView setHidden:NO];
        [HemaFunction addbordertoView:cell.messageImgView radius:0.0 width:0.0 color:[UIColor clearColor]];
        
        CGSize size = CGSizeMake(100, 30);
        UIImage *bgImage = nil;
        if([sender isEqualToString:me])
        {
            [cell.messageContentView setTextAlignment:NSTextAlignmentLeft];
            bgImage = [[UIImage imageNamed:@"chat_sender_bg.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:15];
            [cell.messageButton setFrame:CGRectMake(UI_View_Width-62-(size.width+2*padding), myPad, size.width+2*padding, size.height+2*padding)];
            cell.waitIndicator.center = CGPointMake(UI_View_Width-62-(size.width+2*padding)-20, cell.messageButton.center.y>10?cell.messageButton.center.y:10);
            [cell.messageImgView setFrame:CGRectMake(UI_View_Width-62-(size.width+2*padding)+padding-3+80, padding+myPad+5, 13, 20)];
            [cell.messageContentView setFrame:CGRectMake(UI_View_Width-62-(size.width+2*padding)+padding, padding+myPad, 40, size.height)];
            [cell.avatarButton setFrame:CGRectMake(UI_View_Width-48- 6.5, myPad, 48, 48)];
            [cell.nameLabel setFrame:CGRectMake(UI_View_Width-48- 6.5, 48+myPad, 48, 17)];
            
            [cell.timeLabel setTextAlignment:NSTextAlignmentRight];
            [cell.timeLabel setFrame:CGRectMake(UI_View_Width-170, size.height+2*padding+myPad, 100, 14)];
            
            NSArray *rightImageArr = [NSArray arrayWithObjects:
                                      [UIImage imageNamed:@"chat_sender_audio_playing_000@2x"],
                                      [UIImage imageNamed:@"chat_sender_audio_playing_001@2x"],
                                      [UIImage imageNamed:@"chat_sender_audio_playing_002@2x"],
                                      [UIImage imageNamed:@"chat_sender_audio_playing_003@2x"], nil];
            cell.messageImgView.image = [rightImageArr objectAtIndex:3];
            cell.messageImgView.animationImages = rightImageArr;
            cell.messageImgView.animationDuration = 1;
            cell.messageImgView.animationRepeatCount = 0;
        }
        else
        {
            [cell.messageContentView setTextAlignment:NSTextAlignmentRight];
            bgImage = [[UIImage imageNamed:@"chat_receiver_bg.png"] stretchableImageWithLeftCapWidth:15 topCapHeight:15];
            [cell.messageButton setFrame:CGRectMake(62, myPad, size.width+2*padding, size.height+2*padding)];
            [cell.messageImgView setFrame:CGRectMake(62+padding+3+7, padding+myPad+5, 13, 20)];
            [cell.messageContentView setFrame:CGRectMake(62+padding+3+55, padding+myPad, 40, size.height)];
            [cell.avatarButton setFrame:CGRectMake(6.5, myPad, 48, 48)];
            [cell.nameLabel setFrame:CGRectMake(6.5, 48+myPad, 48, 17)];
            
            [cell.timeLabel setTextAlignment:NSTextAlignmentLeft];
            [cell.timeLabel setFrame:CGRectMake(69, size.height+2*padding+myPad, 151, 14)];
            
            NSArray *leftImageArr = [NSArray arrayWithObjects:
                                     [UIImage imageNamed:@"chat_receiver_audio_playing000@2x"],
                                     [UIImage imageNamed:@"chat_receiver_audio_playing001@2x"],
                                     [UIImage imageNamed:@"chat_receiver_audio_playing002@2x"],
                                     [UIImage imageNamed:@"chat_receiver_audio_playing003@2x"], nil];
            cell.messageImgView.image = [leftImageArr objectAtIndex:3];
            cell.messageImgView.animationImages = leftImageArr;
            cell.messageImgView.animationDuration = 1;
            cell.messageImgView.animationRepeatCount = 0;
        }
        [HemaFunction addbordertoView:cell.messageImgView radius:0.0 width:0.0 color:[UIColor clearColor]];
        
        [cell.messageButton setBackgroundImage:bgImage forState:UIControlStateNormal];
        
        [cell.avatarButton setHidden:NO];
        [cell.messageButton setHidden:NO];
        cell.messageImgView.tag = 100+indexPath.row;
        cell.messageButton.btnRow = indexPath.row;
        cell.messageButton.btnId = @"3";
        
        [cell.messageContentView setText:[NSString stringWithFormat:@"%@'",[dict objectForKey:@"dxdetail"]]];
        
        //如果正在播放
        if ([[dict objectForKey:@"isPlayRecord"]integerValue] == 1)
        {
            [cell.messageImgView startAnimating];
        }else
        {
            [cell.messageImgView stopAnimating];
        }
        myLong.touchI = 3;
        temTap.touchI = 3;
    }else if (4 == [[dict objectForKey:@"dxpacktype"]integerValue])//视频
    {
        [cell.messageContentView setHidden:NO];
        [cell.messageImgView setHidden:NO];
        [HemaFunction addbordertoView:cell.messageImgView radius:0.0 width:0.0 color:[UIColor clearColor]];
        
        CGSize size = CGSizeMake(100, 60);
        UIImage *bgImage = nil;
        if([sender isEqualToString:me])
        {
            [cell.messageContentView setTextAlignment:NSTextAlignmentLeft];
            bgImage = [[UIImage imageNamed:@"chat_sender_bg.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:15];
            [cell.messageButton setFrame:CGRectMake(UI_View_Width-62-(size.width+2*padding), myPad, size.width+2*padding, size.height+2*padding)];
            cell.waitIndicator.center = CGPointMake(UI_View_Width-62-(size.width+2*padding)-20, cell.messageButton.center.y>10?cell.messageButton.center.y:10);
            [cell.messageImgView setFrame:CGRectMake(UI_View_Width-62-(size.width+2*padding)+padding+20+10, padding+myPad+10, 40, 40)];
            [cell.messageContentView setFrame:CGRectMake(UI_View_Width-62-(size.width+2*padding)+padding, padding+myPad+40, 40, 20)];
            [cell.avatarButton setFrame:CGRectMake(UI_View_Width-48- 6.5, myPad, 48, 48)];
            [cell.nameLabel setFrame:CGRectMake(UI_View_Width-48- 6.5, 48+myPad, 48, 17)];
            
            [cell.timeLabel setTextAlignment:NSTextAlignmentRight];
            [cell.timeLabel setFrame:CGRectMake(UI_View_Width-170, size.height+2*padding+myPad, 100, 14)];
        }
        else
        {
            [cell.messageContentView setTextAlignment:NSTextAlignmentRight];
            bgImage = [[UIImage imageNamed:@"chat_receiver_bg.png"] stretchableImageWithLeftCapWidth:15 topCapHeight:15];
            [cell.messageButton setFrame:CGRectMake(62, myPad, size.width+2*padding, size.height+2*padding)];
            [cell.messageImgView setFrame:CGRectMake(62+padding+20+10, padding+myPad+10, 40, 40)];
            [cell.messageContentView setFrame:CGRectMake(62+padding+3+55, padding+myPad+40, 40, 20)];
            [cell.avatarButton setFrame:CGRectMake(6.5, myPad, 48, 48)];
            [cell.nameLabel setFrame:CGRectMake(6.5, 48+myPad, 48, 17)];
            
            [cell.timeLabel setTextAlignment:NSTextAlignmentLeft];
            [cell.timeLabel setFrame:CGRectMake(69, size.height+2*padding+myPad, 151, 14)];
        }
        cell.messageImgView.image = [UIImage imageNamed:@"R聊天中间视频.png"];
        
        [cell.messageButton setBackgroundImage:bgImage forState:UIControlStateNormal];
        
        [cell.avatarButton setHidden:NO];
        [cell.messageButton setHidden:NO];
        cell.messageImgView.tag = 100+indexPath.row;
        cell.messageButton.btnRow = indexPath.row;
        cell.messageButton.btnId = @"4";
        
        [cell.messageContentView setText:[NSString stringWithFormat:@"%@'",[dict objectForKey:@"dxdetail"]]];
        
        myLong.touchI = 4;
        temTap.touchI = 4;
    }else
    {
        [cell.messageContentView setHidden:NO];
        [cell.messageImgView setHidden:YES];
        //消息
        NSString *message = [dict objectForKey:@"body"];
        CGSize size = [HemaFunction getSizeWithStrNo:message width:200 font:14];
        UIImage *bgImage = nil;
        if([sender isEqualToString:me])
        {
            bgImage = [[UIImage imageNamed:@"chat_sender_bg.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:15];
            [cell.messageButton setFrame:CGRectMake(UI_View_Width-62-(size.width+2*padding), myPad, size.width+2*padding, size.height+2*padding)];
            cell.waitIndicator.center = CGPointMake(UI_View_Width-62-(size.width+2*padding)-20, cell.messageButton.center.y>10?cell.messageButton.center.y:10);
            [cell.messageContentView setFrame:CGRectMake(UI_View_Width-62-(size.width+2*padding)+padding/2, padding+myPad, size.width, size.height)];
            [cell.avatarButton setFrame:CGRectMake(UI_View_Width-48- 6.5, myPad, 48, 48)];
            [cell.nameLabel setFrame:CGRectMake(UI_View_Width-48- 6.5, 48+myPad, 48, 17)];
            
            [cell.timeLabel setTextAlignment:NSTextAlignmentRight];
            [cell.timeLabel setFrame:CGRectMake(UI_View_Width-170, size.height+2*padding+myPad, 100, 14)];
        }
        else
        {
            bgImage = [[UIImage imageNamed:@"chat_receiver_bg.png"] stretchableImageWithLeftCapWidth:15 topCapHeight:15];
            [cell.messageButton setFrame:CGRectMake(62, myPad, size.width+2*padding, size.height+2*padding)];
            [cell.messageContentView setFrame:CGRectMake(62+padding+padding/2, padding+myPad, size.width, size.height)];
            [cell.avatarButton setFrame:CGRectMake(6.5, myPad, 48, 48)];
            [cell.nameLabel setFrame:CGRectMake(6.5, 48+myPad, 48, 17)];
            
            [cell.timeLabel setTextAlignment:NSTextAlignmentLeft];
            [cell.timeLabel setFrame:CGRectMake(69, size.height+2*padding+myPad, 151, 14)];
        }
        cell.messageContentView.text = message;
        [cell.messageButton setBackgroundImage:bgImage forState:UIControlStateNormal];
        
        cell.messageButton.btnRow = indexPath.row;
        cell.messageButton.btnId = @"1";
        
        myLong.touchI = 1;
        temTap.touchI = 1;
    }
    
    //更改：单聊人名隐藏；群聊人名放在最顶上
    float myHeight = 17;
    if (isChatGroup)
    {
        [cell.nameLabel setHidden:NO];
        if([sender isEqualToString:me])
        {
            [cell.nameLabel setFrame:CGRectMake(cell.timeLabel.frame.origin.x, myPad, cell.timeLabel.frame.size.width, myHeight)];
            [cell.nameLabel setTextAlignment:NSTextAlignmentRight];
        }else
        {
            [cell.nameLabel setFrame:CGRectMake(cell.timeLabel.frame.origin.x, myPad, cell.timeLabel.frame.size.width, myHeight)];
            [cell.nameLabel setTextAlignment:NSTextAlignmentLeft];
        }
        [cell.messageImgView setFrame:CGRectMake(cell.messageImgView.frame.origin.x, cell.messageImgView.frame.origin.y+myHeight, cell.messageImgView.frame.size.width, cell.messageImgView.frame.size.height)];
        [cell.messageContentView setFrame:CGRectMake(cell.messageContentView.frame.origin.x, cell.messageContentView.frame.origin.y+myHeight, cell.messageContentView.frame.size.width, cell.messageContentView.frame.size.height)];
        [cell.messageButton setFrame:CGRectMake(cell.messageButton.frame.origin.x, cell.messageButton.frame.origin.y+myHeight, cell.messageButton.frame.size.width, cell.messageButton.frame.size.height)];
        [cell.timeLabel setFrame:CGRectMake(cell.timeLabel.frame.origin.x, cell.timeLabel.frame.origin.y+myHeight, cell.timeLabel.frame.size.width, 14)];
    }else
    {
        [cell.nameLabel setHidden:YES];
    }
    
    [cell.timeLabel setHidden:YES];
    
    //发送状态之类
    if([[dict objectForKey:@"issend"] isEqualToString:@"0"])//如果正在发送，显示菊花
    {
        [cell.waitIndicator startAnimating];
    }
    
    [cell.reSendButton setCenter:cell.waitIndicator.center];//重新发送按钮
    if([[dict objectForKey:@"issend"] isEqualToString:@"2"])//如果历史消息未发送，显示重新发送按钮
    {
        [cell.reSendButton setHidden:NO];
    }
    //重新发送事件
    [cell.reSendButton setBtnRow:indexPath.row];
    [cell.reSendButton addTarget:self action:@selector(reSendButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.avatarButton setHidden:NO];
    [cell.messageButton setHidden:NO];
    
    //处理一些事情
    [cell.messageContentView setUserInteractionEnabled:NO];
    
    return cell;
}
#pragma mark- UITableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *dict  = [dataSourceChat objectAtIndex:indexPath.row];//数据源
    
    CGSize size = CGSizeMake(100, 100);
    
    //文字
    if (1 == [[dict objectForKey:@"dxpacktype"]integerValue])
    {
        NSString *msg = [dict objectForKey:@"body"];
        size = [HemaFunction getSizeWithStrNo:msg width:200 font:14];
    }
    //图片
    if (2 == [[dict objectForKey:@"dxpacktype"]integerValue])
    {
        size = CGSizeMake(100, 100);
    }
    //音频
    if (3 == [[dict objectForKey:@"dxpacktype"]integerValue])
    {
        size = CGSizeMake(100, 30);
    }
    //视频
    if (4 == [[dict objectForKey:@"dxpacktype"]integerValue])
    {
        size = CGSizeMake(100, 60);
    }
    //时间
    if (5 == [[dict objectForKey:@"dxpacktype"]integerValue])
    {
        return 30;
    }
    size.height += padding*2+10;
    CGFloat height = size.height < 50 ? 50 : size.height;
    if (isChatGroup)
    {
        return height+myPad+17;
    }
    return height+myPad;
    
    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
#pragma mark - 请求服务器
#pragma mark 聊天百度推送
- (void)requestChatPush:(NSString*)msgtype content:(NSString*)content recv_id:(NSString*)recv_id group_id:(NSString*)group_id group_name:(NSString*)group_name
{
    NSString *token = [[HemaManager sharedManager] userToken];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:token forKey:@"token"];
    [dic setObject:msgtype  forKey:@"msgtype"];
    [dic setObject:content  forKey:@"content"];
    [dic setObject:recv_id forKey:@"recv_id"];
    [dic setObject:group_id forKey:@"group_id"];
    [dic setObject:group_name forKey:@"group_name"];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",REQUEST_MAINLINK,REQUEST_CHATPUSH_ADD];
    [HemaRequest requestWithURL:url target:self selector:@selector(responseChatPush:) parameter:dic];
}
- (void)responseChatPush:(NSDictionary*)info
{
    if(1 == [[info objectForKey:@"success"] intValue])
    {
        
    }else
    {
        [HemaFunction openIntervalHUD:[info objectForKey:@"msg"]];
    }
}
#pragma mark 上传文件
- (void)requestPublishFile:(NSString*)keytype keyid:(NSString*)keyid orderby:(NSString*)orderby data:(NSData*)data
{
    NSString *token = [[HemaManager sharedManager] userToken];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:token forKey:@"token"];
    [dic setObject:keytype forKey:@"keytype"];
    [dic setObject:keyid forKey:@"keyid"];
    [dic setObject:orderby forKey:@"orderby"];
    [dic setObject:@"无" forKey:@"content"];
    [dic setObject:data forKey:@"temp_file"];
    if ([keytype integerValue] == 7)
    {
        [dic setObject:@"0" forKey:@"duration"];
    }else
    {
        [dic setObject:[NSString stringWithFormat:@"%d",(int)mySecond] forKey:@"duration"];
    }
    if ([keytype integerValue] == 7)
    {
        [HemaRequest requestWithURL:[NSString stringWithFormat:@"%@%@",REQUEST_MAINLINK,REQUEST_FILE_UPLOAD] target:self selector:@selector(responsePublishFile:) parameter:dic];
    }
    if ([keytype integerValue] == 8)
    {
        [HemaRequest requestWithAudioURL:[NSString stringWithFormat:@"%@%@",REQUEST_MAINLINK,REQUEST_FILE_UPLOAD] target:self selector:@selector(responsePublishFile:) parameter:dic];
    }
    if ([keytype integerValue] == 9)
    {
        [HemaRequest requestWithVideoURL:[NSString stringWithFormat:@"%@%@",REQUEST_MAINLINK,REQUEST_FILE_UPLOAD] target:self selector:@selector(responsePublishFile:) parameter:dic];
    }
}
- (void)responsePublishFile:(NSDictionary*)info
{
    [HemaFunction closeHUD:waitMB];
    if(1 == [[info objectForKey:@"success"] intValue])
    {
        //语音传输
        if (0 == rowClick)
        {
            [self sendAll:[[[info objectForKey:@"infor"]objectAtIndex:0]objectForKey:@"item2"] temUrl:[[[info objectForKey:@"infor"]objectAtIndex:0]objectForKey:@"item1"] packtype:@"3"];
        }
        //图片or拍照
        if (1 == rowClick||2 == rowClick)
        {
            [self sendAll:[[[info objectForKey:@"infor"]objectAtIndex:0]objectForKey:@"item2"] temUrl:[[[info objectForKey:@"infor"]objectAtIndex:0]objectForKey:@"item1"] packtype:@"2"];
        }
        //视频or拍摄
        if (3 == rowClick||4 == rowClick)
        {
            [self sendAll:[[[info objectForKey:@"infor"]objectAtIndex:0]objectForKey:@"item2"] temUrl:[[[info objectForKey:@"infor"]objectAtIndex:0]objectForKey:@"item1"] packtype:@"4"];
        }
    }else
    {
        [HemaFunction closeHUD:waitMB];
        [HemaFunction openIntervalHUD:[info objectForKey:@"msg"]];
    }
}
#pragma mark - 加载刷新
//刷新页面
-(void)reShowView
{
    [self hideNoDataView];
    [self.mytable reloadData];
}
//继承的方法
- (void)refresh
{
    NSString *temID = nil;
    if(dataSourceChat.count>1)
    {
        NSMutableDictionary *temDic = [dataSourceChat objectAtIndex:1];
        if (![HemaFunction xfunc_check_strEmpty:[temDic objectForKey:@"rowid"]])
        {
            temID = [temDic objectForKey:@"rowid"];
        }else
        {
            temID = @"99999999";
        }
    }else
    {
        temID = @"99999999";
    }
    myCount = dataSourceChat.count;
    
    [self readFromSqlWithID:temID isAfter:NO];
}
-(void)myRresh:(NSString*)temID
{
    [self readFromSqlWithID:temID isAfter:NO];
}
-(void)addMore
{
    
}
-(void)startAddMore
{
    return;
}
#pragma mark - 从数据库读取数据
- (void)readFromSqlWithID:(NSString*)temID isAfter:(BOOL)isAfter
{
    //查询语句
    NSString *query = nil;
    NSString *myMobile = [HemaFunction xfuncGetAppdelegate].xmppStream.myJID.user;
    if(isAfter)
    {
        if(isChatGroup)
        {
            query = [NSString stringWithFormat:@"select rowid,owner,fromjid,tojid,body,regdate,dxpacktype,dxclientype,dxclientname,dxclientavatar,dxgroupid,dxgroupname,dxgroupavatar,dxdetail,dxextend,isread,issend,id from message where rowid > %d and dxgroupid = %@ and owner = %@",(int)[temID integerValue],[dataSource objectForKey:@"id"],myMobile];
        }
        else
        {
            query = [NSString stringWithFormat:@"select rowid,owner,fromjid,tojid,body,regdate,dxpacktype,dxclientype,dxclientname,dxclientavatar,dxgroupid,dxgroupname,dxgroupavatar,dxdetail,dxextend,isread,issend,id from message where ((fromjid = '%@' and tojid = '%@') or (fromjid = '%@' and tojid = '%@')) and rowid > %d and owner = %@ and dxgroupid = 0",myMobile,[dataSource objectForKey:@"id"],[dataSource objectForKey:@"id"],myMobile,(int)[temID integerValue],myMobile];
        }
    }
    else
    {
        if(temID)
        {
            if(isChatGroup)
            {
                query = [NSString stringWithFormat:@"select rowid,owner,fromjid,tojid,body,regdate,dxpacktype,dxclientype,dxclientname,dxclientavatar,dxgroupid,dxgroupname,dxgroupavatar,dxdetail,dxextend,isread,issend,id from message where rowid < %d and dxgroupid = %@ and owner = %@ order by rowid desc limit 10",(int)[temID integerValue],[dataSource objectForKey:@"id"],myMobile];
            }
            else
            {
                query = [NSString stringWithFormat:@"select rowid,owner,fromjid,tojid,body,regdate,dxpacktype,dxclientype,dxclientname,dxclientavatar,dxgroupid,dxgroupname,dxgroupavatar,dxdetail,dxextend,isread,issend,id from message where ((fromjid = '%@' and tojid = '%@') or (fromjid = '%@' and tojid = '%@')) and rowid < %d and owner = %@ and dxgroupid = 0 order by rowid desc limit 10",myMobile,[dataSource objectForKey:@"id"],[dataSource objectForKey:@"id"],myMobile,(int)[temID integerValue],myMobile];
            }
        }
        else
        {
            if(isChatGroup)
            {
                query = [NSString stringWithFormat:@"select rowid,owner,fromjid,tojid,body,regdate,dxpacktype,dxclientype,dxclientname,dxclientavatar,dxgroupid,dxgroupname,dxgroupavatar,dxdetail,dxextend,isread,issend,id from message where dxgroupid = %@ and owner = %@ order by rowid desc limit 10",[dataSource objectForKey:@"id"],myMobile];
            }
            else
            {
                query = [NSString stringWithFormat:@"select rowid,owner,fromjid,tojid,body,regdate,dxpacktype,dxclientype,dxclientname,dxclientavatar,dxgroupid,dxgroupname,dxgroupavatar,dxdetail,dxextend,isread,issend,id from message where ((fromjid = '%@' and tojid = '%@') or (fromjid = '%@' and tojid = '%@')) and owner = %@ and dxgroupid = 0 order by rowid desc limit 10",myMobile,[dataSource objectForKey:@"id"],[dataSource objectForKey:@"id"],myMobile,myMobile];
            }
        }
    }
    NSLog(@"查询的语句:%@",query);
    [self selectDataBase:query isAfter:isAfter];
}
#pragma mark 数据库操作
//查询数据
-(void)selectDataBase:(NSString*)query isAfter:(BOOL)isAfter
{
    if (!dataSourceChat)
        dataSourceChat = [[NSMutableArray alloc]init];
    
    sqlite3_stmt *statement;
    sqlite3 *contactDB;
    
    NSMutableArray *keyArr = [[NSMutableArray alloc]initWithObjects:
                              @"rowid",@"owner",@"fromjid",@"tojid",@"body",
                              @"regdate",@"dxpacktype",@"dxclientype",@"dxclientname",@"dxclientavatar",
                              @"dxgroupid",@"dxgroupname",@"dxgroupavatar",@"dxdetail",@"dxextend",
                              @"isread",@"issend",@"id",nil];
    
    const char *dbpath = [_databasePath UTF8String];
    if (sqlite3_open(dbpath, &contactDB)==SQLITE_OK)
    {
        if (sqlite3_prepare_v2(contactDB, [query UTF8String],-1, &statement, nil) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                NSMutableDictionary *temDic = [[NSMutableDictionary alloc]init];
                for (int i = 0; i<18; i++)
                {
                    NSString *strObject = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, i)];
                    NSString *strKey = [keyArr objectAtIndex:i];
                    
                    if (i == 16)
                    {
                        if(!isAfter&&[strObject integerValue] == 0)
                        {
                            strObject = @"2";
                        }
                    }
                    [temDic setObject:strObject forKey:strKey];
                }
                [temDic setObject:@"0" forKey:@"isPlayRecord"];//是否播放
                
                if (isAfter)
                {
                    if (dataSourceChat.count > 0)
                    {
                        NSMutableDictionary *lastDic = [dataSourceChat lastObject];
                        NSString *oldRegdate = [lastDic objectForKey:@"regdate"];
                        NSString *newRegdate = [temDic objectForKey:@"regdate"];
                        
                        CGFloat timeDifference = [HemaFunction getDateDifference:oldRegdate newDate:newRegdate];
                        
                        if(timeDifference > 300)
                        {
                            NSMutableDictionary *timeDic = [[NSMutableDictionary alloc] init];
                            [timeDic setObject:[temDic objectForKey:@"regdate"] forKey:@"regdate"];
                            [timeDic setObject:@"5" forKey:@"dxpacktype"];
                            [dataSourceChat addObject:timeDic];
                            
                        }
                    }else
                    {
                        NSMutableDictionary *timeDic = [[NSMutableDictionary alloc] init];
                        [timeDic setObject:[temDic objectForKey:@"regdate"] forKey:@"regdate"];
                        [timeDic setObject:@"5" forKey:@"dxpacktype"];
                        [dataSourceChat addObject:timeDic];
                    }
                    [dataSourceChat addObject:temDic];
                }else
                {
                    if(dataSourceChat.count>0)
                    {
                        NSMutableDictionary *firstDic = [dataSourceChat objectAtIndex:0];
                        NSString *newRegdate = [firstDic objectForKey:@"regdate"];
                        NSString *oldRegdate = [temDic objectForKey:@"regdate"];
                        CGFloat timeDifference = [HemaFunction getDateDifference:oldRegdate newDate:newRegdate];
                        if(timeDifference > 300)
                        {
                            NSMutableDictionary *timeDic = [[NSMutableDictionary alloc] init];
                            [timeDic setObject:[temDic objectForKey:@"regdate"] forKey:@"regdate"];
                            [timeDic setObject:@"5" forKey:@"dxpacktype"];
                            [dataSourceChat insertObject:timeDic atIndex:0];
                        }
                        else
                        {
                            [firstDic setObject:[temDic objectForKey:@"regdate"] forKey:@"regdate"];
                        }
                    }
                    else
                    {
                        NSMutableDictionary *timeDic = [[NSMutableDictionary alloc] init];
                        [timeDic setObject:[temDic objectForKey:@"regdate"] forKey:@"regdate"];
                        [timeDic setObject:@"5" forKey:@"dxpacktype"];
                        [dataSourceChat insertObject:timeDic atIndex:0];
                    }
                    [dataSourceChat insertObject:temDic atIndex:1];
                }
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
    //刷新页面
    if(!isAfter)
    {
        if(!isLoading)
        {
            [self tableViewMoved];
        }else
        {
            [self.mytable reloadData];
        }
        if (myCount > 0)
        {
            NSIndexPath *temPath = [NSIndexPath indexPathForRow:dataSourceChat.count-myCount inSection:0];
            [self.mytable scrollToRowAtIndexPath:temPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
        }
        [self stopLoading];
    }else
    {
        [self tableViewMoved];
    }
}
@end
