//
//  AppDelegate.m
//  Hema
//
//  Created by LarryRodic on 15/10/5.
//  Copyright (c) 2015年 Hemaapp. All rights reserved.
//

#import "AppDelegate.h"
#import "RRootTBC.h"
#import <ShareSDK/ShareSDK.h>
#import <AdSupport/AdSupport.h>
#import <AlipaySDK/AlipaySDK.h>
#import "MobClick.h"
#import "MMExampleDrawerVisualStateManager.h"
#import "IQKeyboardManager.h"

#import "TabBarController.h"
#import "LoginVC.h"


@interface AppDelegate ()
{
    UIImageView *backImg;
    MBProgressHUD *waitMB;
    
    //数据库
    sqlite3 *contactDB;
    NSString *databasePath;
}
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    //创建默认的rootViewController
    //TabBarController *tabBarVC = [[TabBarController alloc] init];
    LoginVC *loginVC = [[LoginVC alloc] init];
    LCPanNavigationController *rootNav = [[LCPanNavigationController alloc] initWithRootViewController:loginVC];
    _window.rootViewController = rootNav;
    
    _window.backgroundColor = BB_White_Color;
    [_window makeKeyAndVisible];
    [_window makeKeyWindow];
    
    return YES;
}

//    //禁用输入框自动上移，如某个页面需要请于某个页面willappear中开启，willdisappear中关闭
//    [[IQKeyboardManager sharedManager] setEnable:NO];
//    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
//    [[IQKeyboardManager sharedManager] setShouldShowTextFieldPlaceholder:NO];
//    
//    //分享与统计
//    _viewDelegate = [[AGViewDelegate alloc] init];
//    [ShareSDK registerApp:BB_ShareKey];
//    [ShareFunction initializePlat];
//    
//    [MobClick setAppVersion:XcodeAppVersion];
//    [MobClick startWithAppkey:BB_UMENG_APPKEY reportPolicy:(ReportPolicy) REALTIME channelId:nil];
//    [MobClick updateOnlineConfig];
//    
//    //系统导航颜色
//    [[UINavigationBar appearance]setTintColor:ItemTextNormalColot];
//    [[UINavigationBar appearance] setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:Nav_TitleFont],NSForegroundColorAttributeName:Nav_TitleColor}];
//    
//    //设置默认的定位地点
//    _myCoordinate = CoLocation;
//    _mycity = @"济南市";
//    _myprovice = @"山东省,济南市";
//    
//    //高德地图
//    [MAMapServices sharedServices].apiKey = BB_GEO_APIKEY;
//    
//    //推送注册
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
//    {
//        UIUserNotificationType myTypes = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
//        
//        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:myTypes categories:nil];
//        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
//    }else
//    {
//        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeSound;
//        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
//    }
//    
//    //自定义状态,消息推送时显示
//    self.MTStateBar = [[MTStatusBarOverlay alloc] initWithFrame:CGRectMake(0, 0, UI_View_Width, 20)];
//    
//    //从推送打开软件
//    if(launchOptions)
//    {
//        [[HemaManager sharedManager] setPushDic:[[launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey]objectForKey:@"aps"]];
//    }
//    
//    //百度云推送
//    [BPush registerChannel:launchOptions apiKey:@"0yIvA2nSBN9VTrGl1YoYntzm" pushMode:BPushModeDevelopment withFirstAction:nil withSecondAction:nil withCategory:nil isDebug:YES];
//    //App 是用户点击推送消息启动
//    NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
//    if (userInfo)
//    {
//        NSLog(@"从消息启动:%@",userInfo);
//        [BPush handleNotification:userInfo];
//    }
//    
//    #if TARGET_IPHONE_SIMULATOR
//    Byte dt[32] = {0xc6, 0x1e, 0x5a, 0x13, 0x2d, 0x04, 0x83, 0x82, 0x12, 0x4c, 0x26, 0xcd, 0x0c, 0x16, 0xf6, 0x7c, 0x74, 0x78, 0xb3, 0x5f, 0x6b, 0x37, 0x0a, 0x42, 0x4f, 0xe7, 0x97, 0xdc, 0x9f, 0x3a, 0x54, 0x10};
//    [self application:application didRegisterForRemoteNotificationsWithDeviceToken:[NSData dataWithBytes:dt length:32]];
//    #endif
//    
//    //创建封面
//    [self setBackImg];
//    
//    //创建数据库
//    [self initDataBase];
//    
//    return YES;
//}
//- (void)applicationWillResignActive:(UIApplication *)application
//{
//    
//}
//- (void)applicationDidEnterBackground:(UIApplication *)application
//{
//    application.applicationIconBadgeNumber = 0;
//}
//- (void)applicationWillEnterForeground:(UIApplication *)application
//{
//    
//}
//- (void)applicationDidBecomeActive:(UIApplication *)application
//{
//    [self startLocation];
//    
//    if (!_window.rootViewController||[_window.rootViewController isKindOfClass:[REmptyVC class]])
//    {
//        if ([HemaFunction canConnectNet])
//        {
//            [self requestSystemInit];
//        }else
//        {
//            HemaManager *myManager = [HemaManager sharedManager];
//            
//            if (![HemaFunction xfunc_check_strEmpty:[[NSUserDefaults standardUserDefaults] objectForKey:BB_XCONST_LOGIN_System]])
//            {
//                myManager.myInitInfor = [[NSUserDefaults standardUserDefaults] objectForKey:BB_XCONST_LOGIN_System];
//            }else
//            {
//                return;
//            }
//            
//            [self gotoAlertUp];
//            [self gotoRoot];
//        }
//    }else
//    {
//        [self gotoAlertUp];
//    }
//    
//    //检测有无网络
//    if (!_defaultHostReach)
//    {
//        _defaultHostReach = [AHReach reachForDefaultHost];
//        [_defaultHostReach startUpdatingWithBlock:^(AHReach *reach)
//         {
//             [self updateAvailability:_defaultHostReach];
//         }];
//    }
//}
//- (void)applicationWillTerminate:(UIApplication *)application
//{
//    
//}
//- (BOOL)application:(UIApplication *)application  handleOpenURL:(NSURL *)url
//{
//    return [ShareSDK handleOpenURL:url wxDelegate:self];
//}
//- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
//{
//    //跳转支付宝钱包进行支付，需要将支付宝钱包的支付结果回传给SDK
//    if ([url.host isEqualToString:@"safepay"])
//    {
//        [[AlipaySDK defaultService]
//         processOrderWithPaymentResult:url
//         standbyCallback:^(NSDictionary *resultDic)
//         {
//             if ([[resultDic objectForKey:@"resultStatus"]integerValue] == 9000)
//             {
//                 [[NSNotificationCenter defaultCenter] postNotificationName:BB_NOTIFICATION_OrderOK object:nil userInfo:nil];
//             }else
//             {
//                 [[NSNotificationCenter defaultCenter] postNotificationName:BB_NOTIFICATION_OrderFail object:nil userInfo:nil];
//             }
//         }];
//        return YES;
//    }
//    //微信的支付回调
//    if ([url.host isEqualToString:@"pay"])
//    {
//        return [WXApi handleOpenURL:url delegate:(id<WXApiDelegate>)self];
//    }
//    //第三方登录与分享
//    return [ShareSDK handleOpenURL:url
//                 sourceApplication:sourceApplication
//                        annotation:annotation
//                        wxDelegate:self];
//}
////微信支付回调
//- (void)onResp:(BaseResp *)resp
//{
//    if ([resp isKindOfClass:[PayResp class]])
//    {
//        PayResp *response = (PayResp *)resp;
//        switch (response.errCode)
//        {
//            case WXSuccess:
//                //服务器端查询支付通知或查询API返回的结果再提示成功
//                NSLog(@"支付成功");
//                [[NSNotificationCenter defaultCenter] postNotificationName:BB_NOTIFICATION_OrderOK object:nil userInfo:nil];
//                break;
//            default:
//                NSLog(@"支付失败， retcode=%d",resp.errCode);
//                [[NSNotificationCenter defaultCenter] postNotificationName:BB_NOTIFICATION_OrderFail object:nil userInfo:nil];
//                break;
//        }
//    }
//}
//#pragma mark- 推送相关
//- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
//{
//    [BPush registerDeviceToken:deviceToken];
//    [BPush bindChannelWithCompleteHandler:^(id result, NSError *error)
//    {
//        //需要在绑定成功后进行
//        if (result)
//        {
//            NSLog(@"绑定结果：%@",result);
//            _mydeviceid = [result valueForKey:@"user_id"];
//            _mychannelid = [result valueForKey:@"channel_id"];
//            if ([HemaFunction xfuncGetAppdelegate].isLogin)
//            {
//                [self requestSaveDeviceLogin];
//            }
//        }
//    }];
//}
//- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
//{
//    NSLog(@"DeviceToken获取失败，原因：%@",error);
//}
//- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
//{
//    NSString *message = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
//    
//    NSLog(@"userinfo:%@",userInfo);
//    NSLog(@"aps    message:%@",message);
//    
//    NSDictionary *temDic = [[NSDictionary alloc] initWithObjectsAndKeys:message,@"message", nil];
//    [[NSNotificationCenter defaultCenter] postNotificationName:BB_NOTIFICATION_BaiDuMessage object:nil userInfo:temDic];
//    
//    NSInteger badge = [[[userInfo objectForKey:@"aps"]objectForKey:@"badge"]integerValue];
//    application.applicationIconBadgeNumber = badge;
//    
//    [BPush handleNotification:userInfo];
//    NSLog(@"********** ios7.0之前 **********");
//    //应用在前台或者后台开启状态下，不跳转页面，让用户选择。
//    if (application.applicationState == UIApplicationStateActive || application.applicationState == UIApplicationStateBackground)
//    {
//       [SystemFunction postMessage:userInfo[@"aps"][@"alert"]];
//    }else
//    {
//        NSLog(@"杀死状态下，直接跳转到跳转页面。");
//    }
//}
////此方法是用户点击了通知，应用在前台或者开启后台并且应用在后台时调起
//- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
//{
//    completionHandler(UIBackgroundFetchResultNewData);
//    NSLog(@"********** iOS7.0之后 background **********");
//    //应用在前台或者后台开启状态下，不跳转页面，让用户选择。
//    if (application.applicationState == UIApplicationStateActive || application.applicationState == UIApplicationStateBackground)
//    {
//        [SystemFunction postMessage:userInfo[@"aps"][@"alert"]];
//    }else
//    {
//        NSLog(@"杀死状态下，直接跳转到跳转页面。");
//    }
//}
////在iOS8系统中，还需要添加这个方法。通过新的API注册推送服务
//- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
//{
//    [application registerForRemoteNotifications];
//}
//- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
//{
//    NSLog(@"接收本地通知");
//    [BPush showLocalNotificationAtFront:notification identifierKey:nil];
//}
//#pragma mark - Location Delegate
//- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
//{
//    switch (status)
//    {
//        case kCLAuthorizationStatusNotDetermined:
//            if ([_locationManager respondsToSelector:@selector(requestAlwaysAuthorization)])
//            {
//                [_locationManager requestAlwaysAuthorization];
//            }
//            break;
//        default:
//            break;
//    }
//}
//- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
//{
//    CLLocation *location = [locations objectAtIndex:0];
//    
//    if (![WGS84TOGCJ02 isLocationOutOfChina:[location coordinate]])
//    {
//        //转换后的coord
//        CLLocationCoordinate2D coord = [WGS84TOGCJ02 transformFromWGSToGCJ:[location coordinate]];
//        _myCoordinate = coord;
//    }
//    //获取当前所在的城市名
//    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
//    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *array, NSError *error)
//     {
//         if (array.count > 0)
//         {
//             CLPlacemark *placemark = [array objectAtIndex:0];
//             if ([HemaFunction xfunc_check_strEmpty:placemark.locality])
//             {
//                 NSString *citye = [NSString stringWithFormat:@"%@,%@",placemark.administrativeArea,placemark.subLocality];
//                 _myprovice = citye;
//                 _mycity = placemark.subLocality;
//             }else
//             {
//                 NSString *citye = [NSString stringWithFormat:@"%@,%@",placemark.administrativeArea,placemark.locality];
//                 _myprovice = citye;
//                 _mycity = placemark.locality;
//             }
//         }
//     }];
//    if (_isLogin)
//    {
//        [self requestSavePosition];
//    }
//}
//- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
//{
//    
//}
//- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
//{
//    
//}
//#pragma mark- UIAlertView Delegate
//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    if(999 == alertView.tag&&0 == buttonIndex)
//    {
//        [SystemFunction updateVerson];
//    }
//    if(1999 == alertView.tag&&0 == buttonIndex)
//    {
//        [self requestQuit];
//    }
//    if(1999 == alertView.tag&&1 == buttonIndex)
//    {
//        [self connect];
//    }
//}
//#pragma mark- 自定义
//#pragma mark 方法
////设置背景图
//-(void)setBackImg
//{
//    if (!backImg)
//    {
//        backImg = [[UIImageView alloc]init];
//        [backImg setFrame:CGRectMake(0, 0, UI_View_Width, UI_View_Height+64)];
//        [_window addSubview:backImg];
//        
//        if (HM_ISIPHONE4)
//        {
//            [backImg setImage:[UIImage imageNamed:@"640*960.png"]];
//        }
//        if (HM_ISIPHONE5)
//        {
//            [backImg setImage:[UIImage imageNamed:@"640*1136.png"]];
//        }
//        if (HM_ISIPHONE6)
//        {
//            [backImg setImage:[UIImage imageNamed:@"750*1334.png"]];
//        }
//        if (HM_ISIPHONE6PLUS)
//        {
//            [backImg setImage:[UIImage imageNamed:@"1242*2208.png"]];
//        }
//    }
//}
////背景图消失
//-(void)removeBackImg
//{
//    if (backImg)
//    {
//        [backImg setHidden:YES];
//        [backImg removeFromSuperview];backImg = nil;
//    }
//}
////打开定位
//-(void)startLocation
//{
//    if (![CLLocationManager locationServicesEnabled])
//    {
//        return;
//    }
//    if(!_locationManager)
//    {
//        if(!_locationManager)
//            _locationManager = [[CLLocationManager alloc]init];
//        _locationManager.delegate = [HemaFunction xfuncGetAppdelegate];
//        _locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
//        _locationManager.distanceFilter=10;
//        
//        if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 8.0)
//        {
//            [_locationManager requestWhenInUseAuthorization];
//        }
//    }
//    [_locationManager startUpdatingLocation];
//}
////关闭定位
//-(void)stopLocation
//{
//    if(_locationManager)
//    {
//        [_locationManager stopUpdatingLocation];
//    }
//}
////提示强制更新更新弹框
//-(void)gotoAlertUp
//{
//    HemaManager *myManager = [HemaManager sharedManager];
//    NSMutableDictionary *dict = myManager.myInitInfor;
//    if ([[dict objectForKey:@"sys_must_update"]integerValue] == 1)
//    {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"有新版本" message:@"新版本进行了大的改动，此版本已不再使用，请立即更新到最新版本" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//        [alert show];
//        alert.tag = 999;
//        alert.delegate = self;
//    }
//}
////选择去向
//-(void)gotoWhat
//{
//    //获取初始化成功后进入页面
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    NSString *lastversion = [defaults objectForKey:BB_XCONST_LAST_VERSION];
//    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
//    NSString *currentVersion = [infoDictionary objectForKey:@"CFBundleVersion"];
//    
//    //去引导页
//    if ([HemaFunction xfunc_check_strEmpty:lastversion]||(![lastversion isEqualToString:currentVersion]))
//    {
//        [self removeBackImg];
//        [defaults setObject:currentVersion forKey:BB_XCONST_LAST_VERSION];
//        
//        RStartVC *myVC = [[RStartVC alloc]init];
//        LCPanNavigationController *nav = [[LCPanNavigationController alloc]initWithRootViewController:myVC];
//        _window.rootViewController = nav;
//    }else
//    {
//        //自动登录
//        if ([[[NSUserDefaults standardUserDefaults] objectForKey:BB_XCONST_ISAUTO_LOGIN] isEqualToString:@"yes"]&&![HemaFunction xfuncGetAppdelegate].isLogin)
//        {
//            if ([HemaFunction canConnectNet])
//            {
//                if (![HemaFunction xfunc_check_strEmpty:[[NSUserDefaults standardUserDefaults] objectForKey:BB_XCONST_LOCAL_PLATTYPE]])
//                {
//                    if ([[[NSUserDefaults standardUserDefaults] objectForKey:BB_XCONST_LOCAL_PLATTYPE]integerValue] == 0)
//                    {
//                        [self requestLogin];
//                    }else
//                    {
//                        //第三方登录
//                        if ([[[NSUserDefaults standardUserDefaults] objectForKey:BB_XCONST_LOCAL_PLATTYPE]integerValue] == 1)
//                        {
//                            [self wechatLogin:nil];
//                        }
//                        if ([[[NSUserDefaults standardUserDefaults] objectForKey:BB_XCONST_LOCAL_PLATTYPE]integerValue] == 2)
//                        {
//                            [self qqLogin:nil];
//                        }
//                        if ([[[NSUserDefaults standardUserDefaults] objectForKey:BB_XCONST_LOCAL_PLATTYPE]integerValue] == 3)
//                        {
//                            [self sinaLogin:nil];
//                        }
//                    }
//                }else
//                {
//                    [self requestLogin];
//                }
//                
//            }else
//            {
//                [self gotoRoot];
//            }
//        }else
//        {
//            [self gotoRoot];
//        }
//    }
//}
////去向
//- (void)gotoRoot
//{
//    NSLog(@"都来这了");
//    if (_isLogin)
//    {
//        [self loginConnect];
//        [self requestSaveDeviceLogin];
//        [self requestSavePosition];
//        
//        /*
//        //去底部栏
//        RRootTBC *root = [[RRootTBC alloc]init];
//        _window.rootViewController = root;
//        */
//        
//        //去有侧滑的底部栏
//        RRootTBC * root = [[RRootTBC alloc] init];
//        RLeftSlideVC *left = [[RLeftSlideVC alloc] init];
//        RRightSlideVC *right = [[RRightSlideVC alloc] init];
//        //..............................
//        MMDrawerController * drawerController = [[MMDrawerController alloc]
//                                                 initWithCenterViewController:root
//                                                 leftDrawerViewController:left
//                                                 rightDrawerViewController:right];
//        [drawerController setMaximumLeftDrawerWidth:UI_View_Width-70];
//        [drawerController setMaximumRightDrawerWidth:UI_View_Width-70];
//        
//        [drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
//        [drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
//        
//        [drawerController setCenterHiddenInteractionMode:MMDrawerOpenCenterInteractionModeNone];
//        [drawerController setShouldStretchDrawer:NO];
//        
//        [[MMExampleDrawerVisualStateManager sharedManager] setLeftDrawerAnimationType:MMDrawerAnimationTypeSwingingDoor];
//        [[MMExampleDrawerVisualStateManager sharedManager] setRightDrawerAnimationType:MMDrawerAnimationTypeSwingingDoor];
//        
//        [_window setRootViewController:drawerController];
//        [[HemaManager sharedManager]resSetRootArr:drawerController];
//    }else
//    {
//        RLoginVC *myVC = [[RLoginVC alloc]init];
//        LCPanNavigationController *nav = [[LCPanNavigationController alloc]initWithRootViewController:myVC];
//        _window.rootViewController = nav;
//    }
//    [self removeBackImg];
//}
//#pragma mark 第三方登录
////微信登录
//-(void)wechatLogin:(id)sender
//{
//    //判断是否授权
//    if ([ShareSDK hasAuthorizedWithType:ShareTypeWeixiSession])
//    {
//        [ShareSDK getUserInfoWithType:ShareTypeWeixiSession authOptions:nil result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error)
//         {
//             NSLog(@"wechat:%d",result);
//             if (result)
//             {
//                 NSMutableDictionary *temDic = [[NSMutableDictionary alloc]init];
//                 [temDic setObject:[userInfo uid] forKey:@"uid"];
//                 [temDic setObject:[userInfo profileImage]?[userInfo profileImage]:@"" forKey:@"avatar"];
//                 [temDic setObject:[userInfo nickname]?[userInfo nickname]:@"中国买家" forKey:@"nickname"];
//                 if ([userInfo gender] == 1)
//                 {
//                     [temDic setObject:@"女" forKey:@"sex"];
//                 }else
//                 {
//                     [temDic setObject:@"男" forKey:@"sex"];
//                 }
//                 [temDic setObject:@"20" forKey:@"age"];
//                 
//                 [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:BB_XCONST_LOCAL_PLATTYPE];
//                 
//                 [self requestPlatformLogin:temDic plattype:@"1"];
//             }else
//             {
//                 [self gotoRoot];
//             }
//         }];
//    }else
//    {
//        [self gotoRoot];
//    }
//}
////QQ登录
//-(void)qqLogin:(id)sender
//{
//    //判断是否授权
//    if ([ShareSDK hasAuthorizedWithType:ShareTypeQQSpace])
//    {
//        [ShareSDK getUserInfoWithType:ShareTypeQQSpace authOptions:nil result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error)
//         {
//             NSLog(@"qq:%d",result);
//             if (result)
//             {
//                 NSMutableDictionary *temDic = [[NSMutableDictionary alloc]init];
//                 [temDic setObject:[userInfo uid] forKey:@"uid"];
//                 [temDic setObject:[userInfo profileImage]?[userInfo profileImage]:@"" forKey:@"avatar"];
//                 [temDic setObject:[userInfo nickname]?[userInfo nickname]:@"中国买家" forKey:@"nickname"];
//                 if ([userInfo gender] == 1)
//                 {
//                     [temDic setObject:@"女" forKey:@"sex"];
//                 }else
//                 {
//                     [temDic setObject:@"男" forKey:@"sex"];
//                 }
//                 [temDic setObject:@"20" forKey:@"age"];
//                 
//                 [[NSUserDefaults standardUserDefaults] setValue:@"2" forKey:BB_XCONST_LOCAL_PLATTYPE];
//                 
//                 [self requestPlatformLogin:temDic plattype:@"2"];
//             }else
//             {
//                 [self gotoRoot];
//             }
//         }];
//    }else
//    {
//        [self gotoRoot];
//    }
//}
////微博登录
//-(void)sinaLogin:(id)sender
//{
//    //判断是否授权
//    if ([ShareSDK hasAuthorizedWithType:ShareTypeSinaWeibo])
//    {
//        [ShareSDK getUserInfoWithType:ShareTypeSinaWeibo authOptions:nil result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error)
//         {
//             NSLog(@"wb:%d",result);
//             if (result)
//             {
//                 NSMutableDictionary *temDic = [[NSMutableDictionary alloc]init];
//                 [temDic setObject:[userInfo uid] forKey:@"uid"];
//                 [temDic setObject:[userInfo profileImage]?[userInfo profileImage]:@"" forKey:@"avatar"];
//                 [temDic setObject:[userInfo nickname]?[userInfo nickname]:@"中国买家" forKey:@"nickname"];
//                 if ([userInfo gender] == 1)
//                 {
//                     [temDic setObject:@"女" forKey:@"sex"];
//                 }else
//                 {
//                     [temDic setObject:@"男" forKey:@"sex"];
//                 }
//                 [temDic setObject:@"20" forKey:@"age"];
//                 
//                 [[NSUserDefaults standardUserDefaults] setValue:@"3" forKey:BB_XCONST_LOCAL_PLATTYPE];
//                 
//                 [self requestPlatformLogin:temDic plattype:@"3"];
//             }else
//             {
//                 [self gotoRoot];
//             }
//         }];
//    }else
//    {
//        [self gotoRoot];
//    }
//}
//#pragma mark- 是否有网络通知
//- (void)updateAvailability:(AHReach *)reach
//{
//    if([reach isReachable])
//    {
//        NSLog(@"有网络");
//    }else
//    {
//        NSLog(@"无网络");
//    }
//}
//#pragma mark- 连接服务器
//#pragma mark 获取初始化信息
//- (void)requestSystemInit
//{
//    [self setBackImg];
//    
//    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
//    NSString *currentVersion = [infoDictionary objectForKey:@"CFBundleVersion"];
//    
//    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
//    [dic setObject:currentVersion forKey:@"lastloginversion"];
//    [dic setObject:[[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString] forKey:@"device_sn"];
//    [dic setObject:[HemaFunction getMacaddress] forKey:@"device_mac"];
//    [dic setObject:@"1" forKey:@"devicetype"];
//    
//    [HemaRequest requestWithURL:[NSString stringWithFormat:@"%@%@",REQUEST_MAINLINK,REQUEST_SYSTEM_INIT] target:self selector:@selector(responseSystemInit:) parameter:dic];
//}
//- (void)responseSystemInit:(NSDictionary*)info
//{
//    [self stopLocation];
//    
//    if(1 == [[info objectForKey:@"success"] intValue])
//    {
//        NSMutableDictionary *dict = [SystemFunction getDicFromDic:[[info objectForKey:@"infor"] objectAtIndex:0]];
//        
//        [[NSUserDefaults standardUserDefaults] setObject:dict forKey:BB_XCONST_LOGIN_System];
//        
//        HemaManager *myManager = [HemaManager sharedManager];
//        myManager.myInitInfor = dict;
//        
//        [self gotoAlertUp];
//        [self gotoWhat];
//    }
//    else
//    {
//        [HemaFunction openIntervalHUD:[info objectForKey:@"msg"]];
//    }
//}
//#pragma mark 登录
//- (void)requestLogin
//{
//    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
//    NSString *currentVersion = [infoDictionary objectForKey:@"CFBundleVersion"];
//    
//    NSString *temUsername = [[NSUserDefaults standardUserDefaults] objectForKey:BB_XCONST_LOCAL_LOGINNAME];
//    NSString *temPawssword = [[NSUserDefaults standardUserDefaults] objectForKey:BB_XCONST_LOCAL_PASSWORD];
//    
//    if ([HemaFunction xfunc_check_strEmpty:temUsername])
//    {
//        [self gotoRoot];
//        return;
//    }
//    
//    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
//    [dic setObject:temUsername forKey:@"username"];
//    [dic setObject:temPawssword forKey:@"password"];
//    [dic setObject:_mydeviceid?_mydeviceid:@"无" forKey:@"deviceid"];
//    [dic setObject:@"1" forKey:@"devicetype"];
//    [dic setObject:currentVersion forKey:@"lastloginversion"];
//    
//    [HemaRequest requestWithURL:[NSString stringWithFormat:@"%@%@",REQUEST_MAINLINK,REQUEST_CLIENT_LOGIN] target:self selector:@selector(responseLogin:) parameter:dic];
//}
//- (void)responseLogin:(NSDictionary*)info
//{
//    if(1 == [[info objectForKey:@"success"] intValue])
//    {
//        NSArray *temArray = [info objectForKey:@"infor"];
//        NSDictionary *dic = [temArray objectAtIndex:0];
//        NSMutableDictionary *temDic = [[NSMutableDictionary alloc] init];
//        for(NSString * key in dic.allKeys)
//        {
//            if(![HemaFunction xfunc_check_strEmpty:[dic objectForKey:key]])
//            {
//                NSString*value = [dic objectForKey:key];
//                [temDic setValue:value forKey:key];
//            }
//        }
//        HemaManager *myManager = [HemaManager sharedManager];
//        myManager.myInfor = temDic;
//        myManager.userToken = [dic objectForKey:@"token"];
//        
//        _isLogin = YES;
//        [[NSUserDefaults standardUserDefaults] setValue:@"yes" forKey:BB_XCONST_ISAUTO_LOGIN];
//        [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:BB_XCONST_LOCAL_PLATTYPE];
//    }else
//    {
//        [[NSUserDefaults standardUserDefaults] setValue:@"no" forKey:BB_XCONST_ISAUTO_LOGIN];
//    }
//    [self gotoRoot];
//}
//#pragma mark 第三方登录
//- (void)requestPlatformLogin:(NSMutableDictionary*)temDic plattype:(NSString*)plattype
//{
//    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
//    NSString *currentVersion = [infoDictionary objectForKey:@"CFBundleVersion"];
//    
//    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
//    [dic setObject:plattype forKey:@"plattype"];
//    [dic setObject:[temDic objectForKey:@"uid"] forKey:@"uid"];
//    [dic setObject:@"1" forKey:@"devicetype"];
//    [dic setObject:currentVersion forKey:@"lastloginversion"];
//    
//    [dic setObject:[temDic objectForKey:@"avatar"]?[temDic objectForKey:@"avatar"]:@"无" forKey:@"avatar"];
//    [dic setObject:[temDic objectForKey:@"nickname"]?[temDic objectForKey:@"nickname"]:@"无" forKey:@"nickname"];
//    [dic setObject:[temDic objectForKey:@"sex"]?[temDic objectForKey:@"sex"]:@"无" forKey:@"sex"];
//    [dic setObject:[temDic objectForKey:@"age"]?[temDic objectForKey:@"age"]:@"无" forKey:@"age"];
//    
//    [[NSUserDefaults standardUserDefaults] setValue:[temDic objectForKey:@"uid"] forKey:BB_XCONST_LOCAL_UID];
//    
//    [HemaRequest requestWithURL:[NSString stringWithFormat:@"%@%@",REQUEST_MAINLINK,REQUEST_PLATFORM_SAVE] target:self selector:@selector(responsePlatformLogin:) parameter:dic];
//}
//- (void)responsePlatformLogin:(NSDictionary*)info
//{
//    if(1 == [[info objectForKey:@"success"] intValue])
//    {
//        NSArray *temArray = [info objectForKey:@"infor"];
//        NSDictionary *dic = [temArray objectAtIndex:0];
//        NSMutableDictionary *temDic = [[NSMutableDictionary alloc] init];
//        for(NSString * key in dic.allKeys)
//        {
//            if(![HemaFunction xfunc_check_strEmpty:[dic objectForKey:key]])
//            {
//                NSString*value = [dic objectForKey:key];
//                [temDic setValue:value forKey:key];
//            }
//        }
//        HemaManager *myManager = [HemaManager sharedManager];
//        myManager.myInfor = temDic;
//        myManager.userToken = [dic objectForKey:@"token"];
//        
//        _isLogin = YES;
//        [[NSUserDefaults standardUserDefaults] setValue:@"yes" forKey:BB_XCONST_ISAUTO_LOGIN];
//    }else
//    {
//        [[NSUserDefaults standardUserDefaults] setValue:@"no" forKey:BB_XCONST_ISAUTO_LOGIN];
//    }
//    [self gotoRoot];
//}
//#pragma mark 登陆后系统推送
//- (void)requestSaveDeviceLogin
//{
//    if ([HemaFunction xfunc_check_strEmpty:self.mydeviceid])
//    {
//        return;
//    }
//    NSString *token = [[HemaManager sharedManager] userToken];
//    
//    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
//    [dic setObject:token forKey:@"token"];
//    [dic setObject:self.mydeviceid?self.mydeviceid:@"无" forKey:@"deviceid"];
//    [dic setObject:self.mychannelid?self.mychannelid:@"无" forKey:@"channelid"];
//    [dic setObject:@"1" forKey:@"devicetype"];
//    [dic setObject:self.mycity forKey:@"district_name"];
//    
//    [HemaRequest requestWithURL:[NSString stringWithFormat:@"%@%@",REQUEST_MAINLINK,REQUEST_DEVICE_SAVE] target:self selector:@selector(responseSaveDeviceLogin:) parameter:dic];
//}
//- (void)responseSaveDeviceLogin:(NSDictionary*)info
//{
//    
//}
//#pragma mark 保存位置信息
//- (void)requestSavePosition
//{
//    if (_myCoordinate.longitude == 0&&_myCoordinate.latitude == 0)
//    {
//        return;
//    }
//    NSString *token = [[HemaManager sharedManager] userToken];
//    NSString *lng = [NSString stringWithFormat:@"%f",_myCoordinate.longitude];
//    NSString *lat = [NSString stringWithFormat:@"%f",_myCoordinate.latitude];
//    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
//    [dic setObject:token forKey:@"token"];
//    [dic setObject:lng forKey:@"lng"];
//    [dic setObject:lat forKey:@"lat"];
//    [dic setObject:_mycity forKey:@"district_name"];
//    
//    [HemaRequest requestWithURL:[NSString stringWithFormat:@"%@%@",REQUEST_MAINLINK,REQUEST_POSITION_SAVE] target:self selector:@selector(responseSavePosition:) parameter:dic];
//}
//- (void)responseSavePosition:(NSDictionary*)info
//{
//    if(1 == [[info objectForKey:@"success"] intValue])
//    {
//        [self stopLocation];
//    }
//}
//#pragma mark 退出登录
//- (void)requestQuit
//{
//    if (![HemaFunction xfunc_check_strEmpty:[[NSUserDefaults standardUserDefaults] objectForKey:BB_XCONST_LOCAL_PLATTYPE]])
//    {
//        if ([[[NSUserDefaults standardUserDefaults] objectForKey:BB_XCONST_LOCAL_PLATTYPE]integerValue] == 1)
//        {
//            //取消授权
//            [ShareSDK cancelAuthWithType:ShareTypeWeixiSession];
//        }
//        if ([[[NSUserDefaults standardUserDefaults] objectForKey:BB_XCONST_LOCAL_PLATTYPE]integerValue] == 2)
//        {
//            //取消授权
//            [ShareSDK cancelAuthWithType:ShareTypeQQSpace];
//        }
//        if ([[[NSUserDefaults standardUserDefaults] objectForKey:BB_XCONST_LOCAL_PLATTYPE]integerValue] == 3)
//        {
//            //取消授权
//            [ShareSDK cancelAuthWithType:ShareTypeSinaWeibo];
//        }
//        [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:BB_XCONST_LOCAL_PLATTYPE];
//    }
//    NSString *token = [[HemaManager sharedManager] userToken];
//    
//    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
//    [dic setObject:token forKey:@"token"];
//    
//    waitMB = [HemaFunction openHUD:@"正在退出"];
//    
//    [HemaRequest requestWithURL:[NSString stringWithFormat:@"%@%@",REQUEST_MAINLINK,REQUEST_CLIENT_LOGINOUT] target:self selector:@selector(responseQuit:) parameter:dic];
//}
//- (void)responseQuit:(NSDictionary*)info
//{
//    [HemaFunction closeHUD:waitMB];
//    if(1 == [[info objectForKey:@"success"] intValue])
//    {
//        [[NSUserDefaults standardUserDefaults] setValue:@"no" forKey:BB_XCONST_ISAUTO_LOGIN];
//        _isLogin = NO;
//        [self disconnect];
//        
//        //处理完退出登录去的页面
//        [self gotoRoot];
//    }else
//    {
//        [HemaFunction openIntervalHUD:[info objectForKey:@"msg"]];
//    }
//}
//#pragma mark 获得屏蔽的成员列表
//- (void)requestMemberList
//{
//    NSString *token = [[HemaManager sharedManager] userToken];
//    
//    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
//    [dic setObject:token forKey:@"token"];
//    [dic setObject:@"1" forKey:@"keytype"];
//    
//    [HemaRequest requestWithURL:[NSString stringWithFormat:@"%@%@",REQUEST_MAINLINK,REQUEST_HIDE_IDLIST_GET] target:self selector:@selector(responseMemberList:) parameter:dic];
//}
//- (void)responseMemberList:(NSDictionary*)info
//{
//    if(1 == [[info objectForKey:@"success"] intValue])
//    {
//        NSMutableArray *myArr = [[NSMutableArray alloc]init];
//        if(![HemaFunction xfunc_check_strEmpty:[info objectForKey:@"infor"]])
//        {
//            NSString *myStr = [[[info objectForKey:@"infor"]objectAtIndex:0]objectForKey:@"idList"];
//            if (![HemaFunction xfunc_check_strEmpty:myStr])
//            {
//                NSArray *temArr = [myStr componentsSeparatedByString:@","];
//                for (int i = 0; i<temArr.count; i++)
//                {
//                    [myArr addObject:[temArr objectAtIndex:0]];
//                }
//            }
//        }
//        HemaManager *myManager = [HemaManager sharedManager];
//        myManager.memberArr = myArr;
//    }
//}
//#pragma mark 获得屏蔽的群组列表
//- (void)requestGroupList
//{
//    NSString *token = [[HemaManager sharedManager] userToken];
//    
//    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
//    [dic setObject:token forKey:@"token"];
//    [dic setObject:@"2" forKey:@"keytype"];
//    
//    [HemaRequest requestWithURL:[NSString stringWithFormat:@"%@%@",REQUEST_MAINLINK,REQUEST_HIDE_IDLIST_GET] target:self selector:@selector(responseGroupList:) parameter:dic];
//}
//- (void)responseGroupList:(NSDictionary*)info
//{
//    if(1 == [[info objectForKey:@"success"] intValue])
//    {
//        NSMutableArray *myArr = [[NSMutableArray alloc]init];
//        if(![HemaFunction xfunc_check_strEmpty:[info objectForKey:@"infor"]])
//        {
//            NSString *myStr = [[[info objectForKey:@"infor"]objectAtIndex:0]objectForKey:@"idList"];
//            if (![HemaFunction xfunc_check_strEmpty:myStr])
//            {
//                NSArray *temArr = [myStr componentsSeparatedByString:@","];
//                for (int i = 0; i<temArr.count; i++)
//                {
//                    [myArr addObject:[temArr objectAtIndex:0]];
//                }
//            }
//        }
//        HemaManager *myManager = [HemaManager sharedManager];
//        myManager.groupArr = myArr;
//    }
//}
//#pragma mark- 数据库创建
////创建打开数据库
//-(void)initDataBase
//{
//    //根据路径创建数据库并创建一个表
//    NSString *docsDir;
//    NSArray *dirPaths;
//    
//    dirPaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
//    docsDir = [dirPaths objectAtIndex:0];
//    
//    databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: Chat_DataName]];
//    NSFileManager *filemgr = [NSFileManager defaultManager];
//    if ([filemgr fileExistsAtPath:databasePath] == NO)
//    {
//        const char *dbpath = [databasePath UTF8String];
//        if (sqlite3_open(dbpath, &contactDB)==SQLITE_OK)
//        {
//            char *errMsg;
//            const char *sql_stmt = "CREATE TABLE IF NOT EXISTS message (ID INTEGER default '0',owner VARCHAR,talker VARCHAR,fromjid VARCHAR, tojid VARCHAR,body VARCHAR,regdate VARCHAR,dxpacktype VARCHAR,dxclientype VARCHAR,dxclientname VARCHAR,dxclientavatar VARCHAR,dxgroupid VARCHAR,dxgroupname VARCHAR,dxgroupavatar VARCHAR,dxdetail VARCHAR,dxextend VARCHAR,isread INTEGER,issend INTEGER,talkername VARCHAR,talkeravatar VARCHAR,isdelete INTEGER)";
//            if (sqlite3_exec(contactDB, sql_stmt, NULL, NULL, &errMsg)!=SQLITE_OK)
//            {
//                
//            }
//        }
//    }
//}
//#pragma mark- 聊天
////登陆后设置聊天
//-(void)loginConnect
//{
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    [defaults setObject:[[[HemaManager sharedManager] myInitInfor] objectForKey:@"sys_chat_ip"] forKey:BB_XCONST_Chat_Server];
//
//    NSString *temPawssword = [[NSUserDefaults standardUserDefaults] objectForKey:BB_XCONST_LOCAL_PASSWORD];
//    
//    [defaults setObject:[[[HemaManager sharedManager] myInfor] objectForKey:@"id"] forKey:BB_XCONST_Chat_ID];
//    [defaults setObject:temPawssword forKey:BB_XCONST_Chat_PWD];
//    
//    NSLog(@"登陆地聊天id：%@",[[[HemaManager sharedManager] myInfor] objectForKey:@"id"]);
//    
//    //获取聊天所屏蔽的人和群组
//    [self requestMemberList];
//    [self requestGroupList];
//    
//    [self connect];
//}
//#pragma mark- XMPP
//-(BOOL)connect
//{
//    [self setupStream];
//    
//    if (![_xmppStream isDisconnected])
//    {
//        //如果已经连接返回
//        return YES;
//    }
//    //连接服务器
//    NSError *error = nil;
//    if (![_xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:&error])
//    {
//        return NO;
//    }else
//    {
//        return YES;
//    }
//}
//-(void)setupStream
//{
//    _xmppStream = [[XMPPStream alloc] init];
//    [_xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
//    
//    //从本地取得用户名，密码和服务器地址
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    NSString *server = [defaults objectForKey:BB_XCONST_Chat_Server];
//    NSString *userId = [defaults objectForKey:BB_XCONST_Chat_ID];
//    
//    //设置用户
//    XMPPJID *jid = [XMPPJID jidWithUser:userId domain:server resource:@"DXResource"];
//    [_xmppStream setMyJID:jid];
//    NSLog(@"这个id是：%@,%@,%@,%@",jid,[defaults objectForKey:BB_XCONST_Chat_ID],server,[[[HemaManager sharedManager] myInitInfor] objectForKey:@"sys_chat_port"]);
//    
//    //设置服务器
//    [_xmppStream setHostName:server];
//    [_xmppStream setHostPort:[[[[HemaManager sharedManager] myInitInfor] objectForKey:@"sys_chat_port"] integerValue]];
//}
//-(void)goOnline
//{
//    //发送在线状态
//    XMPPPresence *presence = [XMPPPresence presence];
//    [[self xmppStream] sendElement:presence];
//}
//-(void)goOffline
//{
//    //发送下线状态
//    XMPPPresence *presence = [XMPPPresence presenceWithType:@"unavailable"];
//    [[self xmppStream] sendElement:presence];
//}
//-(void)disconnect
//{
//    if([_xmppStream isConnected])
//    {
//        [self goOffline];
//        [_xmppStream disconnect];
//    }else
//    {
//        _xmppStream = nil;
//    }
//    _xmppStream = nil;
//}
//#pragma mark- XMPP Delegate
////连接服务器
//- (void)xmppStreamDidConnect:(XMPPStream *)sender
//{
//    NSLog(@"聊天连接成功 ");
//    
//    NSError *error = nil;
//    //验证密码
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    NSString *password = [defaults objectForKey:BB_XCONST_Chat_PWD];
//    [[self xmppStream] authenticateWithPassword:password error:&error];
//}
////失去联系
//- (void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error
//{
//    if (!_isLogin)
//    {
//        return;
//    }
//    NSLog(@"连接错误:%@",[error description]);
//    if(7 == [error code]&&_xmppStream == sender)
//    {
//        //被多点登录
//        if (_isDuoDian)
//        {
//            _isDuoDian = NO;
//            
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"通知" message:@"检测到您的账号已在其他设备上登录，是否重新登录？" delegate:self cancelButtonTitle:nil otherButtonTitles:@"退出账号",@"重新登录", nil];
//            alert.tag = 1999;
//            [alert show];
//            
//            return;
//        }else
//        {
//            [self connect];
//        }
//        
//        BOOL isAppActivity = [[UIApplication sharedApplication] applicationState] == UIApplicationStateActive;
//        if (isAppActivity)
//        {
//            //如果在前端，重连机制
//            //[self connect];
//        }
//    }
//    else
//    {
//        if ([HemaFunction xfunc_check_strEmpty:[error description]])
//        {
//            return;
//        }
//        BOOL isAppActivity = [[UIApplication sharedApplication] applicationState] == UIApplicationStateActive;
//        if (isAppActivity)
//        {
//            //如果在前端，重连机制
//            [self connect];
//        }
//    }
//}
////验证通过
//- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender
//{
//    [self goOnline];
//    NSLog(@"验证通过:%@ myjid:%@",_xmppStream,_xmppStream.myJID);
//}
//- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(NSXMLElement *)error
//{
//    [_xmppStream disconnect];
//    NSLog(@"验证错误:%@",[error description]);
//}
////收到消息
//- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message
//{
//    NSLog(@"确定收到了信息:%@",message);
//    [self saveMessage:message];
//}
//- (void)xmppStream:(XMPPStream *)sender didSendMessage:(XMPPMessage *)message
//{
//    NSString* temID = [[message attributeForName:@"id"] stringValue];
//    NSLog(@"确定发送了信息:%@",message);
//    
//    [self updateMessageWithPackID:temID];
//    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:temID,@"temID", nil];
//    [[NSNotificationCenter defaultCenter] postNotificationName:BB_NOTIFICATION_SEND_MESSAGE object:nil userInfo:dict];
//}
//- (void)xmppStream:(XMPPStream *)sender didFailToSendMessage:(XMPPMessage *)message error:(NSError *)error
//{
//    NSLog(@"发送失败:%@",error.description);
//    
//    NSString* temID = [[message attributeForName:@"id"] stringValue];
//    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:temID,@"temID", nil];
//    [[NSNotificationCenter defaultCenter] postNotificationName:BB_NOTIFICATION_NOSEND_MESSAGE object:nil userInfo:dict];
//}
////修改数据库里的消息为已经发送
//- (void)updateMessageWithPackID:(NSString*)xtompackid
//{
//    NSString *updateSql = [NSString stringWithFormat:@"update message set issend = 1 where id = '%@'",xtompackid];
//    [SystemFunction exceSQL:updateSql];
//}
//#pragma mark- sql 处理
////收到的消息存入数据库
//- (void)saveMessage:(XMPPMessage*)message
//{
//    NSString *type = [[message attributeForName:@"type"] stringValue];
//    if ([type isEqualToString:@"error"])
//    {
//        return;
//    }
//    //获取from to
//    NSString *froma = [[message attributeForName:@"from"] stringValue];
//    XMPPJID *jidfrom = [XMPPJID jidWithString:froma];froma = jidfrom.user;
//    NSString *toa = [[message attributeForName:@"to"] stringValue];
//    XMPPJID *jidto = [XMPPJID jidWithString:toa];toa = jidto.user;
//    
//    //获取时间
//    NSXMLElement *delay = [message elementForName:@"delay"];
//    NSString *stamp = [[delay attributeForName:@"stamp"] stringValue];
//    //2014-04-02T02:32:24.622Z
//    NSString *now = [self getRegdateFromDelaytime:stamp];
//    
//    NSString *msg = [[message elementForName:@"body"] stringValue];
//    NSMutableDictionary *temDic = [self getpropertiesFromMessage:message];
//    
//    NSString* temID = [[message attributeForName:@"id"] stringValue];
//    NSString *myMobile = [HemaFunction xfuncGetAppdelegate].xmppStream.myJID.user;
//    
//    NSString *insertSQL = nil;
//    
//    if ([[temDic objectForKey:@"dxgroupid"]integerValue] == 0)//单聊
//    {
//        NSMutableArray *myArr = [[HemaManager sharedManager] memberArr];
//        for (int i = 0; i<myArr.count; i++)
//        {
//            NSLog(@"单聊匹配：%@,%@",[myArr objectAtIndex:i],froma);
//            if ([[myArr objectAtIndex:i]isEqualToString:froma])
//            {
//                return;
//            }
//        }
//        
//        insertSQL = [NSString stringWithFormat:@"INSERT INTO message (id,owner,talker,fromjid,tojid,body,regdate,dxpacktype,dxclientype,dxclientname,dxclientavatar,dxgroupid,dxgroupname,dxgroupavatar,dxdetail,dxextend,isread,issend,talkername,talkeravatar,isdelete) VALUES('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')",temID,myMobile,froma,froma,toa,msg,now,[temDic objectForKey:@"dxpacktype"],[temDic objectForKey:@"dxclientype"],[temDic objectForKey:@"dxclientname"],[temDic objectForKey:@"dxclientavatar"],[temDic objectForKey:@"dxgroupid"],@"",@"",[temDic objectForKey:@"dxdetail"],[temDic objectForKey:@"dxextend"],@"0",@"1",[temDic objectForKey:@"dxclientname"],[temDic objectForKey:@"dxclientavatar"],@"0"];
//        [SystemFunction exceSQL:insertSQL];
//    }else//群聊
//    {
//        NSMutableArray *myArr = [[HemaManager sharedManager] groupArr];
//        for (int i = 0; i<myArr.count; i++)
//        {
//            NSLog(@"群聊匹配：%@,%@",[myArr objectAtIndex:i],[temDic objectForKey:@"dxgroupid"]);
//            if ([[myArr objectAtIndex:i]isEqualToString:[temDic objectForKey:@"dxgroupid"]])
//            {
//                return;
//            }
//        }
//        insertSQL = [NSString stringWithFormat:@"INSERT INTO message (id,owner,talker,fromjid,tojid,body,regdate,dxpacktype,dxclientype,dxclientname,dxclientavatar,dxgroupid,dxgroupname,dxgroupavatar,dxdetail,dxextend,isread,issend,talkername,talkeravatar,isdelete) VALUES('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')",temID,myMobile,[temDic objectForKey:@"dxgroupid"],froma,toa,msg,now,[temDic objectForKey:@"dxpacktype"],[temDic objectForKey:@"dxclientype"],[temDic objectForKey:@"dxclientname"],[temDic objectForKey:@"dxclientavatar"],[temDic objectForKey:@"dxgroupid"],[temDic objectForKey:@"dxgroupname"],[temDic objectForKey:@"dxgroupavatar"],[temDic objectForKey:@"dxdetail"],[temDic objectForKey:@"dxextend"],@"0",@"1",@"",@"",@"0"];
//        if (![myMobile isEqualToString:froma])
//        {
//            [SystemFunction exceSQL:insertSQL];
//        }
//    }
//    NSLog(@"确定收到");
//    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:[temDic objectForKey:@"dxgroupid"],@"dxgroupid",froma,@"talker", nil];
//    [[NSNotificationCenter defaultCenter] postNotificationName:BB_NOTIFICATION_GET_MESSAGE object:nil userInfo:dict];
//}
////转换消息时间
//- (NSString*)getRegdateFromDelaytime:(NSString*)p_time
//{
//    NSString *time = @"";
//    if(p_time.length==24)
//    {
//        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
//        NSDate *date = [dateFormatter dateFromString:p_time];
//        
//        NSTimeZone *zone = [NSTimeZone systemTimeZone];
//        NSInteger interval = [zone secondsFromGMTForDate: date];
//        NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
//        
//        NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
//        [dateFormatter1 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//        NSString *dateStr = [dateFormatter1 stringFromDate:localeDate];
//        return dateStr;
//    }
//    else
//    {
//        NSDate *date = [NSDate date];
//        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//        time = [dateFormatter stringFromDate:date];
//    }
//    return time;
//}
////获取message的属性
//- (NSMutableDictionary*)getpropertiesFromMessage:(DDXMLElement*)message
//{
//    NSXMLElement *pro = [message elementForName:@"properties"];
//    NSArray*arr =[pro elementsForName:@"property"];
//    
//    NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
//    for(id obj in arr)
//    {
//        NSXMLElement *element = (NSXMLElement*)obj;
//        NSString *name = [[element elementForName:@"name"] stringValue];
//        NSString *value = [[element elementForName:@"value"] stringValue];
//        [resultDic setObject:value forKey:name];
//    }
//    return resultDic;
//}
@end
