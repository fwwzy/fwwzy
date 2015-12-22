//
//  LQview.h
//  画板3
//
//  Created by imac on 15/9/16.
//  Copyright (c) 2015年 刘强强. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LQview : UIView
/**
 *  线条颜色
 */
@property(nonatomic,strong) UIColor *colorLine;
/**
 *  线条宽度
 */
@property(nonatomic,assign)NSInteger widthLine;

/**
 *  撤销
 */
-(void)revoke;
/**
 *  清屏
 */
-(void)clearScreen;
/**
 *  橡皮
 */
-(void)rubLine;

@end
