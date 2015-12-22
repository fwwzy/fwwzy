//
//  RPublishBlogVC.m
//  Hema
//
//  Created by LarryRodic on 15/10/18.
//  Copyright (c) 2015年 Hemaapp. All rights reserved.
//
#define CountLegth 1000 //字数限制
#define CountImg 8 //图片限制

#import "RPublishBlogVC.h"
#import "HemaTextView.h"
#import "CTAssetsPickerController.h"

#import "UIImageView+MJWebCache.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"

#import "HemaLongGR.h"
#import "IQKeyboardManager.h"

@interface RPublishBlogVC ()<UITextViewDelegate,CTAssetsPickerControllerDelegate>
{
    NSInteger uploadNum;//上传文件的次数
    CGPoint _lastPoint;//拖动时上一个位置
    CGRect _currentPresssViewFrame;//拖动的button的frame
}
@property(nonatomic,strong)HemaTextView *myTextView;//输入框
@property(nonatomic,strong)NSMutableArray *dataImg;//图片
@property(nonatomic,strong)UILabel *countLabel;//提示数字
//拖动
@property(nonatomic,strong)NSMutableArray *btnArr;//图片的button集合
@property(nonatomic,strong)HemaButton *placeholderButton;//拖动时替代的button
@property(nonatomic,strong)HemaButton *currentPressedView;//拖动的button
@property(nonatomic,strong)UIImage *placeholderImage;//拖动时替代的image
@property(nonatomic,strong)UIImage *currentImage;//拖动时的image

@end

