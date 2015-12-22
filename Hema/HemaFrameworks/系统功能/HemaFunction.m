//
//  HemaFunction.m
//  Hema
//
//  Created by LarryRodic on 15/10/5.
//  Copyright (c) 2015年 Hemaapp. All rights reserved.
//

#import "HemaFunction.h"
#import "Reachability.h"
#import <CoreText/CoreText.h>
#import <CoreLocation/CoreLocation.h>
#import <AVFoundation/AVFoundation.h>

#import <sys/socket.h>
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>

@implementation HemaFunction

#pragma mark- 字符串相关
//获取text文本高度(厚字体)
+ (CGSize)getSizeWithStr:(NSString*)str width:(float)width font:(float)font
{
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:font]};
    CGSize temSize = [str boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                       options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                    attributes:attribute
                                       context:nil].size;
    if(![HemaFunction xfunc_check_strEmpty:str])
    {
        temSize = [str boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                    options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                 attributes:attribute
                                    context:nil].size;
    }
    return temSize;
}
//获取text文本高度(正常字体)
+ (CGSize)getSizeWithStrNo:(NSString*)str width:(float)width font:(float)font
{
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:font]};
    CGSize temSize = [str boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                       options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                    attributes:attribute
                                       context:nil].size;
    if(![HemaFunction xfunc_check_strEmpty:str])
    {
        temSize = [str boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                    options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                 attributes:attribute
                                    context:nil].size;
    }
    return temSize;
}
//获取隐藏的手机号
+ (NSString*)getSecreatMobile:(NSString*)_mobile
{
    if (_mobile.length<11)
    {
        return @"无";
    }
    NSRange temRange = NSMakeRange(3, 4);
    NSString *star = @"";
    for(int i = 0;i<temRange.length;i++)
    {
        star = [NSString stringWithFormat:@"%@*",star];
    }
    _mobile = [_mobile stringByReplacingCharactersInRange:temRange withString:star];
    return _mobile;
}
//获取隐藏的邮箱号
+ (NSString*)getSecreatEmail:(NSString*)_email
{
    NSRange range = [_email rangeOfString:@"@"];
    if(range.length >0)
    {
        NSArray *emailArr = [_email componentsSeparatedByString:@"@"];
        NSString *temName = [emailArr objectAtIndex:0];
        int fromLen = (int)(temName.length/3);
        int middleLen = (int)(temName.length - fromLen*2);
        NSString *temStar = @"";
        for(int i = 0;i<middleLen;i++)
        {
            temStar = [NSString stringWithFormat:@"%@*",temStar];
        }
        NSRange temRange = NSMakeRange(fromLen, middleLen);
        temName = [temName stringByReplacingCharactersInRange:temRange withString:temStar];
        _email = [NSString stringWithFormat:@"%@@%@",temName,[emailArr objectAtIndex:1]];
    }
    return _email;
}
//函数功能：字符串判空
+ (BOOL) xfunc_check_strEmpty:(NSString *) parmStr
{
    if (!parmStr)
        return YES;
    if ([parmStr isEqual:nil])
        return YES;
    if ([parmStr isEqual:@""])
        return YES;
    id tempStr=parmStr;
    if (tempStr==[NSNull null])
        return YES;
    return NO;
}
//手机号合法判断
+ (BOOL)xfunc_isMobileNumber:(NSString *)mobileNum
{
    if (mobileNum.length != 11)
    {
        return NO;
    }
    return YES;
}
//邮箱合法
+ (BOOL)xfunc_isEmail:(NSString*)email
{
    NSString *regex = @"^[\\w-]+(\\.[\\w-]+)*@[\\w-]+(\\.[\\w-]+)+$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [pred evaluateWithObject:email];
}
//获取固定宽度的字符串存放长度的个数
+ (int)getLineSize:(NSString *)content startIndex:(int)start width:(float)width font:(float)font
{
    CFAttributedStringRef attrString;
    NSMutableAttributedString *astr = [[NSMutableAttributedString alloc] initWithString:content];
    //创建字体及字号
    UIFont* temFont = [UIFont systemFontOfSize:font];
    CTFontRef helvetica = CTFontCreateWithName((CFStringRef)temFont.fontName, temFont.pointSize, NULL);
    //将字体设置给attributeString
    [astr addAttribute:(id)kCTFontAttributeName
                 value:(__bridge id)helvetica
                 range:NSMakeRange(0, [astr length])];
    CFRelease(helvetica);
    attrString = (__bridge CFAttributedStringRef)astr;
    CTTypesetterRef typesetter = CTTypesetterCreateWithAttributedString(attrString);
    CFIndex count = CTTypesetterSuggestLineBreak(typesetter, start, width);
    CFRelease(typesetter);
    
    return (int)count;
}
//获取公里数
+ (NSString*)getDistance:(float)distance
{
    NSString *temStr;
    if (distance >= 1000)
    {
        temStr = [NSString stringWithFormat:@"%f",distance/1000];
        temStr = [temStr substringWithRange:NSMakeRange(0, temStr.length-7)];
        temStr = [NSString stringWithFormat:@"%@km",temStr];
    }else
    {
        temStr = [NSString stringWithFormat:@"%f",distance];
        temStr = [temStr substringWithRange:NSMakeRange(0, temStr.length-7)];
        temStr = [NSString stringWithFormat:@"%@m",temStr];
    }
    return temStr;
}
//经纬度之间的距离
+ (double)distanceBetweenOrderBy:(double)lat1 :(double)lng1 :(double)lat2 :(double)lng2
{
    CLLocation* curLocation = [[CLLocation alloc] initWithLatitude:lat1 longitude:lng1];
    CLLocation* otherLocation = [[CLLocation alloc] initWithLatitude:lat2 longitude:lng2];
    double distance  = [curLocation distanceFromLocation:otherLocation];
    return distance;
}
//判断是否有中文
+ (BOOL)IsChinese:(NSString *)str
{
    for(int i=0; i< [str length];i++)
    {
        int a = [str characterAtIndex:i];
        if( a > 0x4e00 && a < 0x9fff)
        {
            return YES;
        }
    }
    return NO;
}
#pragma mark- 时间相关
//获取当前时间
+ (NSDate*)getDateNow
{
    NSDate *date = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: date];
    NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
    return localeDate;
}
+ (NSString*)getStringNow
{
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateStr = [dateFormatter stringFromDate:date];
    return dateStr;
}
// 获取操作在多久之前(用于发表话题、帖子、评论时)
+ (NSString *)getTimeFromDate:(NSString *)fromDate
{
    if ([HemaFunction xfunc_check_strEmpty:fromDate])
    {
        return @"今天";
    }
    NSDate *date=[NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *oldDate = [dateFormatter dateFromString:fromDate];
    
    NSString *nowdate = [HemaFunction getStringNow];
    NSRange temRange = NSMakeRange(0, 10);
    NSString *timeStrNow = [nowdate substringWithRange:temRange];
    NSString *timeStrOld = [fromDate substringWithRange:temRange];
    
    NSCalendar *calendar=[[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
    NSUInteger unitFlags=NSHourCalendarUnit|NSMinuteCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit;
    NSDateComponents *dateComponent=[calendar components:unitFlags fromDate:oldDate toDate:date options:0];
    NSInteger difHour=[dateComponent hour];
    NSInteger diffMin=[dateComponent minute];
    NSString *timer = nil;
    
    if ([timeStrNow isEqualToString:timeStrOld])//当天的
    {
        if (difHour == 0)//不到一个小时
        {
            if (diffMin == 0)
            {
                timer=[NSString stringWithFormat:@"刚刚"];
            }else
            {
                timer=[NSString stringWithFormat:@"%d分钟前",(int)diffMin];
            }
            
        }else
            timer=[NSString stringWithFormat:@"今天%@",[fromDate substringWithRange:NSMakeRange(11, 5)]];
    }else
    {
        temRange = NSMakeRange(0, 4);
        timeStrNow = [nowdate substringWithRange:temRange];
        timeStrOld = [fromDate substringWithRange:temRange];
        if ([timeStrNow isEqualToString:timeStrOld])//今年的
            timer=[NSString stringWithFormat:@"%@",[fromDate substringWithRange:NSMakeRange(5, 11)]];
        else
            timer=[NSString stringWithFormat:@"%@",[fromDate substringWithRange:NSMakeRange(0, 10)]];
    }
    return timer;
}
//获取时间差
+ (CGFloat)getDateDifference:(NSString*)oldDateStr newDate:(NSString*)newDateStr
{
    CGFloat timeDifference = 0.0;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yy-MM-dd HH:mm:ss"];
    NSDate *oldDate = [formatter dateFromString:oldDateStr];
    NSDate *newDate = [formatter dateFromString:newDateStr];
    NSTimeInterval oldTime = [oldDate timeIntervalSince1970];
    NSTimeInterval newTime = [newDate timeIntervalSince1970];
    timeDifference = newTime - oldTime;
    
    return timeDifference;
}
//获取一个随机数
+ (int)getRandomNumber:(int)from to:(int)to
{
    return (int)(from+(arc4random()%(to-from+1))); //+1,result is [from to]; else is [from, to)!!!!!!!
}
#pragma mark- 弹窗相关
//显示黑色等待弹窗
+ (MBProgressHUD*)openHUD:(NSString*)message
{
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithWindow:[HemaFunction xfuncGetAppdelegate].window];
    [[HemaFunction xfuncGetAppdelegate].window addSubview:HUD];
    HUD.labelText = message;
    HUD.mode = MBProgressHUDModeIndeterminate;
    HUD.yOffset = -50.0f;
    [HUD show:YES];
    return HUD;
}
+ (void)closeHUD:(MBProgressHUD*)HUD
{
    if (HUD)
    {
        [HUD hide:YES];
        [HUD removeFromSuperview];HUD = nil;
    }
}
//显示黑色定时弹窗 view
+ (void)openIntervalHUD:(NSString*)message
{
    if ([HemaFunction xfunc_check_strEmpty:message])
    {
        return;
    }
    [UIWindow showToastMessage:message];
}
//显示黑色定时弹窗(带对勾的表示发表成功之类的)
+ (void)openIntervalHUDOK:(NSString*)message
{
    if ([HemaFunction xfunc_check_strEmpty:message])
    {
        return;
    }
    MBProgressHUD *HUD;
    HUD = [[MBProgressHUD alloc] initWithWindow:[HemaFunction xfuncGetAppdelegate].window];
    [[HemaFunction xfuncGetAppdelegate].window addSubview:HUD];
    
    HUD.labelText = message;
    HUD.userInteractionEnabled = YES;
    HUD.mode = MBProgressHUDModeCustomView;
    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"R对号.png"]];
    HUD.yOffset = -50.0f;
    
    [HUD showAnimated:YES whileExecutingBlock:^{
        sleep(1.5);
    } completionBlock:^{
        [HUD removeFromSuperview];
    }];
}
#pragma mark- 视图相关
//自定义边角
+ (BOOL)addbordertoView:(UIView*)view radius:(CGFloat)radius width:(CGFloat)width color:(UIColor*)color
{
    CALayer *layer = [view layer];
    [layer setBorderColor:color.CGColor];
    [layer setBorderWidth:width];
    [layer setCornerRadius:radius];
    [layer setMasksToBounds:YES];
    return YES;
}
#pragma mark- 获取主变量相关函数
//获取主appdelegate
+ (AppDelegate*)xfuncGetAppdelegate
{
    return (AppDelegate*)[[UIApplication sharedApplication] delegate];
}
//获得后台服务根目录
+ (NSString*)getRootPath
{
    NSString *url = [[[HemaManager sharedManager] myInitInfor] objectForKey:@"sys_web_service"];
    if ([HemaFunction xfunc_check_strEmpty:url])
    {
        return REQUEST_MAINLINK_INIT;
    }
    return [[[HemaManager sharedManager] myInitInfor] objectForKey:@"sys_web_service"];
}
#pragma mark- 图片处理相关
//绘制阴影
+ (void)dropShadowWithOffset:(CGSize)offset radius:(CGFloat)radius
                       color:(UIColor *)color opacity:(CGFloat)opacity view:(UIView*)myview
{
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, myview.bounds);
    myview.layer.shadowPath = path;
    CGPathCloseSubpath(path);
    CGPathRelease(path);
    
    myview.layer.shadowColor = color.CGColor;
    myview.layer.shadowOffset = offset;
    myview.layer.shadowRadius = radius;
    myview.layer.shadowOpacity = opacity;
    
    myview.clipsToBounds = NO;
}
//绘制四周阴影
+ (void)dropShadow:(CGSize)offset radius:(CGFloat)radius
             color:(UIColor *)color opacity:(CGFloat)opacity view:(UIView*)myview
{
    myview.layer.shadowColor = color.CGColor;//shadowColor阴影颜色
    myview.layer.shadowOffset = offset;//shadowOffset阴影偏移，默认(0, -3),这个跟shadowRadius配合使用
    myview.layer.shadowOpacity = opacity;//阴影透明度，默认0
    myview.layer.shadowRadius = radius;//阴影半径，默认3
    
    //路径阴影
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    float width = myview.bounds.size.width;
    float height = myview.bounds.size.height;
    float x = myview.bounds.origin.x;
    float y = myview.bounds.origin.y;
    float addWH = 1;
    
    CGPoint topLeft      = myview.bounds.origin;
    CGPoint topMiddle = CGPointMake(x+(width/2),y-addWH);
    CGPoint topRight     = CGPointMake(x+width,y);
    
    CGPoint rightMiddle = CGPointMake(x+width+addWH,y+(height/2));
    
    CGPoint bottomRight  = CGPointMake(x+width,y+height);
    CGPoint bottomMiddle = CGPointMake(x+(width/2),y+height+addWH);
    CGPoint bottomLeft   = CGPointMake(x,y+height);
    
    
    CGPoint leftMiddle = CGPointMake(x-addWH,y+(height/2));
    
    [path moveToPoint:topLeft];
    //添加四个二元曲线
    [path addQuadCurveToPoint:topRight
                 controlPoint:topMiddle];
    [path addQuadCurveToPoint:bottomRight
                 controlPoint:rightMiddle];
    [path addQuadCurveToPoint:bottomLeft
                 controlPoint:bottomMiddle];
    [path addQuadCurveToPoint:topLeft
                 controlPoint:leftMiddle];
    //设置阴影路径
    myview.layer.shadowPath = path.CGPath;
}
//剪切view
+ (UIImage*)captureView:(UIView *)aView
{
    CGRect rect = aView.frame;
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [aView.layer renderInContext:context];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}
//获取一个纯色图片
+(UIImage*)getImageWithSize:(CGSize)contentSize color:(UIColor*)color
{
    //初始化画布
    UIGraphicsBeginImageContext(contentSize);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0.0, contentSize.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    //fill color
    CGColorRef fillColor = color.CGColor;
    CGContextSetFillColor(context, CGColorGetComponents(fillColor));
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, 0, 0.0f);
    CGContextAddLineToPoint(context, contentSize.width, 0.0f);
    CGContextAddLineToPoint(context, contentSize.width, contentSize.height);
    CGContextAddLineToPoint(context, 0.0f, contentSize.height);
    CGContextClosePath(context);
    CGContextFillPath(context);
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}
//拍照或者从相册获取图片结束后裁剪图片
+(UIImage*)getImage:(UIImage*)image
{
    float myHeight = image.size.height*640/image.size.width;
    
    UIImage *temImg = image;
    NSData *temData = UIImageJPEGRepresentation(image, 0.8);
    
    if (temData.length>400*1024)
    {
        if (image.size.width<=640)
        {
            return temImg;
        }
        
        UIGraphicsBeginImageContext(CGSizeMake(640, myHeight));
        [image drawInRect:CGRectMake(0, 0, 640, myHeight)];
        UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return scaledImage;
    }
    return temImg;
}
//添加上下黑边的方法
+(UIImage*)imageToSquare:(UIImage*)image
{
    if(image.size.width <= image.size.height)
    {
        return image;
    }
    CGSize contentSize = CGSizeMake(image.size.width, image.size.width);
    CGFloat yCoordinate = (contentSize.height-image.size.height)/2;//NSLog(@"y:%f",yCoordinate);
    
    //初始化画布
    UIGraphicsBeginImageContext(contentSize);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0.0, contentSize.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    //fill color
    CGColorRef fillColor = [[UIColor clearColor] CGColor];
    CGContextSetFillColor(context, CGColorGetComponents(fillColor));
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, 0, 0.0f);
    CGContextAddLineToPoint(context, contentSize.width, 0.0f);
    CGContextAddLineToPoint(context, contentSize.width, contentSize.height);
    CGContextAddLineToPoint(context, 0.0f, contentSize.height);
    CGContextClosePath(context);
    CGContextFillPath(context);
    
    //画图
    CGContextDrawImage(context, CGRectMake(0.0, yCoordinate, contentSize.width, image.size.height), image.CGImage);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}
