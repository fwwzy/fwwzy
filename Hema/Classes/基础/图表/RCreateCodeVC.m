//
//  RCreateCodeVC.m
//  Hema
//
//  Created by geyang on 15/11/10.
//  Copyright © 2015年 Hemaapp. All rights reserved.
//

#import "RCreateCodeVC.h"

@interface RCreateCodeVC ()
@property(nonatomic,strong)UIImageView *myQRImgView;//二维码
@property(nonatomic,strong)UIImageView *myBarImgView;//条形码
@property(nonatomic,copy)NSString *code;
@end

@implementation RCreateCodeVC

-(void)loadSet
{
    [self.navigationItem setNewTitle:@"二维码生成"];
    [self.navigationItem setRightItemWithTarget:self action:@selector(rightbtnPressed:) title:@"输入"];
    
    _myBarImgView = [[UIImageView alloc]init];
    _myBarImgView.frame = CGRectMake((UI_View_Width-240)/2, 10, 240, 128);
    _myBarImgView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:_myBarImgView];
    
    _myQRImgView = [[UIImageView alloc]init];
    _myQRImgView.frame = CGRectMake((UI_View_Width-240)/2, 150, 240, 240);
    _myQRImgView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:_myQRImgView];
    
    _myBarImgView.image = [HemaFunction generateBarCode:_code width:_myBarImgView.width height:_myBarImgView.height];
    _myQRImgView.image = [HemaFunction generateQRCode:_code width:_myQRImgView.width height:_myQRImgView.height];
}
-(void)loadData
{
    _code = @"https://www.baidu.com";
}
#pragma mark- 自定义
#pragma mark 事件
-(void)rightbtnPressed:(id)sender
{
    MMPopupBlock completeBlock = ^(MMPopupView *popupView)
    {
        
    };
    [[[MMAlertView alloc] initWithInputTitle:@"内容" detail:@"请输入要生成的内容" placeholder:@"输吧~~~" handler:^(NSString *text)
      {
          if (![HemaFunction xfunc_check_strEmpty:text])
          {
              if ([HemaFunction IsChinese:text])
              {
                  [HemaFunction openIntervalHUD:@"说好的不能输入中文呢"];
                  return;
              }
              _code = text;
              _myBarImgView.image = [HemaFunction generateBarCode:_code width:_myBarImgView.width height:_myBarImgView.height];
              _myQRImgView.image = [HemaFunction generateQRCode:_code width:_myQRImgView.width height:_myQRImgView.height];
          }
      }]
     showWithBlock:completeBlock];
}
@end