//
//  HemaTextView.m
//  Hema
//
//  Created by LarryRodic on 15/10/7.
//  Copyright (c) 2015年 Hemaapp. All rights reserved.
//

#import "HemaTextView.h"

@implementation HemaTextView
@synthesize placeHolderLabel;
@synthesize placeholder;
@synthesize placeholderColor;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setPlaceholder:@""];
        [self setPlaceholderColor:[UIColor lightGrayColor]];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:nil];
    }
    
    //键盘上的确定view
    UIView *okView = [[UIView alloc]init];
    [okView setFrame:CGRectMake(0, 0, UI_View_Width, 40)];
    okView.backgroundColor = BB_Back_Color_Here_Bar;
    self.inputAccessoryView = okView;
    
    HemaButton *okBtn = [HemaButton buttonWithType:UIButtonTypeCustom];
    [okBtn setFrame:CGRectMake(UI_View_Width-60, 0, 60, 40)];
    [okBtn setTitle:@"确定" forState:UIControlStateNormal];
    [okBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [okBtn setTitleColor:BB_Blake_Color forState:UIControlStateNormal];
    [okBtn addTarget:self action:@selector(textOkBtn:) forControlEvents:UIControlEventTouchUpInside];
    [okView addSubview:okBtn];
    
    //横线
    UIView *textline = [[UIView alloc]init];
    [textline setFrame:CGRectMake(0, 0, UI_View_Width, 0.5)];
    [textline setBackgroundColor:BB_lineColor];
    [okView addSubview:textline];
    
    return self;
}
//取消键盘
-(void)textOkBtn:(id)sender
{
    [self resignFirstResponder];
}
- (void)textChanged:(NSNotification*)notification
{
    if(0 == [[self placeholder] length])
        return;
    if(0 == [[self text] length])
        [[self viewWithTag:999] setAlpha:1.0f];
    else
        [[self viewWithTag:999] setAlpha:0.0f];
}
- (void)setText:(NSString *)text
{
    [super setText:text];
    [self textChanged:nil];
}
- (void)drawRect:(CGRect)rect
{
    if([[self placeholder] length]>0)
    {
        if(!placeHolderLabel)
        {
            placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 7, self.bounds.size.width - 10, 0)];
            placeHolderLabel.lineBreakMode = NSLineBreakByWordWrapping;
            placeHolderLabel.numberOfLines = 0;
            placeHolderLabel.font = self.font;
            placeHolderLabel.textColor = self.placeholderColor;
            placeHolderLabel.alpha = 0;
            placeHolderLabel.tag = 999;
            placeHolderLabel.backgroundColor = [UIColor clearColor];
            [self addSubview:placeHolderLabel];
        }
        placeHolderLabel.text = self.placeholder;
        [placeHolderLabel sizeToFit];
        [self sendSubviewToBack:placeHolderLabel];
    }
    if(0 == [[self text] length]&&[[self placeholder] length] > 0)
    {
        [[self viewWithTag:999] setAlpha:1.0f];
    }
    [super drawRect:rect];
}

@end
