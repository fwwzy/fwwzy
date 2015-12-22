//
//  HemaEditorVC.h
//  Hema
//
//  Created by LarryRodic on 15/10/5.
//  Copyright (c) 2015年 Hemaapp. All rights reserved.
//

#import "AllVC.h"

typedef enum
{
    EditorTypeSinleInput = 0,
    EditorTypeNormalPick,//普通筛选
    EditorTypeTimePick,//时间筛选
    EditorTypeTwoPick,//左右选取时间
    EditorTypeYMDPick,//年月日时间筛选(出生日期)
}EditorType;

@protocol HemaEditorDelegate;
@interface HemaEditorVC : AllVC<UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
@property(nonatomic,assign)EditorType editorType;
@property(nonatomic,copy)NSString *key;//传过来的关键值
//普通输入的样式
@property(nonatomic,copy)NSString *content;//默认的内容
@property(nonatomic,copy)NSString *explanation;//说明文字 输入框下面的提示文字
@property(nonatomic,copy)NSString *placeholder;//如果内容为空的时候，输入框内的输入文字
@property(nonatomic,assign)NSInteger mymaxlength;//输入框的最大长度
@property(nonatomic,assign)UIKeyboardType keyBoardType;//输入框的键盘格式
//普通拾取器的样式
@property(nonatomic,strong)NSMutableArray *dataSource;//picker 数据源
//两个拾取器的样式
@property(nonatomic,strong)NSMutableArray *dataOne;//picker 数据源
@property(nonatomic,strong)NSMutableArray *dataTwo;//picker 数据源
@property(nonatomic,assign)NSObject<HemaEditorDelegate>* delegate;
@end

@protocol HemaEditorDelegate <NSObject>
-(void)HemaEditorOK:(HemaEditorVC*)editor backValue:(NSString*)value;
@end