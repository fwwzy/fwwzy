//
//  HemaCashManager.h
//  Hema
//
//  Created by LarryRodic on 15/10/5.
//  Copyright (c) 2015年 Hemaapp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HemaCashManager : NSObject
@property(retain) dispatch_queue_t myIOQueue;//缓存的线程

+ (id)sharedManager;

- (BOOL)removeDocument:(NSString*)document;//删除文件夹
- (void)addImgToBtnFromDocumentORURL:(UIButton*)btn document:(NSString*)document url:(NSString*)url;//把图片设为按钮的背景
- (void)addImgToImgViewFromDocumentORURL:(UIImageView*)imgView document:(NSString*)document url:(NSString*)url;////往imgView添加图片
- (BOOL)downloadAVFromDocumentORURL:(NSString*)document url:(NSString*)url;//缓存声音、视频
- (NSString*)liGetImgNameFromURL:(NSString*)url;//由图片的url生成图片名

- (dispatch_queue_t)runOnIOThread;//获取线程
- (dispatch_block_t) BlockWithAutoreleasePool:(dispatch_block_t)block;//自动释放
- (BOOL)isValidPNGByImageUrl:(NSString*)url;//校验图片是否为有效的PNG图片
@end