@implementation RPublishBlogVC

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [[IQKeyboardManager sharedManager] setEnable:NO];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
    [super viewWillDisappear:animated];
}
-(void)loadSet
{
    //导航
    [self.navigationItem setNewTitle:@"发布动态"];
    [self.navigationItem setLeftItemWithTarget:self action:@selector(leftbtnPressed:) image:BackImgName];
    [self.navigationItem setRightItemWithTarget:self action:@selector(rightbtnPressed:) title:@"发布"];
    
    [self forbidPullRefresh];
    [SystemFunction setTableSeparatorInset:self.mytable left:10];
    
    _placeholderButton = [HemaButton buttonWithType:UIButtonTypeCustom];
    _placeholderImage = [UIImage new];
}
-(void)loadData
{
    uploadNum = 0;
    _dataImg = [[NSMutableArray alloc]init];
}
#pragma mark- 自定义
#pragma mark 事件
-(void)leftbtnPressed:(id)sender
{
    [_myTextView resignFirstResponder];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
-(void)rightbtnPressed:(id)sender
{
    [self requestBlogAdd];
}
//长按图片
-(void)imgLongPress:(HemaLongGR*)sender
{
    [_myTextView resignFirstResponder];
    UITableViewCell *cell = (UITableViewCell *)[self.mytable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    
    CGPoint point = [sender locationInView:cell.contentView];
    if (sender.state == UIGestureRecognizerStateBegan)
    {
        _currentPressedView = (HemaButton*)sender.view;
        _currentPresssViewFrame = sender.view.frame;
        sender.view.transform = CGAffineTransformMakeScale(1.1, 1.1);
        long index = [_btnArr indexOfObject:sender.view];
        _currentImage = [_dataImg objectAtIndex:index];
        [_btnArr removeObject:sender.view];
        [_btnArr insertObject:_placeholderButton atIndex:index];
        
        [_dataImg removeObject:_currentImage];
        [_dataImg insertObject:_placeholderImage atIndex:index];
        
        _lastPoint = point;
        [cell.contentView bringSubviewToFront:sender.view];
    }
    
    CGRect temp = sender.view.frame;
    temp.origin.x += point.x - _lastPoint.x;
    temp.origin.y += point.y - _lastPoint.y;
    sender.view.frame = temp;
    
    _lastPoint = point;
    
    [_btnArr enumerateObjectsUsingBlock:^(HemaButton *button, NSUInteger idx, BOOL *stop)
    {
        if (CGRectContainsPoint(button.frame, point) && button != sender.view)
        {
            [_btnArr removeObject:_placeholderButton];
            [_btnArr insertObject:_placeholderButton atIndex:idx];
            
            [_dataImg removeObject:_placeholderImage];
            [_dataImg insertObject:_placeholderImage atIndex:idx];
            *stop = YES;
            
            [UIView animateWithDuration:0.5 animations:^{
                [self setupSubViewsFrame];
            }];
        }
        
    }];
    
    if (sender.state == UIGestureRecognizerStateEnded)
    {
        long index = [_btnArr indexOfObject:_placeholderButton];
        [_btnArr removeObject:_placeholderButton];
        [_btnArr insertObject:sender.view atIndex:index];
        
        [_dataImg removeObject:_placeholderImage];
        [_dataImg insertObject:_currentImage atIndex:index];
        
        [UIView animateWithDuration:0.4 animations:^{
            sender.view.transform = CGAffineTransformIdentity;
            [self setupSubViewsFrame];
        } completion:^(BOOL finished)
        {
            if (!CGRectEqualToRect(_currentPresssViewFrame, _currentPressedView.frame))
            {
               
            }
        }];
    }
}
#pragma mark 方法
//发布成功
-(void)mypublishOK
{
    [HemaFunction closeHUD:waitMB];
    if (_publishBlogOK)
    {
        _publishBlogOK(self);
    }
    [self leftbtnPressed:nil];
}
//删除图片
-(void)deleteImg:(HemaButton*)sender
{
    [[_btnArr objectAtIndex:sender.btnRow] removeFromSuperview];
    [_btnArr removeObjectAtIndex:sender.btnRow];
    [_dataImg removeObjectAtIndex:sender.btnRow];
    
    [UIView animateWithDuration:0.4 animations:^{
        [self setupSubViewsFrame];
        if (_btnArr.count < 7)
        {
            float width = (UI_View_Width-50)/4;
            UITableViewCell *cell = (UITableViewCell *)[self.mytable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
            HemaButton *addBtn = (HemaButton*)[cell viewWithTag:9];
            [addBtn setFrame:CGRectMake(10+(width+10)*(_dataImg.count%4), 5+(width+10)*(_dataImg.count/4), width, width)];
        }
        [self setupSubViewsFrame];
    }completion:^(BOOL finished)
     {
         if (_btnArr.count == 7)
         {
             [self.mytable reloadData];
         }
     }];
}
//观看图片
-(void)gotoScanImg:(HemaButton*)sender
{
    [_myTextView resignFirstResponder];
    
    //查看大图
    NSInteger count = _dataImg.count;
    // 1.封装图片数据
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i<count; i++)
    {
        MJPhoto *photo = [[MJPhoto alloc] init];
        photo.image = _dataImg[i];
        photo.srcImageView = (UIImageView*)[self.mytable viewWithTag:100+i];
        [photos addObject:photo];
    }
    
    // 2.显示相册
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.currentPhotoIndex = sender.btnRow;
    browser.photos = photos;
    [browser show];
}
//选取图片
-(void)gotoGetImg:(id)sender
{
    [_myTextView resignFirstResponder];
    UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:@"选取照片" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:Button_Albums,Button_Camera,Button_Cancel, nil];
    [SystemFunction setActionSheet:actionSheet index:2 myVC:self];
}
//重设button的frame
- (void)setupSubViewsFrame
{
    float width = (UI_View_Width-50)/4;
    [_btnArr enumerateObjectsUsingBlock:^(HemaButton *button, NSUInteger i, BOOL *stop)
    {
        [button setFrame:CGRectMake(10+(width+10)*(i%4), (width+10)*(i/4), width+5, width+5)];
        button.btnRow = i;
        
        for (UIView *myView in button.subviews)
        {
            if ([myView isKindOfClass:[UIImageView class]])
            {
                myView.tag = 100+i;
            }
        }
        
        HemaButton *deleteBtn = (HemaButton*)[button viewWithTag:10];
        deleteBtn.btnRow = i;
    }];
}
#pragma mark- UIActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString*title = [actionSheet buttonTitleAtIndex:buttonIndex];
    //拍照
    if([title isEqualToString:Button_Camera])
    {
        [SystemFunction pickerCamere:self allowsEditing:NO];
        return;
    }
    if([title isEqualToString:Button_Albums])
    {
        CTAssetsPickerController *picker = [[CTAssetsPickerController alloc] init];
        picker.maximumNumberOfSelection = CountImg - _dataImg.count;
        picker.assetsFilter = [ALAssetsFilter allPhotos];
        picker.delegate = self;
        [self presentViewController:picker animated:YES completion:NULL];
        
        return;
    }
}
#pragma mark- UIImagePicker Delegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [SystemFunction fixPick:navigationController myVC:viewController];
}
- (void)imagePickerController:(UIImagePickerController *)picker
        didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    image = [HemaFunction getImage:image];
    [_dataImg addObject:image];
    [self.mytable reloadData];
    [picker dismissViewControllerAnimated:YES completion:nil];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - AssetsPicker Delegate
