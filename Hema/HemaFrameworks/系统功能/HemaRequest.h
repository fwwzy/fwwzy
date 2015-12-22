//
//  HemaRequest.h
//  Hema
//
//  Created by LarryRodic on 15/10/5.
//  Copyright (c) 2015年 Hemaapp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ShareSDK/ShareSDK.h>

@interface HemaRequest : NSObject<NSURLConnectionDataDelegate,NSURLConnectionDelegate>

+ (HemaRequest*)requestWithURL:(NSString*)url target:(id)aTarget selector:(SEL)aSelector parameter:(NSMutableDictionary*)paramters;//普通
+ (HemaRequest*)requestWithAudioURL:(NSString*)url target:(id)aTarget selector:(SEL)aSelector parameter:(NSMutableDictionary*)paramters;//音频
+ (HemaRequest*)requestWithVideoURL:(NSString*)url target:(id)aTarget selector:(SEL)aSelector parameter:(NSMutableDictionary*)paramters;//视频
@end