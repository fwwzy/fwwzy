//
//  RActivityTrackingVC.m
//  Hema
//
//  Created by geyang on 15/11/5.
//  Copyright © 2015年 Hemaapp. All rights reserved.
//

#import "RActivityTrackingVC.h"
#import <CoreMotion/CoreMotion.h>

@interface RActivityTrackingVC ()
@property(nonatomic,strong)CMStepCounter *stepCounter;
@property(nonatomic,strong)CMMotionActivityManager *activityManager;
@property(nonatomic,strong)NSOperationQueue *operationQueue;
@property(nonatomic,strong)UILabel *stepsLabel;
@property(nonatomic,strong)UILabel *statusLabel;
@property(nonatomic,strong)UILabel *confidenceLabel;
@end

@implementation RActivityTrackingVC

- (void)viewWillDisappear:(BOOL)animated
{
    [self.stepCounter stopStepCountingUpdates];
    [self.activityManager stopActivityUpdates];
    [self.operationQueue cancelAllOperations];
    [super viewWillDisappear:animated];
}
-(void)loadSet
{
    [self.navigationItem setNewTitle:@"运动跟踪检测"];
    
    _stepsLabel = [[UILabel alloc]init];
    _stepsLabel.backgroundColor = [UIColor clearColor];
    _stepsLabel.textAlignment = NSTextAlignmentLeft;
    _stepsLabel.font = [UIFont systemFontOfSize:14];
    _stepsLabel.frame = CGRectMake(10, 100, UI_View_Width-20, 20);
    _stepsLabel.textColor = BB_Blake_Color;
    [self.view addSubview:_stepsLabel];
    
    _statusLabel = [[UILabel alloc]init];
    _statusLabel.backgroundColor = [UIColor clearColor];
    _statusLabel.textAlignment = NSTextAlignmentLeft;
    _statusLabel.font = [UIFont systemFontOfSize:14];
    _statusLabel.frame = CGRectMake(10, 140, UI_View_Width-20, 20);
    _statusLabel.textColor = BB_Blake_Color;
    [self.view addSubview:_statusLabel];
    
    _confidenceLabel = [[UILabel alloc]init];
    _confidenceLabel.backgroundColor = [UIColor clearColor];
    _confidenceLabel.textAlignment = NSTextAlignmentLeft;
    _confidenceLabel.font = [UIFont systemFontOfSize:14];
    _confidenceLabel.frame = CGRectMake(10, 180, UI_View_Width-20, 20);
    _confidenceLabel.textColor = BB_Blake_Color;
    [self.view addSubview:_confidenceLabel];
    
    [self startTracking];
}
#pragma mark- 自定义
#pragma mark 方法
//开始检测
- (void)startTracking
{
    if (!([CMStepCounter isStepCountingAvailable] || [CMMotionActivityManager isActivityAvailable]))
    {
        NSString *msg = @"此功能此设备不支持，请用有M7处理器的设备！";
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"不支持此设备"
                                                        message:msg
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    __weak RActivityTrackingVC *weakSelf = self;
    self.operationQueue = [[NSOperationQueue alloc] init];
    
    //开始检测步数
    if ([CMStepCounter isStepCountingAvailable])
    {
        self.stepCounter = [[CMStepCounter alloc] init];
        [self.stepCounter startStepCountingUpdatesToQueue:self.operationQueue
                                                 updateOn:1
                                              withHandler:
         ^(NSInteger numberOfSteps, NSDate *timestamp, NSError *error) {
             dispatch_async(dispatch_get_main_queue(), ^{
                 if (error)
                 {
                     [HemaFunction openIntervalHUD:error.description];
                 }else
                 {
                     NSString *text = [NSString stringWithFormat:@"步数: %ld", (long)numberOfSteps];
                     [weakSelf.stepsLabel setText:text];
                 }
             });
         }];
    }
    //开始检测运行情况
    if ([CMMotionActivityManager isActivityAvailable])
    {
        self.activityManager = [[CMMotionActivityManager alloc] init];
        [self.activityManager startActivityUpdatesToQueue:self.operationQueue
                                              withHandler:
         ^(CMMotionActivity *activity)
        {
             dispatch_async(dispatch_get_main_queue(), ^{
                 NSString *status = [weakSelf statusForActivity:activity];
                 NSString *confidence = [weakSelf stringFromConfidence:activity.confidence];
                 
                 [weakSelf.statusLabel setText:[NSString stringWithFormat:@"状态: %@", status]];
                 [weakSelf.confidenceLabel setText:[NSString stringWithFormat:@"可信度: %@", confidence]];
             });
         }];
    }
}
- (NSString *)statusForActivity:(CMMotionActivity *)activity
{
    NSMutableString *status = @"".mutableCopy;
    if (activity.stationary)
    {
        [status appendString:@"没有移动"];
    }
    if (activity.walking)
    {
        if (status.length)
            [status appendString:@", "];
        [status appendString:@"一个“走”的人"];
    }
    if (activity.running)
    {
        if (status.length)
            [status appendString:@", "];
        [status appendString:@"一个“跑”的人"];
    }
    if (activity.automotive)
    {
        if (status.length)
            [status appendString:@", "];
        [status appendString:@"一个“在车里”的人"];
    }
    if (activity.unknown || !status.length)
    {
        [status appendString:@"未知"];
    }
    return status;
}
- (NSString *)stringFromConfidence:(CMMotionActivityConfidence)confidence
{
    switch (confidence)
    {
        case CMMotionActivityConfidenceLow:
            return @"低";
        case CMMotionActivityConfidenceMedium:
            return @"中";
        case CMMotionActivityConfidenceHigh:
            return @"高";
        default:
            return nil;
    }
}
@end
