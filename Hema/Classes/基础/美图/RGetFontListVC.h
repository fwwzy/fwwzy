//
//  RGetFontListVC.h
//  Hema
//
//  Created by geyang on 15/11/18.
//  Copyright © 2015年 Hemaapp. All rights reserved.
//

#import "PullRefreshGroupVC.h"

typedef void(^FontCallback)(BOOL success, id result);
@interface RGetFontListVC : PullRefreshGroupVC
@property(nonatomic,copy)FontCallback fontSuccessBlock;
@end
