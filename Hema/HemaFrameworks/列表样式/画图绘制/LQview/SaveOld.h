//
//  SaveOld.h
//  画板3
//
//  Created by imac on 15/9/16.
//  Copyright (c) 2015年 刘强强. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SaveOld : NSObject
/**
 *  已绘制线色
 */
@property(nonatomic,strong) UIColor *colorOld;
/**
 *  已绘制线宽
 */
@property(nonatomic,assign)NSInteger widthOld;


@end
