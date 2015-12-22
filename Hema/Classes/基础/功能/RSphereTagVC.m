//
//  RSphereTagVC.m
//  Hema
//
//  Created by geyang on 15/11/6.
//  Copyright © 2015年 Hemaapp. All rights reserved.
//

#import "RSphereTagVC.h"
#import "ZYQSphereView.h"

@interface RSphereTagVC ()
@property(nonatomic,strong)ZYQSphereView *sphereView;
@end

@implementation RSphereTagVC

-(void)loadSet
{
    [self.navigationItem setNewTitle:@"标签云"];
    self.view.backgroundColor = [UIColor blackColor];
    
    _sphereView = [[ZYQSphereView alloc] initWithFrame:CGRectMake((UI_View_Width - 300)/2.0, 50, 300, 300)];
    NSMutableArray *views = [[NSMutableArray alloc] init];
    for (int i = 0; i < 50; i++)
    {
        HemaButton *subV = [[HemaButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        subV.backgroundColor = [UIColor colorWithRed:arc4random_uniform(100)/100. green:arc4random_uniform(100)/100. blue:arc4random_uniform(100)/100. alpha:1];
        [subV setTitle:[NSString stringWithFormat:@"%d",i] forState:UIControlStateNormal];
        subV.layer.masksToBounds = YES;
        subV.layer.cornerRadius = 3;
        subV.btnRow = i;
        [subV addTarget:self action:@selector(subVClick:) forControlEvents:UIControlEventTouchUpInside];
        [views addObject:subV];
    }
    [_sphereView setItems:views];
    _sphereView.isPanTimerStart=YES;
    [self.view addSubview:_sphereView];
    
    [_sphereView timerStart];
    
    HemaButton *changeBtn = [HemaButton buttonWithType:UIButtonTypeCustom];
    [changeBtn setFrame:CGRectMake((UI_View_Width-120)/2, CGRectGetMaxY(_sphereView.frame)+20, 120, 30)];
    [HemaFunction addbordertoView:changeBtn radius:1 width:1 color:[UIColor magentaColor]];
    [changeBtn setTitle:@"开始/停止" forState:UIControlStateNormal];
    [changeBtn setTitleColor:[UIColor magentaColor] forState:UIControlStateNormal];
    [changeBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [changeBtn addTarget:self action:@selector(changePressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:changeBtn];
}
#pragma mark- 自定义
#pragma mark 事件
//点击标签
-(void)subVClick:(HemaButton*)sender
{
    NSLog(@"%@",sender.titleLabel.text);
    BOOL isStart = [_sphereView isTimerStart];
    [_sphereView timerStop];
    
    [UIView animateWithDuration:0.3 animations:^{
        sender.transform=CGAffineTransformMakeScale(1.5, 1.5);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 animations:^{
            sender.transform=CGAffineTransformMakeScale(1, 1);
            if (isStart) {
                [_sphereView timerStart];
            }
        }];
    }];
}
//改变状态
-(void)changePressed:(id)sender
{
    if ([_sphereView isTimerStart])
    {
        [_sphereView timerStop];
    }else
    {
        [_sphereView timerStart];
    }
}
@end