- (void)assetsPickerController:(CTAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets
{
    for (int i = 0; i<assets.count; i++)
    {
        ALAssetRepresentation *assetRep = [[assets objectAtIndex:i] defaultRepresentation];
        CGImageRef imgRef = [assetRep fullResolutionImage];
        UIImage *orgImage = [UIImage imageWithCGImage:imgRef
                                                scale:assetRep.scale
                                          orientation:(UIImageOrientation)assetRep.orientation];
        UIImage *image = orgImage;
        image = [HemaFunction getImage:image];
        [_dataImg addObject:image];
        
        [self.mytable reloadData];
    }
}
#pragma mark- UITextView Delegate
- (void)textViewDidChange:(UITextView *)textView
{
    _countLabel.text = [NSString stringWithFormat:@"%d/%d",(int)textView.text.length,(int)CountLegth];
}
#pragma mark - UITableView dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (1 == indexPath.row)
    {
        static NSString *CellIdentifier = @"001";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if(cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = BB_White_Color;
        }else
        {
            for(UIView *view in cell.contentView.subviews)
            {
                [view removeFromSuperview];
            }
        }
        
        float width = (UI_View_Width-50)/4;
        
        if (!_btnArr)
        {
            _btnArr = [[NSMutableArray alloc]init];
        }
        [_btnArr removeAllObjects];
        
        for (int i = 0; i<_dataImg.count; i++)
        {
            HemaButton *backBtn = [HemaButton buttonWithType:UIButtonTypeCustom];
            [backBtn setFrame:CGRectMake(10+(width+10)*(i%4), (width+10)*(i/4), width+5, width+5)];
            backBtn.btnRow = i;
            [backBtn addTarget:self action:@selector(gotoScanImg:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:backBtn];
            [_btnArr addObject:backBtn];
            
            UIImageView *downImgView = [[UIImageView alloc]init];
            [downImgView setImage:[_dataImg objectAtIndex:i]];
            downImgView.tag = 100+i;
            downImgView.contentMode = UIViewContentModeScaleAspectFill;
            downImgView.clipsToBounds = YES;
            [downImgView setFrame:CGRectMake(0, 5, width, width)];
            [HemaFunction addbordertoView:downImgView radius:0.0 width:0.5 color:BB_lineColor];
            [backBtn addSubview:downImgView];
            
            HemaButton *deleteBtn = [HemaButton buttonWithType:UIButtonTypeCustom];
            [deleteBtn setFrame:CGRectMake(width-14, 0, 19, 19)];
            deleteBtn.btnRow = i;
            deleteBtn.tag = 10;
            [deleteBtn addTarget:self action:@selector(deleteImg:) forControlEvents:UIControlEventTouchUpInside];
            [deleteBtn setImage:[UIImage imageNamed:@"R图片删除按钮.png"] forState:UIControlStateNormal];
            [backBtn addSubview:deleteBtn];
            
            HemaLongGR *myLong = [[HemaLongGR alloc]initWithTarget:self action:@selector(imgLongPress:)];
            myLong.minimumPressDuration = 0.5;
            myLong.touchI = i;
            [backBtn addGestureRecognizer:myLong];
        }
        if (_dataImg.count<CountImg)
        {
            HemaButton *addBtn = [HemaButton buttonWithType:UIButtonTypeCustom];
            [addBtn setFrame:CGRectMake(10+(width+10)*(_dataImg.count%4), 5+(width+10)*(_dataImg.count/4), width, width)];
            [addBtn setBackgroundImage:[UIImage imageNamed:@"R选取图片按钮.png"] forState:UIControlStateNormal];
            [addBtn addTarget:self action:@selector(gotoGetImg:) forControlEvents:UIControlEventTouchUpInside];
            addBtn.tag = 9;
            [cell.contentView addSubview:addBtn];
        }
        
        return cell;
    }
    static NSString *CellIdentifier = @"all";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = BB_White_Color;
        [cell setSeparatorInset:UIEdgeInsetsMake(0, UI_View_Width, 0, 0)];
        
        //内容
        _myTextView = [[HemaTextView alloc]initWithFrame:CGRectMake(10, 10, UI_View_Width-20, 115)];
        [_myTextView setBackgroundColor:BB_White_Color];
        _myTextView.font = [UIFont systemFontOfSize:14];
        _myTextView.textAlignment = NSTextAlignmentLeft;
        _myTextView.textColor = [UIColor blackColor];
        _myTextView.placeholder = @"点击输入需要发布的内容...";
        _myTextView.placeholderColor = BB_Gray_Color;
        _myTextView.delegate = self;
        [cell.contentView addSubview:_myTextView];
        
        //字符数量显示
        _countLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 130, UI_View_Width-15, 20)];
        _countLabel.backgroundColor = [UIColor clearColor];
        _countLabel.textColor = [UIColor grayColor];
        _countLabel.textAlignment = NSTextAlignmentRight;
        _countLabel.font = [UIFont systemFontOfSize:13];
        _countLabel.text = [NSString stringWithFormat:@"%d/%d",(int)_myTextView.text.length,(int)CountLegth];
        [cell.contentView addSubview:_countLabel];
    }
    return cell;
}
#pragma mark - Table view delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.row)
    {
        return 150;
    }
    float width = (UI_View_Width-50)/4;
    
    if (_dataImg.count>=4)
    {
        return 30+2*width;
    }
    return 20+width;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *) indexPath
{
    
}
#pragma mark - 连接服务器
#pragma mark 发布
- (void)requestBlogAdd
{
    if ([HemaFunction xfunc_check_strEmpty:_myTextView.text])
    {
        [HemaFunction openIntervalHUD:@"文字内容不能为空"];
        return;
    }
    if (_myTextView.text.length>140)
    {
        [HemaFunction openIntervalHUD:@"内容不能超过140字"];
        return;
    }
    NSString *token = [[HemaManager sharedManager] userToken];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:token forKey:@"token"];
    [dic setObject:@"2" forKey:@"blogtype"];
    [dic setObject:@"0" forKey:@"price"];
    [dic setObject:[NSString stringWithFormat:@"%f",[HemaFunction xfuncGetAppdelegate].myCoordinate.latitude] forKey:@"lat"];
    [dic setObject:[NSString stringWithFormat:@"%f",[HemaFunction xfuncGetAppdelegate].myCoordinate.longitude] forKey:@"lng"];
    [dic setObject:self.myTextView.text forKey:@"content"];
    
    waitMB = [HemaFunction openHUD:@"正在发布"];
    
    [HemaRequest requestWithURL:[NSString stringWithFormat:@"%@%@",REQUEST_MAINLINK,REQUEST_BLOG_ADD] target:self selector:@selector(responseBlogAdd:) parameter:dic];
}
- (void)responseBlogAdd:(NSDictionary*)info
{
    if(1 == [[info objectForKey:@"success"] intValue])
    {
        NSString *str = [[[info objectForKey:@"infor"] objectAtIndex:0] objectForKey:@"blog_id"];
        if (_dataImg.count == 0)
        {
            [self mypublishOK];
        }else
        {
            //上传图片
            NSMutableArray *ImgArr = self.dataImg;
            for (int i = 0; i<ImgArr.count; i++)
            {
                UIImage *img = [ImgArr objectAtIndex:i];
                NSData *temData = UIImageJPEGRepresentation(img, 0.8);
                [self requestPublishFile:str orderby:[NSString stringWithFormat:@"%d",i] data:temData];
            }
        }
    }else
    {
        [HemaFunction closeHUD:waitMB];
        [HemaFunction openIntervalHUD:[info objectForKey:@"msg"]];
    }
}
#pragma mark 上传图片、视频
- (void)requestPublishFile:(NSString*)keyid orderby:(NSString*)orderby data:(NSData*)data
{
    NSString *token = [[HemaManager sharedManager] userToken];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:token forKey:@"token"];
    [dic setObject:@"2" forKey:@"keytype"];
    [dic setObject:keyid forKey:@"keyid"];
    [dic setObject:orderby forKey:@"orderby"];
    [dic setObject:data forKey:@"temp_file"];
    [dic setObject:@"无" forKey:@"content"];
    [dic setObject:@"0" forKey:@"duration"];
    [HemaRequest requestWithURL:[NSString stringWithFormat:@"%@%@",REQUEST_MAINLINK,REQUEST_FILE_UPLOAD] target:self selector:@selector(responsePublishFile:) parameter:dic];
}
- (void)responsePublishFile:(NSDictionary*)info
{
    if(1 == [[info objectForKey:@"success"] intValue])
    {
        uploadNum ++;
        
        NSMutableArray *ImgArr = self.dataImg;
        
        if (uploadNum == ImgArr.count)
        {
            [self mypublishOK];
        }
    }else
    {
        [HemaFunction closeHUD:waitMB];
        [HemaFunction openIntervalHUD:[info objectForKey:@"msg"]];
    }
}
@end
