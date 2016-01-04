//
//  MineMessVC.m
//  Hema
//
//  Created by Lsy on 16/1/4.
//  Copyright © 2016年 Hemaapp. All rights reserved.
//

#import "MineMessVC.h"
#import "MineNameVC.h"
#import "FindPwdVC.h"
#import "MineWelVC.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>

@interface MineMessVC ()<UITableViewDataSource,UITableViewDelegate>{
    UITableView *_tableView;
}

@end

@implementation MineMessVC

-(void)viewWillAppear:(BOOL)animated{
    //隐藏导航栏
    self.navigationController.navigationBarHidden = YES;
}
- (void)loadSet {
    //背景色
    self.view.backgroundColor =[UIColor colorWithRed:252.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:0.8];
    //导航
    UIView *navView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UI_View_Width, self.view.height/3)];
    navView.backgroundColor = [UIColor colorWithRed:179.0/255 green:23.0/255 blue:40.0/255 alpha:1];
//    navView.backgroundColor = [UIColor colorWithRed:217.0/255 green:29.0/255 blue:43.0/255 alpha:1];
    navView.userInteractionEnabled = YES;
    [self.view addSubview:navView];
    //后退
    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 29, 14, 20)];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"lg_back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:backBtn];
    //标题
    UILabel *loginLbl = [[UILabel alloc] init];
    loginLbl.frame = CGRectMake(UI_View_Width / 2 - 40, 30, 80, 17);
    loginLbl.textColor = BB_White_Color;
    loginLbl.font = [UIFont systemFontOfSize:18];
    loginLbl.text = @"个人信息";
    [navView addSubview:loginLbl];
    //设置
    UIButton *setBtn = [[UIButton alloc]initWithFrame:CGRectMake(UI_View_Width - 29, 29, 20, 20)];
    [setBtn setBackgroundImage:[UIImage imageNamed:@"mine_setting"] forState:UIControlStateNormal];
    [navView addSubview: setBtn];
    //头像
    iconView = [[UIImageView alloc]initWithFrame:CGRectMake(UI_View_Width/2-33, 65, 66, 66)];
    [iconView setImage:[UIImage imageNamed:@"mine_upicon"]];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(upIconView)];
    iconView.userInteractionEnabled = YES;
    [iconView addGestureRecognizer:tap];
    [navView addSubview:iconView];
    //ID
    UILabel *idLabel = [[UILabel alloc]initWithFrame:CGRectMake(UI_View_Width/2-50, 140, 100, 15)];
    idLabel.font = [UIFont systemFontOfSize:11];
    idLabel.textAlignment = NSTextAlignmentCenter;
    idLabel.text = @"点击上传头像";
    idLabel.textColor =[UIColor colorWithRed:143.0/255 green:14.0/255 blue:30.0/255 alpha:1];
    [navView addSubview:idLabel];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, self.view.height/3+10, UI_View_Width, 200)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor =[UIColor colorWithRed:252.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:0.8];
    _tableView.scrollEnabled = YES;
    [self.view addSubview:_tableView];
    //声明
    UILabel *sayLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(_tableView.frame), UI_View_Width - 25, 40)];
    sayLabel.text = @"全民夺宝，不会将用户信息提供给第三方、或移作其他目的的使用";
    sayLabel.numberOfLines = 2;
    sayLabel.textColor = BB_Gray_Color;
    sayLabel.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:sayLabel];
    //完成
    UIButton *finishBtn = [[UIButton alloc]initWithFrame:CGRectMake(40, CGRectGetMaxY(sayLabel.frame)+(self.view.height-CGRectGetMaxY(sayLabel.frame)-40)/2, (UI_View_Width - 80), 40)];
    finishBtn.backgroundColor = BB_Red_Color;
    [finishBtn setTitle:@"完成" forState:UIControlStateNormal];
    [finishBtn setTitleColor:BB_White_Color forState:UIControlStateNormal];
    finishBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [finishBtn addTarget:self action:@selector(finishBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:finishBtn];
}
#pragma mark - 代理
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = nil;
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"qqq"];
    }else{
        while ([cell.contentView.subviews lastObject]!=nil) {
            [(UIView *)[cell.contentView.subviews lastObject]removeFromSuperview];
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //名称
    UILabel *nameLabel = [[UILabel alloc]init];
    //标题
    UILabel *titleLabel = [[UILabel alloc]init];
    //箭头
    UIImageView *rightView = [[UIImageView alloc]initWithFrame:CGRectMake(UI_View_Width - 20, 17, 8, 14)];
    [rightView setImage:[UIImage imageNamed:@"mine_right"]];
    if (indexPath.row == 0) {
        titleLabel.frame = CGRectMake(10, 15, 100, 20);
        titleLabel.text = @"昵称";
        titleLabel.textColor = BB_Gray_Color;
        titleLabel.font = [UIFont systemFontOfSize:16];
        
        nameLabel.frame = CGRectMake(UI_View_Width - 150, 15, 120, 20);
        nameLabel.textAlignment = NSTextAlignmentRight;
        nameLabel.text = @"夺宝英雄";
        nameLabel.font = [UIFont systemFontOfSize:16];
        self.blockName = ^(NSString *str){
            nameLabel.text = str;
            NSLog(@"%@",str);
        };
    }
    if (indexPath.row == 1) {
        titleLabel.frame = CGRectMake(10, 15, 100, 20);
        titleLabel.text = @"手机号";
        titleLabel.textColor = BB_Gray_Color;
        titleLabel.font = [UIFont systemFontOfSize:16];
        
        nameLabel.frame = CGRectMake(UI_View_Width - 150, 15, 120, 20);
        nameLabel.textAlignment = NSTextAlignmentRight;
        nameLabel.text = @"13526215478";
        nameLabel.font = [UIFont systemFontOfSize:16];
    }
    if (indexPath.row == 2) {
        titleLabel.frame = CGRectMake(10, 15, 100, 20);
        titleLabel.text = @"我的推广ID";
        titleLabel.textColor = BB_Gray_Color;
        titleLabel.font = [UIFont systemFontOfSize:16];
        
        nameLabel.frame = CGRectMake(UI_View_Width - 150, 15, 120, 20);
        nameLabel.textAlignment = NSTextAlignmentRight;
        nameLabel.text = @"123456";
        nameLabel.font = [UIFont systemFontOfSize:16];
    }
    if (indexPath.row == 3) {
        titleLabel.frame = CGRectMake(10, 15, 100, 20);
        titleLabel.text = @"邀请人ID";
        titleLabel.textColor = BB_Gray_Color;
        titleLabel.font = [UIFont systemFontOfSize:16];
        
        nameLabel.frame = CGRectMake(UI_View_Width - 150, 15, 120, 20);
        nameLabel.textAlignment = NSTextAlignmentRight;
        nameLabel.text = @"12356897458";
        nameLabel.font = [UIFont systemFontOfSize:16];
        self.blockNum = ^(NSString *str){
            nameLabel.text = str;
        };
    }
    [cell addSubview:nameLabel];
    [cell addSubview:titleLabel];
    [cell addSubview:rightView];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        MineNameVC *mnc = [[MineNameVC alloc]init];
        [self.navigationController pushViewController:mnc animated:YES];
        mnc.blockName = self.blockName;
    }
    if (indexPath.row == 1) {
        FindPwdVC *hvc = [[FindPwdVC alloc]init];
        [self.navigationController pushViewController:hvc animated:YES];
    }
    if (indexPath.row == 3) {
        MineWelVC *mwc = [[MineWelVC alloc]init];
        [self.navigationController pushViewController:mwc animated:YES];
        mwc.blockNum = self.blockNum;
    }
}
#pragma mark - 事件
-(void)finishBtnClick{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)backBtnClick{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)upIconView{
    UIActionSheet *menu=[[UIActionSheet alloc] initWithTitle:@"上传图片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照上传",@"从相册上传", nil];
    menu.actionSheetStyle=UIActionSheetStyleBlackTranslucent;
    [menu showInView:self.view];
    NSLog(@"被点击啦！");
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==0){
        
        [self snapImage];
        [self openFlashlight];
        NSLog(@"111111111111");
    }else if(buttonIndex==1){
        [self pickImage];
        NSLog(@"222222222222");
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
    iconView.image=image;
    [HemaFunction addbordertoView:iconView radius:33 width:0 color:nil];
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

@end
