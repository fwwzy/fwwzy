//
//  Navbar.h
//  Hema
//
//  Created by LarryRodic on 15/10/5.
//  Copyright (c) 2015年 Hemaapp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Navbar : UINavigationBar
@end

typedef enum
{
    NavBarButtonItemTypeDefault = 0,//默认类型 暂时只选这一种
    NavBarButtonItemTypeBack = 1,
    NavBarButtonItemTypeNone = 2
}NavBarButtonItemType;//左右导航类型

@interface NavBarButtonItem : NSObject
@property (nonatomic,assign)NavBarButtonItemType itemType;
@property (nonatomic,strong)UIButton *button;
@property (nonatomic,strong)NSString *title;
@property (nonatomic,strong)NSString *image;
@end

@interface UINavigationItem (CustomBarButtonItem)<UIGestureRecognizerDelegate>

//中间
- (void)setNewTitle:(NSString *)title;
- (void)setNewTitle:(NSString *)title color:(UIColor*)color;
- (void)setNewTitleImage:(UIImage *)image;
//左导航
- (void)setLeftItemWithTarget:(id)target
                       action:(SEL)action
                        title:(NSString *)title;
- (void)setLeftItemWithTarget:(id)target
                       action:(SEL)action
                        image:(NSString *)image;
//右导航
- (void)setRightItemWithTarget:(id)target
                        action:(SEL)action
                         title:(NSString *)title;
- (void)setRightItemWithTarget:(id)target
                        action:(SEL)action
                         image:(NSString *)image;
@end