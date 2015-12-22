//
//  RPhotoBeautyShareVC.m
//  Hema
//
//  Created by geyang on 15/11/18.
//  Copyright © 2015年 Hemaapp. All rights reserved.
//

typedef NS_ENUM(NSUInteger, CLBlurType)
{
    kCLBlurTypeNormal = 0,
    kCLBlurTypeCircle,
    kCLBlurTypeBand,
    KCLSpotLight,
};//渲染的效果样式

#import "RPhotoBeautyShareVC.h"
#import "QHBannerMenuView.h"
#import "CLBlurBand.h"
#import "CLBlurCircle.h"
#import "CLSpotCircle.h"
#import "FXLabel.h"
#import "UIImage+Utility.h"
#import "MarqueeLabel.h"
#import "JGActionSheet.h"

@interface RPhotoBeautyShareVC ()<QHBannerMenuViewDelegate>
{
    CLBlurType blurType;//模糊类型
    
    //模糊效果需要的三个属性
    CGFloat _X;
    CGFloat _Y;
    CGFloat _R;
    
    CGRect bandImageRect;//方形模糊的位置
}
@property(nonatomic,strong)QHBannerMenuView *bannerMenuView;///<底部菜单
@property(nonatomic,strong)UIScrollView *contentView;///<中间的内容
@property(nonatomic,strong)UIImageView *sharedImageView;///<中间的图片
@property(nonatomic,strong)NSArray *bannerMenu;///<菜单数组

@property(nonatomic,strong)CLBlurCircle *circleView;///<圆形模糊
@property(nonatomic,strong)CLBlurBand *bandView;///<方形模糊
@property(nonatomic,strong)CLSpotCircle *spotLightView;///<聚光灯
@property(nonatomic,strong)UIImage *blurImage;///<模糊的图片
@end

