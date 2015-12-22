//
//  ShareFunction.m
//  Hema
//
//  Created by LarryRodic on 15/10/7.
//  Copyright (c) 2015年 Hemaapp. All rights reserved.
//

#import "ShareFunction.h"
#import "TOWebViewController.h"
#import <ShareSDK/ShareSDK.h>

@implementation ShareFunction
//分享平台配置
+(void)initializePlat
{
    [ShareSDK setInterfaceOrientationMask:SSInterfaceOrientationMaskPortrait];
    
    //新浪微博
    [ShareSDK connectSinaWeiboWithAppKey:@"1261371174"
                               appSecret:@"9b3d2c661b28f74f10f50ebb6f6500fa"
                             redirectUri:@"http://open.weibo.com/apps/1261371174/info/advanced"];
    //微信
    [ShareSDK connectWeChatWithAppId:@"wx91bba2b62cae7661"
                           appSecret:@"e95e32037e1054bbacda505acc2433bf"
                           wechatCls:[WXApi class]];
    //QQ空间
    [ShareSDK connectQZoneWithAppKey:@"1104489095"
                           appSecret:@"khJINNzuTXzzpoWy"
                   qqApiInterfaceCls:[QQApiInterface class]
                     tencentOAuthCls:[TencentOAuth class]];
}
//分享的内容
+(id<ISSContent>)getContent:(NSInteger)keytype dataDic:(NSMutableDictionary*)dataDic myVC:(UIViewController*)myVC
{
    id<ISSContent> publishContent = nil;
    SSPublishContentMediaType myType = SSPublishContentMediaTypeNews;
    
    NSString *myContent = nil;
    NSString *myTitle = nil;
    NSString *myUrl = nil;
    NSString *myImage = nil;
    
    //软件本身
    if (keytype == 1)
    {
        myContent = [[[HemaManager sharedManager] myInitInfor] objectForKey:@"msg_invite"];
        myTitle = BB_ShareName;
        myUrl = [NSString stringWithFormat:@"%@share/sdk.php?id=%@",[[[HemaManager sharedManager] myInitInfor] objectForKey:@"sys_plugins"],@"0"];
        myImage = [NSString stringWithFormat:@"%@images/logo.png",REQUEST_MAINLINK_ROOT];
    }
    //帖子
    if (keytype == 2)
    {
        myContent = [dataDic objectForKey:@"content"];
        if ([HemaFunction xfunc_check_strEmpty:[dataDic objectForKey:@"title"]])
        {
            myTitle = BB_ShareName;
        }else
        {
            myTitle = [dataDic objectForKey:@"title"];
        }
        myUrl = [NSString stringWithFormat:@"%@share/sdk.php?id=%@",[[[HemaManager sharedManager] myInitInfor] objectForKey:@"sys_plugins"],[dataDic objectForKey:@"id"]];
        if ([HemaFunction xfunc_check_strEmpty:[dataDic objectForKey:@"imgurlbig"]])
        {
            myImage = [NSString stringWithFormat:@"%@images/logo.png",REQUEST_MAINLINK_ROOT];
        }else
        {
            myImage = [dataDic objectForKey:@"imgurlbig"];
        }
    }
    
    publishContent = [ShareSDK content:myContent
                        defaultContent:nil
                                 image:[ShareSDK imageWithUrl:myImage]
                                 title:myTitle
                                   url:myUrl
                           description:nil
                             mediaType:myType];
    
    return publishContent;
}
//自定义分享
+(void)yourShare:(ShareType)shareType content:(id<ISSContent>)content
{
    [ShareSDK showShareViewWithType:shareType
                          container:nil
                            content:content
                      statusBarTips:YES
                        authOptions:nil
                       shareOptions:nil
                             result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                 if (state == SSResponseStateSuccess)
                                 {
                                     NSLog(@"分享成功");
                                 }
                                 else if (state == SSResponseStateFail)
                                 {
                                     NSLog(@"分享失败,错误码:%d,错误描述:%@", (int)[error errorCode], [error errorDescription]);
                                 }
                             }];
}
//分享
+(void)share:(NSInteger)keytype dataDic:(NSMutableDictionary*)dataDic myVC:(UIViewController*)myVC
{
    id<ISSContent> publishContent = [ShareFunction getContent:keytype dataDic:dataDic myVC:myVC];

    //定制微信好友信息
    [publishContent addWeixinSessionUnitWithType:INHERIT_VALUE
                                         content:INHERIT_VALUE
                                           title:INHERIT_VALUE
                                             url:INHERIT_VALUE
                                      thumbImage:INHERIT_VALUE
                                           image:INHERIT_VALUE
                                    musicFileUrl:nil
                                         extInfo:nil
                                        fileData:nil
                                    emoticonData:nil];
    
    //定制微信朋友圈信息
    [publishContent addWeixinTimelineUnitWithType:INHERIT_VALUE
                                          content:INHERIT_VALUE
                                            title:INHERIT_VALUE
                                              url:INHERIT_VALUE
                                       thumbImage:INHERIT_VALUE
                                            image:INHERIT_VALUE
                                     musicFileUrl:nil
                                          extInfo:nil
                                         fileData:nil
                                     emoticonData:nil];
    
    //创建弹出菜单容器
    id<ISSContainer> container = [ShareSDK container];
    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                         allowCallback:YES
                                                         authViewStyle:SSAuthViewStyleFullScreenPopup
                                                          viewDelegate:[HemaFunction xfuncGetAppdelegate].viewDelegate
                                               authManagerViewDelegate:[HemaFunction xfuncGetAppdelegate].viewDelegate];
    
    //自定义菜单项
    id<ISSShareActionSheetItem> item1 = [ShareSDK shareActionSheetItemWithTitle:@"其他"
                                                                           icon:[UIImage imageNamed:@"R分享其他.jpg"]
                                                                   clickHandler:^{
                                                                       [self gotoQiTa:keytype dataDic:dataDic myVC:myVC];
                                                                   }];
    
    //创建自定义分享列表
    NSArray *shareList = [ShareSDK customShareListWithType:
                          SHARE_TYPE_NUMBER(ShareTypeWeixiTimeline),
                          SHARE_TYPE_NUMBER(ShareTypeWeixiSession),
                          item1,
                          nil];
    
    [ShareSDK showShareActionSheet:container
                         shareList:shareList
                           content:publishContent
                     statusBarTips:NO
                       authOptions:authOptions
                      shareOptions:[ShareSDK defaultShareOptionsWithTitle:nil
                                                          oneKeyShareList:[NSArray defaultOneKeyShareList]
                                                           qqButtonHidden:NO
                                                    wxSessionButtonHidden:NO
                                                   wxTimelineButtonHidden:NO
                                                     showKeyboardOnAppear:NO
                                                        shareViewDelegate:[HemaFunction xfuncGetAppdelegate].viewDelegate
                                                      friendsViewDelegate:[HemaFunction xfuncGetAppdelegate].viewDelegate
                                                    picViewerViewDelegate:nil]
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                            }];
}
//其他分享
+(void)gotoQiTa:(NSInteger)keytype dataDic:(NSMutableDictionary*)dataDic myVC:(UIViewController*)myVC
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@share/webview.php?id=%@",[[[HemaManager sharedManager] myInitInfor] objectForKey:@"sys_plugins"],(keytype == 1)?@"0":[dataDic objectForKey:@"id"]]];
    TOWebViewController *webViewController = [[TOWebViewController alloc] initWithURL:url];
    webViewController.titleStr = @"分享";
    [myVC.navigationController pushViewController:webViewController animated:YES];
}
@end
