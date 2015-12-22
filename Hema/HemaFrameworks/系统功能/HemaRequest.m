//
//  HemaRequest.m
//  Hema
//
//  Created by LarryRodic on 15/10/5.
//  Copyright (c) 2015年 Hemaapp. All rights reserved.
//
#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)

#define REQUEST_BOUNDARY @"AaB03x"
#define Xtom_HOST_NAME @"www.baidu.com"
#define Xtom_NET_TIMEDURING 30 //网络请求允许的时间

#import "HemaRequest.h"
#import "Reachability.h"
#import "JSONKit.h"

@interface HemaRequest()
{
    BOOL isFile;
    NSURLConnection *connector;
    NSTimer *myTimer;
    
    BOOL isGetToken;//是否已经获得新的token
}
@property(nonatomic,strong)NSURL *requestURL;
@property(nonatomic,strong)NSMutableDictionary *requestParameters;
@property(nonatomic,strong)NSMutableData *receiveData;//服务器返回的数据
@property(nonatomic,strong)id backTarget;//获取数据后的响应目标
@property(nonatomic,assign)SEL backSelector;//响应方法
@property(nonatomic,assign)int requestType;//0 是纯文本 1 image/JPEG 2text/plain
@end

@implementation HemaRequest

+ (HemaRequest*)requestWithURL:(NSString*)url target:(id)aTarget selector:(SEL)aSelector parameter:(NSMutableDictionary*)paramters
{
    HemaRequest *request = [[HemaRequest alloc] init];
    [request requestWithURL:url target:aTarget selector:aSelector parameter:paramters];
    return request;
}
- (void)requestWithURL:(NSString*)url target:(id)aTarget selector:(SEL)aSelector parameter:(NSMutableDictionary*)paramters
{
    if(!self.requestURL)
        self.requestURL = [NSURL URLWithString:url];
    if(!self.backTarget)
        self.backTarget = aTarget;
    if(!self.backSelector)
        self.backSelector = aSelector;
    if(!self.requestParameters)
        self.requestParameters = paramters;
    NSLog(@"link:%@ parameter:%@",self.requestURL,self.requestParameters);
    
    if([self canConnectNet])
    {
        self.requestType = [self getRequestType:_requestParameters];
        
        NSMutableURLRequest* theRequest = [[NSMutableURLRequest alloc] initWithURL:_requestURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:Xtom_NET_TIMEDURING];
        if(0 == _requestType)
        {
            [theRequest setHTTPMethod:@"POST"];
            NSData *postData = [self getPostData];
            [theRequest setHTTPBody:postData];
            [theRequest setValue:[NSString stringWithFormat:@"%d",(int)postData.length] forHTTPHeaderField:@"Content-Length"];
        }
        if(1 == _requestType)
        {
            [theRequest setHTTPMethod:@"POST"];
            [theRequest setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@", REQUEST_BOUNDARY]forHTTPHeaderField:@"Content-Type"];
            [theRequest setHTTPBody:[self getPostData]];
        }
        [self openConnector:theRequest];
    }else
    {
        NSDictionary *temDic=[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"1",@"11", nil] forKeys:[NSArray arrayWithObjects:@"error_code",@"success", nil]];
        
        SuppressPerformSelectorLeakWarning(
                                           [_backTarget performSelector:_backSelector withObject:temDic];
                                           );
        
        [SystemFunction postMessage:@"未找到可用网络"];
    }
}
+ (HemaRequest*)requestWithAudioURL:(NSString*)url target:(id)aTarget selector:(SEL)aSelector parameter:(NSMutableDictionary*)paramters
{
    HemaRequest *request = [[HemaRequest alloc] init];
    [request requestWithAudioURL:url target:aTarget selector:aSelector parameter:paramters];
    return request;
}
- (void)requestWithAudioURL:(NSString*)url target:(id)aTarget selector:(SEL)aSelector parameter:(NSMutableDictionary*)paramters
{
    
    if(!self.requestURL)
        self.requestURL = [NSURL URLWithString:url];
    if(!self.backTarget)
        self.backTarget = aTarget;
    if(!self.backSelector)
        self.backSelector = aSelector;
    if(!self.requestParameters)
        self.requestParameters = paramters;
    
    if([self canConnectNet])
    {
        NSMutableURLRequest* theRequest = [[NSMutableURLRequest alloc] initWithURL:_requestURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:Xtom_NET_TIMEDURING];
        [theRequest setHTTPMethod:@"POST"];
        [theRequest setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@", REQUEST_BOUNDARY]forHTTPHeaderField:@"Content-Type"];
        [theRequest setHTTPBody:[self getAudioPostData]];
        [self openConnector:theRequest];
    }
    else
    {
        NSDictionary *temDic=[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"1",@"11", nil] forKeys:[NSArray arrayWithObjects:@"error_code",@"success", nil]];
        SuppressPerformSelectorLeakWarning(
                                           [_backTarget performSelector:_backSelector withObject:temDic];
                                           );
        
        [SystemFunction postMessage:@"未找到可用网络"];
    }
}
//视频
+ (HemaRequest*)requestWithVideoURL:(NSString*)url target:(id)aTarget selector:(SEL)aSelector parameter:(NSMutableDictionary*)paramters
{
    HemaRequest *request = [[HemaRequest alloc] init];
    [request requestWithVideoURL:url target:aTarget selector:aSelector parameter:paramters];
    return request;
}
- (void)requestWithVideoURL:(NSString*)url target:(id)aTarget selector:(SEL)aSelector parameter:(NSMutableDictionary*)paramters
{
    
    if(!self.requestURL)
        self.requestURL = [NSURL URLWithString:url];
    if(!self.backTarget)
        self.backTarget = aTarget;
    if(!self.backSelector)
        self.backSelector = aSelector;
    if(!self.requestParameters)
        self.requestParameters = paramters;
    
    if([self canConnectNet])
    {
        NSMutableURLRequest* theRequest = [[NSMutableURLRequest alloc] initWithURL:_requestURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:Xtom_NET_TIMEDURING];
        [theRequest setHTTPMethod:@"POST"];
        [theRequest setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@", REQUEST_BOUNDARY]forHTTPHeaderField:@"Content-Type"];
        [theRequest setHTTPBody:[self getVideoPostData]];
        [self openConnector:theRequest];
    }
    else
    {
        NSDictionary *temDic=[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"1",@"11", nil] forKeys:[NSArray arrayWithObjects:@"error_code",@"success", nil]];
        SuppressPerformSelectorLeakWarning(
                                           [_backTarget performSelector:_backSelector withObject:temDic];
                                           );
        
        [SystemFunction postMessage:@"未找到可用网络"];
    }
}
#pragma mark- 方法
//手动关闭连接
- (void)closeConnect
{
    if(connector)
    {
        [connector cancel];connector = nil;
    }
    if(myTimer)
    {
        [myTimer invalidate];myTimer = nil;
    }
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}
//打开连接请求
- (void)openConnector:(NSMutableURLRequest*)request
{
    //"正在连接"状态打开
    connector = [NSURLConnection connectionWithRequest:request delegate:self];
    if (connector)
    {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        self.receiveData = [[NSMutableData alloc] init];
        //myTimer = [NSTimer scheduledTimerWithTimeInterval:Xtom_NET_TIMEDURING target:self selector:@selector(checkData:) userInfo:nil repeats:NO];
    }
    else
    {
        NSDictionary *temDic=[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"1",@"11", nil] forKeys:[NSArray arrayWithObjects:@"error_code",@"success", nil]];
        SuppressPerformSelectorLeakWarning(
                                           [_backTarget performSelector:_backSelector withObject:temDic];
                                           );
        
        [SystemFunction postMessage:@"未找到可用网络"];
    }
}
//检测网络状态
- (BOOL)canConnectNet
{
    Reachability *reache=[Reachability reachabilityWithHostName:Xtom_HOST_NAME];
    
    switch ([reache currentReachabilityStatus])
    {
        case NotReachable://无网络
            return NO;
        case ReachableViaWiFi://wifi网络
            return YES;
        case ReachableViaWWAN://wwlan网络
            return YES;
        default:
            break;
    }
    return NO;
}
//获取请求类型
- (int)getRequestType:(NSDictionary*)para
{
    for(NSObject *object in para.allValues)
    {
        if([object isKindOfClass:[NSData class]])//检索是不是含有文件
        {
            return 1;
        }
    }
    return 0;
}
//设置请求音频数据
- (NSData*)getAudioPostData
{
    NSData *returnData = nil;
    NSMutableData *temMutableData = [[NSMutableData alloc] init];
    NSString *boundary = REQUEST_BOUNDARY;
    for(NSString *key in _requestParameters.allKeys)
    {
        if([[_requestParameters objectForKey:key] isKindOfClass:[NSString class]])
        {
            NSString *temStr = [NSString stringWithFormat:@"--%@\r\nContent-Disposition:form-data;name=\"%@\"\r\n\r\n%@\r\n",boundary,key,[_requestParameters objectForKey:key]];
            [temMutableData appendData:[temStr dataUsingEncoding:NSUTF8StringEncoding]];
        }
        else
        {
            NSString *temStr = [NSString stringWithFormat:@"--%@\r\nContent-Disposition:form-data;name=\"%@\";filename=ab.mp3\r\n Content-Type:audio/mpeg\r\n\r\n",boundary,key];
            [temMutableData appendData:[temStr dataUsingEncoding:NSUTF8StringEncoding]];
            [temMutableData appendData:[_requestParameters objectForKey:key]];
            [temMutableData appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        }
    }
    NSString *endStr = [NSString stringWithFormat:@"--%@--\r\n",boundary];
    [temMutableData appendData:[endStr dataUsingEncoding:NSUTF8StringEncoding]];
    returnData = temMutableData;
    return returnData;
}
//设置请求视频数据
- (NSData*)getVideoPostData
{
    NSData *returnData = nil;
    NSMutableData *temMutableData = [[NSMutableData alloc] init];
    NSString *boundary = REQUEST_BOUNDARY;
    for(NSString *key in _requestParameters.allKeys)
    {
        if([[_requestParameters objectForKey:key] isKindOfClass:[NSString class]])
        {
            NSString *temStr = [NSString stringWithFormat:@"--%@\r\nContent-Disposition:form-data;name=\"%@\"\r\n\r\n%@\r\n",boundary,key,[_requestParameters objectForKey:key]];
            [temMutableData appendData:[temStr dataUsingEncoding:NSUTF8StringEncoding]];
        }
        else
        {
            NSString *temStr = [NSString stringWithFormat:@"--%@\r\nContent-Disposition:form-data;name=\"%@\";filename=ab.mp4\r\n Content-Type:video/mp4\r\n\r\n",boundary,key];
            [temMutableData appendData:[temStr dataUsingEncoding:NSUTF8StringEncoding]];
            [temMutableData appendData:[_requestParameters objectForKey:key]];
            [temMutableData appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        }
    }
    NSString *endStr = [NSString stringWithFormat:@"--%@--\r\n",boundary];
    [temMutableData appendData:[endStr dataUsingEncoding:NSUTF8StringEncoding]];
    returnData = temMutableData;
    return returnData;
}
//设置请求数据
- (NSData*)getPostData
{
    NSData *returnData = nil;
    if(0 == _requestType)
    {
        NSMutableString *temMutableString = [NSMutableString stringWithString:@""];
        for(NSString *key in _requestParameters.allKeys)
        {
            [temMutableString appendFormat:@"&%@=%@",key,[_requestParameters objectForKey:key]];
        }
        returnData = [temMutableString dataUsingEncoding:NSUTF8StringEncoding];
    }
    if(1 == _requestType)
    {
        NSMutableData *temMutableData = [[NSMutableData alloc] init];
        NSString *boundary = REQUEST_BOUNDARY;
        //rfc1867协议样式
        //        --AaB03x\r\n Content-Disposition:form-data;name="title"\r\n \r\n value\r\n
        //        --AaB03x\r\n Content-Disposition:form-data;name="imagetitle";filename="ab.jpg"\r\n Content-Type:image/JPEG\r\n \r\n datavalue\r\n
        //        --AaB03x--\r\n
        for(NSString *key in _requestParameters.allKeys)
        {
            if([[_requestParameters objectForKey:key] isKindOfClass:[NSString class]])
            {
                NSString *temStr = [NSString stringWithFormat:@"--%@\r\nContent-Disposition:form-data;name=\"%@\"\r\n\r\n%@\r\n",boundary,key,[_requestParameters objectForKey:key]];
                [temMutableData appendData:[temStr dataUsingEncoding:NSUTF8StringEncoding]];
            }
            else
            {
                NSString *temStr = [NSString stringWithFormat:@"--%@\r\nContent-Disposition:form-data;name=\"%@\";filename=ab.jpg\r\n Content-Type:image/JPEG\r\n\r\n",boundary,key];
                [temMutableData appendData:[temStr dataUsingEncoding:NSUTF8StringEncoding]];
                [temMutableData appendData:[_requestParameters objectForKey:key]];
                [temMutableData appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            }
        }
        NSString *endStr = [NSString stringWithFormat:@"--%@--\r\n",boundary];
        [temMutableData appendData:[endStr dataUsingEncoding:NSUTF8StringEncoding]];
        returnData = temMutableData;
    }
    return returnData;
}
#pragma mark- NSUrlConnection Delegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    //可以获取数据的长度
    //NSLog(@"response:%@",response);
    //NSLog(@"length:%lld",response.expectedContentLength);
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_receiveData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    //解析json数据
    NSDictionary *resultDictionary = [NSJSONSerialization JSONObjectWithData:_receiveData options:NSJSONReadingMutableLeaves error:nil];//新的解析方法
    //NSDictionary *resultDictionary = [_receiveData objectFromJSONData];//老的解析方法
    
    //#warning //NSLog
    /*
    NSString *str=[[NSMutableString alloc] initWithData:_receiveData encoding:NSUTF8StringEncoding];
    str=[str stringByReplacingOccurrencesOfString:@"," withString:@",\n"];
    str=[str stringByReplacingOccurrencesOfString:@"{" withString:@"{\n"];
    str=[str stringByReplacingOccurrencesOfString:@"}" withString:@"\n}"];
    */
    NSLog(@"request info:%@",resultDictionary);
    //NSLog(@"请求的数据原始版:%@",str);
    
    NSString *status = [resultDictionary objectForKey:@"success"];
    //如果token有误请重新连接 否则把数据发到请求方
    if(0 == [status intValue]&&200 ==[[resultDictionary objectForKey:@"error_code"] intValue])
    {
        if (![HemaFunction xfunc_check_strEmpty:[[NSUserDefaults standardUserDefaults] objectForKey:BB_XCONST_LOCAL_PLATTYPE]])
        {
            if ([[[NSUserDefaults standardUserDefaults] objectForKey:BB_XCONST_LOCAL_PLATTYPE]integerValue] == 0)
            {
                [self loginInBackground];
            }else
            {
                //第三方登录
                if ([[[NSUserDefaults standardUserDefaults] objectForKey:BB_XCONST_LOCAL_PLATTYPE]integerValue] == 1)
                {
                    [self wechatLogin:nil];
                }
                if ([[[NSUserDefaults standardUserDefaults] objectForKey:BB_XCONST_LOCAL_PLATTYPE]integerValue] == 2)
                {
                    [self qqLogin:nil];
                }
                if ([[[NSUserDefaults standardUserDefaults] objectForKey:BB_XCONST_LOCAL_PLATTYPE]integerValue] == 3)
                {
                    [self sinaLogin:nil];
                }
            }
        }else
        {
            if (isGetToken)
            {
                return;
            }
            isGetToken = YES;
            [self loginInBackground];
        }
    }
    else
    {
        //返回数据
        if(_backTarget && _backSelector)
        {
            if([_backTarget respondsToSelector:_backSelector])
            {
                SuppressPerformSelectorLeakWarning(
                                                   [_backTarget performSelector:_backSelector withObject:resultDictionary];
                                                   );
            }
        }
    }

    
    [self closeConnect];
    
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSString *msg = [NSString stringWithFormat:@"%@",[error localizedDescription]];
    NSDictionary *dic=[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"12",msg, nil] forKeys:[NSArray arrayWithObjects:@"success",@"msg", nil]];
    if([_backTarget respondsToSelector:_backSelector])
    {
        SuppressPerformSelectorLeakWarning(
                                           [_backTarget performSelector:_backSelector withObject:dic];
                                           );
    }
    [self closeConnect];
}

#pragma mark 登录
- (void)loginInBackground
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *currentVersion = [infoDictionary objectForKey:@"CFBundleVersion"];
    
    NSString *temUsername = [[NSUserDefaults standardUserDefaults] objectForKey:BB_XCONST_LOCAL_LOGINNAME];
    NSString *temPawssword = [[NSUserDefaults standardUserDefaults] objectForKey:BB_XCONST_LOCAL_PASSWORD];
    
    if ([HemaFunction xfunc_check_strEmpty:temUsername])
    {
        return;
    }
    if ([HemaFunction xfunc_check_strEmpty:temPawssword])
    {
        return;
    }
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:temUsername forKey:@"username"];
    [dic setObject:temPawssword forKey:@"password"];
    [dic setObject:[HemaFunction xfuncGetAppdelegate].mydeviceid?[HemaFunction xfuncGetAppdelegate].mydeviceid:@"无" forKey:@"deviceid"];
    [dic setObject:@"1" forKey:@"devicetype"];
    [dic setObject:currentVersion forKey:@"lastloginversion"];
    
    [HemaRequest requestWithURL:[NSString stringWithFormat:@"%@%@",REQUEST_MAINLINK,REQUEST_CLIENT_LOGIN] target:self selector:@selector(responseLogin:) parameter:dic];
}
- (void)responseLogin:(NSDictionary*)info
{
    if(1 == [[info objectForKey:@"success"] intValue])
    {
        //保存信息
        NSArray *temArray = [info objectForKey:@"infor"];
        NSDictionary *dic = [temArray objectAtIndex:0];
        NSMutableDictionary *temDic = [[NSMutableDictionary alloc] init];
        for(NSString * key in dic.allKeys)
        {
            if(![HemaFunction xfunc_check_strEmpty:[dic objectForKey:key]])
            {
                NSString*value = [dic objectForKey:key];
                [temDic setValue:value forKey:key];
            }
        }
        HemaManager *myManager = [HemaManager sharedManager];
        myManager.myInfor = temDic;
        myManager.userToken = [dic objectForKey:@"token"];
        
        [HemaFunction xfuncGetAppdelegate].isLogin = YES;
        
        //重新连接服务器请求数据
        [self.requestParameters setObject:myManager.userToken forKey:@"token"];
        [self requestWithURL:nil target:nil selector:nil parameter:nil];
        
        //10分钟后处理token
        [self performSelector:@selector(changeGetToken) withObject:nil afterDelay:600];
    }
}
#pragma mark - 第三方登录
//微信登录
-(void)wechatLogin:(id)sender
{
    [self requestPlatformLogin:nil plattype:@"1"];
}
//QQ登录
-(void)qqLogin:(id)sender
{
    [self requestPlatformLogin:nil plattype:@"2"];
}
//微博登录
-(void)sinaLogin:(id)sender
{
    [self requestPlatformLogin:nil plattype:@"3"];
}
#pragma mark 第三方登录
- (void)requestPlatformLogin:(NSMutableDictionary*)temDic plattype:(NSString*)plattype
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *currentVersion = [infoDictionary objectForKey:@"CFBundleVersion"];//客户端软件当前版本
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:plattype forKey:@"plattype"];
    
    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:BB_XCONST_LOCAL_UID] forKey:@"uid"];
    [dic setObject:@"1" forKey:@"devicetype"];
    [dic setObject:currentVersion forKey:@"lastloginversion"];
    
    [dic setObject:@"无" forKey:@"avatar"];
    [dic setObject:@"无" forKey:@"nickname"];
    [dic setObject:@"无" forKey:@"sex"];
    [dic setObject:@"无" forKey:@"age"];
    
    [HemaRequest requestWithURL:[NSString stringWithFormat:@"%@%@",REQUEST_MAINLINK,REQUEST_PLATFORM_SAVE] target:self selector:@selector(responsePlatformLogin:) parameter:dic];
}
- (void)responsePlatformLogin:(NSDictionary*)info
{
    if(1 == [[info objectForKey:@"success"] intValue])
    {
        //保存信息
        NSArray *temArray = [info objectForKey:@"infor"];
        NSDictionary *dic = [temArray objectAtIndex:0];
        NSMutableDictionary *temDic = [[NSMutableDictionary alloc] init];
        for(NSString * key in dic.allKeys)
        {
            if(![HemaFunction xfunc_check_strEmpty:[dic objectForKey:key]])
            {
                NSString*value = [dic objectForKey:key];
                [temDic setValue:value forKey:key];
            }
        }
        HemaManager *myManager = [HemaManager sharedManager];
        myManager.myInfor = temDic;
        myManager.userToken = [dic objectForKey:@"token"];
        
        [HemaFunction xfuncGetAppdelegate].isLogin = YES;
        
        //重新连接服务器请求数据
        [self.requestParameters setObject:myManager.userToken forKey:@"token"];
        [self requestWithURL:nil target:nil selector:nil parameter:nil];
        
        //10分钟后处理token
        [self performSelector:@selector(changeGetToken) withObject:nil afterDelay:600];
    }
}
-(void)changeGetToken
{
    isGetToken = NO;
}
@end
