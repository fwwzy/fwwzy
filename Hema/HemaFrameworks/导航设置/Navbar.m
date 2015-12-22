//
//  Navbar.m
//  Hema
//
//  Created by LarryRodic on 15/10/5.
//  Copyright (c) 2015年 Hemaapp. All rights reserved.
//

#import "Navbar.h"

@implementation Navbar

@end

@implementation NavBarButtonItem
@synthesize itemType = _itemType;
@synthesize button = _button;

- (id)initWithType:(NavBarButtonItemType)itemType
{
    self = [super init];
    if (self)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        self.button  = button;
        self.itemType = itemType;
        button.titleLabel.font  = [UIFont systemFontOfSize:ItemTextFont];
        [button setTitleColor:ItemTextNormalColot forState:UIControlStateNormal];
    }
    return self;
}
+ (id)defauleItemWithTarget:(id)target action:(SEL)action title:(NSString *)title
{
    NavBarButtonItem *item = [[NavBarButtonItem alloc]initWithType:NavBarButtonItemTypeDefault];
    item.title = title;
    [item setTarget:target withAction:action];
    return item;
}
+ (id)defauleItemWithTarget:(id)target action:(SEL)action image:(NSString *)image
{
    NavBarButtonItem *item = [[NavBarButtonItem alloc]initWithType:NavBarButtonItemTypeNone];
    item.image = image;
    UIImageView *temView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:image]];
    [item.button setFrame:CGRectMake(0, 0, temView.image.size.width/2, temView.image.size.height/2)];
    [item setTarget:target withAction:action];
    return item;
}
- (void)setTarget:(id)target withAction:(SEL)action
{
    [_button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}
- (void)setTitle:(NSString *)title
{
    _title = title;
    [_button setTitle:title forState:UIControlStateNormal];
    if (_title.length>3)
    {
        _button.frame = CGRectMake(0, 0, 80, ItemHeight);
    }else
    {
        _button.frame = CGRectMake(0, 0, 48, ItemHeight);
    }
    [self  titleOffsetWithType];
}

- (void)setImage:(NSString *)image
{
    _image = image;
    UIImage *image_ = [UIImage imageNamed:image];
    [_button setImage:image_  forState:UIControlStateNormal];
}
- (void)titleOffsetWithType
{
    switch (_itemType) {
        case NavBarButtonItemTypeBack:
        {
            [_button setContentEdgeInsets:BackItemOffset];
        }
            break;
        case NavBarButtonItemTypeDefault:
        {
            [_button setContentEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        }
            break;
        default:
            break;
    }
}
@end

@implementation UINavigationItem(CustomBarButtonItem)

- (void)setNewTitle:(NSString *)title
{
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor clearColor];
    label.frame = CGRectMake(0, 0, 100, 44);
    label.font = [UIFont boldSystemFontOfSize:Nav_TitleFont];
    label.textColor = Nav_TitleColor;
    label.textAlignment = NSTextAlignmentCenter;
    label.text = title;
    self.titleView = label;
}
- (void)setNewTitle:(NSString *)title color:(UIColor*)color
{
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor clearColor];
    label.frame = CGRectMake(0, 0, 100, 44);
    label.font = [UIFont boldSystemFontOfSize:Nav_TitleFont];
    label.textColor = color;
    label.textAlignment = NSTextAlignmentCenter;
    label.text = title;
    self.titleView = label;
}
- (void)setNewTitleImage:(UIImage *)image
{
    UIImageView *imageView = [[UIImageView alloc] init];
    CGRect bounds = imageView.bounds;
    imageView.image = image;
    bounds.size = image.size;
    imageView.bounds = bounds;
    self.titleView = imageView;
}
- (void)setLeftItemWithTarget:(id)target action:(SEL)action title:(NSString *)title
{
    NavBarButtonItem *buttonItem = [NavBarButtonItem defauleItemWithTarget:target
                                                                    action:action
                                                                     title:title];
    self.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:buttonItem.button];
    UIBarButtonItem *flexSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                               target:self
                                                                               action:nil];
    flexSpacer.width = -10;
    [self setLeftBarButtonItems:[NSArray arrayWithObjects:flexSpacer,self.leftBarButtonItem , nil]];
}
- (void)setLeftItemWithTarget:(id)target action:(SEL)action image:(NSString *)image
{
    
    NavBarButtonItem *buttonItem = [NavBarButtonItem defauleItemWithTarget:target
                                                                    action:action
                                                                     image:image];
    self.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:buttonItem.button];
    
    UIBarButtonItem *flexSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                               target:self
                                                                               action:nil];
    flexSpacer.width = 0;
    [self setLeftBarButtonItems:[NSArray arrayWithObjects:flexSpacer,self.leftBarButtonItem , nil]];
}
- (void)setRightItemWithTarget:(id)target action:(SEL)action title:(NSString *)title
{
    NavBarButtonItem *buttonItem = [NavBarButtonItem defauleItemWithTarget:target
                                                                    action:action
                                                                     title:title];
    self.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:buttonItem.button];
    
    UIBarButtonItem *flexSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                               target:self
                                                                               action:nil];
    flexSpacer.width = -10;
    [self setRightBarButtonItems:[NSArray arrayWithObjects:flexSpacer,self.rightBarButtonItem ,nil]];
}

- (void)setRightItemWithTarget:(id)target action:(SEL)action image:(NSString *)image
{
    NavBarButtonItem *buttonItem = [NavBarButtonItem defauleItemWithTarget:target
                                                                    action:action
                                                                     image:image];
    self.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:buttonItem.button];
    
    UIBarButtonItem *flexSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                               target:self
                                                                               action:nil];
    flexSpacer.width = 0;
    [self setRightBarButtonItems:[NSArray arrayWithObjects:flexSpacer,self.rightBarButtonItem ,nil]];
}

@end