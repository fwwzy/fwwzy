//
//  MJPhoto.m
//
//  Created by mj on 13-3-4.
//  Copyright (c) 2013年 itcast. All rights reserved.

#import <QuartzCore/QuartzCore.h>
#import "MJPhoto.h"

@implementation MJPhoto

#pragma mark 截图
- (UIImage *)capture:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, YES, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

- (void)setSrcImageView:(UIImageView *)srcImageView
{
    if (srcImageView) {
        _srcImageView = srcImageView;
        _placeholder = srcImageView.image;
        if (srcImageView.clipsToBounds) {
            _capture = [self capture:srcImageView];
        }
    }else
    {
        UIImageView *myImgView = [[UIImageView alloc]init];
        myImgView.frame = CGRectMake(0, 0, UI_View_Width, UI_View_Height);
        
        _srcImageView = myImgView;
        _placeholder = myImgView.image;
        if (myImgView.clipsToBounds) {
            _capture = [self capture:myImgView];
        }
    }
    
}

@end