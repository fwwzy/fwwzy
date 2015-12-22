//
//  HemaEditorVC.m
//  Hema
//
//  Created by LarryRodic on 15/10/5.
//  Copyright (c) 2015年 Hemaapp. All rights reserved.
//

#import "HemaEditorVC.h"

@interface HemaEditorVC ()
@property(nonatomic,strong)UIView *backView;//白色背景框
@property(nonatomic,strong)UITextField *myTextField;
@property(nonatomic,strong)UILabel *myLabel;//下面的提示语句
@property(nonatomic,strong)UIPickerView *myPicker;//选择器
@property(nonatomic,strong)UIDatePicker *myDatePicker;//时间筛选器
@property(nonatomic,strong)NSDateFormatter *myDateFormatter;//筛选样式

@property(nonatomic,copy)NSString *leftTime;
@property(nonatomic,copy)NSString *rightTime;
@property(nonatomic,strong)NSMutableArray *dataHere;//picker 数据源 中间值 供dataTwo变化用
@end

@implementation HemaEditorVC
@synthesize editorType;
@synthesize key;
@synthesize title;
@synthesize content;
@synthesize explanation;
@synthesize placeholder;
@synthesize mymaxlength;
@synthesize keyBoardType;
@synthesize dataSource;
@synthesize delegate;
@synthesize dataOne;
@synthesize dataTwo;

//私有的
@synthesize backView;
@synthesize myTextField;
@synthesize myLabel;
@synthesize myPicker;
@synthesize myDatePicker;
@synthesize myDateFormatter;
@synthesize dataHere;
@synthesize leftTime;
@synthesize rightTime;

