//
//  HemaReplyVC.m
//  Hema
//
//  Created by LarryRodic on 15/10/7.
//  Copyright (c) 2015年 Hemaapp. All rights reserved.
//

#import "HemaReplyVC.h"
#import "HemaTextView.h"

@interface HemaReplyVC ()<UITextViewDelegate>
@property(nonatomic,strong)HemaTextView *mytextView;//输入框
@end

@implementation HemaReplyVC

-(void)loadSet
{
    [self.navigationItem setNewTitle:_titleName];
    [self.navigationItem setRightItemWithTarget:self action:@selector(rightbtnPressed:) title:@"确定"];
    
    //白色背景
    UIView *backView = [[UIView alloc]init];
    backView.frame = CGRectMake(0, 0, UI_View_Width, UI_View_Height-290);
    [HemaFunction addbordertoView:backView radius:1.0f width:1.0f color:BB_Border_Color];
    [backView setBackgroundColor:BB_White_Color];
    [self.view addSubview:backView];
    
    //输入框
    _mytextView = [[HemaTextView alloc]initWithFrame:CGRectMake(5, 5, UI_View_Width-10, backView.height-10)];
    _mytextView.font = [UIFont systemFontOfSize:14];
    _mytextView.backgroundColor = [UIColor clearColor];
    _mytextView.textAlignment = NSTextAlignmentLeft;
    _mytextView.textColor = BB_Gray_Color;
    _mytextView.delegate = self;
    [backView addSubview:_mytextView];
    
    _mytextView.text = _publishContent;
    _mytextView.placeholder = _placeholder;
}
#pragma mark- 自定义
#pragma mark 事件
-(void)leftbtnPressed:(id)sender
{
    [_mytextView resignFirstResponder];
    if (self.navigationController.viewControllers.count == 1)
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
-(void)rightbtnPressed:(id)sender
{
    if (!isCanNull)
    {
        if (_mytextView.text.length == 0)
        {
            [HemaFunction openIntervalHUD:@"文本框不能为空"];
            return;
        }
    }
    [_delegate HemaReplyOK:self content:_mytextView.text];
    [self leftbtnPressed:nil];
}
#pragma mark- UITextViewDelegate
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_mytextView resignFirstResponder];
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    return YES;
}
@end
