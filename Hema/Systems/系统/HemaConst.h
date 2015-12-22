//
//  HemaConst.h
//  Hema
//
//  Created by LarryRodic on 15/10/5.
//  Copyright (c) 2015年 Hemaapp. All rights reserved.
//
///////////////////////////////////////////////////////////////
//                     尺寸设置                               //
///////////////////////////////////////////////////////////////

#define HM_ISIPHONE6PLUS ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)
#define HM_ISIPHONE6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
#define HM_ISIPHONE5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define HM_ISIPHONE4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)

#define HM_ISIOS7 [[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0//是不是ios7
#define HM_ISIOS8 [[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0//ios8以上
#define HM_ISIOS9 [[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0//ios9以上

#define UI_View_Height [UIScreen mainScreen].bounds.size.height-64//导航条下的屏幕高度
#define UI_View_Width [UIScreen mainScreen].bounds.size.width//屏幕宽度
//纯粹放大适配
#define UI_Width_Scale ((HM_ISIPHONE6)?(375.0f/320.0f):((HM_ISIPHONE6PLUS)?(414.0f/320.0f):1.0f))
#define UI_Height_Scale ((HM_ISIPHONE6)?(1334.0f/1136.0f):((HM_ISIPHONE6PLUS)?(736.0f/568.0f):1.0f))

///////////////////////////////////////////////////////////////
//                     导航设置                               //
///////////////////////////////////////////////////////////////

#define Nav_TitleFont 20
#define Nav_TitleColor BB_White_Color
#define Nav_Color BB_Blue_Color //导航背景色

#define BackItemOffset UIEdgeInsetsMake(0, 5, 0, 0)
#define ItemLeftMargin 0
#define ItemWidth 48
#define ItemHeight 30
#define ItemTextFont 16
#define ItemTextNormalColot BB_White_Color

#define BackImgName @"R白色返回箭头.png"

//状态栏展示
#define Status_BackColor Nav_Color //背景颜色
#define Status_TitleColor BB_White_Color //字体颜色

///////////////////////////////////////////////////////////////
//                     加载刷新                               //
///////////////////////////////////////////////////////////////

#define RefreshNoData @"R暂无数据" //暂无数据
#define RefreshArrow [UIImage imageNamed:@"R刷新箭头.png"] //箭头
#define RefreshFont RGB_UI_COLOR(122, 135, 155) //字体的颜色

///////////////////////////////////////////////////////////////
//                     颜色相关                               //
///////////////////////////////////////////////////////////////

#define RGB_UI_COLOR(R,G,B) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:1]

#define BB_Back_Color_Here [UIColor colorWithRed:243/255.0 green:244/255.0 blue:248/255.0 alpha:1.0f]//界面背景色
#define BB_Red_Color [UIColor colorWithRed:236/255.0 green:17/255.0 blue:26/255.0 alpha:1]//红色
#define BB_White_Color [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1]//白色
#define BB_Orange_Color [UIColor colorWithRed:251/255.0 green:84/255.0 blue:54/255.0 alpha:1]//橘黄色
#define BB_Blue_Color [UIColor colorWithRed:32/255.0 green:164/255.0 blue:216/255.0 alpha:1]//蓝色
#define BB_lineColor [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1]//线条的颜色
#define BB_Gray_Color [UIColor colorWithRed:168/255.0 green:168/255.0 blue:168/255.0 alpha:1]//灰色
#define BB_Blake_Color [UIColor colorWithRed:54/255.0 green:54/255.0 blue:54/255.0 alpha:1]//黑色
#define BB_Border_Color [UIColor colorWithRed:231/255.0 green:231/255.0 blue:231/255.0 alpha:1]//边框的颜色
#define BB_Green_Color [UIColor colorWithRed:55/255.0 green:164/255.0 blue:169/255.0 alpha:1]//绿色
#define BB_Back_Color_Here_Bar [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0f]//底部栏的颜色
//...其余颜色自己添加


///////////////////////////////////////////////////////////////
//                     系统常量                               //
///////////////////////////////////////////////////////////////

//配置
#define CoLocation CLLocationCoordinate2DMake(36.657587, 117.131358)//默认定位经纬度
#define BB_XCONST_IS_YLCeshi @"00"//银联是否是测试环境 00正式环境 01测试环境
#define BB_UMENG_APPKEY @"552f8068fd98c59352001e6f"//友盟key
#define BB_GEO_APIKEY @"a769dc47c85e2f748498c7fd1fa50c49"//高德地图key com.hemaapp.demo1
#define BB_ShareKey @"5577ff992136"//sharesdk的key 默认这个就可以
#define BB_ShareName @"HemaDemo"//分享的软件名称
#define BB_ScrollTime 3.0//轮播图的时间间隔
#define GDownLoad @"gdownload"//仅在WIFI下显示图片 1 仅 0 都可以

//缓存
#define BB_CASH_DOCUMENT @"hemacash"//缓存目录
#define BB_CASH_AVATAR @"avatar"//图片目录
#define BB_CASH_AUDIO @"audio"//语音目录
#define BB_CASH_VIDEO @"video"//视频目录

//第三方
#define BB_XCONST_LOCAL_PLATTYPE @"plattype"//第三方平台类型 0 没有 1：微信 2：QQ 3：微博
#define BB_XCONST_LOCAL_UID @"plattypeuid"//第三方平台 uid

//登录
#define BB_XCONST_ISAUTO_LOGIN @"isAutoLogin"//是否自动登录
#define BB_XCONST_LOCAL_LOGINNAME @"loginname"//登录名
#define BB_XCONST_LOCAL_PASSWORD @"localPWD"//登录密码
#define BB_XCONST_LAST_VERSION @"lastversion"//本地版本号
#define BB_XCONST_LOGIN_System @"login_System"//初始化信息

