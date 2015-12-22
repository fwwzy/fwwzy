//
//  SGFocusImageItem.h
//  ScrollViewLoop
//
//  Created by Vincent Tang on 13-7-18.
//  Copyright (c) 2013年 Vincent Tang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SGFocusImageItem : NSObject

@property (nonatomic, retain)  NSString     *title;
@property (nonatomic, retain)  NSString      *image;//图片url地址
@property (nonatomic, assign)  NSInteger     tag;
@property (nonatomic, retain)  NSMutableDictionary *myDic;//存储的信息，用于跳转

- (id)initWithTitle:(NSString *)title image:(NSString *)image tag:(NSInteger)tag;
- (id)initWithDict:(NSMutableDictionary *)dict tag:(NSInteger)tag;
@end
