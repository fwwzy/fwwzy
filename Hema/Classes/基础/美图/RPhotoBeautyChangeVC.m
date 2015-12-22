//
//  RPhotoBeautyChangeVC.m
//  Hema
//
//  Created by geyang on 15/11/19.
//  Copyright © 2015年 Hemaapp. All rights reserved.
//
#define CountImg 5 //图片限制

#import "RPhotoBeautyChangeVC.h"
#import "HemaLongGR.h"
#import "CTAssetsPickerController.h"
#import "MWCommon.h"
#import "MWPhoto.h"
#import "MWPhotoBrowser.h"

@interface RPhotoBeautyChangeVC ()<CTAssetsPickerControllerDelegate,MWPhotoBrowserDelegate>
{
    NSInteger uploadNum;//上传文件的次数
    CGPoint _lastPoint;//拖动时上一个位置
    CGRect _currentPresssViewFrame;//拖动的button的frame
}
@property(nonatomic,strong)NSMutableArray *btnArr;//图片的button集合
@property(nonatomic,strong)HemaButton *placeholderButton;//拖动时替代的button
@property(nonatomic,strong)HemaButton *currentPressedView;//拖动的button
@property(nonatomic,strong)UIImage *placeholderImage;//拖动时替代的image
@property(nonatomic,strong)UIImage *currentImage;//拖动时的image
@property(nonatomic,strong)ALAsset *placeholderAsset;//拖动时替代的asset
@property(nonatomic,strong)ALAsset *currentAsset;//拖动时的那个对应的asset
@property(nonatomic,strong)NSMutableArray *photos;//相册集合
@end

@implementation RPhotoBeautyChangeVC

