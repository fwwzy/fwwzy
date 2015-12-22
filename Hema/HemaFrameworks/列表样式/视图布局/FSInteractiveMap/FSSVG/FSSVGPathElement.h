//
//  FSSVGPathElement.h
//  FSInteractiveMap
//
//  Created by Arthur GUIBERT on 22/12/2014.
//  Copyright (c) 2014 Arthur GUIBERT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface FSSVGPathElement : NSObject

@property (nonatomic, strong) NSString* title;
@property (nonatomic, strong) NSString* identifier;
@property (nonatomic, strong) NSString* className;
@property (nonatomic, strong) NSString* tranform;
@property (nonatomic, strong) UIBezierPath* path;
@property (nonatomic) BOOL fill;

- (instancetype)initWithAttributes:(NSDictionary *)attributes;

@end

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com 
