//
//  RMapSearchBar.m
//  Hema
//
//  Created by geyang on 15/11/25.
//  Copyright © 2015年 Hemaapp. All rights reserved.
//

#import "RMapSearchBar.h"

@implementation RMapSearchBar

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    //通过遍历self.subviews找到searchField
    UITextField*searchField = nil;
    NSUInteger numViews = [self.subviews count];
    
    for(int i = 0;i<numViews;i++)
    {
        if([[self.subviews objectAtIndex:i]isKindOfClass:[UITextField class]])
        {
            searchField = [self.subviews objectAtIndex:i];
        }
    }
    
    //如果上述方法找不到searchField
    if(searchField == nil)
    {
        NSArray*arraySub = [self subviews];
        UIView*viewSelf = [arraySub objectAtIndex:0];
        NSArray*arrayView = [viewSelf subviews];
        for(int i = 0;i<arrayView.count;i++)
        {
            if([[arrayView objectAtIndex:i]isKindOfClass:[UITextField class]])
            {
                searchField = [arrayView objectAtIndex:i];
            }
        }
    }
    
    if(!(searchField == nil))
    {
        searchField.layer.borderColor = BB_lineColor.CGColor;
        searchField.layer.borderWidth = 0.5;
        searchField.layer.cornerRadius = 15;
        
        //设置颜色
        searchField.textColor = BB_Blake_Color;
    }
}
@end
