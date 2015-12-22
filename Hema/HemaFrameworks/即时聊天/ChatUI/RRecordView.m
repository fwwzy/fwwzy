//
//  RecordView.m
//  PingChuan
//
//  Created by LarryRodic on 15/8/27.
//  Copyright (c) 2015年 平川嘉恒. All rights reserved.
//

#import "RRecordView.h"

@interface RRecordView ()
{
    NSTimer *_timer;
    // 显示动画的ImageView
    UIImageView *_recordAnimationView;
    // 提示文字
    UILabel *_textLabel;
    BOOL isQuit;//是否是取消
}
@end

@implementation RRecordView
@synthesize recorder;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UIView *bgView = [[UIView alloc] initWithFrame:self.bounds];
        bgView.backgroundColor = [UIColor grayColor];
        bgView.layer.cornerRadius = 5;
        bgView.layer.masksToBounds = YES;
        bgView.alpha = 0.6;
        [self addSubview:bgView];
        
        _recordAnimationView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, self.bounds.size.width - 20, self.bounds.size.height - 10)];
        _recordAnimationView.image = [UIImage imageNamed:@"VoiceSearchFeedback001"];
        [self addSubview:_recordAnimationView];
        
        _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(5,
                                                               self.bounds.size.height - 30,
                                                               self.bounds.size.width - 10,
                                                               25)];
        
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.backgroundColor = [UIColor clearColor];
        _textLabel.text = @"手指上滑 取消发送";
        [self addSubview:_textLabel];
        _textLabel.font = [UIFont systemFontOfSize:13];
        _textLabel.textColor = [UIColor whiteColor];
        _textLabel.layer.cornerRadius = 5;
        _textLabel.layer.borderColor = [[UIColor redColor] colorWithAlphaComponent:0.5].CGColor;
        _textLabel.layer.masksToBounds = YES;
    }
    return self;
}

// 录音按钮按下
-(void)recordButtonTouchDown
{
    // 需要根据声音大小切换recordView动画
    _textLabel.text = @"手指上滑 取消发送";
    _textLabel.backgroundColor = [UIColor clearColor];
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.05
                                              target:self
                                            selector:@selector(setVoiceImage)
                                            userInfo:nil
                                             repeats:YES];
}
// 手指在录音按钮内部时离开
-(void)recordButtonTouchUpInside
{
    isQuit = NO;
    _recordAnimationView.image = [UIImage imageNamed:@"VoiceSearchFeedback001"];
    [_recordAnimationView setFrame:CGRectMake(10, 0, self.bounds.size.width - 20, self.bounds.size.height - 10)];
    [_timer invalidate];
}
// 手指在录音按钮外部时离开
-(void)recordButtonTouchUpOutside
{
    isQuit = NO;
    _recordAnimationView.image = [UIImage imageNamed:@"VoiceSearchFeedback001"];
    [_recordAnimationView setFrame:CGRectMake(10, 0, self.bounds.size.width - 20, self.bounds.size.height - 10)];
    [_timer invalidate];
}
// 手指移动到录音按钮内部
-(void)recordButtonDragInside
{
    isQuit = NO;
    [_recordAnimationView setFrame:CGRectMake(10, 0, self.bounds.size.width - 20, self.bounds.size.height - 10)];
    //[_recordAnimationView setFrame:CGRectMake(42.5, 5, 55, 99)];
    
    _textLabel.text = @"手指上滑 取消发送";
    _textLabel.backgroundColor = [UIColor clearColor];
}

// 手指移动到录音按钮外部
-(void)recordButtonDragOutside
{
    isQuit = YES;
    _recordAnimationView.image = [UIImage imageNamed:@"R取消语音.png"];
    [_recordAnimationView setFrame:CGRectMake(42.5, 5, 55, 99)];
    
    _textLabel.text = @"松开手指 取消发送";
    _textLabel.backgroundColor = [UIColor redColor];
}

