//
//  RVideoPlayVC.m
//  Hema
//
//  Created by LarryRodic on 15/10/20.
//  Copyright (c) 2015年 Hemaapp. All rights reserved.
//
#define TopViewHeight 64
#define BottomViewHeight 48
#define VolumeStep 0.1f

#import "RVideoPlayVC.h"
#import <MediaPlayer/MediaPlayer.h>
#import <CoreMedia/CoreMedia.h>

typedef NS_ENUM(NSInteger, GestureType)
{
    GestureTypeOfNone = 0,
    GestureTypeOfVolume,
    GestureTypeOfBrightness,
    GestureTypeOfProgress,
};

@interface RVideoPlayVC ()
@property(nonatomic,assign)GestureType gestureType;//手势类型
@property(nonatomic,assign)CGPoint originalLocation;
@end

@implementation RVideoPlayVC
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"AVSystemController_SystemVolumeDidChangeNotification" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadSet];
}
-(void)loadSet
{
    //监听声音
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(volumeChanged:) name:@"AVSystemController_SystemVolumeDidChangeNotification" object:nil];
    //监控 app 活动状态，打电话/锁屏 时暂停播放
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(becomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resignActive) name:UIApplicationWillResignActiveNotification object:nil];
    
    [self.view setBackgroundColor:[UIColor blackColor]];
    [self createAvPlayer];
    
    [self createTopView];
    [self createSoundView];
    [self createBottomView];
    
    [self performSelector:@selector(hidenControlBar) withObject:nil afterDelay:3];
}
#pragma mark - 初始化
//视频传递
-(id)initWithURL:(NSURL *)url movieTitle:(NSString *)movieTitle movieSize:(NSString*)movieSize
{
    self.isPlaying = NO;
    self.movieURLList = @[url];
    self.titleName = movieTitle;
    self.sizeName = movieSize;
    self.itemTimeList = [[NSMutableArray alloc]initWithCapacity:5];
    return nil;
}
#pragma mark - 创建
//顶部view
-(void)createTopView
{
    _topView = [[UIView alloc]init];
    _topView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    [self.view addSubview:_topView];
    
    //标题
    UILabel *titleLable = [[UILabel alloc]initWithFrame:CGRectMake(51, 0, 250, TopViewHeight)];
    titleLable.backgroundColor = [UIColor clearColor];
    titleLable.text = _titleName;
    [titleLable setFont:[UIFont systemFontOfSize:17]];
    titleLable.textColor = [UIColor whiteColor];
    titleLable.textAlignment = NSTextAlignmentLeft;
    [_topView addSubview:titleLable];
    
    //返回
    _returnBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, TopViewHeight)];
    [_returnBtn addTarget:self action:@selector(popView:) forControlEvents:UIControlEventTouchUpInside];
    [_topView addSubview:_returnBtn];
    
    UIImageView *backImgView = [[UIImageView alloc]init];
    [backImgView setImage:[UIImage imageNamed:BackImgName]];
    [backImgView setFrame:CGRectMake(14, (TopViewHeight-backImgView.image.size.height/2)/2, backImgView.image.size.width/2, backImgView.image.size.height/2)];
    [_returnBtn addSubview:backImgView];
    
    [_topView setHidden:YES];
}
-(void)createSoundView
{
    _soundView = [[UIView alloc]initWithFrame:CGRectMake(0, 81, 27, 135)];
    _soundView.backgroundColor = [UIColor colorWithRed:0.f green:0.f blue:0.f alpha:0.5f];
    [self.view addSubview:_soundView];
    
    UIImageView *soundImgView = [[UIImageView alloc]init];
    [soundImgView setFrame:CGRectMake(6, 117, 15, 11)];
    [soundImgView setImage:[UIImage imageNamed:@"R视频喇叭.png"]];
    [_soundView addSubview:soundImgView];
    
    [_soundView setHidden:YES];
    
    //声音条
    _soundProgressSlider = [[UISlider alloc]initWithFrame:CGRectMake(-41, 132, 108, 20)];
    [_soundProgressSlider setMinimumTrackTintColor:BB_Blue_Color];
    [_soundProgressSlider setMaximumTrackTintColor:BB_White_Color];
    _soundProgressSlider.minimumValue = 0.0f;
    _soundProgressSlider.maximumValue = 1.0f;
    [_soundProgressSlider setValue:[self getVolumeLevel] animated:NO];
    [_soundProgressSlider setThumbImage:[UIImage imageNamed:@"R进度条.png"] forState:UIControlStateNormal];
    [_soundProgressSlider addTarget:self action:@selector(soundDidBegin:) forControlEvents:UIControlEventTouchDown];
    [_soundProgressSlider addTarget:self action:@selector(soundDidChange:) forControlEvents:UIControlEventValueChanged];
    [_soundProgressSlider addTarget:self action:@selector(soundDidEnd:) forControlEvents:(UIControlEventTouchUpInside | UIControlEventTouchCancel)];
    [self.view addSubview:_soundProgressSlider];
    
    _soundProgressSlider.transform=CGAffineTransformMakeRotation(M_PI*3/2);
    
    [_soundProgressSlider setHidden:YES];
}
-(void)createBottomView
{
    _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.height-BottomViewHeight, UI_View_Width, BottomViewHeight)];
    _bottomView.backgroundColor = [UIColor colorWithRed:0.f green:0.f blue:0.f alpha:0.5f];
    [self.view addSubview:_bottomView];
    
    UIView *backView = [[UIView alloc]init];
    [backView setFrame:CGRectMake(0, 0, 50, BottomViewHeight)];
    [backView setBackgroundColor:BB_Blue_Color];
    [_bottomView addSubview:backView];
    
    _playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_playBtn setFrame:CGRectMake(9,8, 32, 32)];
    [_playBtn setImage:[UIImage imageNamed:@"R暂停.png"] forState:UIControlStateNormal];
    [_playBtn addTarget:self action:@selector(pauseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:_playBtn];
    
    UIButton *temBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [temBtn setFrame:CGRectMake(0,0, 50, BottomViewHeight)];
    [temBtn addTarget:self action:@selector(pauseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:temBtn];
    
    //进度条
    _movieProgressSlider = [[UISlider alloc]initWithFrame:CGRectMake(60, 14, 165, 20)];
    [_movieProgressSlider setMinimumTrackTintColor:BB_Blue_Color];
    [_movieProgressSlider setMaximumTrackTintColor:[UIColor whiteColor]];
    [_movieProgressSlider setThumbImage:[UIImage imageNamed:@"R进度条.png"] forState:UIControlStateNormal];
    [_movieProgressSlider addTarget:self action:@selector(scrubbingDidBegin:) forControlEvents:UIControlEventTouchDown];
    [_movieProgressSlider addTarget:self action:@selector(scrubbingDidEnd:) forControlEvents:(UIControlEventTouchUpInside | UIControlEventTouchCancel)];
    [_bottomView addSubview:_movieProgressSlider];
    
    //全屏按钮
    _fullBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_fullBtn setFrame:CGRectMake(UI_View_Width-48,0, 48, 48)];
    [_fullBtn setImage:[UIImage imageNamed:@"R视频全屏按钮.png"] forState:UIControlStateNormal];
    [_fullBtn addTarget:self action:@selector(fullBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:_fullBtn];
    
    //剩余时间
    _remainTimeLable = [[UILabel alloc]initWithFrame:CGRectMake(220, 0, 50, BottomViewHeight)];
    _remainTimeLable.font = [UIFont systemFontOfSize:13];
    _remainTimeLable.textColor = [UIColor whiteColor];
    _remainTimeLable.backgroundColor = [UIColor clearColor];
    _remainTimeLable.textAlignment = NSTextAlignmentRight;
    [_bottomView addSubview:_remainTimeLable];
    
    //视频大小
    _sizeLable = [[UILabel alloc]initWithFrame:CGRectMake(UI_View_Height+64-100+55, 0, 45, BottomViewHeight)];
    _sizeLable.backgroundColor = [UIColor clearColor];
    _sizeLable.text = self.sizeName;
    [_sizeLable setFont:[UIFont systemFontOfSize:13]];
    _sizeLable.textColor = [UIColor whiteColor];
    _sizeLable.textAlignment = NSTextAlignmentLeft;
    [_bottomView addSubview:_sizeLable];
    
    [_sizeLable setHidden:YES];
}
-(void)createAvPlayer
{
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    CGRect playerFrame = CGRectMake(0, 0, UI_View_Width, AllViewHeight);
    
    __block CMTime totalTime = CMTimeMake(0, 0);
    [self.movieURLList enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSURL *url = (NSURL *)obj;
        AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:url];
        totalTime.value += playerItem.asset.duration.value;
        totalTime.timescale = playerItem.asset.duration.timescale;
        [_itemTimeList addObject:[NSNumber numberWithDouble:((double)playerItem.asset.duration.value/totalTime.timescale)]];
    }];
    _movieLength = (CGFloat)totalTime.value/totalTime.timescale;
    _player = [AVPlayer playerWithPlayerItem:[AVPlayerItem playerItemWithURL:(NSURL *)_movieURLList[0]]];
    
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
    _playerLayer.frame = playerFrame;
    _playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    [self.view.layer addSublayer:_playerLayer];
    
    [_player play];
    _currentPlayingItem = 0;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerItemDidReachEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    
    typeof(_player) player_ = _player;
    typeof(_itemTimeList) itemTimeList_ = _itemTimeList;
    typeof(_currentPlayingItem) *currentPlayingItem_ = &_currentPlayingItem;
    __block RVideoPlayVC *controller = self;
    
    //第一个参数反应了检测的频率
    _timeObserver = [_player addPeriodicTimeObserverForInterval:CMTimeMake(3, 30) queue:NULL usingBlock:^(CMTime time)
                    {
                        //获取当前时间
                        CMTime currentTime = player_.currentItem.currentTime;
                        double currentPlayTime = (double)currentTime.value/currentTime.timescale;
                        
                        NSInteger currentTemp = *currentPlayingItem_;
                        
                        while (currentTemp > 0)
                        {
                            currentPlayTime += [(NSNumber *)itemTimeList_[currentTemp-1] doubleValue];
                            --currentTemp;
                        }
                        //转成秒数
                        CGFloat remainingTime = _movieLength - currentPlayTime;
                        NSDate *remainingDate = [NSDate dateWithTimeIntervalSince1970:remainingTime];
                        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                        [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
                        [formatter setDateFormat:(remainingTime/3600>=1)? @"h:mm:ss":@"mm:ss"];
                        NSString *remainingTimeStr = [NSString stringWithFormat:@"-%@",[formatter stringFromDate:remainingDate]];
                        
                        [controller setProgressContent:remainingTimeStr valueContent:(currentPlayTime/_movieLength)];
                    }];
}
//设置信息
-(void)setProgressContent:(NSString*)remainingTimeStr valueContent:(float)valueContent
{
    [_remainTimeLable setText:remainingTimeStr];
    [_movieProgressSlider setValue:valueContent animated:NO];
}
#pragma mark - 自定义
#pragma mark 事件
-(void)leftbtnPressed:(id)sender
{
    [self.delegate RVideoPlayBack];
}
//变成小屏幕
-(void)popView:(id)sender
{
    [self.delegate RVideoPlayBack];
}
//暂停
-(void)pauseBtnClick:(id)sender
{
    _isPlaying = !_isPlaying;
    if (_isPlaying)
    {
        [_player play];
        [_playBtn setImage:[UIImage imageNamed:@"R暂停.png"] forState:UIControlStateNormal];
        
    }else
    {
        [_player pause];
        [_playBtn setImage:[UIImage imageNamed:@"R播放.png"] forState:UIControlStateNormal];
    }
}
//按动进度滑块
-(void)scrubbingDidBegin:(id)sender
{
    _gestureType = GestureTypeOfProgress;
    [_player pause];
    [_playBtn setImage:[UIImage imageNamed:@"R播放.png"] forState:UIControlStateNormal];
}
//拖动进度条
-(void)scrubberIsScrolling
{
    double currentTime = floor(_movieLength *_movieProgressSlider.value);
    
    int i = 0;
    double temp = [((NSNumber *)_itemTimeList[i]) doubleValue];
    while (currentTime > temp) {
        ++i;
        temp += [((NSNumber *)_itemTimeList[i]) doubleValue];
    }
    if (i != _currentPlayingItem) {
        [_player replaceCurrentItemWithPlayerItem:[AVPlayerItem playerItemWithURL:(NSURL *)_movieURLList[i]]];
        _currentPlayingItem = i;
    }
    temp -= [((NSNumber *)_itemTimeList[i]) doubleValue];
    
    //转换成CMTime才能给player来控制播放进度
    CMTime dragedCMTime = CMTimeMake(currentTime-temp, 1);
    [_player seekToTime:dragedCMTime completionHandler:
     ^(BOOL finish){
         [_player play];
     }];
}
//释放进度滑块
-(void)scrubbingDidEnd:(id)sender
{
    _gestureType = GestureTypeOfNone;
    [_playBtn setImage:[UIImage imageNamed:@"R暂停.png"] forState:UIControlStateNormal];
    
    [self scrubberIsScrolling];
}
//拖动声音滑块
-(void)soundDidBegin:(id)sender
{
    
}
//改变声音
-(void)soundDidChange:(id)sender
{
    MPVolumeView*slide =[MPVolumeView new];
    UISlider*volumeViewSlider;
    for(UIView*view in[slide subviews])
    {
        if([[[view class] description] isEqualToString:@"MPVolumeSlider"])
        {
            volumeViewSlider =(UISlider*) view;
        }
    }
    [volumeViewSlider setValue:_soundProgressSlider.value animated:YES];
}
//拖动释放滑块
-(void)soundDidEnd:(id)sender
{
    
}
//全屏按钮
-(void)fullBtnClick:(id)sender
{
    [self.delegate RVideoPlayFull];
}
//声音增加
- (void)volumeAdd:(CGFloat)step
{
    MPVolumeView*slide =[MPVolumeView new];
    UISlider*volumeViewSlider;
    for(UIView*view in[slide subviews])
    {
        if([[[view class] description] isEqualToString:@"MPVolumeSlider"])
        {
            volumeViewSlider =(UISlider*) view;
        }
    }
    float x = volumeViewSlider.value;
    [volumeViewSlider setValue:x + step animated:NO];
}
#pragma mark 监听通知
//声音改变
-(void)volumeChanged:(NSNotification *)notification
{
    float volume = [[[notification userInfo] objectForKey:@"AVSystemController_AudioVolumeNotificationParameter"]floatValue];
    [_soundProgressSlider setValue:volume animated:NO];
}
//视频播放到结尾
- (void)playerItemDidReachEnd:(NSNotification *)notification
{
    [_playBtn setImage:[UIImage imageNamed:@"R播放.png"] forState:UIControlStateNormal];
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"status"])
    {
        
    }
}
-(void)VideoBack
{
    [_delegate RVideoPlayOver];
}
//程序活动的动作
- (void)becomeActive
{
    [self pauseBtnClick:nil];
}
//程序不活动的动作
- (void)resignActive
{
    [self pauseBtnClick:nil];
}
#pragma mark touch event
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint currentLocation = [touch locationInView:self.view];
    CGFloat offset_x = currentLocation.x - _originalLocation.x;
    CGFloat offset_y = currentLocation.y - _originalLocation.y;
    if (CGPointEqualToPoint(_originalLocation,CGPointZero))
    {
        _originalLocation = currentLocation;
        return;
    }
    _originalLocation = currentLocation;
    
    CGRect frame = [UIScreen mainScreen].bounds;
    if (_gestureType == GestureTypeOfNone)
    {
        if ((currentLocation.x > frame.size.height*0.8) && (ABS(offset_x) <= ABS(offset_y)))
        {
            _gestureType = GestureTypeOfVolume;
        }else if ((currentLocation.x < frame.size.height*0.2) && (ABS(offset_x) <= ABS(offset_y)))
        {
            _gestureType = GestureTypeOfBrightness;
        }else if ((ABS(offset_x) > ABS(offset_y)))
        {
            _gestureType = GestureTypeOfProgress;
        }
    }
    if ((_gestureType == GestureTypeOfProgress) && (ABS(offset_x) > ABS(offset_y)))
    {
        if (_isFullScreen)
        {
            [_player pause];
            [_playBtn setImage:[UIImage imageNamed:@"R播放.png"] forState:UIControlStateNormal];
            
            if (offset_x > 0)
            {
                _movieProgressSlider.value += 0.005;
            }else
            {
                _movieProgressSlider.value -= 0.005;
            }
        }
    }else if ((_gestureType == GestureTypeOfVolume) && (currentLocation.x > frame.size.height*0.8) && (ABS(offset_x) <= ABS(offset_y)))
    {
        if (_isFullScreen)
        {
            if (offset_y > 0)
            {
                [self volumeAdd:-VolumeStep];
            }else
            {
                [self volumeAdd:VolumeStep];
            }
        }
    }else if ((_gestureType == GestureTypeOfBrightness) && (currentLocation.x < frame.size.height*0.2) && (ABS(offset_x) <= ABS(offset_y)))
    {
        
    }
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    _originalLocation = CGPointZero;
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.view];
    if (_gestureType == GestureTypeOfNone && !CGRectContainsPoint(self.bottomView.frame, point) && !CGRectContainsPoint(self.topView.frame, point))
    {
        //这说明是轻拍收拾，隐藏／现实状态栏
        [UIView animateWithDuration:0.25 animations:^{
            if (_topView.frame.origin.y < 0)
            {
                //显示
                [self showControlBar];
                [self performSelector:@selector(hidenControlBar) withObject:nil afterDelay:3];
            }else
            {
                //隐藏
                [self hidenControlBar];
            }
        }];
    }else if (_gestureType == GestureTypeOfProgress)
    {
        _gestureType = GestureTypeOfNone;
        if (_isFullScreen)
        {
            [_playBtn setImage:[UIImage imageNamed:@"R暂停.png"] forState:UIControlStateNormal];
            [self scrubberIsScrolling];
        }
    }else
    {
        _gestureType = GestureTypeOfNone;
    }
}
#pragma mark 方法
//获取系统音量
-(float)getVolumeLevel
{
    MPVolumeView*slide =[MPVolumeView new];
    UISlider*volumeViewSlider;
    for(UIView*view in[slide subviews])
    {
        if([[[view class] description] isEqualToString:@"MPVolumeSlider"])
        {
            volumeViewSlider =(UISlider*) view;
        }
    }
    float val =[volumeViewSlider value];
    return val;
}
//隐藏上下条
- (void)hidenControlBar
{
    [UIView animateWithDuration:0.25 animations:^{
        [_topView setHidden:YES];
        [_soundView setHidden:YES];
        [_soundProgressSlider setHidden:YES];
        [_bottomView setHidden:YES];
        
        if (_isFullScreen)
        {
            [self.topView setFrame:CGRectMake(0, -64, UI_View_Height+64, 64)];
        }else
        {
            [self.topView setFrame:CGRectMake(0, -64, UI_View_Width, 64)];
        }
    }];
}
//显示上下条
- (void)showControlBar
{
    [UIView animateWithDuration:0.25 animations:^{
        if (_isFullScreen)
        {
            [_topView setHidden:NO];
            [_soundView setHidden:NO];
            [_soundProgressSlider setHidden:NO];
            [_bottomView setHidden:NO];
            
            [self.topView setFrame:CGRectMake(0, 0, UI_View_Height+64, 64)];
        }else
        {
            [_topView setHidden:YES];
            [_soundView setHidden:YES];
            [_soundProgressSlider setHidden:YES];
            [_bottomView setHidden:NO];
            
            [self.topView setFrame:CGRectMake(0, 0, UI_View_Width, 64)];
        }
    }];
}
//全屏
-(void)fullChange
{
    self.isFullScreen = YES;
    
    [self.playerLayer setFrame:CGRectMake(0, 0, UI_View_Height+64, UI_View_Width)];
    [self.bottomView setFrame:CGRectMake(0, UI_View_Width-48, UI_View_Height+64, 48)];
    [self.topView setFrame:CGRectMake(0, 0, UI_View_Height+64, 64)];
    [self.movieProgressSlider setFrame:CGRectMake(60, 14, UI_View_Height+64-160, 20)];
    [self.remainTimeLable setFrame:CGRectMake(UI_View_Height+64-100, 0, 50, 48)];
    [self.topView setHidden:NO];
    [self.bottomView setHidden:NO];
    [self.soundProgressSlider setHidden:NO];
    [self.fullBtn setHidden:YES];
    [self.soundView setHidden:NO];
    [self.sizeLable setHidden:NO];
    self.isFullScreen = YES;
}
//小屏
-(void)smallChange
{
    [self.topView setFrame:CGRectMake(0, -64, UI_View_Width, 64)];
    [self.playerLayer setFrame:CGRectMake(0, 0, UI_View_Width, AllViewHeight)];
    [self.bottomView setFrame:CGRectMake(0, AllViewHeight-48, UI_View_Width, 48)];
    [self.movieProgressSlider setFrame:CGRectMake(60, 14, 165, 20)];
    [self.remainTimeLable setFrame:CGRectMake(220, 0, 50, 48)];
    [self.topView setHidden:YES];
    [self.bottomView setHidden:NO];
    [self.soundProgressSlider setHidden:YES];
    [self.fullBtn setHidden:NO];
    [self.soundView setHidden:YES];
    [self.sizeLable setHidden:YES];
    self.isFullScreen = NO;
}
@end
