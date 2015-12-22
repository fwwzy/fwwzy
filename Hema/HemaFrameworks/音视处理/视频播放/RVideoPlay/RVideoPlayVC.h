//
//  RVideoPlayVC.h
//  Hema
//
//  Created by LarryRodic on 15/10/20.
//  Copyright (c) 2015年 Hemaapp. All rights reserved.
//
#define AllViewHeight 178 //短屏时的高度
#import "AllVC.h"

@protocol RVideoPlayDelegate;
@interface RVideoPlayVC : AllVC
@property(nonatomic,assign)NSObject<RVideoPlayDelegate>* delegate;
@property(nonatomic,strong)NSArray *movieURLList;//地址列表
@property(nonatomic,strong)NSMutableArray *itemTimeList;//时间数组（有待研究）
@property(nonatomic,assign)BOOL isFullScreen;//是否全屏
@property(nonatomic,assign)BOOL isPlaying;//是否正在播放
@property(nonatomic,assign)CGFloat movieLength;//视频时长
@property(nonatomic,assign)NSInteger currentPlayingItem;//当前播放的视频
@property(nonatomic,copy)NSString *sizeName;//视频大小名称
@property(nonatomic,copy)NSString *titleName;//视频名称
@property(nonatomic,assign)id timeObserver;//（有待研究）

//视频播放器界面的布局 全屏采取旋转的方式
@property(nonatomic,strong)AVPlayerLayer *playerLayer;//播放器layer
@property(nonatomic,strong)AVPlayer *player;//播放器
@property(nonatomic,strong)UIView *topView;//顶部view
@property(nonatomic,strong)UIView *bottomView;//底部view
@property(nonatomic,strong)UIView *soundView;//声音view
@property(nonatomic,strong)UIButton *playBtn;//播放、暂停按钮
@property(nonatomic,strong)UIButton *fullBtn;//全屏按钮
@property(nonatomic,strong)UISlider *movieProgressSlider;//视频进度条
@property(nonatomic,strong)UISlider *soundProgressSlider;//声音进度条
@property(nonatomic,strong)UILabel *remainTimeLable;//剩余时间
@property(nonatomic,strong)UILabel *sizeLable;//视频大小
@property(nonatomic,strong)UIButton *returnBtn;//返回按钮

-(id)initWithURL:(NSURL *)url movieTitle:(NSString *)movieTitle movieSize:(NSString*)movieSize;
-(void)fullChange;//全屏
-(void)smallChange;//小屏
@end

//返回时调用
@protocol RVideoPlayDelegate <NSObject>
@required

@optional
-(void)RVideoPlayBack;//返回小屏
-(void)RVideoPlayFull;//全屏
-(void)RVideoPlayOver;//视频播放结束
@end