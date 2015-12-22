//
//  SystemFunction.h
//  Hema
//
//  Created by LarryRodic on 15/10/7.
//  Copyright (c) 2015年 Hemaapp. All rights reserved.
//
//软件的相关类库，不同软件可随意添加

#import <Foundation/Foundation.h>

@interface SystemFunction : NSObject

#pragma mark- 照片相关
+(void)pickerCamere:(AllVC*)myVC allowsEditing:(BOOL)allowsEditing;//打开相机
+(void)pickerAlbums:(AllVC*)myVC allowsEditing:(BOOL)allowsEditing;//打开相册
+(void)pickerVideo:(AllVC*)myVC;//打开录像
+(void)pickerMedia:(AllVC*)myVC;//打开视频库
+(void)fixPick:(UINavigationController*)nav myVC:(UIViewController *)myVC;//bug fixes:UINavigationController使用中偷换StatusBar颜色的问题
+(void)cashImgView:(HemaImgView*)myImgView url:(NSString*)url firstImg:(NSString*)firstImg;//缓存图片到HemaImgView
+(void)cashButton:(HemaButton*)myButton url:(NSString*)url firstImg:(NSString*)firstImg;//缓存图片到HemaButton

#pragma mark- 样式相关
+(void)setTableSeparatorInset:(UITableView*)mytable left:(float)left;//设置table的边线距离
+(void)setActionSheet:(UIActionSheet*)actionSheet index:(NSInteger)index myVC:(AllVC*)myVC;//UIActionSheet属性
+(void)setNavBackImgView:(AllVC*)myVC picStr:(NSString*)picStr;//设置导航条背景图片

#pragma mark- 动画相关
+(void)actionActive;//开启动画

#pragma mark- 系统相关
+(UIViewController*)getFirstVCFromVC:(UIViewController*)myVC;//寻找第一响应的VC
+(void)updateVerson;//更新软件
+(void)postMessage:(NSString*)message;//状态栏展示消息
+(NSString*)openDataBase;//打开数据库
+(BOOL)exceSQL:(NSString*)sql;//执行sql语句

#pragma mark- 数据相关
+(NSMutableDictionary*)getDicFromDic:(NSMutableDictionary*)myDic;//生成新的字典

#pragma mark- 适配iPhone6&6+
CGRect CGRectMake1(CGFloat x, CGFloat y, CGFloat width, CGFloat height);
CGRect CGRectMake2(CGFloat x, CGFloat y, CGFloat width, CGFloat height);
@end
