//
//  AllVC.h
//  BiaoBiao
//
//  Created by 平川嘉恒 on 14-4-24.
//  Copyright (c) 2014年 平川嘉恒. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Localisator.h"

@interface AllVC : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIGestureRecognizerDelegate,UIActionSheetDelegate>
{
    MBProgressHUD *waitMB;
    NSInteger myRow;//选择处理操作的某一个row
    BOOL isSwipe;//是否有滑动的(侧滑删除时用)
    
    BOOL isPullRefresh;//是否是继承的加载刷新类，此字段尔等暂时可不看。
}
-(void)leftbtnPressed:(id)sender;
@end