@implementation RPhotoBeautyShareVC

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    LCPanNavigationController *nav = (LCPanNavigationController*)self.navigationController;
    [nav.panGestureRecognizer setEnabled:NO];
}
-(void)viewWillDisappear:(BOOL)animated
{
    LCPanNavigationController *nav = (LCPanNavigationController*)self.navigationController;
    [nav.panGestureRecognizer setEnabled:YES];
    [super viewWillDisappear:animated];
}
-(void)loadSet
{
    [self.navigationItem setNewTitle:@"预览"];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"R美图背景.png"]];
    [self.navigationItem setRightItemWithTarget:self action:@selector(rightbtnPressed:) title:@"导出"];
    
    [self initContent];
    [self performSelector:@selector(initBlur) withObject:nil afterDelay:0.5];
}
//创建中间
-(void)initContent
{
    _contentView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, UI_View_Width, UI_View_Height)];
    [self.view addSubview:_contentView];
    
    CGRect rect = CGRectZero;
    rect.origin.x = 0;
    rect.origin.y = 0;
    UIImage *image = _image;
    CGFloat height = image.size.height;
    CGFloat width = image.size.width;
    if (width > _contentView.width)
    {
        rect.size.width = _contentView.width;
        rect.size.height = height*(_contentView.frame.size.width /width);
    }else
    {
        rect.size.width = width;
        rect.size.height = height;
    }
    rect.origin.x = (_contentView.width - rect.size.width)/2.0f;
    if (rect.size.height < _contentView.frame.size.height)
    {
        rect.origin.y = (_contentView.height - rect.size.height)/2.0f;
    }
    
    _contentView.contentSize = CGSizeMake(_contentView.width, rect.size.height);
    
    _sharedImageView = [[UIImageView alloc] initWithFrame:rect];
    _sharedImageView.image = image;
    _sharedImageView.clipsToBounds = YES;
    [_contentView addSubview:_sharedImageView];
    
    [self initBannerMenu];
    [self initTextEditTip];
}
//创建菜单
- (void)initBannerMenu
{
    _bannerMenu = @[@"原图", @"聚光灯", @"圆形模糊", @"方形模糊"];
    
    _bannerMenuView = [[QHBannerMenuView alloc] initWithFrame:CGRectMake(0, UI_View_Height - 60, 60, 60) menuWidth:UI_View_Width-70 delegate:self];
    [self.view addSubview:_bannerMenuView];
}
//创建模糊
- (void)initBlur
{
    blurType = kCLBlurTypeNormal;
    _blurImage = [_image gaussBlur:1.0];
    
    _X = 0.5;
    _Y = 0.5;
    _R = 0.5;
    
    [self setHandlerView];
    [self setDefaultParams];
}
//提示语
- (void)initTextEditTip
{
    MarqueeLabel *label = [[MarqueeLabel alloc] initWithFrame:CGRectMake(0, 0, UI_View_Width, 20)];
    label.text = @"图形特效: 1. 聚光灯; 2. 圆形背景模糊; 3. 线形背景模糊; 4. 支持点击、移动、放大/缩小、旋转等操作.";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:16];
    label.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    label.marqueeType = MLContinuous;
    label.scrollDuration = 10.0f;
    label.fadeLength = 0.0f;
    label.rate = 30.0f;
    
    label.layer.cornerRadius = 5;
    label.layer.borderColor = [UIColor grayColor].CGColor;
    label.layer.borderWidth = 1;
    [self.view addSubview:label];
}
#pragma mark- 自定义
#pragma mark 事件
//导出
-(void)rightbtnPressed:(id)sender
{
    JGActionSheetSection *sectionExport = [JGActionSheetSection sectionWithTitle:@"导出" message:nil buttonTitles:@[@"保存"] buttonStyle:JGActionSheetButtonStyleDefault];
    JGActionSheetSection *sectionShare = [JGActionSheetSection sectionWithTitle:@"分享" message:nil buttonTitles:@[@"朋友圈",@"微信好友",@"其他"] buttonStyle:JGActionSheetButtonStyleDefault];
    JGActionSheetSection *sectionCancle = [JGActionSheetSection sectionWithTitle:nil message:nil buttonTitles:@[@"取消"] buttonStyle:JGActionSheetButtonStyleCancel];
    
    NSArray *sections = @[sectionExport, sectionShare, sectionCancle];
    JGActionSheet *sheet = [[JGActionSheet alloc] initWithSections:sections];
    [sheet setButtonPressedBlock:^(JGActionSheet *sheet, NSIndexPath *indexPath)
     {
         if (indexPath.section == 0)
         {
             if (indexPath.row == 0)
             {
                 [self saveTapHandler];
             }
         }
         if (indexPath.section == 1)
         {
             if (indexPath.row == 0||indexPath.row == 1)
             {
                 [UIWindow showToastMessage:@"暂时不给你分享，爱咋咋地！"];
             }
             if (indexPath.row == 2)
             {
                 [self sharePhotoByOthers];
             }
         }
         [sheet dismissAnimated:YES];
     }];
    [sheet setOutsidePressBlock:^(JGActionSheet *sheet)
     {
         [sheet dismissAnimated:YES];
     }];
    [sheet showInView:self.navigationController.view animated:YES];
}
//各种手势
- (void)tapHandlerView:(UITapGestureRecognizer*)sender
{
    switch (blurType)
    {
        case kCLBlurTypeCircle:
        {
            CGPoint point = [sender locationInView:_contentView];
            _circleView.center = point;
            [self buildThumnailImage];
            
            break;
        }
        case kCLBlurTypeBand:
        {
            CGPoint point = [sender locationInView:_contentView];
            point = CGPointMake(point.x-_contentView.width/2, point.y-_contentView.height/2);
            point = CGPointMake(point.x*cos(-_bandView.rotation)-point.y*sin(-_bandView.rotation), point.x*sin(-_bandView.rotation)+point.y*cos(-_bandView.rotation));
            _bandView.offset = point.y;
            [self buildThumnailImage];
            
            break;
        }
        case KCLSpotLight:
        {
            CGPoint point = [sender locationInView:_contentView];
            _spotLightView.center = point;
            [self buildThumnailImage];
            
            break;
        }
        default:
            break;
    }
}
- (void)panHandlerView:(UIPanGestureRecognizer*)sender
{
    switch (blurType)
    {
        case kCLBlurTypeCircle:
        {
            CGPoint point = [sender locationInView:_contentView];
            _circleView.center = point;
            [self buildThumnailImage];
            
            break;
        }
        case kCLBlurTypeBand:
        {
            CGPoint point = [sender locationInView:_contentView];
            point = CGPointMake(point.x-_contentView.width/2, point.y-_contentView.height/2);
            point = CGPointMake(point.x*cos(-_bandView.rotation)-point.y*sin(-_bandView.rotation), point.x*sin(-_bandView.rotation)+point.y*cos(-_bandView.rotation));
            _bandView.offset = point.y;
            [self buildThumnailImage];
            
            break;
        }
        case KCLSpotLight:
        {
            CGPoint point = [sender locationInView:_contentView];
            _spotLightView.center = point;
            [self buildThumnailImage];
            
            break;
        }
        default:
            break;
    }
}
- (void)pinchHandlerView:(UIPinchGestureRecognizer*)sender
{
    switch (blurType)
    {
        case kCLBlurTypeCircle:
        {
            static CGRect initialFrame;
            if (sender.state == UIGestureRecognizerStateBegan)
            {
                initialFrame = _circleView.frame;
            }
            
            CGFloat scale = sender.scale;
            CGRect rct;
            rct.size.width  = MAX(MIN(initialFrame.size.width*scale, 3*MAX(_contentView.width, _contentView.height)), 0.3*MIN(_contentView.width, _contentView.height));
            rct.size.height = rct.size.width;
            rct.origin.x = initialFrame.origin.x + (initialFrame.size.width-rct.size.width)/2;
            rct.origin.y = initialFrame.origin.y + (initialFrame.size.height-rct.size.height)/2;
            
            _circleView.frame = rct;
            [self buildThumnailImage];
            
            break;
        }
        case kCLBlurTypeBand:
        {
            static CGFloat initialScale;
            if (sender.state == UIGestureRecognizerStateBegan)
            {
                initialScale = _bandView.scale;
            }
            
            _bandView.scale = MIN(2, MAX(0.2, initialScale * sender.scale));
            [self buildThumnailImage];
            
            break;
        }
        case KCLSpotLight:
        {
            static CGRect initialFrame;
            if (sender.state == UIGestureRecognizerStateBegan)
            {
                initialFrame = _spotLightView.frame;
            }
            
            CGFloat scale = sender.scale;
            CGRect rct;
            rct.size.width  = MAX(MIN(initialFrame.size.width*scale, 3*MAX(_contentView.width, _contentView.height)), 0.3*MIN(_contentView.width, _contentView.height));
            rct.size.height = rct.size.width;
            rct.origin.x = initialFrame.origin.x + (initialFrame.size.width-rct.size.width)/2;
            rct.origin.y = initialFrame.origin.y + (initialFrame.size.height-rct.size.height)/2;
            _spotLightView.frame = rct;
            
            [self buildThumnailImage];
            
            break;
        }
        default:
            break;
    }
}
- (void)rotateHandlerView:(UIRotationGestureRecognizer*)sender
{
    switch (blurType)
    {
        case kCLBlurTypeBand:
        {
            static CGFloat initialRotation;
            if (sender.state == UIGestureRecognizerStateBegan)
            {
                initialRotation = _bandView.rotation;
            }
            _bandView.rotation = MIN(M_PI/2, MAX(-M_PI/2, initialRotation + sender.rotation));
            [self buildThumnailImage];
            break;
        }
        default:
            break;
    }
}
#pragma mark 方法
//设置手势
- (void)setHandlerView
{
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandlerView:)];
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panHandlerView:)];
    UIPinchGestureRecognizer *pinch    = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchHandlerView:)];
    UIRotationGestureRecognizer *rotate   = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotateHandlerView:)];
    
    panGesture.maximumNumberOfTouches = 1;
    tapGesture.delegate = self;
    panGesture.delegate = self;
    pinch.delegate = self;
    rotate.delegate = self;
    
    [_contentView addGestureRecognizer:tapGesture];
    [_contentView addGestureRecognizer:panGesture];
    [_contentView addGestureRecognizer:pinch];
    [_contentView addGestureRecognizer:rotate];
}
//设置默认属性
- (void)setDefaultParams
{
    CGFloat W = 1.5*MIN(_contentView.width, _contentView.height);
    _circleView = [[CLBlurCircle alloc] initWithFrame:CGRectMake(_contentView.width/2-W/2, _contentView.height/2-W/2, W, W)];
    _circleView.backgroundColor = [UIColor clearColor];
    _circleView.color = [UIColor redColor];
    
    CGFloat H = _contentView.height;
    CGFloat R = sqrt((_contentView.width*_contentView.width) + (_contentView.height*_contentView.height));
    _bandView = [[CLBlurBand alloc] initWithFrame:CGRectMake(0, 0, R, H)];
    _bandView.center = CGPointMake(_contentView.width/2, _contentView.height/2);
    _bandView.backgroundColor = [UIColor clearColor];
    _bandView.color = [UIColor redColor];
    
    CGFloat ratio = _image.size.width / _contentView.width;
    bandImageRect = _bandView.frame;
    bandImageRect.size.width  *= ratio;
    bandImageRect.size.height *= ratio;
    bandImageRect.origin.x *= ratio;
    bandImageRect.origin.y *= ratio;
    
    _spotLightView = [[CLSpotCircle alloc] initWithFrame:CGRectMake(_contentView.width/2-W/2, _contentView.height/2-W/2, W, W)];
    _spotLightView.backgroundColor = [UIColor clearColor];
    _spotLightView.color = [UIColor redColor];
}
//生成模糊小图片效果
- (void)buildThumnailImage
{
    static BOOL inProgress = NO;
    if(inProgress)
    {
        return;
    }
    inProgress = YES;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (blurType == KCLSpotLight)
        {
            UIImage *image = [self spotLightImage:_image];
            [_sharedImageView performSelectorOnMainThread:@selector(setImage:) withObject:image waitUntilDone:NO];
        }
        else
        {
            UIImage *image = [self buildResultImage:_image withBlurImage:_blurImage];
            [_sharedImageView performSelectorOnMainThread:@selector(setImage:) withObject:image waitUntilDone:NO];
        }
        
        [_sharedImageView setNeedsDisplay];
        inProgress = NO;
    });
}
//从原图生成聚光灯效果的小图片
- (UIImage*)spotLightImage:(UIImage*)image
{
    CGFloat ratio = image.size.width / _contentView.width;
    CGRect frame  = _spotLightView.frame;
    frame.size.width  *= ratio;
    frame.size.height *= ratio;
    frame.origin.x *= ratio;
    frame.origin.y *= ratio;
    
    UIImage *mask = [UIImage imageNamed:@"R白色聚光灯效果.png"];
    UIGraphicsBeginImageContext(image.size);
    {
        CGContextSetFillColorWithColor(UIGraphicsGetCurrentContext(), [[UIColor whiteColor] CGColor]);
        CGContextFillRect(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, image.size.width, image.size.height));
        [mask drawInRect:frame];
        mask = UIGraphicsGetImageFromCurrentImageContext();
    }
    UIGraphicsEndImageContext();
    
    UIImage *tmp = [image maskedImage:mask];
    UIGraphicsBeginImageContext(image.size);
    {
        CGContextSetFillColorWithColor(UIGraphicsGetCurrentContext(), [[UIColor blackColor] CGColor]);
        CGContextFillRect(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, image.size.width, image.size.height));
        [tmp drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
        tmp = UIGraphicsGetImageFromCurrentImageContext();
    }
    UIGraphicsEndImageContext();
    return tmp;
}
//各种模糊继续生成
- (UIImage*)buildResultImage:(UIImage*)image withBlurImage:(UIImage*)blurImage
{
    UIImage *result = blurImage;
    switch (blurType)
    {
        case kCLBlurTypeCircle:
        {
            result = [self circleBlurImage:image withBlurImage:blurImage];
            break;
        }
        case kCLBlurTypeBand:
        {
            result = [self bandBlurImage:image withBlurImage:blurImage];
            break;
        }
        case KCLSpotLight:
        {
            result = [self spotLightImage:image];
            break;
        }
        default:
            break;
    }
    return result;
}
- (UIImage*)circleBlurImage:(UIImage*)image withBlurImage:(UIImage*)blurImage
{
    CGFloat ratio = image.size.width / _contentView.width;
    CGRect frame  = _circleView.frame;
    frame.size.width  *= ratio;
    frame.size.height *= ratio;
    frame.origin.x *= ratio;
    frame.origin.y *= ratio;
    
    UIImage *mask = [UIImage imageNamed:@"R黑色聚光灯效果.png"];
    UIGraphicsBeginImageContext(image.size);
    {
        CGContextSetFillColorWithColor(UIGraphicsGetCurrentContext(), [[UIColor whiteColor] CGColor]);
        CGContextFillRect(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, image.size.width, image.size.height));
        [mask drawInRect:frame];
        mask = UIGraphicsGetImageFromCurrentImageContext();
    }
    UIGraphicsEndImageContext();
    
    return [self blurImage:image withBlurImage:blurImage andMask:mask];
}
- (UIImage*)bandBlurImage:(UIImage*)image withBlurImage:(UIImage*)blurImage
{
    UIImage *mask = [UIImage imageNamed:@"R黑色方形效果.png"];
    UIGraphicsBeginImageContext(image.size);
    {
        CGContextRef context =  UIGraphicsGetCurrentContext();
        
        CGContextSetFillColorWithColor(context, [[UIColor whiteColor] CGColor]);
        CGContextFillRect(context, CGRectMake(0, 0, image.size.width, image.size.height));
        
        CGContextSaveGState(context);
        CGFloat ratio = image.size.width / _image.size.width;
        CGFloat Tx = (bandImageRect.size.width/2  + bandImageRect.origin.x)*ratio;
        CGFloat Ty = (bandImageRect.size.height/2 + bandImageRect.origin.y)*ratio;
        
        CGContextTranslateCTM(context, Tx, Ty);
        CGContextRotateCTM(context, _bandView.rotation);
        CGContextTranslateCTM(context, 0, _bandView.offset*image.size.width/_contentView.width);
        CGContextScaleCTM(context, 1, _bandView.scale);
        CGContextTranslateCTM(context, -Tx, -Ty);
        
        CGRect rct = bandImageRect;
        rct.size.width  *= ratio;
        rct.size.height *= ratio;
        rct.origin.x    *= ratio;
        rct.origin.y    *= ratio;
        
        [mask drawInRect:rct];
        
        CGContextRestoreGState(context);
        
        mask = UIGraphicsGetImageFromCurrentImageContext();
    }
    UIGraphicsEndImageContext();
    
    return [self blurImage:image withBlurImage:blurImage andMask:mask];
}
//最终生成
- (UIImage*)blurImage:(UIImage*)image withBlurImage:(UIImage*)blurImage andMask:(UIImage*)maskImage
{
    UIImage *tmp = [image maskedImage:maskImage];
    UIGraphicsBeginImageContext(image.size);
    {
        [blurImage drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
        [tmp drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
        tmp = UIGraphicsGetImageFromCurrentImageContext();
    }
    UIGraphicsEndImageContext();
    
    return tmp;
}
//根据size生成新的图片
-(UIImage *)scaleFromImage:(UIImage *)image toSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}
//保存图片
- (void)saveTapHandler
{
    if (blurType != kCLBlurTypeNormal)
    {
        UIImage *image = [self buildResultImage:_image withBlurImage:_blurImage];
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(imageSavedToPhotosAlbum: didFinishSavingWithError: contextInfo:), nil);
    }else
    {
        UIImageWriteToSavedPhotosAlbum(_image, self, @selector(imageSavedToPhotosAlbum: didFinishSavingWithError: contextInfo:), nil);
    }
}
//其他分享
- (void)sharePhotoByOthers
{
    NSString *title = @"HemaDemo真是好呀！好啥呀好！";
    UIImage *imageScale = [self scaleFromImage:_image toSize:CGSizeMake(128, 128)];
    NSData *dataForJPEGFile = UIImageJPEGRepresentation(imageScale, 0.9);
    UIImage *image = [UIImage imageWithData: dataForJPEGFile];
    NSURL *URL = [NSURL URLWithString:@"http://www.baidu.com"];
    NSArray *activityItems = [[NSArray alloc] initWithObjects:title, image, URL, nil];
    
    UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    activityController.excludedActivityTypes = @[UIActivityTypeAssignToContact, UIActivityTypeMessage];
    [self presentViewController:activityController animated:YES completion:nil];
    
    if ([activityController respondsToSelector:@selector(popoverPresentationController)])
    {
        UIPopoverPresentationController *presentationController = [activityController popoverPresentationController];
        presentationController.sourceView = self.view;
    }
}
#pragma mark - SavePhotoAlbumDelegate
- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *) contextInfo
{
    if (!error)
    {
        [UIWindow showToastMessage:@"庆祝吧，已保存成功！"];
    }else
    {
        [UIWindow showToastMessage:@"很遗憾，保存已失败！"];
    }
}
#pragma mark- UIGestureRecognizerDelegate
- (BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}
#pragma mark- QHBannerMenuViewDelegate
- (NSInteger)bannerMenuView:(QHBannerMenuView *)bannerMenuView
{
    return _bannerMenu.count;
}
- (UIView *)bannerMenuView:(QHBannerMenuView *)bannerMenuView menuForRowAtIndexPath:(NSUInteger)index
{
    NSString *title = [_bannerMenu objectAtIndex:index];
    FXLabel *label  = [[FXLabel alloc] init];
    label.text = title;
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.shadowColor = [UIColor whiteColor];
    label.shadowOffset = CGSizeMake(0, 2);
    label.shadowBlur = 5;
    label.textColor = [UIColor brownColor];
    label.font = [UIFont systemFontOfSize:15];
    [label setAdjustsFontSizeToFitWidth:YES];
    
    return label;
}
- (void)bannerMenuView:(QHBannerMenuView *)bannerMenuView didSelectRowAtIndexPath:(NSUInteger)index
{
    [_circleView removeFromSuperview];
    [_bandView removeFromSuperview];
    [_spotLightView removeFromSuperview];
    
    if (index == 1)
    {
        blurType = KCLSpotLight;
        [_sharedImageView addSubview:_spotLightView];
        [_spotLightView setNeedsDisplay];
        
        UIImage *image = [self spotLightImage:_image];
        [_sharedImageView performSelectorOnMainThread:@selector(setImage:) withObject:image waitUntilDone:NO];
    }else if (index == 2)
    {
        blurType = kCLBlurTypeCircle;
        [_sharedImageView addSubview:_circleView];
        [_circleView setNeedsDisplay];
        
        UIImage *image = [self buildResultImage:_image withBlurImage:_blurImage];
        [_sharedImageView performSelectorOnMainThread:@selector(setImage:) withObject:image waitUntilDone:NO];
    }else if (index == 3)
    {
        blurType = kCLBlurTypeBand;
        [_sharedImageView addSubview:_bandView];
        [_bandView setNeedsDisplay];
        
        UIImage *image = [self buildResultImage:_image withBlurImage:_blurImage];
        [_sharedImageView performSelectorOnMainThread:@selector(setImage:) withObject:image waitUntilDone:NO];
    }else
    {
        blurType = kCLBlurTypeNormal;
        _sharedImageView.image = _image;
    }
}
@end
