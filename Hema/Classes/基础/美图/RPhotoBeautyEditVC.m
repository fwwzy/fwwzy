//
//  RPhotoBeautyEditVC.m
//  Hema
//
//  Created by geyang on 15/11/17.
//  Copyright © 2015年 Hemaapp. All rights reserved.
//

#import "RPhotoBeautyEditVC.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "CMPopTipView.h"
#import "HemaLongGR.h"
#import "HemaTapGR.h"
#import "YcKeyBoardView.h"
#import "CLTextView.h"
#import "JGActionSheet.h"
#import "InfColorPickerController.h"
#import "KxMenu.h"
#import "StickerView.h"
#import "MeituImageEditView.h"
#import "GLStoryboardSelectView.h"
#import "RGetFontListVC.h"
#import "RPhotoBeautyShareVC.h"
#import "RPhotoBeautyChangeVC.h"

typedef NS_ENUM(NSUInteger, ScrollViewStatus)
{
    kPuzzleScrollView = 0,
    kBorderScrollView,
    kStickerScrollView,
    kFaceScrollView,
    kFilterScrollView,
};//底部哪个弹框的枚举类型

@interface RPhotoBeautyEditVC ()<YcKeyBoardViewDelegate,InfColorPickerControllerDelegate,MeituImageEditViewDelegate,GLStoryboardSelectViewDelegate>
{
    BOOL isNewText;///<是否是新的文字添加
    NSInteger selectStoryBoardStyleIndex;//选择的底部拼图的样式
}
@property(nonatomic,strong)UIScrollView *contentView;///<中间内容
@property(nonatomic,strong)UIImageView *freeBgView;///<背景颜色
@property(nonatomic,strong)UIImageView *bringPosterView;///<边框
@property(nonatomic,strong)YcKeyBoardView *keyboard;///<输入文字的输入框
@property(nonatomic,strong)CLTextView *selectedTextView;///<被选中的文字
@property(nonatomic,strong)UIColor *color;///<被选中的文字的颜色
@property(nonatomic,strong)UIColor *selectedBoardColor;///<被选中的边框的颜色

@property(nonatomic,strong)UIScrollView *bottomControlView;///<底部菜单点击出现的选择栏
@property(nonatomic,strong)UIView *bottomView;///<底部栏
@property(nonatomic,strong)HemaButton *selectControlButton;///<底部已选中的按钮
@property(nonatomic,strong)CMPopTipView *popTipView;///<提示框
@property(nonatomic,strong)HemaButton *editBtn;///<编辑按钮->添加与删除
@property(nonatomic,strong)HemaButton *inforBtn;///<说明按钮->说明有啥子功能

@property(nonatomic,strong)GLStoryboardSelectView *storyboardView;///<拼图弹框样式
@property(nonatomic,strong)GLStoryboardSelectView *borderView;///<边框弹框样式
@property(nonatomic,strong)GLStoryboardSelectView *stickerView;///<装饰弹框样式
@property(nonatomic,strong)GLStoryboardSelectView *faceView;///<变脸弹框样式
@property(nonatomic,strong)GLStoryboardSelectView *filterView;///<滤镜弹框样式
@end

