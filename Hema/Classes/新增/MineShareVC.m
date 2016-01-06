//
//  MineShareVC.m
//  Hema
//
//  Created by MsTail on 16/1/6.
//  Copyright © 2016年 Hemaapp. All rights reserved.
//

#import "MineShareVC.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>

@interface MineShareVC ()<UITextViewDelegate> {
    UITextView *_textView;
    UILabel *_strLength;
    UIButton *_photoBtn;
    NSMutableArray *_photoArr;
}

@end

@implementation MineShareVC

- (void)viewWillDisappear:(BOOL)animated {
    self.navigationController.navigationBarHidden = YES;
}
- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = NO;
}

- (void)loadSet {
    
    [self.navigationItem setNewTitle:@"我的抢币"];
    [self.navigationItem setLeftItemWithTarget:self action:@selector(leftbtnPressed:) image:@"lg_back"];
    
    //textView
    _textView = [[UITextView alloc] init];
    _textView.frame = CGRectMake(15, 15, UI_View_Width - 30, self.view.height / 3);
    _textView.textColor = BB_Gray_Color;
    _textView.font = [UIFont systemFontOfSize:14];
    _textView.text = @"请发表获奖感言";
    [HemaFunction addbordertoView:_textView radius:0 width:1 color:RGB_UI_COLOR(180, 180, 180)];
    _textView.delegate = self;
    
    //字数统计
    _strLength = [[UILabel alloc] init];
    _strLength.frame = CGRectMake(_textView.size.width - 90, _textView.size.height - 30, 80, 20);
    _strLength.textAlignment = NSTextAlignmentRight;
    _strLength.font = [UIFont systemFontOfSize:14];
    _strLength.text = @"限140字";
    
    //上传照片
    _photoBtn = [[UIButton alloc] init];
    _photoBtn.frame = CGRectMake(15, _textView.size.height + 35, 50, 50);
    [_photoBtn setImage:[UIImage imageNamed:@"mine_photo"] forState:UIControlStateNormal];
    [_photoBtn addTarget:self action:@selector(photoBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    //提交
    HemaButton *submitBtn = [[HemaButton alloc] init];
    submitBtn.frame = CGRectMake(60, _photoBtn.origin.y + _photoBtn.size.height + 40, UI_View_Width - 120, 40);
    [submitBtn setBackgroundImage:[UIImage imageNamed:@"lg_login"] forState:UIControlStateNormal];
    [submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(submitBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    _photoArr = [[NSMutableArray alloc] init];
    
    [_textView addSubview:_strLength];
    [self.view addSubview:submitBtn];
    [self.view addSubview:_photoBtn];
    [self.view addSubview:_textView];
    
}
- (void)loadData {
    
}

- (void)photoBtnClick:(UIButton *)sender {
    UIActionSheet *menu=[[UIActionSheet alloc] initWithTitle:@"上传图片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照上传",@"从相册上传", nil];
    menu.actionSheetStyle=UIActionSheetStyleBlackTranslucent;
    [menu showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==0){
        
        [self snapImage];
        [self openFlashlight];
    }else if(buttonIndex==1){
        [self pickImage];
    }
}

-(void)openFlashlight
{
    AVCaptureDevice * device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (device.torchMode == AVCaptureTorchModeOff) {
        AVCaptureSession * session = [[AVCaptureSession alloc]init];
        
        AVCaptureDeviceInput * input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
        [session addInput:input];
        
        // Create video output and add to current session
        AVCaptureVideoDataOutput * output = [[AVCaptureVideoDataOutput alloc]init];
        [session addOutput:output];
        
        // Start session configuration
        [session beginConfiguration];
        [device lockForConfiguration:nil];
        
        // Set torch to on
        [device setTorchMode:AVCaptureTorchModeOn];
        
        [device unlockForConfiguration];
        [session commitConfiguration];
        
        // Start the session
        [session startRunning];
        
        // Keep the session around
        [self setAVSession:self.AVSession];
        
        
    }
}
-(void)closeFlashlight
{
    [self.AVSession stopRunning];
}
- (void)snapImage{
    //    UIImagePickerController *ipc=[[UIImagePickerController alloc] init];
    //    ipc.sourceType=UIImagePickerControllerSourceTypeCamera;
    //    ipc.delegate=self;
    //    ipc.allowsEditing=NO;
    //
    //    [self presentViewController:ipc animated:YES completion:nil];
    
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController * picker = [[UIImagePickerController alloc]init];
        picker.delegate = self;
        picker.allowsEditing=NO;
        //打开相册选择照片
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:picker animated:YES completion:nil];
        
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"你没有摄像头" delegate:nil cancelButtonTitle:@"Drat!" otherButtonTitles:nil];
        [alert show];
    }
    
}
//从相册里找
- (void)pickImage{
    //相册是可以用模拟器打开的
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        UIImagePickerController * picker = [[UIImagePickerController alloc]init];
        picker.delegate = self;
        
        //打开相册选择照片
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:picker animated:YES completion:nil];
        
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"你没有摄像头" delegate:nil cancelButtonTitle:@"Drat!" otherButtonTitles:nil];
        [alert show];
    }
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //
    NSLog(@"info~~%@",info);
    
    UIImage*image=[info objectForKey:UIImagePickerControllerOriginalImage];
    
    //创建上传图片
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame = CGRectMake(15 + _photoArr.count * 60, _textView.size.height + 35, 50, 50);
    imageView.tag = _photoArr.count;
    imageView.userInteractionEnabled = YES;
    UIButton *closeBtn = [[UIButton alloc] init];
    closeBtn.frame = CGRectMake(imageView.size.width - 10, - 5, 15, 15);
    [closeBtn setImage:[UIImage imageNamed:@"mine_remove"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    imageView.image = image;
    [self.view addSubview:imageView];
    [imageView addSubview:closeBtn];
    [_photoArr addObject:imageView];
    if (_photoArr.count == 4) {
        _photoBtn.hidden = YES;
    } else {
    _photoBtn.frame = CGRectMake(15 + _photoArr.count * 60, _textView.size.height + 35, 50, 50);
    }
    
    //读取用户隐私，包含经纬度 创建时间
    NSURL*url=[info objectForKey:UIImagePickerControllerReferenceURL];
    //添加一个系统库
    ALAssetsLibrary *ass=[[ALAssetsLibrary alloc]init];
    [ass assetForURL:url resultBlock:^(ALAsset *asset) {
        //获取图片隐私
        NSLog(@"%@",asset.defaultRepresentation.metadata);
        
    } failureBlock:nil];
    
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    
}
//取消
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}


//placeholder
- (void)textViewDidBeginEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:@"请发表获奖感言"]) {
        textView.text = @"";
        textView.textColor = BB_Blake_Color;
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if (textView.text.length<1) {
        textView.text = @"请发表获奖感言";
        textView.textColor = BB_Gray_Color;
    }
}

//删除上传的图片
- (void)closeBtnClick:(UIButton *)sender {
    
    _photoBtn.hidden = NO;
    [sender.superview removeFromSuperview];
    //删除后前移照片
    for (NSInteger i =  [_photoArr indexOfObject:sender.superview]; i < _photoArr.count; i++) {
        UIImageView *imageView = _photoArr[i];
        imageView.frame = CGRectMake(15 + (i - 1) * 60, _textView.size.height + 35, 50, 50);
    }
    _photoBtn.frame = CGRectMake(15 + (_photoArr.count - 1) * 60, _textView.size.height + 35, 50, 50);
     [_photoArr removeObject:sender.superview];
}

//限制字数统计
- (void)textViewDidChange:(UITextView *)textView {
    _strLength.text = [NSString stringWithFormat:@"限%zd字",140 - _textView.text.length];
}

//限制140字
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if (range.location > 139) {
        return NO;
    }
    return YES;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
