/*
 *  UIExpandingTextViewInternal.m
 *  
 *  Created by Brandon Hamilton on 2011/05/03.
 *  Copyright 2011 Brandon Hamilton.
 *  
 *  Permission is hereby granted, free of charge, to any person obtaining a copy
 *  of this software and associated documentation files (the "Software"), to deal
 *  in the Software without restriction, including without limitation the rights
 *  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 *  copies of the Software, and to permit persons to whom the Software is
 *  furnished to do so, subject to the following conditions:
 *  
 *  The above copyright notice and this permission notice shall be included in
 *  all copies or substantial portions of the Software.
 *  
 *  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 *  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 *  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 *  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 *  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 *  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 *  THE SOFTWARE.
 */

#import "UIExpandingTextViewInternal.h"

#define kTopContentInset -4
#define lBottonContentInset 12

@implementation UIExpandingTextViewInternal

-(void)setContentOffset:(CGPoint)s
{
    //NSLog(@"去年：%@",self.text);
	if(self.tracking || self.decelerating)
    {
		self.contentInset = UIEdgeInsetsMake(kTopContentInset, 0, 0, 0);
	} 
    else 
    {
        CGRect txtFrame = self.frame;
        CGFloat textViewContentHeight = txtFrame.size.height =[[NSString stringWithFormat:@"%@\n ",self.text]
                                                               boundingRectWithSize:CGSizeMake(txtFrame.size.width, CGFLOAT_MAX)
                                                               options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                               attributes:[NSDictionary dictionaryWithObjectsAndKeys:self.font,NSFontAttributeName, nil] context:nil].size.height;
        float bottomContentOffset = (textViewContentHeight - self.frame.size.height + self.contentInset.bottom);
        
		//float bottomContentOffset = (self.contentSize.height - self.frame.size.height + self.contentInset.bottom);
		if(s.y < bottomContentOffset && self.scrollEnabled) 
        {
			self.contentInset = UIEdgeInsetsMake(kTopContentInset, 0, 0, 0);
		}
	}
	[super setContentOffset:s];
}

-(void)setContentInset:(UIEdgeInsets)s
{
	UIEdgeInsets edgeInsets = s;
	edgeInsets.top = kTopContentInset;
	if(s.bottom > 12) 
    {
        edgeInsets.bottom = 4;
    }
	[super setContentInset:edgeInsets];
}
@end
