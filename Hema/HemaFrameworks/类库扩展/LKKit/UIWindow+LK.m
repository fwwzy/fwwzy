//
//  UIWindow+LK.m
//  LJHV2
//
//  Created by LK on 13-7-2.
//  Copyright (c) 2013年 LJH. All rights reserved.
//

#import "UIWindow+LK.h"
#import "UIView+Toast_LK.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIWindow (LK)

+(UIWindow*)getShowWindow
{
    UIWindow *window = nil;
    NSArray *windows = [UIApplication sharedApplication].windows;
    for (UIWindow *uiWindow in windows)
    {
        //有inputView或者键盘时，避免提示被挡住，应该选择这个 UITextEffectsWindow 来显示
        if ([NSStringFromClass(uiWindow.class) isEqualToString:@"UITextEffectsWindow"])
        {
            window = uiWindow;
            break;
        }
    }
    if (!window)
    {
        window = [[UIApplication sharedApplication] keyWindow];
    }
    return window;
}

+(UILabel*)labelWithText:(NSString*)text
{
    UILabel* lb = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 250, 0)];
    lb.font = [UIFont systemFontOfSize:16];
    lb.textColor = [UIColor whiteColor];
    lb.backgroundColor = [UIColor clearColor];
    lb.text = text;
    [lb sizeToFit];
    return lb;
}


- (void)removeKeyboardShadow
{
    NSEnumerator* enumerator = [UIApplication sharedApplication].windows.reverseObjectEnumerator;
    for (UIWindow *window in enumerator) {
        if (![window.class isEqual:[UIWindow class]]) {
            for (UIView *view in window.subviews) {
                if (strcmp("UIPeripheralHostView", object_getClassName(view)) == 0) {
                    UIView *shadowView = view.subviews[0];
                    if ([shadowView isKindOfClass:[UIImageView class]]) {
                        shadowView.hidden = YES;
                        return;
                    }
                }
            }
        }
    }
}


static __weak UIView *lastToast = nil;

+(void)showToastCircleMessage:(NSString*)message subMes:(NSString*)subMes
{
    UIWindow *window = [self getShowWindow];
    float duration = (float)message.length*0.08 + 0.3;
    
    UILabel* row1 = nil,*row2 = nil;
    
    if(message)
        row1 = [self labelWithText:message];
    if(subMes)
        row2 = [self labelWithText:subMes];
    
    float width = MAX(row1.width, row2.width);
    if(width == 0)
        return;
    
    float height = row1.height + row2.height;
    if(row1 && row2)
    {
        height +=2;
    }
    
    float diameter = sqrtf(width*width + height*height) + 10;
    
    CAShapeLayer* layer = [[CAShapeLayer alloc]init];
    
    CGPathRef pathRef = CGPathCreateWithEllipseInRect(CGRectMake(0, 0, diameter, diameter), NULL);
    layer.path = pathRef;
    CGPathRelease(pathRef);
    
    layer.fillColor = [UIColor colorWithWhite:0 alpha:0.5].CGColor;
    
    if (lastToast)
    {
        [lastToast removeFromSuperview];
        lastToast = nil;
    }
    __block UIView* showView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, diameter, diameter)];
    lastToast = showView;
    [showView.layer addSublayer:layer];
    
    showView.center = CGPointMake(window.width/2, window.height/2);
    showView.alpha = 0;
    [window addSubview:showView];
    
    row1.origin = CGPointMake((diameter-row1.width)/2,(diameter - height )/2);
    row2.origin = CGPointMake((diameter-row2.width)/2, (row1?(row1.bottom + 2):(diameter - height )/2));
    
    [showView addSubview:row1];
    [showView addSubview:row2];
    
    [UIView animateWithDuration:0.2 animations:^{
        showView.alpha = 1;
    } completion:^(BOOL finished) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(MIN(MAX(1, duration), 3) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.2 animations:^{
                showView.alpha = 0;
            } completion:^(BOOL finished) {
                [showView removeFromSuperview];
                showView = nil;
            }];
        });
    }];
}
+(void)showToastMessage:(NSString *)message
{
    [self showToastMessage:message withColor:nil];
}

+(void)showToastMessage:(NSString *)message withColor:(UIColor *)color
{
    UIWindow *window = [self getShowWindow];
    float duration = (float)message.length*0.08 + 0.3;
    [window makeToast:message messageColor:color duration:MIN(MAX(1, duration), 3) position:@"center"];
}
+(void)showToastMessage:(NSString *)message withColor:(UIColor *)color duration:(CGFloat)interval
{
    UIWindow *window = [self getShowWindow];
    float duration = (interval>0)?interval:1.5f;
    [window makeToast:message messageColor:color duration:MIN(MAX(1, duration), 3) position:@"center"];
}
@end
