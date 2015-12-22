//
//  RPhotoEditVC.m
//  Hema
//
//  Created by geyang on 15/11/4.
//  Copyright © 2015年 Hemaapp. All rights reserved.
//

#import "RPhotoEditVC.h"
#import "PECropViewController.h"
#import "UIView+CHDAnimation.h"
#import "HemaTapGR.h"
#import "TOCropViewController.h"

@interface RPhotoEditVC ()<PECropViewControllerDelegate,TOCropViewControllerDelegate,UIScrollViewDelegate>
{
    NSInteger keytype;//第几种样式
}
@property(nonatomic,strong)UIImageView *myImgView;
@property(nonatomic,strong)HemaButton *selectBtn;
@end

@implementation RPhotoEditVC
@synthesize myImgView;

- (void)viewWillAppear:(BOOL)animated
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
    [self.navigationItem setNewTitle:@"图片裁剪"];
    [self.navigationItem setRightItemWithTarget:self action:@selector(rightbtnPressed:) title:@"选取"];
    
    UIScrollView *myScrollView = [[UIScrollView alloc]init];
    [myScrollView setFrame:CGRectMake(0, 0, UI_View_Width, UI_View_Width)];
    myScrollView.contentSize = CGSizeMake(UI_View_Width, UI_View_Width);
    myScrollView.minimumZoomScale = 1.0f;
    myScrollView.maximumZoomScale = 4.0f;
    myScrollView.scrollEnabled = YES;
    myScrollView.delegate = self;
    [self.view addSubview:myScrollView];
    
    myImgView = [[UIImageView alloc]init];
    [myImgView setImage:[UIImage imageNamed:@"R表情帝.png"]];
    myImgView.clipsToBounds = YES;
    myImgView.contentMode = UIViewContentModeScaleAspectFit;
    myImgView.frame = CGRectMake(0, 0, UI_View_Width, UI_View_Width);
    myImgView.userInteractionEnabled = YES;
    [myScrollView addSubview:myImgView];
    
    HemaTapGR *temTap = [[HemaTapGR alloc] initWithTarget:self action:@selector(handlemySingleTap:)];
    [myImgView addGestureRecognizer:temTap];
    temTap.numberOfTapsRequired = 1;
    temTap.numberOfTouchesRequired = 1;
    temTap.delegate = self;
    
    //各种设置
    UIView *downView = [[UIView alloc]initWithFrame:CGRectMake(0, UI_View_Height-44, UI_View_Width, 44)];
    [self.view addSubview:downView];
    
    _selectBtn = [HemaButton buttonWithType:UIButtonTypeCustom];
    [_selectBtn setFrame:CGRectMake(0, 0, UI_View_Width, 44)];
    [_selectBtn setTitle:@"第一种" forState:UIControlStateNormal];
    [_selectBtn setTitleColor:BB_Red_Color forState:UIControlStateNormal];
    [_selectBtn.titleLabel setFont:[UIFont systemFontOfSize:20]];
    [_selectBtn addTarget:self action:@selector(selectPressed:) forControlEvents:UIControlEventTouchUpInside];
    [downView addSubview:_selectBtn];
}
-(void)loadData
{
    keytype = 1;
}
#pragma mark- 自定义
#pragma mark 事件
-(void)rightbtnPressed:(id)sender
{
    UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:@"选取图片" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:Button_Albums,Button_Camera,Button_Cancel, nil];
    [SystemFunction setActionSheet:actionSheet index:2 myVC:self];
}
//点击图片
- (void)handlemySingleTap:(HemaTapGR *)tap
{
    [myImgView setAnimationWithType:arc4random()%11 duration:1.0 direction:arc4random()%5];
    [myImgView setImage:myImgView.image];
}
//选择样式
-(void)selectPressed:(id)sender
{
    UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:@"选取样式" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"第一种",@"第二种",Button_Cancel, nil];
    [SystemFunction setActionSheet:actionSheet index:2 myVC:self];
}
#pragma mark 方法
//进入编辑类
-(void)openEditor
{
    PECropViewController *myVC = [[PECropViewController alloc] init];
    myVC.delegate = self;
    myVC.image = myImgView.image;
    
    UIImage *image = myImgView.image;
    CGFloat width = image.size.width;
    CGFloat height = image.size.height;
    CGFloat length = MIN(width, height);
    myVC.imageCropRect = CGRectMake((width-length)/2,(height-length)/2,length,length);
    
    LCPanNavigationController *nav = [[LCPanNavigationController alloc] initWithRootViewController:myVC];
    [self presentViewController:nav animated:YES completion:NULL];
}
#pragma mark- UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString*title = [actionSheet buttonTitleAtIndex:buttonIndex];
    if([title isEqualToString:Button_Camera])
    {
        [SystemFunction pickerCamere:self allowsEditing:NO];
    }
    if([title isEqualToString:Button_Albums])
    {
        [SystemFunction pickerAlbums:self allowsEditing:NO];
    }
    if([title isEqualToString:@"第一种"])
    {
        keytype = 1;
        [_selectBtn setTitle:title forState:UIControlStateNormal];
    }
    if([title isEqualToString:@"第二种"])
    {
        keytype = 2;
        [_selectBtn setTitle:title forState:UIControlStateNormal];
    }
}
#pragma mark- UIImagePickerControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [SystemFunction fixPick:navigationController myVC:viewController];
}
- (void)imagePickerController:(UIImagePickerController *)picker
        didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    image = [HemaFunction getImage:image];
    myImgView.image = image;
    
    [picker dismissViewControllerAnimated:YES completion:^{
        if (keytype == 1)
        {
            [self openEditor];
        }else
        {
            TOCropViewController *cropController = [[TOCropViewController alloc] initWithImage:image];
            cropController.delegate = self;
            [self presentViewController:cropController animated:YES completion:nil];
        }
    }];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark- UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return myImgView;
}
#pragma mark- PECropViewControllerDelegate
- (void)cropViewController:(PECropViewController *)controller didFinishCroppingImage:(UIImage *)croppedImage transform:(CGAffineTransform)transform cropRect:(CGRect)cropRect
{
    [controller dismissViewControllerAnimated:YES completion:NULL];
    myImgView.image = croppedImage;
}
- (void)cropViewControllerDidCancel:(PECropViewController *)controller
{
    [controller dismissViewControllerAnimated:YES completion:NULL];
}
#pragma mark- TOCropViewControllerDelegate
#pragma mark - Cropper Delegate -
- (void)cropViewController:(TOCropViewController *)cropViewController didCropToImage:(UIImage *)image withRect:(CGRect)cropRect angle:(NSInteger)angle
{
    myImgView.image = image;
    CGRect viewFrame = [self.view convertRect:myImgView.frame toView:self.navigationController.view];
    [cropViewController dismissAnimatedFromParentViewController:self withCroppedImage:image toFrame:viewFrame completion:^{
        
    }];
}
@end