//对图片进行旋转 image = [HemaFunction grayscale:image type:1];image = [HemaFunction image:image rotation:UIImageOrientationRight]; 黑白化+旋转处理拍照完的图片
+ (UIImage *)image:(UIImage *)image rotation:(UIImageOrientation)orientation
{
    long double rotate = 0.0;
    CGRect rect;
    float translateX = 0;
    float translateY = 0;
    float scaleX = 1.0;
    float scaleY = 1.0;
    
    switch (orientation) {
        case UIImageOrientationLeft:
            rotate = M_PI_2;
            rect = CGRectMake(0, 0, image.size.height, image.size.width);
            translateX = 0;
            translateY = -rect.size.width;
            scaleY = rect.size.width/rect.size.height;
            scaleX = rect.size.height/rect.size.width;
            break;
        case UIImageOrientationRight:
            rotate = 3 * M_PI_2;
            rect = CGRectMake(0, 0, image.size.height, image.size.width);
            translateX = -rect.size.height;
            translateY = 0;
            scaleY = rect.size.width/rect.size.height;
            scaleX = rect.size.height/rect.size.width;
            break;
        case UIImageOrientationDown:
            rotate = M_PI;
            rect = CGRectMake(0, 0, image.size.width, image.size.height);
            translateX = -rect.size.width;
            translateY = -rect.size.height;
            break;
        default:
            rotate = 0.0;
            rect = CGRectMake(0, 0, image.size.width, image.size.height);
            translateX = 0;
            translateY = 0;
            break;
    }
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    //做CTM变换
    CGContextTranslateCTM(context, 0.0, rect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextRotateCTM(context, rotate);
    CGContextTranslateCTM(context, translateX, translateY);
    
    CGContextScaleCTM(context, scaleX, scaleY);
    //绘制图片
    CGContextDrawImage(context, CGRectMake(0, 0, rect.size.width, rect.size.height), image.CGImage);
    
    UIImage *newPic = UIGraphicsGetImageFromCurrentImageContext();
    
    return newPic;
}
//更改图片的颜色
+ (UIImage *)invertImage:(UIImage *)originalImage myColor:(UIColor*)myColor
{
    UIGraphicsBeginImageContext(originalImage.size);
    CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeCopy);
    CGRect imageRect = CGRectMake(0, 0, originalImage.size.width, originalImage.size.height);
    [originalImage drawInRect:imageRect];
    
    CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeDifference);
    CGContextTranslateCTM(UIGraphicsGetCurrentContext(), 0, originalImage.size.height);
    CGContextScaleCTM(UIGraphicsGetCurrentContext(), 1.0, -1.0);
    CGContextClipToMask(UIGraphicsGetCurrentContext(), imageRect,  originalImage.CGImage);
    CGContextSetFillColorWithColor(UIGraphicsGetCurrentContext(),myColor.CGColor);
    CGContextFillRect(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, originalImage.size.width, originalImage.size.height));
    UIImage *returnImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return returnImage;
}
//黑白化图片 请在真机下调试
+ (UIImage*)grayscale:(UIImage*)anImage type:(int)type
{
    CGImageRef imageRef = anImage.CGImage;
    
    size_t width  = CGImageGetWidth(imageRef);
    size_t height = CGImageGetHeight(imageRef);
    size_t bitsPerComponent = CGImageGetBitsPerComponent(imageRef);
    size_t bitsPerPixel = CGImageGetBitsPerPixel(imageRef);
    size_t bytesPerRow = CGImageGetBytesPerRow(imageRef);
    
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(imageRef);
    CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(imageRef);
    
    bool shouldInterpolate = CGImageGetShouldInterpolate(imageRef);
    CGColorRenderingIntent intent = CGImageGetRenderingIntent(imageRef);
    CGDataProviderRef dataProvider = CGImageGetDataProvider(imageRef);
    CFDataRef data = CGDataProviderCopyData(dataProvider);
    UInt8 *buffer = (UInt8*)CFDataGetBytePtr(data);
    NSUInteger  x, y;
    for (y = 0; y < height; y++)
    {
        for (x = 0; x < width; x++)
        {
            UInt8 *tmp;
            tmp = buffer + y * bytesPerRow + x * 4;
            
            UInt8 red,green,blue;
            red = *(tmp + 0);
            green = *(tmp + 1);
            blue = *(tmp + 2);
            
            UInt8 brightness;
            switch (type)
            {
                case 1:
                    brightness = (77 * red + 28 * green + 151 * blue) / 256;
                    *(tmp + 0) = brightness;
                    *(tmp + 1) = brightness;
                    *(tmp + 2) = brightness;
                    break;
                case 2:
                    *(tmp + 0) = red;
                    *(tmp + 1) = green * 0.7;
                    *(tmp + 2) = blue * 0.4;
                    break;
                case 3:
                    *(tmp + 0) = 255 - red;
                    *(tmp + 1) = 255 - green;
                    *(tmp + 2) = 255 - blue;
                    break;
                default:
                    *(tmp + 0) = red;
                    *(tmp + 1) = green;
                    *(tmp + 2) = blue;
                    break;
            }
        }
    }
    CFDataRef effectedData = CFDataCreate(NULL, buffer, CFDataGetLength(data));
    CGDataProviderRef effectedDataProvider = CGDataProviderCreateWithCFData(effectedData);
    CGImageRef effectedCgImage = CGImageCreate(
                                               width, height,
                                               bitsPerComponent, bitsPerPixel, bytesPerRow,
                                               colorSpace, bitmapInfo, effectedDataProvider,
                                               NULL, shouldInterpolate, intent);
    
    UIImage *effectedImage = [[UIImage alloc] initWithCGImage:effectedCgImage];
    CGImageRelease(effectedCgImage);
    CFRelease(effectedDataProvider);
    CFRelease(effectedData);
    CFRelease(data);
    return effectedImage;
}
//生成随机颜色
+ (UIColor *)randomColor
{
    CGFloat hue = ( arc4random() % 256 / 256.0 );
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
}
//生成二维码
+ (UIImage *)generateQRCode:(NSString*)code width:(CGFloat)width height:(CGFloat)height
{
    CIImage *qrcodeImage;
    NSData *data = [code dataUsingEncoding:NSISOLatin1StringEncoding allowLossyConversion:false];
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    
    [filter setValue:data forKey:@"inputMessage"];
    [filter setValue:@"H" forKey:@"inputCorrectionLevel"];
    qrcodeImage = [filter outputImage];
    
    //消除模糊
    CGFloat scaleX = width / qrcodeImage.extent.size.width;
    CGFloat scaleY = height / qrcodeImage.extent.size.height;
    CIImage *transformedImage = [qrcodeImage imageByApplyingTransform:CGAffineTransformScale(CGAffineTransformIdentity, scaleX, scaleY)];
    
    return [UIImage imageWithCIImage:transformedImage];
}
//生成条形码
+ (UIImage *)generateBarCode:(NSString*)code width:(CGFloat)width height:(CGFloat)height
{
    CIImage *barcodeImage;
    NSData *data = [code dataUsingEncoding:NSISOLatin1StringEncoding allowLossyConversion:false];
    CIFilter *filter = [CIFilter filterWithName:@"CICode128BarcodeGenerator"];
    
    [filter setValue:data forKey:@"inputMessage"];
    barcodeImage = [filter outputImage];
    
    //消除模糊
    CGFloat scaleX = width / barcodeImage.extent.size.width;
    CGFloat scaleY = height / barcodeImage.extent.size.height;
    CIImage *transformedImage = [barcodeImage imageByApplyingTransform:CGAffineTransformScale(CGAffineTransformIdentity, scaleX, scaleY)];
    
    return [UIImage imageWithCIImage:transformedImage];
}
#pragma mark- 声音播放相关
//提示声
+ (void)playPoint:(NSString*)sound type:(NSString*)type
{
    AVAudioPlayer *avAudioPlayer;
    NSString *string = [[NSBundle mainBundle] pathForResource:sound ofType:type];
    
    NSURL *url = [NSURL fileURLWithPath:string];
    avAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    avAudioPlayer.numberOfLoops = 0;
    [avAudioPlayer play];
    sleep(2);
}
//捕捉在线视频第一帧
+ (UIImage*)thumbnailImageForVideo:(NSURL *)videoURL atTime:(NSTimeInterval)time
{
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
    NSParameterAssert(asset);
    AVAssetImageGenerator *assetImageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    assetImageGenerator.appliesPreferredTrackTransform = YES;
    assetImageGenerator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
    
    CGImageRef thumbnailImageRef = NULL;
    CFTimeInterval thumbnailImageTime = time;
    NSError *thumbnailImageGenerationError = nil;
    thumbnailImageRef = [assetImageGenerator copyCGImageAtTime:CMTimeMake(thumbnailImageTime, 60) actualTime:NULL error:&thumbnailImageGenerationError];
    
    if (!thumbnailImageRef)
        NSLog(@"thumbnailImageGenerationError %@", thumbnailImageGenerationError);
    
    UIImage *thumbnailImage = thumbnailImageRef ?[[UIImage alloc] initWithCGImage:thumbnailImageRef] : nil;
    return thumbnailImage;
}
//获取视频的大小
+ (NSInteger)getFileSize:(NSString*) path
{
    NSFileManager * filemanager = [[NSFileManager alloc]init];
    if([filemanager fileExistsAtPath:path]){
        NSDictionary * attributes = [filemanager attributesOfItemAtPath:path error:nil];
        NSNumber *theFileSize;
        if ( (theFileSize = [attributes objectForKey:NSFileSize]) )
            return  [theFileSize intValue]/1024;
        else
            return -1;
    }
    else
    {
        return -1;
    }
}
//获取视频的时间
+ (CGFloat)getVideoDuration:(NSURL*) URL
{
    NSDictionary *opts = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO]
                                                     forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
    AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:URL options:opts];
    float second = 0;
    second = urlAsset.duration.value/urlAsset.duration.timescale;
    return second;
}
#pragma mark- 系统相关
//寻找第一响应者
+ (id) traverseResponderChainForUIViewController:(UIView*)view
{
    for(id next = [view nextResponder];true;next = [next nextResponder])
    {
        if([next isKindOfClass:[UIViewController class]])
        {
            return next;
        }
    }
    
    return nil;
}
//检测网络状态
+ (BOOL)canConnectNet
{
    Reachability *reache=[Reachability reachabilityWithHostName:@"www.baidu.com"];
    
    switch ([reache currentReachabilityStatus])
    {
        case NotReachable://无网络
            return NO;
        case ReachableViaWiFi://wifi网络rr
            return YES;
        case ReachableViaWWAN://wwlan网络
            return YES;
        default:
            break;
    }
    return NO;
}
//检测网络是否是wifi
+ (BOOL)canConnectWifi
{
    Reachability *reache=[Reachability reachabilityWithHostName:@"www.baidu.com"];
    
    switch ([reache currentReachabilityStatus])
    {
        case NotReachable://无网络
            return NO;
        case ReachableViaWiFi://wifi网络rr
            return YES;
        case ReachableViaWWAN://wwlan网络
            return NO;
        default:
            break;
    }
    return NO;
}
//获取mac地址
+ (NSString*)getMacaddress
{
    int mib[6];
    size_t len;
    char *buf;
    unsigned char *ptr;
    struct if_msghdr *ifm;
    struct sockaddr_dl *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0)
        return NULL;
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0)
        return NULL;
    if ((buf = malloc(len)) == NULL)
        return NULL;
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0)
        return NULL;
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *outstring = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);
    return [outstring uppercaseString];
}
@end
