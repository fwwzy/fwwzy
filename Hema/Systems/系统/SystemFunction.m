//
//  SystemFunction.m
//  Hema
//
//  Created by LarryRodic on 15/10/7.
//  Copyright (c) 2015年 Hemaapp. All rights reserved.
//

#import "SystemFunction.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import "Reachability.h"

@implementation SystemFunction

#pragma mark- 照片相关
//打开相机
+(void)pickerCamere:(AllVC*)myVC allowsEditing:(BOOL)allowsEditing
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = myVC;
        picker.allowsEditing = allowsEditing;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [myVC presentViewController:picker animated:YES completion:nil];
    }else
    {
        [HemaFunction openIntervalHUD:@"打开相机错误"];
    }
}
//打开相册
+(void)pickerAlbums:(AllVC*)myVC allowsEditing:(BOOL)allowsEditing
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = myVC;
        picker.allowsEditing = allowsEditing;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [myVC presentViewController:picker animated:YES completion:nil];
        
        [picker.navigationBar setBarTintColor:Nav_Color];
        [picker.navigationBar setTranslucent:NO];
    }else
    {
        [HemaFunction openIntervalHUD:@"连接到图片库错误"];
    }
}
//打开录像
+(void)pickerVideo:(AllVC*)myVC
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController* picker = [[UIImagePickerController alloc] init];
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        NSArray* availableMedia = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
        picker.mediaTypes = [NSArray arrayWithObject:availableMedia[1]];
        picker.videoMaximumDuration = 15;
        picker.delegate = myVC;
        [myVC presentViewController:picker animated:YES completion:nil];
    }else
    {
        [HemaFunction openIntervalHUD:@"打开相机错误"];
    }
}
//打开视频库
+(void)pickerMedia:(AllVC*)myVC
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController* picker = [[UIImagePickerController alloc] init];
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        NSArray* availableMedia = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
        picker.mediaTypes = [NSArray arrayWithObject:availableMedia[1]];
        picker.videoMaximumDuration = 15;
        picker.delegate = myVC;
        [myVC presentViewController:picker animated:YES completion:nil];
        
        [picker.navigationBar setBarTintColor:Nav_Color];
        [picker.navigationBar setTranslucent:NO];
    }else
    {
        [HemaFunction openIntervalHUD:@"连接到视频库错误"];
    }
}
//bug fixes:UINavigationController使用中偷换StatusBar颜色的问题
+(void)fixPick:(UINavigationController*)nav myVC:(UIViewController *)myVC
{
    if ([nav isKindOfClass:[UIImagePickerController class]] &&
        ((UIImagePickerController *)nav).sourceType ==  UIImagePickerControllerSourceTypePhotoLibrary)
    {
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    }
    myVC.navigationItem.leftBarButtonItem.tintColor = ItemTextNormalColot;
    myVC.navigationItem.rightBarButtonItem.tintColor = ItemTextNormalColot;
    
    if (nav.viewControllers.count == 2)
    {
        UIViewController *hereVC = nav.viewControllers.lastObject;
        [hereVC.navigationItem setLeftItemWithTarget:myVC action:@selector(leftbtnPressed:) image:BackImgName];
    }
}
//缓存图片到HemaImgView
+(void)cashImgView:(HemaImgView*)myImgView url:(NSString*)url firstImg:(NSString*)firstImg
{
    Reachability *reache = [Reachability reachabilityWithHostName:@"http://www.baidu.com"];
    if ([reache currentReachabilityStatus] != ReachableViaWiFi)
    {
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:GDownLoad]integerValue] == 1)
        {
            return;
        }
    }
    [myImgView setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:firstImg]];
}
//缓存图片到HemaButton
+(void)cashButton:(HemaButton*)myButton url:(NSString*)url firstImg:(NSString*)firstImg
{
    Reachability *reache = [Reachability reachabilityWithHostName:@"http://www.baidu.com"];
    if ([reache currentReachabilityStatus] != ReachableViaWiFi)
    {
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:GDownLoad]integerValue] == 1)
        {
            return;
        }
    }
    [myButton setImageWithURL:[NSURL URLWithString:url] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:firstImg]];
}
#pragma mark- 样式相关
//设置table的边线距离 最小是10
+(void)setTableSeparatorInset:(UITableView*)mytable left:(float)left
{
    if (left == 10)
    {
        if ([mytable respondsToSelector:@selector(setSeparatorInset:)])
        {
            [mytable setSeparatorInset:UIEdgeInsetsMake(0, 10, 0, 0)];
        }
        if ([mytable respondsToSelector:@selector(setLayoutMargins:)])
        {
            [mytable setLayoutMargins:UIEdgeInsetsZero];
        }
    }else
    {
        [mytable setSeparatorInset:UIEdgeInsetsMake(0, left, 0, 0)];
        if ([mytable respondsToSelector:@selector(setLayoutMargins:)])
        {
            [mytable setLayoutMargins:UIEdgeInsetsZero];
        }
    }
}
//UIActionSheet属性
+(void)setActionSheet:(UIActionSheet*)actionSheet index:(NSInteger)index myVC:(AllVC*)myVC
{
    [actionSheet setCancelButtonIndex:index];
    actionSheet.delegate = myVC;
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    AppDelegate *adelegate = [HemaFunction xfuncGetAppdelegate];
    [actionSheet showInView:adelegate.window];
}
//设置导航条背景图片
+(void)setNavBackImgView:(AllVC*)myVC picStr:(NSString*)picStr
{
    [myVC.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    myVC.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    myVC.navigationController.navigationBar.barTintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:picStr]];
    myVC.navigationController.navigationBar.translucent= NO;
}
#pragma mark- 动画相关
//开启动画
+(void)actionActive
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.25f];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:nil];
}
#pragma mark- 系统相关
//寻找第一响应的VC
+(UIViewController*)getFirstVCFromVC:(UIViewController*)myVC
{
    UIViewController *temVC = myVC;
    for (int i = 0; i<MAXFLOAT; i++)
    {
        if(!temVC.navigationController)
        {
            UIView *view = temVC.view.superview;
            temVC = [HemaFunction traverseResponderChainForUIViewController:view];
        }else
        {
            break;
        }
    }
    return temVC;
}
//更新软件
+(void)updateVerson
{
    NSString * updateURL = [[[HemaManager sharedManager] myInitInfor] objectForKey:@"iphone_update_url"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:updateURL]];
}
//状态栏展示消息
+(void)postMessage:(NSString*)message
{
    [[HemaFunction xfuncGetAppdelegate].MTStateBar postMessage:message duration:5.0];
}
//打开数据库
+(NSString*)openDataBase
{
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    
    NSString *databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent:Chat_DataName]];
    return databasePath;
}
//执行sql语句
+(BOOL)exceSQL:(NSString*)sql
{
    BOOL isExec = NO;
    sqlite3 *database;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    NSString *mydatabasePath = [path stringByAppendingPathComponent:Chat_DataName];
    sqlite3_open([mydatabasePath UTF8String], &database);
    
    char* errorMsg = NULL;
    if(sqlite3_exec(database, [sql UTF8String],0, NULL, &errorMsg) != SQLITE_OK)
    {
        NSLog(@"sql不能执行：%s",errorMsg);
        sqlite3_free(errorMsg);
    }else
    {
        NSLog(@"sql执行成功");
        isExec = YES;
    }
    sqlite3_close(database);
    
    return isExec;
}
#pragma mark- 数据相关
//生成新的字典
+(NSMutableDictionary*)getDicFromDic:(NSMutableDictionary*)myDic
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    for(NSString *key in myDic.allKeys)
    {
        NSString *value = [myDic objectForKey:key];
        if(![HemaFunction xfunc_check_strEmpty:value])
        {
            [dict setObject:value forKey:key];
        }else
        {
            [dict setObject:@"" forKey:key];
        }
    }
    return dict;
}
#pragma mark- 适配iPhone6&6+ 
//全放大
CGRect CGRectMake1(CGFloat x, CGFloat y, CGFloat width, CGFloat height)
{
    CGRect rect;
    rect.origin.x = x * UI_Width_Scale; rect.origin.y = y * UI_Height_Scale;
    rect.size.width = width * UI_Width_Scale; rect.size.height = height * UI_Height_Scale;
    return rect;
}
//只放大宽，高不变
CGRect CGRectMake2(CGFloat x, CGFloat y, CGFloat width, CGFloat height)
{
    CGRect rect;
    rect.origin.x = x * UI_Width_Scale; rect.origin.y = y;
    rect.size.width = width * UI_Width_Scale; rect.size.height = height;
    return rect;
}
@end
