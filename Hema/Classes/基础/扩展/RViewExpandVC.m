//
//  RViewExpandVC.m
//  Hema
//
//  Created by geyang on 15/11/13.
//  Copyright © 2015年 Hemaapp. All rights reserved.
//

#import "RViewExpandVC.h"

#import "UIView+ViewController.h"
#import "UIView+Visuals.h"
#import "UIView+Shake.h"
#import "UIView+Screenshot.h"
#import "UIView+GestureCallback.h"
#import "UIView+Animation.h"
#import "UIView+BFKit.h"

@interface RViewExpandVC ()
@property(nonatomic,strong)NSMutableArray *listArr;
@end

@implementation RViewExpandVC

-(void)loadSet
{
    [self forbidPullRefresh];
}
-(void)loadData
{
    _listArr = [[NSMutableArray alloc]init];
    switch (_keytype)
    {
        case 1:
            [self getDataOfView];
            break;
        case 2:
            [self getDataOfImage];
            break;
        case 3:
            [self getDataOfImageView];
            break;
        default:
            break;
    }
}
#pragma mark- 自定义
#pragma mark 方法
//UIView扩展的数据
-(void)getDataOfView
{
    for (int i = 0; i<9; i++)
    {
        NSMutableDictionary *myDic = [[NSMutableDictionary alloc]init];
        NSMutableString *myStr = [[NSMutableString alloc]initWithString:@""];
        
        if (i == 0)
        {
            [myDic setObject:@"UIView+Visuals" forKey:@"title"];
            
            [myStr appendString:@"-(void)cornerRadius: (CGFloat)radius strokeSize: (CGFloat)size color: (UIColor *)color\n"];
            [myStr appendString:@"设置边角的各种属性\n"];
            [myStr appendString:@"-(void)setRoundedCorners:(UIRectCorner)corners radius:(CGFloat)radius\n"];
            [myStr appendString:@"然后再单独设置每个边角的角度\n"];
            [myStr appendString:@"-(void)shadowWithColor: (UIColor *)color offset: (CGSize)offset opacity: (CGFloat)opacity radius: (CGFloat)radius\n"];
            [myStr appendString:@"设置阴影的颜色等属性\n"];
            [myStr appendString:@"...\n"];
            [myStr appendString:@"还有UIView的添加删除移动旋转等方法"];
        }
        if (i == 1)
        {
            [myDic setObject:@"UIView+ViewController" forKey:@"title"];
            
            [myStr appendString:@"@property (readonly) UIViewController *viewController;\n"];
            [myStr appendString:@"找到当前view所在的viewcontroler"];
        }
        if (i == 2)
        {
            [myDic setObject:@"UIView+Toast" forKey:@"title"];
            
            [myStr appendString:@"-(void)makeToast:(NSString *)message;\n"];
            [myStr appendString:@"-(void)showToast:(UIView *)toast;\n"];
            [myStr appendString:@"...\n"];
            [myStr appendString:@"各种黑色背景视图弹框"];
        }
        if (i == 3)
        {
            [myDic setObject:@"UIView+Shake" forKey:@"title"];
            
            [myStr appendString:@"-(void)shake;\n"];
            [myStr appendString:@"-(void)shake:(int)times withDelta:(CGFloat)delta;\n"];
            [myStr appendString:@"...\n"];
            [myStr appendString:@"摇晃视图"];
        }
        if (i == 4)
        {
            [myDic setObject:@"UIView+Screenshot" forKey:@"title"];
            
            [myStr appendString:@"-(UIImage *)screenshot;\n"];
            [myStr appendString:@"-(UIImage *)screenshot:(CGFloat)maxWidth;\n"];
            [myStr appendString:@"视图截图"];
        }
        if (i == 5)
        {
            [myDic setObject:@"UIView+RecursiveDescription" forKey:@"title"];
            
            [myStr appendString:@"-(NSString*)recursiveView;\n"];
            [myStr appendString:@"打印视图层级字符串"];
        }
        if (i == 6)
        {
            [myDic setObject:@"UIView+GestureCallback" forKey:@"title"];
            
            [myStr appendString:@"-(NSString*)addTapGestureRecognizer:(void(^)(UITapGestureRecognizer* recognizer, NSString* gestureId))tapCallback;\n"];
            [myStr appendString:@"-(void)removeAllTapGestures;\n"];
            [myStr appendString:@"...\n"];
            [myStr appendString:@"视图的各种手势的添加与删除"];
        }
        if (i == 7)
        {
            [myDic setObject:@"UIView+Animation" forKey:@"title"];
            
            [myStr appendString:@"-(void)moveTo:(CGPoint)destination duration:(float)secs option:(UIViewAnimationOptions)option;\n"];
            [myStr appendString:@"-(void)changeAlpha:(float)newAlpha secs:(float)secs;\n"];
            [myStr appendString:@"...\n"];
            [myStr appendString:@"视图的各种动画效果"];
        }
        if (i == 8)
        {
            [myDic setObject:@"UIView+BFKit" forKey:@"title"];
            
            [myStr appendString:@"...\n"];
            [myStr appendString:@"视图的其他扩展，请查阅BFkit文件夹"];
        }
        [myDic setObject:myStr forKey:@"content"];
        [_listArr addObject:myDic];
    }
}
//Image扩展的数据
-(void)getDataOfImage
{
    for (int i = 0; i<7; i++)
    {
        NSMutableDictionary *myDic = [[NSMutableDictionary alloc]init];
        NSMutableString *myStr = [[NSMutableString alloc]initWithString:@""];
        
        if (i == 0)
        {
            [myDic setObject:@"UIImage+Alpha" forKey:@"title"];
            
            [myStr appendString:@"图片的透明度、添加透明边框、判断是否透明、裁切透明图片"];
        }
        if (i == 1)
        {
            [myDic setObject:@"UIImage+animatedGIF" forKey:@"title"];
            
            [myStr appendString:@"+(UIImage *)animatedImageWithAnimatedGIFData:(NSData *)theData;\n"];
            [myStr appendString:@"+(UIImage *)animatedImageWithAnimatedGIFURL:(NSURL *)theURL;\n"];
            [myStr appendString:@"Gif动画展示，或者用UIImage+GIF"];
        }
        if (i == 2)
        {
            [myDic setObject:@"UIImage+Color" forKey:@"title"];
            
            [myStr appendString:@"+(UIImage *)imageWithColor:(UIColor *)color;\n"];
            [myStr appendString:@"-(UIColor *)colorAtPoint:(CGPoint )point;\n"];
            [myStr appendString:@"...\n"];
            [myStr appendString:@"图片与颜色之间的转换"];
        }
        if (i == 3)
        {
            [myDic setObject:@"UIImage+Merge" forKey:@"title"];
            
            [myStr appendString:@"+(UIImage*)mergeImage:(UIImage*)firstImage withImage:(UIImage*)secondImage;\n"];
            [myStr appendString:@"合并两种图片"];
        }
        if (i == 4)
        {
            [myDic setObject:@"UIImage+Orientation" forKey:@"title"];
            
            [myStr appendString:@"-(UIImage *)imageRotatedByDegrees:(CGFloat)degrees;\n"];
            [myStr appendString:@"...\n"];
            [myStr appendString:@"图片与旋转之间的转换"];
        }
        if (i == 5)
        {
            [myDic setObject:@"UIImage+ImageEffects" forKey:@"title"];
            
            [myStr appendString:@"-(UIImage *)applyTintEffectWithColor:(UIColor *)tintColor;\n"];
            [myStr appendString:@"...\n"];
            [myStr appendString:@"图片的模糊效果"];
        }
        if (i == 6)
        {
            [myDic setObject:@"UIImage+CropRotate" forKey:@"title"];
            
            [myStr appendString:@"-(UIImage *)croppedImageWithFrame:(CGRect)frame angle:(NSInteger)angle;\n"];
            [myStr appendString:@"裁切图片"];
        }
        [myDic setObject:myStr forKey:@"content"];
        [_listArr addObject:myDic];
    }
}
//ImageView扩展的数据
-(void)getDataOfImageView
{
    for (int i = 0; i<5; i++)
    {
        NSMutableDictionary *myDic = [[NSMutableDictionary alloc]init];
        NSMutableString *myStr = [[NSMutableString alloc]initWithString:@""];
        
        if (i == 0)
        {
            [myDic setObject:@"UIImageView+Addition" forKey:@"title"];
            
            [myStr appendString:@"+(id)imageViewWithImageArray:(NSArray*)imageArray duration:(NSTimeInterval)duration;\n"];
            [myStr appendString:@"...\n"];
            [myStr appendString:@"几种创建UIImageView的方法"];
        }
        if (i == 1)
        {
            [myDic setObject:@"UIImageView+Letters" forKey:@"title"];
            
            [myStr appendString:@"-(void)setImageWithString:(NSString *)string;\n"];
            [myStr appendString:@"-(void)setImageWithString:(NSString *)string color:(UIColor *)color;\n"];
            [myStr appendString:@"...\n"];
            [myStr appendString:@"根据文字或者颜色等创建UIImageView"];
        }
        if (i == 2)
        {
            [myDic setObject:@"UIImageView+Reflect" forKey:@"title"];
            
            [myStr appendString:@"-(void)reflect;\n"];
            [myStr appendString:@"给UIImageView添加倒影"];
        }
        if (i == 3)
        {
            [myDic setObject:@"UIImageView+Badge" forKey:@"title"];
            
            [myStr appendString:@"-(void)setBadgeNumber:(int)badgenumber;\n"];
            [myStr appendString:@"-(void)setBadgeImage:(UIImage *)image;\n"];
            [myStr appendString:@"UIImageView的角标"];
        }
        if (i == 4)
        {
            [myDic setObject:@"UIImageView+MJWebCache" forKey:@"title"];
            
            [myStr appendString:@"缓存图片，已进行封装，不直接调用"];
        }
        [myDic setObject:myStr forKey:@"content"];
        [_listArr addObject:myDic];
    }
}
#pragma mark- TableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _listArr.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"all";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.backgroundColor = BB_White_Color;
        
        //左侧
        UILabel *labLeft = [[UILabel alloc]init];
        labLeft.backgroundColor = [UIColor clearColor];
        labLeft.textAlignment = NSTextAlignmentLeft;
        labLeft.font = [UIFont systemFontOfSize:13];
        labLeft.tag = 10;
        labLeft.numberOfLines = 0;
        labLeft.textColor = BB_Blake_Color;
        [cell.contentView addSubview:labLeft];
    }
    UILabel *labLeft = (UILabel*)[cell viewWithTag:10];
    
    NSString *myStr = [_listArr[indexPath.section]objectForKey:@"content"];
    
    CGSize mySize = [HemaFunction getSizeWithStrNo:myStr width:UI_View_Width-20 font:13];
    [labLeft setFrame:CGRectMake(10, 10, UI_View_Width-20, mySize.height)];
    [labLeft setText:myStr];
    
    //设置样式
    [labLeft shadowWithColor:BB_Gray_Color offset:CGSizeMake(-1, -1) opacity:1 radius:2];
    
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = [[UIView alloc]init];
    headView.backgroundColor = BB_Blue_Color;
    
    UILabel *labLeft = [[UILabel alloc]init];
    labLeft.backgroundColor = [UIColor clearColor];
    labLeft.textAlignment = NSTextAlignmentLeft;
    labLeft.font = [UIFont systemFontOfSize:15];
    labLeft.tag = 10;
    labLeft.frame = CGRectMake(10, 0, UI_View_Width-50, 44);
    labLeft.textColor = BB_White_Color;
    labLeft.text = [[_listArr objectAtIndex:section] objectForKey:@"title"];
    [headView addSubview:labLeft];
    
    [labLeft shadowWithColor:BB_Red_Color offset:CGSizeMake(1, 1) opacity:0.5 radius:1];
    
    return headView;
}
#pragma mark- TableView delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableString *myStr = [_listArr[indexPath.section]objectForKey:@"content"];
    
    CGSize mySize = [HemaFunction getSizeWithStrNo:myStr width:UI_View_Width-20 font:13];
    return 20+mySize.height;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *) indexPath
{
    
}
@end
