//
//  MineShareVC.h
//  Hema
//
//  Created by MsTail on 16/1/6.
//  Copyright © 2016年 Hemaapp. All rights reserved.
//

#import "AllVC.h"

@interface MineShareVC : AllVC<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    UIImageView *iconView;
    //调用闪光灯的时候创建的类
    AVCaptureSession*_AVSession;
}
@property(nonatomic,retain)AVCaptureSession * AVSession;

@end
