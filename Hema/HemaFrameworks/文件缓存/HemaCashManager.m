//
//  HemaCashManager.m
//  Hema
//
//  Created by LarryRodic on 15/10/5.
//  Copyright (c) 2015年 Hemaapp. All rights reserved.
//

#import "HemaCashManager.h"
#import "HemaImgView.h"

static HemaCashManager *sharedCashManager = nil;
@implementation HemaCashManager
@synthesize myIOQueue;

#pragma mark- 接口相关
//删除文件
- (BOOL)removeDocument:(NSString*)document
{
    NSString *directory = [self getFilePath:document];
    return [self deleteFileAtPaths:directory];
}
//把图片设为按钮的背景
-(void)addImgToBtnFromDocumentORURL:(UIButton*)btn document:(NSString*)document url:(NSString*)url
{
    NSString *temImgName = [self liGetImgNameFromURL:url];btn.titleLabel.text = url;
    NSString *temImgPath = [self getFilePath:temImgName directory:document];
    
    if([[NSFileManager defaultManager] fileExistsAtPath:temImgPath])
    {
        UIImage *img = [self getImagefrompath:temImgPath];
        [btn setBackgroundImage:img forState:UIControlStateNormal];
        [btn setBackgroundImage:img forState:UIControlStateDisabled];
    }
    else
    {
        dispatch_async([self runOnIOThread], [self BlockWithAutoreleasePool:^(void){
            UIImage *img = [self loadImagefromUrl:url];
            [self savepicturefromimage:img path:temImgPath];
            if([btn.titleLabel.text isEqualToString:url])
            {
                dispatch_async(dispatch_get_main_queue(), [self BlockWithAutoreleasePool:^(void){
                    if(btn)
                    {
                        if (img)
                        {
                            [btn setBackgroundImage:img forState:UIControlStateNormal];
                            [btn setBackgroundImage:img forState:UIControlStateDisabled];
                        }
                    }
                }]);
            }
        }]);
    }
}
//往imgView添加图片
-(void)addImgToImgViewFromDocumentORURL:(UIImageView*)imgView document:(NSString*)document url:(NSString*)url
{
    NSString *temImgName = [self liGetImgNameFromURL:url];
    NSString *temImgPath = [self getFilePath:temImgName directory:document];
    
    HemaImgView *yyImgView = nil;
    if([imgView isKindOfClass:[HemaImgView class]])
    {
        yyImgView = (HemaImgView*)imgView;
        yyImgView.imgURL = url;
    }
    
    if([[NSFileManager defaultManager] fileExistsAtPath:temImgPath])
    {
        UIImage *img = [self getImagefrompath:temImgPath];
        imgView.image = img;
    }
    else
    {
        dispatch_async([self runOnIOThread], [self BlockWithAutoreleasePool:^(void){
            UIImage *img = [self loadImagefromUrl:url];
            [self savepicturefromimage:img path:temImgPath];
            
            if(yyImgView)
            {
                if([yyImgView.imgURL isEqualToString:url])
                {
                    dispatch_async(dispatch_get_main_queue(), [self BlockWithAutoreleasePool:^(void){
                        if(imgView)
                        {
                            if (img)
                            {
                                imgView.image = img;
                            }
                        }
                    }]);
                }
            }else
            {
                dispatch_async(dispatch_get_main_queue(), [self BlockWithAutoreleasePool:^(void){
                    if(imgView)
                    {
                        if (img)
                        {
                            imgView.image = img;
                        }
                    }
                }]);
            }
        }]);
    }
}
//缓存声音、视频
-(BOOL)downloadAVFromDocumentORURL:(NSString*)document url:(NSString*)url
{
    NSString *temImgName = [self liGetImgNameFromURL:url];
    NSString *temImgPath = [self getFilePath:temImgName directory:document];
    if([[NSFileManager defaultManager] fileExistsAtPath:temImgPath])
    {
        return YES;
    }
    dispatch_async([self runOnIOThread], [self BlockWithAutoreleasePool:^(void){
        NSData *temData = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
        [temData writeToFile:temImgPath atomically:YES];
        dispatch_async(dispatch_get_main_queue(), [self BlockWithAutoreleasePool:^(void){
        }]);
    }]);
    return NO;
}
#pragma mark- 文件相关
//获取文件完整路陉
-(NSString*)getFilePath:(NSString*)fileName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    
    NSString *filePath = [path stringByAppendingPathComponent:fileName];
    return filePath;
}
//删除文件
-(BOOL)deleteFileAtPaths:(NSString *)path
{
    NSFileManager *manage = [NSFileManager defaultManager];
    BOOL flag = [manage removeItemAtPath:path error:nil];
    return flag;
}
//由图片的url生成图片名
-(NSString*)liGetImgNameFromURL:(NSString*)url
{
    NSString *imgName = [url stringByReplacingOccurrencesOfString:@"//" withString:@""];
    NSRange range = [imgName rangeOfString:@"/"];
    if(imgName.length > (range.location+range.length))
    {
        imgName = [imgName substringFromIndex:range.location+range.length];
        imgName = [imgName stringByReplacingOccurrencesOfString:@"/" withString:@""];
        return imgName;
    }
    return nil;
}
//获取带文件夹的文件路径 例子：my/abc/img
-(NSString*)getFilePath:(NSString *)fileName directory:(NSString*)directoryName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    NSString *strPath = [path stringByAppendingPathComponent:directoryName];
    if (![[NSFileManager defaultManager] fileExistsAtPath:strPath])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:strPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *filePath = [path stringByAppendingFormat:@"/%@/%@",directoryName,fileName];
    return filePath;
}
//从文件获取图像
-(UIImage *)getImagefrompath:(NSString *)path
{
    return [[UIImage alloc]initWithContentsOfFile:path];
}
//下载网络上的图像
-(UIImage*)loadImagefromUrl:(NSString*)url
{
    UIImage *img=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]];
    return img;
}
//把图片存入本地
-(void)savepicturefromimage:(UIImage*)image path:(NSString *)path
{
    [UIImagePNGRepresentation(image) writeToFile:path atomically:YES];
}
//校验图片是否为有效的PNG图片
-(BOOL)isValidPNGByImageUrl:(NSString*)url
{
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    UIImage* image = [UIImage imageWithData:imageData];
    //第一种情况：通过[UIImage imageWithData:data];直接生成图片时，如果image为nil，那么imageData一定是无效的
    if (image == nil && imageData != nil)
    {
        return NO;
    }
    //第二种情况：图片有部分是OK的，但是有部分坏掉了，它将通过第一步校验，那么就要用下面这个方法了。将图片转换成PNG的数据，如果PNG数据能正确生成，那么这个图片就是完整OK的，如果不能，那么说明图片有损坏
    if (UIImagePNGRepresentation(image) == nil)
    {
        return NO;
    }else
    {
        return YES;
    }
    return YES;
}
#pragma mark- 线程相关
//获取限程
-(dispatch_queue_t)runOnIOThread
{
    if(!myIOQueue)
    {
        myIOQueue = dispatch_queue_create("myIOQueue", nil);
    }
    return myIOQueue;
}
//自动释放池
-(void)withAutoPool:(dispatch_block_t)myblock
{
    myblock();
}
//自动释放-
-(dispatch_block_t) BlockWithAutoreleasePool:(dispatch_block_t)block
{
    return [^{
        [self withAutoPool:block];
    } copy];
}
#pragma mark 单例模式
+ (id)sharedManager
{
    @synchronized(self)
    {
        if(sharedCashManager == nil)
            sharedCashManager = [[super allocWithZone:NULL] init];
    }
    return sharedCashManager;
}
+ (id)allocWithZone:(NSZone *)zone
{
    return [self sharedManager];
}
- (id)copyWithZone:(NSZone *)zone
{
    return self;
}
- (id)init
{
    if (self = [super init])
    {
        
    }
    return self;
}
@end