-(void)loadSet
{
    //导航
    [self.navigationItem setNewTitle:title];
    [self.view setBackgroundColor:BB_Back_Color_Here];
    [self.navigationItem setRightItemWithTarget:self action:@selector(rightbtnPressed:) title:@"完成"];
    
    //白色背景
    self.backView = [[UIView alloc]init];
    backView.frame = CGRectMake(8, 10, UI_View_Width-16, 40);
    [backView setBackgroundColor:BB_White_Color];
    [HemaFunction addbordertoView:backView radius:1.0f width:1.f color:BB_Border_Color];
    [self.view addSubview:backView];
    
    //输入框
    self.myTextField = [[UITextField alloc]initWithFrame:CGRectMake(10, 5, UI_View_Width-36, 30)];
    myTextField.delegate = self;
    myTextField.placeholder = placeholder;
    myTextField.text = content;
    myTextField.keyboardType = self.keyBoardType;
    myTextField.returnKeyType = UIReturnKeyDone;
    myTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    myTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    myTextField.textAlignment = NSTextAlignmentLeft;
    myTextField.font = [UIFont systemFontOfSize:14];
    myTextField.textColor = [UIColor grayColor];
    [backView addSubview:myTextField];
    
    //提示语
    self.myLabel = [[UILabel alloc]init];
    myLabel.backgroundColor = [UIColor clearColor];
    myLabel.textAlignment = NSTextAlignmentRight;
    myLabel.font = [UIFont systemFontOfSize:12];
    myLabel.frame = CGRectMake(0, backView.frame.size.height+15, UI_View_Width-8, 14);
    myLabel.userInteractionEnabled = NO;
    myLabel.textColor = [UIColor grayColor];
    myLabel.text = explanation;
    [self.view addSubview:myLabel];
    
    if (EditorTypeSinleInput == editorType)
    {
        [myTextField becomeFirstResponder];
        [myPicker setHidden:YES];
    }
    if (EditorTypeNormalPick == editorType)
    {
        //选择器
        self.myPicker = [[UIPickerView alloc]init];
        myPicker.dataSource = self;
        myPicker.delegate = self;
        [myPicker reloadAllComponents];
        myPicker.showsSelectionIndicator = YES;
        myPicker.frame = CGRectMake(0.0f, UI_View_Height-216.0f, UI_View_Width, 216.0f);
        [self.view addSubview:myPicker];
        
        [myTextField setEnabled:NO];
        [myLabel setHidden:YES];
        for(int i = 0;i<dataSource.count;i++)
        {
            if([myTextField.text isEqualToString:[dataSource objectAtIndex:i]])
            {
                [myPicker selectRow:i inComponent:0 animated:NO];
                break;
            }
        }
    }
    if (EditorTypeTimePick == editorType)
    {
        //时间筛选器
        self.myDateFormatter = [[NSDateFormatter alloc] init];
        [myDateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        
        self.myDatePicker = [[UIDatePicker alloc]init];
        [myDatePicker setBackgroundColor:BB_White_Color];
        NSLocale * locale = [[NSLocale alloc] initWithLocaleIdentifier:@"Chinese"];
        [self.myDatePicker setLocale:locale];
        myDatePicker.minimumDate = [myDateFormatter dateFromString:[self getStringNow]];
        myDatePicker.datePickerMode = UIDatePickerModeDateAndTime;
        [myDatePicker setFrame:CGRectMake(0.0f, UI_View_Height-216, UI_View_Width, 216.0f)];
        [myDatePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
        [self.view addSubview:myDatePicker];
        
        [myTextField setEnabled:NO];
        [myLabel setHidden:YES];
        
        if (![HemaFunction xfunc_check_strEmpty:myTextField.text])
        {
            [myDatePicker setDate:[myDateFormatter dateFromString:myTextField.text] animated:NO];
        }else
        {
            [self dateChanged:nil];
        }
    }
    if (EditorTypeTwoPick == editorType)
    {
        //选择器
        self.myPicker = [[UIPickerView alloc]init];
        myPicker.dataSource = self;
        myPicker.delegate = self;
        [myPicker reloadAllComponents];
        myPicker.showsSelectionIndicator = YES;
        myPicker.frame = CGRectMake(0.0f, UI_View_Height-216.0f, UI_View_Width, 216.0f);
        [self.view addSubview:myPicker];
        
        BOOL isHave = NO;
        for(int i = 0;i<dataOne.count;i++)
        {
            for (int j = 0; j<dataTwo.count; j++)
            {
                if([myTextField.text isEqualToString:[NSString stringWithFormat:@"%@-%@",[dataOne objectAtIndex:i],[dataTwo objectAtIndex:j]]])
                {
                    leftTime = [dataOne objectAtIndex:i];
                    rightTime = [dataTwo objectAtIndex:j];
                    
                    NSMutableArray *dataTem = [[NSMutableArray alloc]init];
                    for (int z = i+1; z<self.dataHere.count; z++)
                    {
                        [dataTem addObject:[self.dataHere objectAtIndex:z]];
                    }
                    [self.dataTwo removeAllObjects];
                    [self.dataTwo addObjectsFromArray:dataTem];
                    
                    [myPicker selectRow:i inComponent:0 animated:NO];
                    [myPicker selectRow:(j-i) inComponent:1 animated:NO];
                    
                    isHave = YES;
                    break;
                }
            }
        }
        if (NO == isHave)
        {
            leftTime = [dataOne objectAtIndex:18];
            rightTime = [dataTwo objectAtIndex:33];
            myTextField.text = [NSString stringWithFormat:@"%@-%@",leftTime,rightTime];
            NSMutableArray *dataTem = [[NSMutableArray alloc]init];
            for (int z = 19; z<self.dataHere.count; z++)
            {
                [dataTem addObject:[self.dataHere objectAtIndex:z]];
            }
            [self.dataTwo removeAllObjects];
            [self.dataTwo addObjectsFromArray:dataTem];
            
            [myPicker selectRow:18 inComponent:0 animated:NO];
            [myPicker selectRow:15 inComponent:1 animated:NO];
        }
        myPicker.hidden = NO;
        myTextField.enabled = NO;
        [myPicker reloadComponent:1];
    }
    if (EditorTypeYMDPick == editorType)
    {
        //时间筛选器
        self.myDateFormatter = [[NSDateFormatter alloc] init];
        [myDateFormatter setDateFormat:@"yyyy-MM-dd"];
        
        self.myDatePicker = [[UIDatePicker alloc]init];
        [myDatePicker setBackgroundColor:BB_White_Color];
        NSLocale * locale = [[NSLocale alloc] initWithLocaleIdentifier:@"Chinese"];
        [self.myDatePicker setLocale:locale];
        myDatePicker.datePickerMode = UIDatePickerModeDate;
        
        //出生日期的设置
        myDatePicker.maximumDate = [myDateFormatter dateFromString:[self getStringNow]];
        myDatePicker.minimumDate = [myDateFormatter dateFromString:@"1900-01-01"];
        
        [myDatePicker setFrame:CGRectMake(0.0f, UI_View_Height-216, UI_View_Width, 216.0f)];
        [myDatePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
        [self.view addSubview:myDatePicker];
        
        [myTextField setEnabled:NO];
        [myLabel setHidden:YES];
        
        if (![HemaFunction xfunc_check_strEmpty:myTextField.text])
        {
            [myDatePicker setDate:[myDateFormatter dateFromString:myTextField.text] animated:NO];
        }else
        {
            [self dateChanged:nil];
        }
    }
}
-(void)loadData
{
    self.dataOne = [[NSMutableArray alloc]initWithObjects:@"00:00",@"00:30",@"01:00",@"01:30",@"02:00",@"02:30",@"03:00",@"03:30",@"04:00",@"04:30",@"05:00",@"05:30",@"06:00",@"06:30",@"07:00",@"07:30",@"08:00",@"08:30",@"09:00",@"09:30",@"10:00",@"10:30",@"11:00",@"11:30",@"12:00",@"12:30",@"13:00",@"13:30",@"14:00",@"14:30",@"15:00",@"15:30",@"16:00",@"16:30",@"17:00",@"17:30",@"18:00",@"18:30",@"19:00",@"19:30",@"20:00",@"20:30",@"21:00",@"21:30",@"22:00",@"22:30",@"23:00",@"23:30", nil];
    self.dataTwo = [[NSMutableArray alloc]initWithObjects:@"00:30",@"01:00",@"01:30",@"02:00",@"02:30",@"03:00",@"03:30",@"04:00",@"04:30",@"05:00",@"05:30",@"06:00",@"06:30",@"07:00",@"07:30",@"08:00",@"08:30",@"09:00",@"09:30",@"10:00",@"10:30",@"11:00",@"11:30",@"12:00",@"12:30",@"13:00",@"13:30",@"14:00",@"14:30",@"15:00",@"15:30",@"16:00",@"16:30",@"17:00",@"17:30",@"18:00",@"18:30",@"19:00",@"19:30",@"20:00",@"20:30",@"21:00",@"21:30",@"22:00",@"22:30",@"23:00",@"23:30",@"24:00", nil];
    self.dataHere = [[NSMutableArray alloc]initWithObjects:@"00:00",@"00:30",@"01:00",@"01:30",@"02:00",@"02:30",@"03:00",@"03:30",@"04:00",@"04:30",@"05:00",@"05:30",@"06:00",@"06:30",@"07:00",@"07:30",@"08:00",@"08:30",@"09:00",@"09:30",@"10:00",@"10:30",@"11:00",@"11:30",@"12:00",@"12:30",@"13:00",@"13:30",@"14:00",@"14:30",@"15:00",@"15:30",@"16:00",@"16:30",@"17:00",@"17:30",@"18:00",@"18:30",@"19:00",@"19:30",@"20:00",@"20:30",@"21:00",@"21:30",@"22:00",@"22:30",@"23:00",@"23:30",@"24:00", nil];
}
#pragma mark- 自定义
#pragma mark 事件
-(void)rightbtnPressed:(id)sender
{
    [self okGoback];
}
//点击完成
-(void)okGoback
{
    NSString *temStr = myTextField.text;
    if (temStr.wordsCount >= mymaxlength)
    {
        [UIWindow showToastMessage:@"字数太长，请限制！"];
        return;
    }
    [delegate HemaEditorOK:self backValue:temStr];
    [self.navigationController popViewControllerAnimated:YES];
}
- (NSString*)getStringNow
{
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateStr = [dateFormatter stringFromDate:date];
    return dateStr;
}
#pragma mark 时间选择
-(void)dateChanged:(id)sender
{
    NSDate *selected = [myDatePicker date];
    NSString *destDateString = [myDateFormatter stringFromDate:selected];
    [myTextField setText:destDateString];
    if (EditorTypeYMDPick == editorType)
    {
        return;
    }
}
#pragma mark - Touch delegate
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}
#pragma mark - UITextField Delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [myTextField resignFirstResponder];
    [self okGoback];
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
}
#pragma mark- UIPickerView Datasource
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if (editorType == EditorTypeTwoPick)
    {
        return 2;
    }
    return 1;
}
-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (editorType == EditorTypeTwoPick)
    {
        if (0 == component)
        {
            return dataOne.count;
        }
        if (1 == component)
        {
            return dataTwo.count;
        }
    }
    return dataSource.count;
}
-(NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (editorType == EditorTypeTwoPick)
    {
        if (0 == component)
        {
            return [dataOne objectAtIndex:row];
        }
        if (1 == component)
        {
            return [dataTwo objectAtIndex:row];
        }
    }
    return [dataSource objectAtIndex:row];
}
#pragma mark- UIPickerView Delegate
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (editorType == EditorTypeTwoPick)
    {
        if (0 == component)
        {
            self.leftTime = [dataOne objectAtIndex:row];
            NSMutableArray *dataTem = [[NSMutableArray alloc]init];
            for (int i = (int)(row+1); i<self.dataHere.count; i++)
            {
                [dataTem addObject:[self.dataHere objectAtIndex:i]];
            }
            [self.dataTwo removeAllObjects];
            [self.dataTwo addObjectsFromArray:dataTem];
            [pickerView selectRow:0 inComponent:1 animated:NO];
            self.rightTime = [dataTwo objectAtIndex:0];
            [pickerView reloadComponent:1];
        }
        if (1 == component)
        {
            self.rightTime = [dataTwo objectAtIndex:row];
        }
        myTextField.text = [NSString stringWithFormat:@"%@-%@",leftTime,rightTime];
        return;
    }
    myTextField.text = [dataSource objectAtIndex:row];
    
}

@end
