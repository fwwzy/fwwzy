//
//  HemaFunction.h
//  Hema
//
//  Created by LarryRodic on 15/10/5.
//  Copyright (c) 2015年 Hemaapp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"
#import "AppDelegate.h"

@interface HemaFunction : NSObject

//字符串相关函数===========================================================
+ (CGSize)getSizeWithStr:(NSString*)str width:(float)width font:(float)font;//获取text文本高度(厚字体)
+ (CGSize)getSizeWithStrNo:(NSString*)str width:(float)width font:(float)font;//获取text文本高度(正常字体)
+ (NSString*)getSecreatMobile:(NSString*)_mobile;//获取隐藏的手机号
+ (NSString*)getSecreatEmail:(NSString*)_email;//获取隐藏的邮箱号
+ (BOOL)xfunc_check_strEmpty:(NSString *)parmStr;//字符串判空
+ (BOOL)xfunc_isMobileNumber:(NSString *)mobileNum;//手机号合法判断
+ (BOOL)xfunc_isEmail:(NSString*)email;//邮箱合法
+ (NSString*)getDistance:(float)distance;//获取公里数
+ (double)distanceBetweenOrderBy:(double)lat1 :(double)lng1 :(double)lat2 :(double)lng2;//经纬度之间的距离
+ (int)getLineSize:(NSString *)content startIndex:(int)start width:(float)width font:(float)font;//获取固定宽度的字符串存放长度的个数
+ (BOOL)IsChinese:(NSString *)str;//判断是否有中文

//时间相关函数===========================================================
+ (NSDate*)getDateNow;//获取当前时间
+ (NSString*)getStringNow;//获取当前时间
+ (NSString *)getTimeFromDate:(NSString *)fromDate;//获取操作在多久之前(用于发表话题、帖子、评论时)
+ (CGFloat)getDateDifference:(NSString*)oldDateStr newDate:(NSString*)newDateStr;//获取时间差
+ (int)getRandomNumber:(int)from to:(int)to;//获取一个随机数

//弹窗相关==============================================================
+ (MBProgressHUD*)openHUD:(NSString*)message;//显示黑色等待弹窗
+ (void)closeHUD:(MBProgressHUD*)HUD;//关闭黑色等待弹窗
+ (void)openIntervalHUD:(NSString*)message;//显示黑色定时弹窗
+ (void)openIntervalHUDOK:(NSString*)message;//显示黑色定时弹窗(带对勾的表示发表成功之类的)

//视图相关函数=============================================================
+ (BOOL)addbordertoView:(UIView*)view radius:(CGFloat)radius width:(CGFloat)width color:(UIColor*)color;//自定义边角

//获取主变量相关函数=============================================================
+ (AppDelegate*)xfuncGetAppdelegate;//获取主appdelegate
+ (NSString*)getRootPath;//获得后台服务根目录

//图片处理相关================================================================
+ (void)dropShadowWithOffset:(CGSize)offset radius:(CGFloat)radius color:(UIColor *)color opacity:(CGFloat)opacity view:(UIView*)myview;//绘制阴影
+ (void)dropShadow:(CGSize)offset radius:(CGFloat)radius color:(UIColor *)color opacity:(CGFloat)opacity view:(UIView*)myview;//绘制四周阴影
+ (UIImage*)captureView:(UIView *)aView;//剪切view
+ (UIImage*)getImageWithSize:(CGSize)contentSize color:(UIColor*)color;//获取一个纯色
+ (UIImage*)getImage:(UIImage*)image;//拍照或者从相册获取图片结束后裁剪图片
+ (UIImage*)imageToSquare:(UIImage*)image;//添加上下黑边的方法
+ (UIImage *)image:(UIImage *)image rotation:(UIImageOrientation)orientation;//对图片进行旋转
+ (UIImage *)invertImage:(UIImage *)originalImage myColor:(UIColor*)myColor;//更改图片的颜色
+ (UIImage*)grayscale:(UIImage*)anImage type:(int)type;//黑白化图片
+ (UIColor *)randomColor;//生成随机颜色
+ (UIImage *)generateQRCode:(NSString*)code width:(CGFloat)width height:(CGFloat)height;//生成二维码
+ (UIImage *)generateBarCode:(NSString*)code width:(CGFloat)width height:(CGFloat)height;//生成条形码
//声音播放相关=============================================================
+ (void)playPoint:(NSString*)sound type:(NSString*)type;//提示声
+ (UIImage*)thumbnailImageForVideo:(NSURL *)videoURL atTime:(NSTimeInterval)time;//捕捉在线视频第一帧
+ (NSInteger)getFileSize:(NSString*) path;//获取视频的大小
+ (CGFloat)getVideoDuration:(NSURL*) URL;//获取视频的时间

//系统相关=============================================================
+ (id)traverseResponderChainForUIViewController:(UIView*)view;//寻找第一响应者
+ (BOOL)canConnectNet;//检测网络状态
+ (BOOL)canConnectWifi;//检测网络是否是wifi
+ (NSString*)getMacaddress;//获取mac地址
@end
