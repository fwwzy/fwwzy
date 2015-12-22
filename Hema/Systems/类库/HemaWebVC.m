//
//  HemaWebVC.m
//  Hema
//
//  Created by LarryRodic on 15/10/7.
//  Copyright (c) 2015年 Hemaapp. All rights reserved.
//

#import "HemaWebVC.h"

#import "UIImageView+MJWebCache.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"

#import "UIWebView+BFKit.h"

@interface HemaWebVC ()<UIWebViewDelegate>
@property(nonatomic,strong)UIWebView *myWebView;
@end

@implementation HemaWebVC

- (void)loadSet
{
    [self.navigationItem setNewTitle:_objectTitle];
    
    _myWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, UI_View_Width, UI_View_Height)];
    _myWebView.delegate = self;//http://www.oschina.net/p/UIButton-Bootstrap
    if (_isAdgust)
    {
        [_myWebView setScalesPageToFit:YES];
    }else
    {
        [_myWebView setScalesPageToFit:NO];
    }
    [self.view addSubview:_myWebView];
    
    NSString *path = _urlPath?_urlPath:@"http://www.baidu.com";
    
    //path = @"http://www.hm5m.com/download/ios.html"; //js与ios之间的交互
    //path = @"http://www.jianshu.com/p/1142e5dafd4d";//查看大图的交互
    //path = @"http://124.128.23.74:8008/group8/hm_yjnh/index.php/map/index.html#";//中国地图的交互
    //[_myWebView setScalesPageToFit:YES];
    
    [_myWebView loadWebsite:path];
    //[_myWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:path]]];
}
#pragma mark- 自定义
#pragma mark 事件
-(void)leftbtnPressed:(id)sender
{
    if (self.navigationController.viewControllers.count == 1)
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
#pragma mark- UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    /*
    NSString *urlStr = [request.URL absoluteString];
    NSLog(@"地址：%@,%d",urlStr,(int)navigationType);
    
    if([urlStr isEqualToString:@"http://www.hm5m.com/getInfo/"])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"点击成功" message:@"呵呵" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        alert.tag = 998;
        alert.delegate = self;
        return NO;
    }
     */
    /*
    //查看大图的处理
    if ([request.URL.scheme isEqualToString:@"image-preview"]) {
        NSString* path = [request.URL.absoluteString substringFromIndex:[@"image-preview:" length]];
        path = [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        int count = 1;
        NSMutableArray *photos = [NSMutableArray arrayWithCapacity:count];
        
        NSString *url = path;
        MJPhoto *photo = [[MJPhoto alloc] init];
        photo.url = [NSURL URLWithString:url];
        photo.srcImageView = nil;
        [photos addObject:photo];
        
        MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
        browser.currentPhotoIndex = 0;
        browser.photos = photos;
        [browser show];
        
        return NO;
    }
    */
    return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    /*
    //js交互
    NSString *jsCode = [NSString stringWithFormat:@"alert(1);"];
    [webView stringByEvaluatingJavaScriptFromString:jsCode];
     */
    
    /*
    //查看大图的处理
    [_myWebView stringByEvaluatingJavaScriptFromString:@"function assignImageClickAction(){var imgs=document.getElementsByTagName('img');var length=imgs.length;for(var i=0;i<length;i++){img=imgs[i];img.onclick=function(){window.location.href='image-preview:'+this.src}}}"];
    [_myWebView stringByEvaluatingJavaScriptFromString:@"assignImageClickAction();"];
     */

}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    
}
/*
 document：属性
 
 document.title //设置文档标题等价于HTML的
 document.bgColor //设置页面背景色
 document.fgColor //设置前景色(文本颜色)
 document.linkColor //未点击过的链接颜色
 document.alinkColor //激活链接(焦点在此链接上)的颜色
 document.vlinkColor //已点击过的链接颜色
 document.URL //设置URL属性从而在同一窗口打开另一网页
 document.fileCreatedDate //文件建立日期，只读属性
 document.fileModifiedDate //文件修改日期，只读属性
 document.fileSize //文件大小，只读属性
 document.cookie //设置和读出cookie
 document.charset //设置字符集 简体中文:gb2312
 document：方法
 document.write() //动态向页面写入内容
 document_createElement_x_x_x(Tag) //创建一个html标签对象
 document.getElementByIdx_xx_x_x(ID) //获得指定ID值的对象
 document.getElementsByName(Name) //获得指定Name值的对象
 document.body.a(oTag)
 body：子对象
 document.body //指定文档主体的开始和结束等价于
 
 
 document.body.bgColor //设置或获取对象后面的背景颜色
 document.body.link //未点击过的链接颜色
 document.body.alink //激活链接(焦点在此链接上)的颜色
 document.body.vlink //已点击过的链接颜色
 document.body.text //文本色
 document.body.innerText //设置…之间的文本
 document.body.innerHTML //设置…之间的HTML代码
 document.body.topMargin //页面上边距
 document.body.leftMargin //页面左边距
 document.body.rightMargin //页面右边距
 document.body.bottomMargin //页面下边距
 document.body.background //背景图片
 document.body.a(oTag) //动态生成一个HTML对象
 location：子对象
 document.location.hash // #号后的部分
 document.location.host // 域名+端口号
 document.location.hostname // 域名
 document.location.href // 完整URL
 document.location.pathname // 目录部分
 document.location.port // 端口号
 document.location.protocol // 网络协议(http:)
 document.location.search // ?号后的部分
 常用对象事件:
 documeny.location.reload() //刷新网页
 document.location.reload(URL) //打开新的网页
 document.location.assign(URL) //打开新的网页
 document.location.replace(URL) //打开新的网页
 selection-选区子对象
 document.selection
 
 
 
 
 原理阐述
 
 1. 背景知识
 
 在了解该原理之前，需要知道如下内容
 
 html中的点击动作一般都是通过javascript来实现的，如下面代码:

 var img = document.getElementById('test');
 img.onclick = function() {
 alert("test");
 }
 PS: 以上代码实现的: 点击< img>来弹出含test的提示框.
 javascript与objc交互
 在iOS APP开发过程中，是通过UIWebView来加载html页面，因此javascript要与objc交互，桥梁应该就在UIWebview提供的API中，可以发现如下一些接口:

 //objc 传参给javascript
 - (NSString *)stringByEvaluatingJavaScriptFromString:(NSString *)script;
 
 //javascript 传参给objc， 参数是存在于request中
 - (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;
 
 2. 实现细节
 
 在UIWebview加载完html后，调用stringByEvaluatingJavaScriptFromString来执行如下javascript代码，可以使用javascript压缩工具压缩下

 function assignImageClickAction() {
 var imgs = document.getElementsByTagName('img');
 var length = imgs.length;
 for (var i = 0; i < length; i++) {
 img = imgs[i];
 img.onclick = function() {
 window.location.href = 'image-preview:' + this.src
 }
 }
 }
 assignImageClickAction();
 在webView:shouldStartLoadWithRequest:navigationType处理image-preview
 */
@end
