//
//  AppDelegate.h
//  Hema
//
//  Created by LarryRodic on 15/10/5.
//  Copyright (c) 2015年 Hemaapp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMPPFramework.h"
#import <AVFoundation/AVFoundation.h>
#import <CoreLocation/CoreLocation.h>
#import <sqlite3.h>
#import <TencentOpenAPI/QQApi.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchAPI.h>

#import "MTStatusBarOverlay.h"
#import "AGViewDelegate.h"
#import "WXApi.h"
#import "BPush.h"
#import "WGS84TOGCJ02.h"
#import "AHReach.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,XMPPStreamDelegate,WXApiDelegate,CLLocationManagerDelegate>
@property (nonatomic,strong)UIWindow *window;
@property (nonatomic,strong)MTStatusBarOverlay *MTStateBar;//状态栏

//自定义
@property (nonatomic,assign)BOOL isLogin;//是否已经登录
@property (nonatomic,assign)BOOL isDuoDian;//即时聊天是否多点登录

@property (nonatomic,copy)NSString *mydeviceid;//百度云推送id
@property (nonatomic,copy)NSString *mychannelid;//百度云推送channelid

@property (nonatomic,readonly)AGViewDelegate *viewDelegate;//分享所需要的

//定位
@property (nonatomic,copy)NSString *myprovice;//我的省份加城市
@property (nonatomic,copy)NSString *mycity;//我的城市
@property (nonatomic,copy)NSString *myHere;//我当前的位置全称 暂时废弃 如有需要请用myCoordinate通过高度地图经纬度逆地理编译获得 详看RSelectLocationVC类
@property (nonatomic,strong)CLLocationManager *locationManager;
@property (nonatomic,assign)CLLocationCoordinate2D myCoordinate;//我的当前经纬度

@property (nonatomic,strong)AHReach *defaultHostReach;//检测是否有网络

//方法
- (void)gotoRoot;//去登录后的首页 或者登录页面 根据isLogin判断

- (void)requestLogin;//登录
- (void)requestQuit;//退出登录

- (void)startLocation;//打开定位
- (void)stopLocation;//关闭定位

//----------------即时聊天
@property(nonatomic,strong)XMPPStream *xmppStream;

//获取聊天屏蔽的成员列表与群组列表
- (void)requestMemberList;
- (void)requestGroupList;
@end

