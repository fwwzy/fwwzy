//
//  UIWebView+JavaScriptAlert.h
//  Hema
//
//  Created by LarryRodic on 15/10/18.
//  Copyright (c) 2015年 Hemaapp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIWebView (JavaScriptAlert)
-(void)webView:(UIWebView *)sender runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(CGRect *)frame;
-(BOOL)webView:(UIWebView *)sender runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(CGRect *)frame;
@end