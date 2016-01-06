//
//  ShareVC.h
//  Hema
//
//  Created by MsTail on 15/12/28.
//  Copyright © 2015年 Hemaapp. All rights reserved.
//

#import "PullRefreshPlainVC.h"

typedef enum {
    mineShare,  //我的晒单
    otherShare  //其他晒单
}shareType;

@interface ShareVC : PullRefreshPlainVC

@property (nonatomic,assign) ShareType shareType;

@end