-(void)loadSet
{
    [self.navigationItem setNewTitle:@"修改图片"];
    [self.navigationItem setLeftItemWithTarget:self action:@selector(leftbtnPressed:) image:BackImgName];
    [self.navigationItem setRightItemWithTarget:self action:@selector(rightbtnPressed:) title:@"确定"];
    [self forbidPullRefresh];
    
    _placeholderButton = [HemaButton buttonWithType:UIButtonTypeCustom];
    _placeholderImage = [UIImage new];
    _placeholderAsset = [[ALAsset alloc]init];
    
    //底部
    UILabel *labDown = [[UILabel alloc]init];
    labDown.backgroundColor = [UIColor clearColor];
    labDown.textAlignment = NSTextAlignmentCenter;
    labDown.font = [UIFont systemFontOfSize:15];
    labDown.text = @"长按图片可以拖动哦";
    labDown.frame = CGRectMake(0, UI_View_Height-50, UI_View_Width, 50);
    labDown.textColor = BB_Blake_Color;
    [self.view addSubview:labDown];
}
#pragma mark- 自定义
#pragma mark 事件
-(void)leftbtnPressed:(id)sender
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
-(void)rightbtnPressed:(id)sender
{
    if (_dataImg.count == 0)
    {
        [UIWindow showToastMessage:@"都删没了呀大哥？"];
        return;
    }
    if (_PhotoBeautyChangeOK)
    {
        _PhotoBeautyChangeOK(_dataImg,_assets);
    }
    [self leftbtnPressed:nil];
}
//长按图片
-(void)imgLongPress:(HemaLongGR*)sender
{
    UITableViewCell *cell = (UITableViewCell *)[self.mytable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    
    CGPoint point = [sender locationInView:cell.contentView];
    if (sender.state == UIGestureRecognizerStateBegan)
    {
        _currentPressedView = (HemaButton*)sender.view;
        _currentPresssViewFrame = sender.view.frame;
        sender.view.transform = CGAffineTransformMakeScale(1.1, 1.1);
        long index = [_btnArr indexOfObject:sender.view];
        _currentImage = [_dataImg objectAtIndex:index];
        _currentAsset = [_assets objectAtIndex:index];
        [_btnArr removeObject:sender.view];
        [_btnArr insertObject:_placeholderButton atIndex:index];
        
        [_dataImg removeObject:_currentImage];
        [_dataImg insertObject:_placeholderImage atIndex:index];
        
        [_assets removeObject:_currentAsset];
        [_assets insertObject:_placeholderAsset atIndex:index];
        
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
             
             [_assets removeObject:_placeholderAsset];
             [_assets insertObject:_placeholderAsset atIndex:idx];
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
        
        [_assets removeObject:_placeholderAsset];
        [_assets insertObject:_currentAsset atIndex:index];
        
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
//删除图片
-(void)deleteImg:(HemaButton*)sender
{
    [[_btnArr objectAtIndex:sender.btnRow] removeFromSuperview];
    [_btnArr removeObjectAtIndex:sender.btnRow];
    [_dataImg removeObjectAtIndex:sender.btnRow];
    [_assets removeObjectAtIndex:sender.btnRow];
    
    [UIView animateWithDuration:0.4 animations:^{
        [self setupSubViewsFrame];
        if (_btnArr.count < 7)
        {
            float width = (UI_View_Width-50)/4;
            UITableViewCell *cell = (UITableViewCell *)[self.mytable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            HemaButton *addBtn = (HemaButton*)[cell viewWithTag:9];
            [addBtn setFrame:CGRectMake(10+(width+10)*(_dataImg.count%4), 15+(width+10)*(_dataImg.count/4), width, width)];
        }
        [self setupSubViewsFrame];
    }completion:^(BOOL finished)
     {
         if (_btnArr.count == (CountImg-1))
         {
             [self.mytable reloadData];
         }
     }];
}
//观看图片
-(void)gotoScanImg:(HemaButton*)sender
{
    if (!_photos)
    {
        _photos = [[NSMutableArray alloc] init];
    }
    [_photos removeAllObjects];
    
    for (int i = 0; i<_dataImg.count; i++)
    {
        MWPhoto *photo = [MWPhoto photoWithImage:[_dataImg objectAtIndex:i]];
        [_photos addObject:photo];
    }
    
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    browser.displayActionButton = YES;
    browser.displayNavArrows = YES;
    browser.displaySelectionButtons = NO;
    browser.alwaysShowControls = NO;
    browser.zoomPhotosToFill = YES;
    browser.enableGrid = YES;
    browser.startOnGrid = NO;
    browser.enableSwipeToDismiss = NO;
    browser.autoPlayOnAppear = NO;
    [browser setCurrentPhotoIndex:sender.btnRow];
    [self.navigationController pushViewController:browser animated:YES];
}
//选取图片
-(void)gotoGetImg:(id)sender
{
    CTAssetsPickerController *picker = [[CTAssetsPickerController alloc] init];
    picker.maximumNumberOfSelection = CountImg - _dataImg.count;
    picker.assetsFilter = [ALAssetsFilter allPhotos];
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:NULL];
}
#pragma mark 方法
//重设button的frame
- (void)setupSubViewsFrame
{
    float width = (UI_View_Width-50)/4;
    [_btnArr enumerateObjectsUsingBlock:^(HemaButton *button, NSUInteger i, BOOL *stop)
     {
         [button setFrame:CGRectMake(10+(width+10)*(i%4), 10+(width+10)*(i/4), width+5, width+5)];
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
#pragma mark - MWPhotoBrowserDelegate
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser
{
    return _dataImg.count;
}
- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index
{
    if (index < _photos.count)
        return [_photos objectAtIndex:index];
    return nil;
}
- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser thumbPhotoAtIndex:(NSUInteger)index
{
    if (index < _photos.count)
        return [_photos objectAtIndex:index];
    return nil;
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
        [_assets addObject:[assets objectAtIndex:i]];
        
        [self.mytable reloadData];
    }
}
#pragma mark - UITableView dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"all";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
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
        [backBtn setFrame:CGRectMake(10+(width+10)*(i%4), 10+(width+10)*(i/4), width+5, width+5)];
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
        [addBtn setFrame:CGRectMake(10+(width+10)*(_dataImg.count%4), 15+(width+10)*(_dataImg.count/4), width, width)];
        [addBtn setBackgroundImage:[UIImage imageNamed:@"R选取图片按钮.png"] forState:UIControlStateNormal];
        [addBtn addTarget:self action:@selector(gotoGetImg:) forControlEvents:UIControlEventTouchUpInside];
        addBtn.tag = 9;
        [cell.contentView addSubview:addBtn];
    }
    
    return cell;
}
#pragma mark - Table view delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
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
@end