@implementation RPhotoBeautyEditVC

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    _popTipView = nil;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    LCPanNavigationController *nav = (LCPanNavigationController*)self.navigationController;
    [nav.panGestureRecognizer setEnabled:NO];
}
-(void)viewWillDisappear:(BOOL)animated
{
    LCPanNavigationController *nav = (LCPanNavigationController*)self.navigationController;
    [nav.panGestureRecognizer setEnabled:YES];
    [super viewWillDisappear:animated];
}
-(void)loadSet
{
    [self.navigationItem setNewTitle:@"图片特效"];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"R美图背景.png"]];
    [self.navigationItem setRightItemWithTarget:self action:@selector(rightbtnPressed:) title:@"预览"];
    
    [self initMiddleContentView];
    [self initToolbarView];
    [self resetViewByStyleIndex:1 imageCount:[_dataImg count]];
    
    //通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(activeTextViewDidChange:) name:CLTextViewActiveViewDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(activeTextViewDidTap:) name:CLTextViewActiveViewDidTapNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(activeTextViewDidDoubleTap:) name:CLTextViewActiveViewDidDoubleTapNotification object:nil];
}
-(void)loadData
{
    isNewText = YES;
    _color = BB_Red_Color;
}
//创建中间内容
-(void)initMiddleContentView
{
    _contentView = [[UIScrollView alloc]init];
    [_contentView setUserInteractionEnabled:YES];
    [self contentResetSizeWithCalc];
    [self.view addSubview:_contentView];
    
    //背景颜色
    _freeBgView = [[UIImageView alloc] initWithFrame:_contentView.bounds];
    [_freeBgView setBackgroundColor:BB_White_Color];
    [_contentView addSubview:_freeBgView];
    
    //边框
    _bringPosterView = [[UIImageView alloc] initWithFrame:_contentView.bounds];
    [_bringPosterView setBackgroundColor:[UIColor clearColor]];
    [_contentView addSubview:_bringPosterView];
    
    //长按手势
    HemaLongGR *gesture = [[HemaLongGR alloc] initWithTarget: self action: @selector(longPressed:)];
    gesture.minimumPressDuration = 0.8;
    [_contentView addGestureRecognizer:gesture];
}
//创建底部
-(void)initToolbarView
{
    //编辑按钮
    _editBtn = [HemaButton buttonWithType:UIButtonTypeCustom];
    [_editBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [_editBtn setTitle:@"添加/删除" forState:UIControlStateNormal];
    [_editBtn setFrame:CGRectMake((UI_View_Width-75)/2, UI_View_Height-70, 75, 30)];
    [_editBtn setBackgroundColor:RGB_UI_COLOR(244, 122, 117)];
    [HemaFunction addbordertoView:_editBtn radius:15 width:0 color:[UIColor clearColor]];
    [_editBtn addTarget:self action:@selector(editPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_editBtn];
    
    //说明按钮
    _inforBtn = [HemaButton buttonWithType:UIButtonTypeCustom];
    [_inforBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [_inforBtn setTitle:@"说明" forState:UIControlStateNormal];
    [_inforBtn setFrame:CGRectMake(UI_View_Width-65, UI_View_Height-70, 45, 30)];
    [_inforBtn setBackgroundColor:RGB_UI_COLOR(249, 129, 2)];
    [HemaFunction addbordertoView:_inforBtn radius:15 width:0 color:[UIColor clearColor]];
    [_inforBtn addTarget:self action:@selector(inforPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_inforBtn];
    
    //提示框
    _popTipView = [[CMPopTipView alloc] initWithMessage:@"点击开始"];
    _popTipView.textColor = [UIColor randomColor];
    _popTipView.backgroundColor = [UIColor randomColor];
    _popTipView.preferredPointDirection = PointDirectionDown;
    _popTipView.animation = arc4random() % 2;
    _popTipView.has3DStyle = FALSE;
    _popTipView.dismissTapAnywhere = YES;
    [_popTipView autoDismissAnimated:YES atTimeInterval:3.0];
    
    //底部菜单点击出现的选择栏
    _bottomControlView = [[UIScrollView alloc]init];
    [_bottomControlView setFrame:CGRectMake(0, UI_View_Height-83, UI_View_Width, 50)];
    [_bottomControlView setContentSize:CGSizeMake(_bottomControlView.width *2, _bottomControlView.height)];
    [_bottomControlView setPagingEnabled:YES];
    [_bottomControlView setScrollEnabled:NO];
    [_bottomControlView setHidden:YES];
    [self.view addSubview:_bottomControlView];
    
    [GLStoryboardSelectView getDefaultFilelist];
    [self initStoryboardView];
    [self initBorderView];
    [self initStickerView];
    [self initFaceView];
    [self initFilterView];
    
    //底部栏
    _bottomView = [[UIView alloc]init];
    [_bottomView setFrame:CGRectMake(0, UI_View_Height-33, UI_View_Width, 33)];
    [_bottomView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"R美图底部栏.png"]]];
    [self.view addSubview:_bottomView];
    
    NSMutableArray *nameArr = [[NSMutableArray alloc]initWithObjects:@"拼图",@"边框",@"装饰",@"变脸",@"滤镜",nil];
    for (int i = 0; i<5; i++)
    {
        HemaButton *editBtn = [HemaButton buttonWithType:UIButtonTypeCustom];
        editBtn.btnRow = i;
        editBtn.tag = 10+i;
        [editBtn.titleLabel setFont:[UIFont systemFontOfSize:18]];
        [editBtn setTitle:nameArr[i] forState:UIControlStateNormal];
        [editBtn setTitleColor:BB_Blue_Color forState:UIControlStateNormal];
        [editBtn setFrame:CGRectMake(_bottomView.width/5*i, 0, _bottomView.width/5,_bottomView.height)];
        [editBtn addTarget:self action:@selector(bottomViewPressed:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:editBtn];
        
        if (0 == i)
        {
            if (_dataImg.count > 1)
            {
                _selectControlButton = editBtn;
                [editBtn setTitleColor:BB_Red_Color forState:UIControlStateNormal];
                [_popTipView presentPointingAtView:editBtn inView:self.view animated:YES];
            }
        }
        if (1 == i)
        {
            if (_dataImg.count == 1)
            {
                _selectControlButton = editBtn;
                [editBtn setTitleColor:BB_Red_Color forState:UIControlStateNormal];
                [_popTipView presentPointingAtView:editBtn inView:self.view animated:YES];
            }
        }
    }
}
//创建输入框
- (void)initKeyboard
{
    int texViewtHeight = 44;
    if(_keyboard == nil)
    {
        _keyboard = [[YcKeyBoardView alloc] initWithFrame:CGRectMake(0, UI_View_Height - texViewtHeight, UI_View_Width, texViewtHeight)];
    }
    _keyboard.delegate = self;
    [_keyboard.textView becomeFirstResponder];
    _keyboard.textView.returnKeyType = UIReturnKeyDone;
    if (_selectedTextView)
    {
        _keyboard.textView.text = _selectedTextView.text;
    }
    [self.view addSubview:_keyboard];
}
//创建拼图弹框样式
- (void)initStoryboardView
{
    _storyboardView = [[GLStoryboardSelectView alloc] initWithFrameFromPuzzle:CGRectMake(0, 0, _bottomControlView.width,_bottomControlView.height) picCount:[_dataImg count]];
    [_storyboardView setBackgroundColor:[[UIColor redColor] colorWithAlphaComponent:0.5]];
    _storyboardView.delegateSelect = self;
    [_bottomControlView addSubview:_storyboardView];
}
//创建边框弹框样式
- (void)initBorderView
{
    _borderView = [[GLStoryboardSelectView alloc] initWithFrameFromBorder:CGRectMake(0, 0, _bottomControlView.width,_bottomControlView.height)];
    [_borderView setBackgroundColor:[[UIColor redColor] colorWithAlphaComponent:0.5]];
    _borderView.delegateSelect = self;
    [_bottomControlView addSubview:_borderView];
}
//创建装饰弹框样式
- (void)initStickerView
{
    _stickerView = [[GLStoryboardSelectView alloc] initWithFrameFromSticker:CGRectMake(0, 0, _bottomControlView.width,_bottomControlView.height)];
    [_stickerView setBackgroundColor:[[UIColor redColor] colorWithAlphaComponent:0.5]];
    _stickerView.delegateSelect = self;
    [_bottomControlView addSubview:_stickerView];
}
//创建变脸弹框样式
- (void)initFaceView
{
    _faceView = [[GLStoryboardSelectView alloc] initWithFrameFromFace:CGRectMake(0, 0, _bottomControlView.width,_bottomControlView.height)];
    [_faceView setBackgroundColor:[[UIColor redColor] colorWithAlphaComponent:0.5]];
    _faceView.delegateSelect = self;
    [_bottomControlView addSubview:_faceView];
}
//创建滤镜弹框样式
- (void)initFilterView
{
    _filterView = [[GLStoryboardSelectView alloc] initWithFrameFromFilter:CGRectMake(0, 0, _bottomControlView.width,_bottomControlView.height)];
    [_filterView setBackgroundColor:[[UIColor redColor] colorWithAlphaComponent:0.5]];
    _filterView.delegateSelect = self;
    [_bottomControlView addSubview:_filterView];
}
#pragma mark- 自定义
#pragma mark 事件
//预览
-(void)rightbtnPressed:(id)sender
{
    RPhotoBeautyShareVC *myVC = [[RPhotoBeautyShareVC alloc]init];
    myVC.image = [_contentView screenshot];
    [self.navigationController pushViewController:myVC animated:YES];
}
//编辑按钮
-(void)editPressed:(HemaButton*)sender
{
    NSMutableArray *temDataImg = [[NSMutableArray alloc]init];
    NSMutableArray *temAssets = [[NSMutableArray alloc]init];
    for (int i = 0; i<_dataImg.count; i++)
    {
        [temDataImg addObject:[_dataImg objectAtIndex:i]];
        [temAssets addObject:[_assets objectAtIndex:i]];
    }
    
    RPhotoBeautyChangeVC *myVC = [[RPhotoBeautyChangeVC alloc]init];
    myVC.dataImg = temDataImg;
    myVC.assets = temAssets;
    myVC.PhotoBeautyChangeOK = ^(NSMutableArray *dataImg,NSMutableArray *assets)
    {
        _dataImg = dataImg;
        _assets = assets;
        [self hiddenStoryboardAndPoster];
        [self contentRemoveView];
        _storyboardView.picCount = dataImg.count;
        [_storyboardView resetStoryBoradImg];
        selectStoryBoardStyleIndex = 1;
        [self resetViewByStyleIndex:selectStoryBoardStyleIndex imageCount:[_dataImg count]];
    };
    LCPanNavigationController *nav = [[LCPanNavigationController alloc]initWithRootViewController:myVC];
    [self presentViewController:nav animated:YES completion:nil];
}
//说明按钮
-(void)inforPressed:(HemaButton*)sender
{
    NSString *myStr = @"谢天谢地，你可终于点击了啊！";
    NSString *detail = @"首先，长按可以输入文字，你造么？\n再者，单击文字可编辑其内容，你肯定不造！\n还有，双击文字还能改变其样式风格呢，懵逼了吧~\n哈哈，再见！";
    [[[MMAlertView alloc] initWithConfirmTitle:myStr detail:detail] showWithBlock:nil];
}
//底部栏点击
-(void)bottomViewPressed:(HemaButton*)sender
{
    if (sender.btnRow == 0)
    {
        if (_dataImg.count == 1)
        {
            [UIWindow showToastMessage:@"一张图片怎么可能让你拼图，也不动动脑子想想！"];
            return;
        }
    }
    
    [self showScrollView:sender.btnRow];
    [self contentResetSizeWithCalc];
    
    switch (sender.btnRow)
    {
        case 0:
        {
            if (_selectControlButton.btnRow != 0)
            {
                _freeBgView.image = nil;
                _freeBgView.backgroundColor = _selectedBoardColor?_selectedBoardColor:[UIColor whiteColor];
                [self contentRemoveView];
                [self resetViewByStyleIndex:selectStoryBoardStyleIndex imageCount:_dataImg.count];
                [_bringPosterView setHidden:NO];
            }
            break;
        }
        case 1:
        {
            if (_selectControlButton.btnRow != 1)
            {
                _freeBgView.image = nil;
                _freeBgView.backgroundColor = _selectedBoardColor?_selectedBoardColor:[UIColor whiteColor];
                [_bringPosterView setHidden:NO];
            }
            break;
        }
        case 2:
        {
            if (_selectControlButton.btnRow != 2)
            {
                _freeBgView.image = nil;
                _freeBgView.backgroundColor = _selectedBoardColor?_selectedBoardColor:[UIColor whiteColor];
            }
            break;
        }
        case 3:
        {
            if (_selectControlButton.btnRow != 3)
            {
                _freeBgView.image = nil;
                _freeBgView.backgroundColor = _selectedBoardColor?_selectedBoardColor:[UIColor whiteColor];
                [_bringPosterView setHidden:NO];
            }
            break;
        }
        case 4:
        {
            if (_selectControlButton.btnRow != 4)
            {
                _freeBgView.image = nil;
                _freeBgView.backgroundColor = _selectedBoardColor?_selectedBoardColor:[UIColor whiteColor];
                [_bringPosterView setHidden:NO];
            }
            break;
        }
        default:
            break;
    }
    _bottomControlView.contentOffset = CGPointMake(0, 0);
    [self showStoryboardAndPoster];
    
    [_selectControlButton setTitleColor:BB_Blue_Color forState:UIControlStateNormal];
    [sender setTitleColor:BB_Red_Color forState:UIControlStateNormal];
    _selectControlButton = sender;
}
//长按中间
-(void)longPressed:(HemaLongGR*)sender
{
    if (sender.state == UIGestureRecognizerStateBegan)
    {
        [self initKeyboard];
        isNewText = YES;
    }
}
//单击中间内容
-(void)tapImageView:(HemaTapGR*)sender
{
    [self hideMiddleEditView];
}
//选择特效
-(void)pushMenuItem:(KxMenuItem*)sender
{
    if ([sender.title isEqualToString:@"默认"])
    {
        _selectedTextView.labelStyle = kDefault;
    }
    if ([sender.title isEqualToString:@"阴影"])
    {
        _selectedTextView.labelStyle = kShadow;
    }
    if ([sender.title isEqualToString:@"浮雕"])
    {
        _selectedTextView.labelStyle = kInnerShadow;
    }
    if ([sender.title isEqualToString:@"渐变"])
    {
        _selectedTextView.labelStyle = kGradientFill;
    }
    if ([sender.title isEqualToString:@"彩虹"])
    {
        _selectedTextView.labelStyle = kMultiPartGradient;
    }
    if ([sender.title isEqualToString:@"浮云"])
    {
        _selectedTextView.labelStyle = kSynthesis;
    }
    if ([sender.title isEqualToString:@"还原"])
    {
        [_selectedTextView clearLabelStyle];
    }
}
//重写选中的文本的方法
- (void)setSelectedTextView:(CLTextView *)selectedTextView
{
    if(selectedTextView != _selectedTextView)
    {
        _selectedTextView = selectedTextView;
    }
}
#pragma mark 方法
//根据底部拼图样式进行重新布局
- (void)resetViewByStyleIndex:(NSInteger)index imageCount:(NSInteger)count
{
    @synchronized(self)
    {
        selectStoryBoardStyleIndex = index;
        NSString *picCountFlag = @"";
        NSString *styleIndex = @"";
        
        if ([_dataImg count] == 1)
        {
            UIImage *image = [_dataImg objectAtIndex:0];
            
            CGRect rect = CGRectZero;
            rect.origin.x = 0;
            rect.origin.y = 0;
            CGFloat height = image.size.height;
            CGFloat width = image.size.width;
            if (width > _contentView.frame.size.width)
            {
                rect.size.width = _contentView.frame.size.width;
                rect.size.height = height*(_contentView.frame.size.width /width);
            }else
            {
                rect.size.width = width;
                rect.size.height = height;
            }
            rect.origin.x = (_contentView.frame.size.width - rect.size.width)/2.0f;
            if (rect.size.height < _contentView.frame.size.height)
            {
                rect.origin.y = (_contentView.frame.size.height - rect.size.height)/2.0f;
            }
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:rect];
            [imageView setClipsToBounds:YES];
            [imageView setBackgroundColor:[UIColor grayColor]];
            [imageView setImage:image];
            
            imageView.userInteractionEnabled = YES;
            HemaTapGR *singleTap = [[HemaTapGR alloc]initWithTarget:self action:@selector(tapImageView:)];
            [imageView addGestureRecognizer:singleTap];
            
            [_contentView addSubview:imageView];
            imageView = nil;
        }else
        {
            switch (count)
            {
                case 2:
                    picCountFlag = @"two";
                    break;
                case 3:
                    picCountFlag = @"three";
                    break;
                case 4:
                    picCountFlag = @"four";
                    break;
                case 5:
                    picCountFlag = @"five";
                    break;
                default:
                    break;
            }
            switch (index)
            {
                case 1:
                    styleIndex = @"1";
                    break;
                case 2:
                    styleIndex = @"2";
                    break;
                case 3:
                    styleIndex = @"3";
                    break;
                case 4:
                    styleIndex = @"4";
                    break;
                case 5:
                    styleIndex = @"5";
                    break;
                case 6:
                    styleIndex = @"6";
                    break;
                default:
                    break;
            }
            
            NSString *styleName = [NSString stringWithFormat:@"number_%@_style_%@.plist",picCountFlag,styleIndex];
            NSDictionary *styleDict = [NSDictionary dictionaryWithContentsOfFile:
                                       [[NSBundle mainBundle].resourcePath stringByAppendingPathComponent:styleName]];
            if (styleDict)
            {
                CGSize superSize = CGSizeFromString([[styleDict objectForKey:@"SuperViewInfo"] objectForKey:@"size"]);
                superSize = [self sizeScaleWithSize:superSize scale:2.0f];
                
                NSArray *subViewArray = [styleDict objectForKey:@"SubViewArray"];
                for(int j = 0; j < [subViewArray count]; j++)
                {
                    CGRect rect = CGRectZero;
                    UIBezierPath *path = nil;
                    UIImage *image = [_dataImg objectAtIndex:j];
                    
                    NSDictionary *subDict = [subViewArray objectAtIndex:j];
                    if([subDict objectForKey:@"frame"])
                    {
                        rect = CGRectFromString([subDict objectForKey:@"frame"]);
                        rect = [self rectScaleWithRect:rect scale:2.0f];
                        rect.origin.x = rect.origin.x * _contentView.frame.size.width/superSize.width;
                        rect.origin.y = rect.origin.y * _contentView.frame.size.height/superSize.height;
                        rect.size.width = rect.size.width * _contentView.frame.size.width/superSize.width;
                        rect.size.height = rect.size.height * _contentView.frame.size.height/superSize.height;
                    }
                    
                    rect = [self rectWithArray:[subDict objectForKey:@"pointArray"] andSuperSize:superSize];
                    if ([subDict objectForKey:@"pointArray"])
                    {
                        NSArray *pointArray = [subDict objectForKey:@"pointArray"];
                        path = [UIBezierPath bezierPath];
                        if (pointArray.count > 2)
                        {
                            // 当点的数量大于2个的时候
                            for(int i = 0; i < [pointArray count]; i++)
                            {
                                NSString *pointString = [pointArray objectAtIndex:i];
                                if (pointString)
                                {
                                    CGPoint point = CGPointFromString(pointString);
                                    point = [self pointScaleWithPoint:point scale:2.0f];
                                    point.x = (point.x)*_contentView.frame.size.width/superSize.width -rect.origin.x;
                                    point.y = (point.y)*_contentView.frame.size.height/superSize.height -rect.origin.y;
                                    if (i == 0)
                                    {
                                        [path moveToPoint:point];
                                    }
                                    else
                                    {
                                        [path addLineToPoint:point];
                                    }
                                }
                            }
                        }else
                        {
                            [path moveToPoint:CGPointMake(0, 0)];
                            [path addLineToPoint:CGPointMake(rect.size.width, 0)];
                            [path addLineToPoint:CGPointMake(rect.size.width, rect.size.height)];
                            [path addLineToPoint:CGPointMake(0, rect.size.height)];
                        }
                        [path closePath];
                    }
                    MeituImageEditView *imageView = [[MeituImageEditView alloc] initWithFrame:rect];
                    [imageView setClipsToBounds:YES];
                    [imageView setBackgroundColor:[UIColor grayColor]];
                    imageView.tag = j;
                    imageView.realCellArea = path;
                    imageView.tapDelegate = self;
                    [imageView setImageViewData:image];
                    
                    [_contentView addSubview:imageView];
                    imageView = nil;
                }
            }
        }
        [_contentView bringSubviewToFront:_bringPosterView];
        _contentView.contentSize = _contentView.frame.size;
        _bringPosterView.frame = CGRectMake(0, 0, _contentView.contentSize.width, _contentView.contentSize.height);
        
        [self bringSelectableViewToFront];
    }
}
//把选中的索引放在最上面
- (void)bringSelectableViewToFront
{
    for (UIView *subView in _contentView.subviews)
    {
        if ([subView isKindOfClass:[StickerView class]] || [subView isKindOfClass:[CLTextView class]])
        {
            [_contentView bringSubviewToFront:subView];
        }
    }
}
//三种scale方式
- (CGRect)rectScaleWithRect:(CGRect)rect scale:(CGFloat)scale
{
    if (scale <= 0)
    {
        scale = 1.0f;
    }
    
    CGRect retRect = CGRectZero;
    retRect.origin.x = rect.origin.x/scale;
    retRect.origin.y = rect.origin.y/scale;
    retRect.size.width = rect.size.width/scale;
    retRect.size.height = rect.size.height/scale;
    return  retRect;
}
- (CGPoint)pointScaleWithPoint:(CGPoint)point scale:(CGFloat)scale
{
    if (scale <= 0)
    {
        scale = 1.0f;
    }
    CGPoint retPointt = CGPointZero;
    retPointt.x = point.x/scale;
    retPointt.y = point.y/scale;
    return  retPointt;
}
- (CGSize)sizeScaleWithSize:(CGSize)size scale:(CGFloat)scale
{
    if (scale <= 0)
    {
        scale = 1.0f;
    }
    CGSize retSize = CGSizeZero;
    retSize.width = size.width/scale;
    retSize.height = size.height/scale;
    return  retSize;
}
//通过点得数组等获得位置
- (CGRect)rectWithArray:(NSArray *)array andSuperSize:(CGSize)superSize
{
    CGRect rect = CGRectZero;
    CGFloat minX = INT_MAX;
    CGFloat maxX = 0;
    CGFloat minY = INT_MAX;
    CGFloat maxY = 0;
    for (int i = 0; i < [array count]; i++)
    {
        NSString *pointString = [array objectAtIndex:i];
        CGPoint point = CGPointFromString(pointString);
        if (point.x <= minX)
        {
            minX = point.x;
        }
        
        if (point.x >= maxX)
        {
            maxX = point.x;
        }
        
        if (point.y <= minY)
        {
            minY = point.y;
        }
        
        if (point.y >= maxY)
        {
            maxY = point.y;
        }
        rect = CGRectMake(minX, minY, maxX - minX, maxY - minY);
    }
    rect = [self rectScaleWithRect:rect scale:2.0f];
    rect.origin.x = rect.origin.x * _contentView.frame.size.width/superSize.width;
    rect.origin.y = rect.origin.y * _contentView.frame.size.height/superSize.height;
    rect.size.width = rect.size.width * _contentView.frame.size.width/superSize.width;
    rect.size.height = rect.size.height * _contentView.frame.size.height/superSize.height;
    
    return rect;
}
//获取中间内容的尺寸
- (CGSize)calcContentSize
{
    CGFloat size_width = UI_View_Width;
    CGFloat size_height = size_width * 4 /3.0f;
    if (size_height >= (UI_View_Height-34))
    {
        size_height = UI_View_Height- 34;
        size_width = size_height * 3/4.0f;
    }
    return  CGSizeMake(size_width, size_height);
}
//重设中间内容的frame
- (void)contentResetSizeWithCalc
{
    _contentView.frame = CGRectMake((UI_View_Width - [self calcContentSize].width)/2.0f, (UI_View_Height - 33 - [self calcContentSize].height)/2.0f, [self calcContentSize].width, [self calcContentSize].height);
    _contentView.contentSize = _contentView.frame.size;
}
//添加新的文字
- (void)addNewText
{
    CLTextView *view = [[CLTextView alloc] init];
    CGFloat ratio = MIN( (0.8 * _contentView.width) / view.width, (0.2 * _contentView.height) / view.height);
    [view setScale:ratio];
    view.center = CGPointMake(_contentView.width/2, 80);
    [_contentView addSubview:view];
    
    [CLTextView setActiveTextView:view];
}
//编辑文字的样式弹框
- (void)showCustomActionSheet:(UIView *)anchor
{
    JGActionSheetSection *section = [JGActionSheetSection sectionWithTitle:@"是时候改变下自己了" message:@"看到这是不是很高兴呀，快来感谢你亲爱的组长吧！" buttonTitles:@[@"字体", @"颜色", @"特效"] buttonStyle:JGActionSheetButtonStyleDefault];
    [section setButtonStyle:JGActionSheetButtonStyleBlue forButtonAtIndex:0];
    [section setButtonStyle:JGActionSheetButtonStyleBlue forButtonAtIndex:1];
    [section setButtonStyle:JGActionSheetButtonStyleBlue forButtonAtIndex:2];
    [section setButtonStyle:JGActionSheetButtonStyleCancel forButtonAtIndex:3];
    
    JGActionSheetSection *sectionCancle = [JGActionSheetSection sectionWithTitle:nil message:nil buttonTitles:@[@"取消"] buttonStyle:JGActionSheetButtonStyleCancel];

    NSArray *sections = @[section,sectionCancle];
    JGActionSheet *sheet = [[JGActionSheet alloc] initWithSections:sections];
    [sheet setButtonPressedBlock:^(JGActionSheet *sheet, NSIndexPath *indexPath)
     {
         if (indexPath.section == 0)
         {
             if (indexPath.row == 0)
             {
                 [self popoverFontVC];
             }else if(indexPath.row == 1)
             {
                 [self popoverColorPicker];
             }else if(indexPath.row == 2)
             {
                 [self popoverMenu:anchor];
             }
         }
         [sheet dismissAnimated:YES];
     }];
    [sheet setOutsidePressBlock:^(JGActionSheet *sheet)
     {
         [sheet dismissAnimated:YES];
     }];
    [sheet showInView:self.navigationController.view animated:YES];
}
//跳转选取字体页面
- (void)popoverFontVC
{
    RGetFontListVC *myVC = [[RGetFontListVC alloc] init];
    [myVC setFontSuccessBlock:^(BOOL success, id result)
     {
         if (success)
         {
             CGFloat fontSize = 35;
             _selectedTextView.font = [UIFont fontWithName:result size:fontSize];
             [_selectedTextView sizeToFitWithMaxWidth:0.8*_contentView.width lineHeight:0.2*_contentView.height];
         }
     }];
    LCPanNavigationController *nav = [[LCPanNavigationController alloc]initWithRootViewController:myVC];
    [self presentViewController:nav animated:YES completion:nil];
}
//跳转颜色选取页面
- (void)popoverColorPicker
{
    InfColorPickerController* picker = [InfColorPickerController colorPickerViewController];
    LCPanNavigationController *nav = [[LCPanNavigationController alloc]initWithRootViewController:picker];
    picker.sourceColor = _color;
    picker.delegate = self;
    [self presentViewController:nav animated:YES completion:nil];
}
//特效弹框
- (void)popoverMenu:(UIView *)anchor
{
    NSArray *menuItems =
    @[[KxMenuItem menuItem:@"改变特效" image:nil target:nil action:NULL],
      [KxMenuItem menuItem:@"默认" image:nil target:self action:@selector(pushMenuItem:)],
      [KxMenuItem menuItem:@"阴影" image:nil target:self action:@selector(pushMenuItem:)],
      [KxMenuItem menuItem:@"浮雕" image:nil target:self action:@selector(pushMenuItem:)],
      [KxMenuItem menuItem:@"渐变" image:nil target:self action:@selector(pushMenuItem:)],
      [KxMenuItem menuItem:@"彩虹" image:nil target:self action:@selector(pushMenuItem:)],
      [KxMenuItem menuItem:@"浮云" image:nil target:self action:@selector(pushMenuItem:)],
      [KxMenuItem menuItem:@"还原" image:nil target:self action:@selector(pushMenuItem:)],
      ];
    KxMenuItem *first = menuItems[0];
    first.foreColor = BB_Orange_Color;
    [KxMenu showMenuInView:self.view fromRect:anchor.frame menuItems:menuItems];
}
//当单击中间时隐藏编辑的按钮
-(void)hideMiddleEditView
{
    [StickerView setActiveStickerView:nil];
    [CLTextView setActiveTextView:nil];
    [self hiddenStoryboardAndPoster];
}
//显示拼图等底部弹出框
- (void)showStoryboardAndPoster
{
    _bottomControlView.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        _bottomControlView.frame =  CGRectMake(0, UI_View_Height - 33 - 50, UI_View_Width, 50);
        _editBtn.frame =  CGRectMake((UI_View_Width-75)/2,UI_View_Height-120, 75, 30);
        _inforBtn.frame =  CGRectMake(UI_View_Width-65,UI_View_Height-120, 45, 30);
    } completion:^(BOOL finished){
                         
    }];
}
//隐藏拼图等底部弹出框
- (void)hiddenStoryboardAndPoster
{
    [UIView animateWithDuration:0.3 animations:^{
        _bottomControlView.frame = CGRectMake(0, UI_View_Height - 33, UI_View_Width, 1);
        _editBtn.frame = CGRectMake((UI_View_Width-75)/2, UI_View_Height-70, 75, 30);
        _inforBtn.frame = CGRectMake(UI_View_Width-65, UI_View_Height-70, 45, 30);
    } completion:^(BOOL finished)
    {
        [_bottomControlView setHidden:YES];
    }];
}
//通过size来处理图片
-(UIImage*)originImage:(UIImage *)image scaleToSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return scaledImage;
}
//要展示底部的哪个弹框
- (void)showScrollView:(ScrollViewStatus)status
{
    switch (status)
    {
        case kPuzzleScrollView:
        {
            _storyboardView.hidden = NO;
            _borderView.hidden = YES;
            _filterView.hidden = YES;
            _stickerView.hidden = YES;
            _faceView.hidden = YES;
            
            break;
        }
        case kBorderScrollView:
        {
            _borderView.hidden = NO;
            _filterView.hidden = YES;
            _storyboardView.hidden = YES;
            _stickerView.hidden = YES;
            _faceView.hidden = YES;
            
            break;
        }
        case kStickerScrollView:
        {
            _stickerView.hidden = NO;
            _filterView.hidden = YES;
            _storyboardView.hidden = YES;
            _borderView.hidden = YES;
            _faceView.hidden = YES;
            
            break;
        }
        case kFaceScrollView:
        {
            _faceView.hidden = NO;
            _stickerView.hidden = YES;
            _filterView.hidden = YES;
            _storyboardView.hidden = YES;
            _borderView.hidden = YES;
            
            break;
        }
        case kFilterScrollView:
        {
            _filterView.hidden = NO;
            _storyboardView.hidden = YES;
            _borderView.hidden = YES;
            _stickerView.hidden = YES;
            _faceView.hidden = YES;
            
            break;
        }
        default:
            break;
    }
}
//清除中间的图片部分subviews
- (void)contentRemoveView
{
    for (UIView *subView in _contentView.subviews)
    {
        if (![subView isKindOfClass:[StickerView class]] && ![subView isKindOfClass:[CLTextView class]])
        {
            [subView removeFromSuperview];
        }
    }
    [_contentView addSubview:_bringPosterView];
    [_contentView bringSubviewToFront:_bringPosterView];
    
    [_contentView addSubview:_freeBgView];
    [_contentView sendSubviewToBack:_freeBgView];
}
#pragma mark 通知
//键盘的通知
- (void)keyboardShow:(NSNotification *)notify
{
    CGRect keyBoardRect = [notify.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat deltaY = keyBoardRect.size.height;
    [UIView animateWithDuration:[notify.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        _keyboard.transform = CGAffineTransformMakeTranslation(0, -deltaY);
    }];
}
- (void)keyboardHide:(NSNotification *)note
{
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        _keyboard.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished){
        _keyboard.textView.text = @"";
        [_keyboard removeFromSuperview];
    }];
}
//文字的通知
- (void)activeTextViewDidChange:(NSNotification*)notification
{
    _selectedTextView = notification.object;
}
- (void)activeTextViewDidTap:(NSNotification*)notification
{
    isNewText = NO;
    [self initKeyboard];
}
- (void)activeTextViewDidDoubleTap:(NSNotification*)notification
{
    isNewText = NO;
    [self showCustomActionSheet:notification.object];
}
//点击view
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self hideMiddleEditView];
}
#pragma mark- MeituImageEditViewDelegate
- (void)tapWithEditView:(MeituImageEditView *)sender
{
    [self hideMiddleEditView];
}
#pragma mark- YcKeyBoardViewDelegate
- (void)keyBoardViewHide:(YcKeyBoardView *)keyBoardView textView:(UITextView *)contentView
{
    if (![HemaFunction xfunc_check_strEmpty:contentView.text])
    {
        if (isNewText)
        {
            [self addNewText];
            isNewText = NO;
        }
        _selectedTextView.text = contentView.text;
        [_selectedTextView sizeToFitWithMaxWidth:0.8*_contentView.width lineHeight:0.2*_contentView.height];
    }
    [contentView resignFirstResponder];
}
#pragma mark- InfColorPickerControllerDelegate
- (void)colorPickerControllerDidFinish: (InfColorPickerController*) picker
{
    _color = picker.resultColor;
    _selectedTextView.fillColor = _color;
    [_selectedTextView clearLabelStyle];
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark- GLStoryboardSelectViewDelegate
//点击底部弹框选中后
- (void)didSelectedStoryboardPicCount:(NSInteger)picCount styleIndex:(NSInteger)styleIndex
{
    [self contentRemoveView];
    [self resetViewByStyleIndex:styleIndex imageCount:_dataImg.count];
}
- (void)didSelectedBorderIndex:(NSInteger)styleIndex
{
    if (styleIndex == 0)
    {
        _bringPosterView.image = nil;
        _freeBgView.backgroundColor = [UIColor whiteColor];
        return;
    }
    NSString *imageName = [NSString stringWithFormat:@"border_%lu", (long)styleIndex];
    UIImage *posterImage = [UIImage imageNamed:imageName];
    posterImage = [self originImage:posterImage scaleToSize:_contentView.frame.size];
    _bringPosterView.image = [posterImage stretchableImageWithLeftCapWidth:posterImage.size.width/4.0f topCapHeight:160];
    _bringPosterView.frame = _bringPosterView.frame;
    
    _freeBgView.image = nil;
    _freeBgView.backgroundColor = [UIColor colorWithPatternImage:posterImage];
    _selectedBoardColor = [UIColor colorWithPatternImage:posterImage];
}
- (void)didSelectedStickerIndex:(NSInteger)styleIndex
{
    NSString *imageName = [NSString stringWithFormat:@"sticker_%lu", (long)styleIndex];
    StickerView *view = [[StickerView alloc] initWithImage:[UIImage imageNamed:imageName]];
    CGFloat ratio = MIN( (0.3 * _contentView.width) / view.width, (0.3 * _contentView.height) / view.height);
    [view setScale:ratio];
    view.center = CGPointMake(_contentView.width/2, _contentView.height/2);
    
    [_contentView addSubview:view];
    [StickerView setActiveStickerView:view];
    
    int aniTime = 0.5;
    view.alpha = 0.2;
    [UIView animateWithDuration:aniTime animations:^{
        view.alpha = 1;
    }];
}
- (void)didSelectedFaceIndex:(NSInteger)styleIndex
{
    NSString *imageName = [NSString stringWithFormat:@"face_%lu", (long)styleIndex];
    UIImage *imageFace = [UIImage imageNamed:imageName];
    StickerView *view = [[StickerView alloc] initWithImage:imageFace];
    
    CGFloat ratio = MIN( (0.3 * _contentView.width) / view.width, (0.3 * _contentView.height) / view.height);
    [view setScale:ratio];
    view.center = CGPointMake(_contentView.width/2, _contentView.height/2);
    
    [_contentView addSubview:view];
    [StickerView setActiveStickerView:view];
}
- (void)didSelectedFilterIndex:(NSInteger)styleIndex
{
    if (_assets && [_assets count] > 0)
    {
        _freeBgView.image = nil;
        _freeBgView.backgroundColor = _selectedBoardColor?_selectedBoardColor:[UIColor whiteColor];
        if (!_dataImg)
        {
            _dataImg = [[NSMutableArray alloc] initWithCapacity:1];
        }else
        {
            [_dataImg removeAllObjects];
        }
        
        for (ALAsset *asset in _assets)
        {
            UIImage *image = [UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
            UIImage *imageRelust = [Auxiliary changeImage:(int)styleIndex imageView:image];
            [_dataImg addObject:imageRelust];
        }
        [self resetViewByStyleIndex:selectStoryBoardStyleIndex imageCount:_dataImg.count];
    }
}
@end
