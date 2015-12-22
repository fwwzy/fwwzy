//
//  RPhotoBeautyHomeVC.m
//  Hema
//
//  Created by geyang on 15/11/17.
//  Copyright © 2015年 Hemaapp. All rights reserved.
//

#import "RPhotoBeautyHomeVC.h"
#import "CMPopTipView.h"
#import "FXLabel.h"
#import "CTAssetsPickerController.h"
#import "RPhotoBeautyEditVC.h"

@interface RPhotoBeautyHomeVC ()<CTAssetsPickerControllerDelegate>
@property(nonatomic,strong)HemaButton *meituBtn;///<选取图片按钮
@property(nonatomic,strong)CMPopTipView *popTipView;///<提示框
@end

@implementation RPhotoBeautyHomeVC

-(void)loadSet
{
    [self.navigationItem setNewTitle:@"美图"];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"R美图背景.png"]];
    
    //按钮
    _meituBtn = [HemaButton buttonWithType:UIButtonTypeCustom];
    [_meituBtn setImage:[UIImage imageNamed:@"R照片特效点击.png"] forState:UIControlStateNormal];
    [_meituBtn setFrame:CGRectMake((UI_View_Width-_meituBtn.currentImage.size.width)/2, (UI_View_Height-_meituBtn.currentImage.size.height)/2-50, _meituBtn.currentImage.size.width, _meituBtn.currentImage.size.height)];
    [_meituBtn addTarget:self action:@selector(meituPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_meituBtn];
    
    //提示框
    _popTipView = [[CMPopTipView alloc] initWithMessage:@"请点击我"];
    _popTipView.textColor = [UIColor randomColor];
    _popTipView.backgroundColor = [UIColor randomColor];
    _popTipView.preferredPointDirection = PointDirectionDown;
    _popTipView.animation = arc4random() % 2;
    _popTipView.has3DStyle = FALSE;
    _popTipView.dismissTapAnywhere = YES;
    [_popTipView autoDismissAnimated:YES atTimeInterval:3.0];
    [_popTipView presentPointingAtView:_meituBtn inView:self.view animated:YES];
    
    //标题
    FXLabel *label = [[FXLabel alloc]init];
    [label setFrame:CGRectMake(10, _meituBtn.bottom, UI_View_Width-20, _meituBtn.currentImage.size.height)];
    label.adjustsFontSizeToFitWidth = YES;
    label.font = [UIFont boldSystemFontOfSize:40];
    label.shadowColor = BB_Blake_Color;
    label.shadowOffset = CGSizeMake(0, 2);
    label.textAlignment = NSTextAlignmentCenter;
    label.shadowBlur = 10;
    label.innerShadowBlur = 4;
    label.innerShadowColor = BB_Red_Color;
    label.innerShadowOffset = CGSizeMake(0, 1);
    label.gradientStartColor = BB_Blue_Color;
    label.gradientEndColor = BB_Gray_Color;
    label.gradientStartPoint = CGPointMake(0, 0.5);
    label.gradientEndPoint = CGPointMake(1, 0.5);
    label.oversampling = 2;
    label.text = @"图片特效";
    [self.view addSubview:label];
}
#pragma mark- 自定义
#pragma mark 事件
-(void)meituPressed:(id)sender
{
    CTAssetsPickerController *picker = [[CTAssetsPickerController alloc] init];
    picker.maximumNumberOfSelection = 5;
    picker.assetsFilter = [ALAssetsFilter allPhotos];
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:NULL];
}
#pragma mark - AssetsPicker Delegate
- (void)assetsPickerController:(CTAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets
{
    NSMutableArray *dataImg = [[NSMutableArray alloc]init];
    for (int i = 0; i<assets.count; i++)
    {
        ALAssetRepresentation *assetRep = [[assets objectAtIndex:i] defaultRepresentation];
        CGImageRef imgRef = [assetRep fullResolutionImage];
        UIImage *orgImage = [UIImage imageWithCGImage:imgRef
                                                scale:assetRep.scale
                                          orientation:(UIImageOrientation)assetRep.orientation];
        UIImage *image = orgImage;
        image = [HemaFunction getImage:image];
        [dataImg addObject:image];
    }
    if (dataImg.count == 0)
    {
        [UIWindow showToastMessage:@"麻烦这位好汉选择下图片吧~"];
    }else
    {
        RPhotoBeautyEditVC *myVC = [[RPhotoBeautyEditVC alloc]init];
        myVC.dataImg = dataImg;
        myVC.assets = [[NSMutableArray alloc]init];
        for (id subAsset in assets)
        {
            [myVC.assets addObject:subAsset];
        }
        [self.navigationController pushViewController:myVC animated:YES];
    }
}
@end