//
//  MJPhotoToolbar.m
//  FingerNews
//
//  Created by mj on 13-9-24.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "MJPhotoToolbar.h"
#import "MJPhoto.h"
#import "MBProgressHUD+Add.h"

#import "HemaConst.h"
#import "HemaButton.h"

#import "MJPhotoBrowser.h"
#import "MJPhotoView.h"

@interface MJPhotoToolbar()
{
    // 显示页码
    UILabel *_indexLabel;
    UIButton *_saveImageBtn;
    UIView *_downView;
    UIImageView *_downBackImg;
    UIImageView *_downImg;
    UILabel *_downName;
    UILabel *_downTime;
    HemaButton *_downBtn;
}
@end

@implementation MJPhotoToolbar
@synthesize isPhotos;
@synthesize lastVC;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setPhotos:(NSArray *)photos
{
    _photos = photos;
    
    if (_photos.count > 1) {
        _indexLabel = [[UILabel alloc] init];
        _indexLabel.font = [UIFont boldSystemFontOfSize:20];
        _indexLabel.frame = self.bounds;
        _indexLabel.backgroundColor = [UIColor clearColor];
        _indexLabel.textColor = [UIColor whiteColor];
        _indexLabel.textAlignment = NSTextAlignmentCenter;
        _indexLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [self addSubview:_indexLabel];
    }
    
    //NSLog(@"我去年：%d",isPhotos);
    if (self.isPhotos == YES)
    {
        [_indexLabel setHidden:YES];
        
        //自定义view
        _downView = [[UIView alloc]init];
        [_downView setFrame:CGRectMake(0, 0, UI_View_Width, 100)];
        [_downView setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_downView];
        
        _downBackImg = [[UIImageView alloc]init];
        [_downBackImg setFrame:CGRectMake(0, 0, UI_View_Width, 100)];
        [_downBackImg setBackgroundColor:[UIColor blackColor]];
        [_downBackImg setAlpha:0.5];
        [_downView addSubview:_downBackImg];
        
        _downImg = [[UIImageView alloc]init];
        [_downImg setFrame:CGRectMake(12, 11, 35, 35)];
        [_downView addSubview:_downImg];
        
        _downName = [[UILabel alloc] init];
        _downName.font = [UIFont boldSystemFontOfSize:13];
        _downName.frame = CGRectMake(60, 13, 200, 15);
        _downName.backgroundColor = [UIColor clearColor];
        _downName.textColor = [UIColor whiteColor];
        _downName.textAlignment = NSTextAlignmentLeft;
        [_downView addSubview:_downName];
        
        _downTime = [[UILabel alloc] init];
        _downTime.font = [UIFont systemFontOfSize:11];
        _downTime.frame = CGRectMake(60, 31, 200, 15);
        _downTime.backgroundColor = [UIColor clearColor];
        _downTime.textColor = [UIColor whiteColor];
        _downTime.textAlignment = NSTextAlignmentLeft;
        [_downView addSubview:_downTime];
        
        _downBtn = [HemaButton buttonWithType:UIButtonTypeCustom];
        [_downBtn setFrame:CGRectMake(0, 0, UI_View_Width, 58)];
        [_downBtn addTarget:self action:@selector(gotoOwner:) forControlEvents:UIControlEventTouchUpInside];
        [_downView addSubview:_downBtn];
        
        //不同软件特殊处理
        [_downImg setHidden:YES];
        [_downTime setHidden:YES];
        [_downBtn setHidden:YES];
        _downName.numberOfLines = 0;
        _downName.frame = CGRectMake(10, 0, 280, 100);
        [self setUserInteractionEnabled:NO];
    }
    
    // 保存图片按钮
    CGFloat btnWidth = self.bounds.size.height;
    _saveImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _saveImageBtn.frame = CGRectMake(UI_View_Width-70, 0, btnWidth, btnWidth);
    _saveImageBtn.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [_saveImageBtn setImage:[UIImage imageNamed:@"MJPhotoBrowser.bundle/save_icon.png"] forState:UIControlStateNormal];
    [_saveImageBtn setImage:[UIImage imageNamed:@"MJPhotoBrowser.bundle/save_icon_highlighted.png"] forState:UIControlStateHighlighted];
    [_saveImageBtn addTarget:self action:@selector(saveImage) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_saveImageBtn];
    
}
-(void)gotoOwner:(HemaButton*)sender
{
    return;
}
- (void)saveImage
{
    //NSLog(@"保存图片看看");
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        MJPhoto *photo = _photos[_currentPhotoIndex];
        UIImageWriteToSavedPhotosAlbum(photo.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    });
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error) {
        [MBProgressHUD showSuccess:@"保存失败" toView:nil];
    } else {
        MJPhoto *photo = _photos[_currentPhotoIndex];
        photo.save = YES;
        _saveImageBtn.enabled = YES;
        [MBProgressHUD showSuccess:@"成功保存到相册" toView:nil];
    }
}
- (void)setCurrentPhotoIndex:(NSUInteger)currentPhotoIndex
{
    _currentPhotoIndex = currentPhotoIndex;
    
    // 更新页码
    _indexLabel.text = [NSString stringWithFormat:@"%d / %d", (int)(_currentPhotoIndex + 1), (int)_photos.count];
    
    //MJPhoto *photo = _photos[_currentPhotoIndex];
    // 按钮
    //_saveImageBtn.enabled = photo.image != nil && !photo.save;
    _saveImageBtn.enabled = YES;
    
    //NSLog(@"数据：%@,%d",_dataSource,_currentPhotoIndex);
    if (self.isPhotos == YES)
    {
        if (![HemaFunction xfunc_check_strEmpty:[[_dataSource objectAtIndex:0] objectForKey:@"content"]])
        {
            NSString *temStr = [[_dataSource objectAtIndex:0] objectForKey:@"content"];
            [_downName setText:temStr];
        }
    }
}

@end
