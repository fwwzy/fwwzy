//
//  UIWebView+JavaScriptAlert.m
//  Hema
//
//  Created by LarryRodic on 15/10/18.
//  Copyright (c) 2015年 Hemaapp. All rights reserved.
//

#import "UIWebView+JavaScriptAlert.h"

@implementation UIWebView (JavaScriptAlert)

static BOOL diagStat = NO;

-(void)webView:(UIWebView *)sender runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(CGRect *)frame
{
    //在这处理弹框逻辑 可以发送通知进行处理
    UIAlertView* dialogue = [[UIAlertView alloc]initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [dialogue show];
}

-(BOOL)webView:(UIWebView *)sender runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(CGRect *)frame
{
    UIAlertView* dialogue = [[UIAlertView alloc] initWithTitle:nil message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    [dialogue show];
    while (dialogue.hidden==NO && dialogue.superview!=nil)
    {
        [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.01f]];
    }
    return diagStat;
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0)
    {
        diagStat=YES;
    }else if(buttonIndex==1)
    {
        diagStat=NO;
    }
}
@end