//聊天
#define BB_XCONST_Chat_ID @"dx_chat_id"
#define BB_XCONST_Chat_PWD @"dx_chat_pwd"
#define BB_XCONST_Chat_Server @"dx_chat_server"

#define Chat_DataName @"hema.db"//数据库名称

//通知
#define BB_NOTIFICATION_OrderOK @"orderOK"//订单第三方支付成功
#define BB_NOTIFICATION_OrderFail @"orderFail"//订单第三方支付失败

#define BB_NOTIFICATION_BaiDuMessage @"baiduMessage"//百度云推送消息的通知
#define BB_NOTIFICATION_SEND_MESSAGE @"sendMessage"//聊天发送消息成功的通知
#define BB_NOTIFICATION_NOSEND_MESSAGE @"nosendMessage"//聊天发送消息失败的通知
#define BB_NOTIFICATION_GET_MESSAGE @"getMessage"//聊天收到消息的通知

#define Button_Scan @"查看大图"
#define Button_Albums @"相册"
#define Button_Camera @"拍照"
#define Button_Cancel @"取消"
#define Button_Read @"全部已读"
#define Button_Delete @"全部删除"

///////////////////////////////////////////////////////////////
//                      存储数据                              //
///////////////////////////////////////////////////////////////

#define SaveSearchWord @"SaveSearchWord"//保存搜索名称
#define SaveLastCityArr @"SaveLastCityArr"//最近访问城市数组 最多三个
#define CityName @"CityName"//保存城市名称
#define CityId @"CityId"//保存城市id
#define DownName @"DownName"//保存县区名称
#define DownId @"DownId"//保存县区id
#define LocalCityName @"LocalCityName"//保存定位城市名称
#define LocalCityId @"LocalCityId"//保存定位城市id

///////////////////////////////////////////////////////////////
//                       逻辑相关                             //
///////////////////////////////////////////////////////////////

#define REQUEST_MAINLINK_ROOT @"http://124.128.23.74:8008/group5/hm_qixin/"
#define REQUEST_MAINLINK_INIT [NSString stringWithFormat:@"%@index.php/Webservice/",REQUEST_MAINLINK_ROOT]
#define REQUEST_MAINLINK [HemaFunction getRootPath]//服务器根地址

//---------------基础接口
#define REQUEST_SYSTEM_INIT @"index/init"//系统初始化
#define REQUEST_CODE_GET @"code_get"//申请验证码接口
#define REQUEST_CODE_VERIFY @"code_verify"//验证验证码
#define REQUEST_CLIENT_LOGIN @"client_login"//登陆接口
#define REQUEST_PLATFORM_SAVE @"platform_save"//第三方登录接口
#define REQUEST_CLIENT_ADD @"client_add"//注册接口
#define REQUEST_CLIENT_LOGINOUT @"client_loginout"//退出登录
#define REQUEST_CLIENT_SAVE @"client_save"//保存个人资料
#define REQUEST_CLIENT_GET @"client_get"//获取个人资料
#define REQUEST_PASSWORD_SAVE @"password_save"//修改密码
#define REQUEST_CLIENT_VERIFY @"client_verify"//找回密码 验证用户
#define REQUEST_PASSWORD_RESET @"password_reset"//找回密码 重设密码
#define REQUEST_POSITION_SAVE @"position_save"//保存位置
#define REQUEST_FILE_UPLOAD @"file_upload"//上传文件
#define REQUEST_DEVICE_SAVE @"device_save"//硬件注册
#define REQUEST_CHATPUSH_ADD @"chatpush_add"//聊天百度推送
#define REQUEST_MOBILE_LIST @"mobile_list"//邀请通讯录号码安装软件接口
#define REQUEST_REMOVE @"remove"//通用删除接口
#define REQUEST_ADVICE_ADD @"advice_add"//意见反馈
#define REQUEST_NOTICE_LIST @"notice_list"//通知列表
#define REQUEST_NOTiCE_SAVEOPERATE @"notice_saveoperate"//通知操作

#define REQUEST_AD_LIST @"ad_list"//广告列表接口
#define REQUEST_DISTRICT_LIST @"district_list"//地区列表
#define REQUEST_IMG_LIST @"img_list"//相册列表

#define REQUEST_BANK_SAVE @"bank_save"//存储银行卡信息
#define REQUEST_ALIPAY_SAVE @"alipay_save"//保存用户提现支付宝信息
#define REQUEST_BANK_LIST @"bank_list"//银行列表
#define REQUEST_CASH_ADD @"cash_add"//提现申请
#define REQUEST_CASH_LIST @"cash_list"//提现列表
#define REQUEST_PAY_LIST @"pay_list"//充值列表

#define REQUEST_FRIEND_ADD @"friend_add"//保存好友
#define REQUEST_FRIEND_REMOVE @"friend_remove"//移除好友
#define REQUEST_CLIENT_LIST @"client_list"//成员列表
#define REQUEST_CLIENT_SAVEOPERATE @"client_saveoperate"//保存用户关系操作

//---------------Demo接口
#define REQUEST_HIDE_IDLIST_GET @"hide_idlist_get"//获取屏蔽消息的群组/用户id串接口
#define REQUEST_BLOG_LIST @"blog_list"//获取帖子列表
#define REQUEST_BLOG_ADD @"blog_add"//保存帖子

//群组
#define REQUEST_GROUP_ADD @"group_add"//添加讨论组
#define REQUEST_GROUP_LIST @"group_list"//讨论组列表
#define REQUEST_GROUP_GET @"group_get"//讨论组详情
#define REQUEST_GROUP_SAVEOPERATE @"group_saveoperate"//保存群组操作
#define REQUEST_GROUP_CLIENT_LIST @"group_client_list"//群组人员列表