-(void)setVoiceImage
{
    if (isQuit)
    {
        return;
    }
    _recordAnimationView.image = [UIImage imageNamed:@"VoiceSearchFeedback001"];
    //_recordAnimationView.image = [UIImage imageNamed:@"弹出语音0.png"];
    //[_recordAnimationView setFrame:CGRectMake(42.5, 5, 55, 99)];
    
    double voiceSound = 0;
    voiceSound = 0;
    if (recorder.isRecording)
    {
        [recorder updateMeters];
        
        //获取音量的平均值  [recorder averagePowerForChannel:0];
        //音量的最大值  [recorder peakPowerForChannel:0];
        
        voiceSound = pow(10, (0.05 * [recorder peakPowerForChannel:0]));
        NSLog(@"音量：%lf",voiceSound);
    }
    //[_recordAnimationView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"弹出语音%d.png",(int)(voiceSound*9)]]];
    
    if (0 < voiceSound <= 0.05) {
        [_recordAnimationView setImage:[UIImage imageNamed:@"VoiceSearchFeedback001"]];
    }else if (0.05<voiceSound<=0.10) {
        [_recordAnimationView setImage:[UIImage imageNamed:@"VoiceSearchFeedback002"]];
    }else if (0.10<voiceSound<=0.15) {
        [_recordAnimationView setImage:[UIImage imageNamed:@"VoiceSearchFeedback003"]];
    }else if (0.15<voiceSound<=0.20) {
        [_recordAnimationView setImage:[UIImage imageNamed:@"VoiceSearchFeedback004"]];
    }else if (0.20<voiceSound<=0.25) {
        [_recordAnimationView setImage:[UIImage imageNamed:@"VoiceSearchFeedback005"]];
    }else if (0.25<voiceSound<=0.30) {
        [_recordAnimationView setImage:[UIImage imageNamed:@"VoiceSearchFeedback006"]];
    }else if (0.30<voiceSound<=0.35) {
        [_recordAnimationView setImage:[UIImage imageNamed:@"VoiceSearchFeedback007"]];
    }else if (0.35<voiceSound<=0.40) {
        [_recordAnimationView setImage:[UIImage imageNamed:@"VoiceSearchFeedback008"]];
    }else if (0.40<voiceSound<=0.45) {
        [_recordAnimationView setImage:[UIImage imageNamed:@"VoiceSearchFeedback009"]];
    }else if (0.45<voiceSound<=0.50) {
        [_recordAnimationView setImage:[UIImage imageNamed:@"VoiceSearchFeedback010"]];
    }else if (0.50<voiceSound<=0.55) {
        [_recordAnimationView setImage:[UIImage imageNamed:@"VoiceSearchFeedback011"]];
    }else if (0.55<voiceSound<=0.60) {
        [_recordAnimationView setImage:[UIImage imageNamed:@"VoiceSearchFeedback012"]];
    }else if (0.60<voiceSound<=0.65) {
        [_recordAnimationView setImage:[UIImage imageNamed:@"VoiceSearchFeedback013"]];
    }else if (0.65<voiceSound<=0.70) {
        [_recordAnimationView setImage:[UIImage imageNamed:@"VoiceSearchFeedback014"]];
    }else if (0.70<voiceSound<=0.75) {
        [_recordAnimationView setImage:[UIImage imageNamed:@"VoiceSearchFeedback015"]];
    }else if (0.75<voiceSound<=0.80) {
        [_recordAnimationView setImage:[UIImage imageNamed:@"VoiceSearchFeedback016"]];
    }else if (0.80<voiceSound<=0.85) {
        [_recordAnimationView setImage:[UIImage imageNamed:@"VoiceSearchFeedback017"]];
    }else if (0.85<voiceSound<=0.90) {
        [_recordAnimationView setImage:[UIImage imageNamed:@"VoiceSearchFeedback018"]];
    }else if (0.90<voiceSound<=0.95) {
        [_recordAnimationView setImage:[UIImage imageNamed:@"VoiceSearchFeedback019"]];
    }else {
        [_recordAnimationView setImage:[UIImage imageNamed:@"VoiceSearchFeedback020"]];
    }
}

@end
