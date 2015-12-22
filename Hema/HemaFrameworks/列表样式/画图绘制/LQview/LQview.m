//
//  LQview.m
//  画板3
//
//  Created by imac on 15/9/16.
//  Copyright (c) 2015年 刘强强. All rights reserved.
//

#import "LQview.h"
#import "SaveOld.h"

@interface LQview ()
/**
 *  存放所有移动过程中的点(包括起始点)
 */
@property(nonatomic,strong) NSMutableArray *movePoints;
/**
 *  存放所有已绘制路径
 */
@property(nonatomic,strong)NSMutableArray *allPointsArr;
/**
 *  存放所有之前绘制好的线模型
 */
@property(nonatomic,strong) NSMutableArray *oldLeneArr;


@end

@implementation LQview

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _colorLine = [[UIColor alloc] init];
        _colorLine = [UIColor blackColor];
        
        _widthLine = 3;
    }
    return self;
}


-(void)setColorLine:(UIColor *)colorLine {
    _colorLine = colorLine;
    [self setNeedsDisplay];
}

-(void)setWidthLine:(NSInteger)widthLine {
    _widthLine = widthLine;
    [self setNeedsDisplay];
}
/**
 *  橡皮
 */
-(void)rubLine {
    
    _colorLine = self.backgroundColor;
    
}

//撤销
-(void)revoke {
    [self setNeedsDisplay];
    [self.allPointsArr removeLastObject];
    [self.oldLeneArr removeLastObject];
}
//清屏
-(void)clearScreen {
    [self setNeedsDisplay];
    [self.allPointsArr removeAllObjects];
    [self.oldLeneArr removeLastObject];
}

- (void)drawRect:(CGRect)rect {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    for (int i = 0; i < self.allPointsArr.count; i ++) {
        NSArray *arr = [self.allPointsArr objectAtIndex:i];
        SaveOld *saveOld = self.oldLeneArr[i];
        [saveOld.colorOld setStroke];
        CGContextSetLineWidth(context, saveOld.widthOld);
        //调用划线方法
        [self fromPointToLineWithContext:context withPoingArr:arr];
    }
    
    
    if (self.movePoints == nil || self.movePoints.count < 2) {
        return;
    }
    [_colorLine setStroke];
    CGContextSetLineWidth(context, _widthLine);
    
    //调用划线方法
    [self fromPointToLineWithContext:context withPoingArr:self.movePoints];
    
}
/**
 *  划线
 */
-(void)fromPointToLineWithContext:(CGContextRef)context withPoingArr:(NSArray *)arr {
    for (int i = 0; i < arr.count - 1; i ++) {
        CGMutablePathRef path = CGPathCreateMutable();
        CGPoint point1 = [arr[i] CGPointValue];
        
        CGPathMoveToPoint(path, nil, point1.x, point1.y);
        
        
        CGContextSetLineCap(context, kCGLineCapRound);
        
        CGPoint point2 = [arr[i + 1] CGPointValue];
        CGPathAddLineToPoint(path, nil, point2.x, point2.y);
        
        CGContextAddPath(context, path);
        CGContextDrawPath(context, kCGPathStroke);
        
        //----------------保存以前样式--------------------
//        UIColor *color = _colorLine;
//        NSInteger width = _widthLine;
    }

}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    //取得手指点击的起始点
    CGPoint points = [touch locationInView:self];
    [self.movePoints addObject:[NSValue valueWithCGPoint:points]];
    //------------------------------------------
    SaveOld *saveOld = [[SaveOld alloc] init];
    saveOld.colorOld = _colorLine;
    saveOld.widthOld = _widthLine;
    
    [self.oldLeneArr addObject:saveOld];

}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    //取得手指点击的起始点
    CGPoint points = [touch locationInView:self];
    [self.movePoints addObject:[NSValue valueWithCGPoint:points]];
    [self setNeedsDisplay];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self.allPointsArr addObject:self.movePoints];
    self.movePoints = nil;
}

-(NSMutableArray *)movePoints {
    if (_movePoints == nil) {
        _movePoints = [[NSMutableArray alloc] init];
    }
    return _movePoints;
}

-(NSMutableArray *)allPointsArr {
    if (_allPointsArr == nil) {
        _allPointsArr = [[NSMutableArray alloc] init];
    }
    return _allPointsArr;
}

-(NSMutableArray *)oldLeneArr {
    if (_oldLeneArr == nil) {
        _oldLeneArr = [[NSMutableArray alloc] init];
    }
    return _oldLeneArr;
}

@end
