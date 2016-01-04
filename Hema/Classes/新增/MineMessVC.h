//
//  MineMessVC.h
//  Hema
//
//  Created by Lsy on 16/1/4.
//  Copyright © 2016年 Hemaapp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MineMessVC : AllVC<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    UIImageView *iconView;
    //调用闪光灯的时候创建的类
    AVCaptureSession*_AVSession;
}
@property(nonatomic,retain)AVCaptureSession * AVSession;
@property(nonatomic,copy)void(^blockName) (NSString *str);
@property(nonatomic,copy)void(^blockNum) (NSString *str);
@end
