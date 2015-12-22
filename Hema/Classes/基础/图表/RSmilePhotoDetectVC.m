//
//  RSmilePhotoDetectVC.m
//  Hema
//
//  Created by geyang on 15/11/5.
//  Copyright © 2015年 Hemaapp. All rights reserved.
//

#import "RSmilePhotoDetectVC.h"
#import "JCAlertView.h"

@interface RSmilePhotoDetectVC ()
@property(nonatomic,strong)UIImageView *myImgView;
@end

@implementation RSmilePhotoDetectVC
@synthesize myImgView;

-(void)loadSet
{
    [self.navigationItem setNewTitle:@"图像人脸识别"];
    [self.navigationItem setRightItemWithTarget:self action:@selector(rightbtnPressed:) title:@"选取"];
    [self.view setBackgroundColor:[UIColor blackColor]];
    
    myImgView = [[UIImageView alloc]init];
    myImgView.image = [UIImage imageNamed:@"R表情帝.png"];
    myImgView.frame = CGRectMake(0, 0, UI_View_Width, UI_View_Width);
    myImgView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:myImgView];
    
    HemaButton *okBtn = [HemaButton buttonWithType:UIButtonTypeCustom];
    [okBtn setFrame:CGRectMake((UI_View_Width-160)/2, (UI_View_Height-UI_View_Width-160)/2+UI_View_Width, 160, 160)];
    [HemaFunction addbordertoView:okBtn radius:80 width:1 color:[UIColor magentaColor]];
    [okBtn setTitle:@"开始检测" forState:UIControlStateNormal];
    [okBtn setTitleColor:[UIColor magentaColor] forState:UIControlStateNormal];
    [okBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [okBtn addTarget:self action:@selector(okPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:okBtn];
}
#pragma mark- 自定义
#pragma mark 事件
-(void)rightbtnPressed:(id)sender
{
    UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:@"选取图片" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:Button_Albums,Button_Camera,Button_Cancel, nil];
    [SystemFunction setActionSheet:actionSheet index:2 myVC:self];
}

-(void)okPressed:(id)sender
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        
        CIImage *image = [CIImage imageWithCGImage:myImgView.image.CGImage];
        CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeFace
                                                  context:nil
                                                  options:@{CIDetectorAccuracy: CIDetectorAccuracyHigh}];
        
        NSDictionary *options = @{CIDetectorSmile: @(YES),CIDetectorEyeBlink: @(YES),};
        NSArray *features = [detector featuresInImage:image options:options];
        NSMutableString *resultStr = @"检测人脸:\n\n".mutableCopy;
        
        for(CIFaceFeature *feature in features)
        {
            [resultStr appendFormat:@"位置:%@\n", NSStringFromCGRect(feature.bounds)];
            [resultStr appendFormat:@"是否是笑脸: %@\n\n", feature.hasSmile ? @"YES" : @"NO"];
            NSLog(@"脸的角度: %@", feature.hasFaceAngle ? @(feature.faceAngle) : @"NONE");
            NSLog(@"左眼是否关闭: %@", feature.leftEyeClosed ? @"YES" : @"NO");
            NSLog(@"右眼是否关闭: %@", feature.rightEyeClosed ? @"YES" : @"NO");
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [JCAlertView showOneButtonWithTitle:@"检测结果" Message:resultStr ButtonType:JCAlertViewButtonTypeDefault ButtonTitle:@"好" Click:^{
                
            }];
        });
    });
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
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}
@end
