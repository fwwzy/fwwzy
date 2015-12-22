//
//  RInforVC.m
//  Hema
//
//  Created by LarryRodic on 15/10/7.
//  Copyright (c) 2015年 Hemaapp. All rights reserved.
//

#import "RInforVC.h"

#import "UIImageView+MJWebCache.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"

#import "HemaEditorVC.h"
#import "RMyChatVC.h"
#import "HemaReplyVC.h"
#import "ActionSheetPicker.h"

@interface RInforVC ()<UIActionSheetDelegate,HemaEditorDelegate,HemaReplyDelegate>
{
    BOOL isSelf;//是否是自己
}
@property(nonatomic,strong)NSMutableDictionary *dataSource;//个人资料
@property(nonatomic,strong)UIImage *headImg;//头像文件
@end

@implementation RInforVC
@synthesize userId;
@synthesize isRegister;
@synthesize dataSource;

-(void)loadSet
{
    //导航
    if (isRegister)
    {
        isSelf = YES;
        [self.navigationItem setNewTitle:@"完善资料"];
        [self initDown:@"注册" twoStr:@""];
    }else
    {
        [self.navigationItem setNewTitle:@"个人资料"];
        [self initDown:@"保存" twoStr:@""];
    }
    //判断是否有无网络
    if (!isRegister)
    {
        if (![HemaFunction canConnectNet])
        {
            [self.mytable setHidden:YES];
            return;
        }
    }
    //禁止加载刷新
    [self forbidPullRefresh];
}
-(void)loadData
{
    if (!dataSource)
        dataSource = [[NSMutableDictionary alloc]init];
    if (isRegister)
    {
        return;
    }
    NSString *myUserID = [[[HemaManager sharedManager] myInfor]objectForKey:@"id"];
    if (userId)
    {
        if ([userId isEqualToString:myUserID])
        {
            isSelf = YES;
        }
    }else
    {
        isSelf = YES;
        userId = myUserID;
    }
    [self requestGetInfor];
}
//创建底部按钮
-(void)initDown:(NSString*)oneStr twoStr:(NSString*)twoStr
{
    UIView *footView = [[UIView alloc]init];
    footView.backgroundColor = [UIColor clearColor];
    
    int count = 2;
    [footView setFrame:CGRectMake(0, 0, UI_View_Width, 160)];
    
    if ([HemaFunction xfunc_check_strEmpty:twoStr])
    {
        count = 1;
        [footView setFrame:CGRectMake(0, 0, UI_View_Width, 100)];
    }
    self.mytable.tableFooterView = footView;
    
    for (int i = 0; i<count; i++)
    {
        HemaButton *oneBtn = [HemaButton buttonWithType:UIButtonTypeCustom];
        oneBtn.frame = CGRectMake(24, 24+60*i, UI_View_Width-48, 36);
        [HemaFunction addbordertoView:oneBtn radius:4.0f width:0.0f color:[UIColor clearColor]];
        [oneBtn setBackgroundColor:BB_Blue_Color];
        oneBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [oneBtn setTitle:(i == 0)?oneStr:twoStr forState:UIControlStateNormal];
        [oneBtn setTitleColor:BB_White_Color forState:UIControlStateNormal];
        oneBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        [oneBtn addTarget:self action:@selector(downPressed:) forControlEvents:UIControlEventTouchUpInside];
        oneBtn.btnRow = i;
        [footView addSubview:oneBtn];
        
        if (![HemaFunction xfunc_check_strEmpty:twoStr])
        {
            if (i == 0)
            {
                [oneBtn setBackgroundColor:BB_Red_Color];
            }
        }
    }
}
#pragma mark- 自定义
#pragma mark 事件
//底部按钮
-(void)downPressed:(HemaButton*)sender
{
    if (isSelf)
    {
        if (isRegister)
        {
            [self requestRegister];
        }else
        {
            [self requestSaveClient];
        }
        return;
    }
    if ([[dataSource objectForKey:@"friendflag"]integerValue] == 1)
    {
        if (sender.btnRow == 0)
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"删除好友" message:@"确定要删除此好友？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alertView.tag = 88;
            alertView.delegate = self;
            [alertView show];
        }else
        {
            //聊天
            RMyChatVC *myVC = [[RMyChatVC alloc]initWithChatter:[dataSource objectForKey:@"id"]];
            myVC.isChatGroup = NO;
            myVC.dataSource = dataSource;
            [self.navigationController pushViewController:myVC animated:YES];
        }
    }else
    {
        [self requestAdd];
    }
}
//点击头像
-(void)gotoImg:(id)sender
{
    if (!isRegister)
    {
        if (!isSelf)
        {
            [self scanBigImage];
            return;
        }
    }
    if (_headImg)
    {
        UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:@"修改头像" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:Button_Scan,Button_Albums,Button_Camera,Button_Cancel, nil];
        [SystemFunction setActionSheet:actionSheet index:3 myVC:self];
        return;
    }
    NSString *avatar = [dataSource objectForKey:@"avatar"];
    if(![HemaFunction xfunc_check_strEmpty:avatar])
    {
        UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:@"修改头像" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:Button_Scan,Button_Albums,Button_Camera,Button_Cancel, nil];
        [SystemFunction setActionSheet:actionSheet index:3 myVC:self];
    }else
    {
        UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:@"修改头像" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:Button_Albums,Button_Camera,Button_Cancel, nil];
        [SystemFunction setActionSheet:actionSheet index:2 myVC:self];
    }
}
#pragma mark 方法
//查看大图
- (void)scanBigImage
{
    int count = 1;
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:count];
    
    NSString *url = [dataSource objectForKey:@"avatarbig"];
    MJPhoto *photo = [[MJPhoto alloc] init];
    if (_headImg)
    {
        photo.image = _headImg;
    }else
    {
        if ([HemaFunction xfunc_check_strEmpty:url])
        {
            return;
        }
        photo.url = [NSURL URLWithString:url];
    }
    photo.srcImageView = (UIImageView*)[self.mytable viewWithTag:999];
    [photos addObject:photo];
    
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.currentPhotoIndex = 0;
    browser.photos = photos;
    [browser show];
}
#pragma mark- UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString*title = [actionSheet buttonTitleAtIndex:buttonIndex];
    if([title isEqualToString:Button_Camera])
    {
        [SystemFunction pickerCamere:self allowsEditing:YES];
    }
    if([title isEqualToString:Button_Albums])
    {
        [SystemFunction pickerAlbums:self allowsEditing:YES];
    }
    if([title isEqualToString:Button_Scan])
    {
        [self scanBigImage];
    }
    if([title isEqualToString:@"男"]||[title isEqualToString:@"女"])
    {
        [dataSource setObject:title forKey:@"sex"];
        [self.mytable reloadData];
        return;
    }
}
#pragma mark- UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(88 == alertView.tag&&1 == buttonIndex)
    {
        [self requestDelete];
    }
}
#pragma mark- HemaEditorDelegate
-(void)HemaEditorOK:(HemaEditorVC*)editor backValue:(NSString*)value
{
    if(editor.key)
    {
        if(!value)
            value = @"";
        [dataSource setObject:value forKey:editor.key];
        [self.mytable reloadData];
    }
}
#pragma mark- HemaReplyDelegate
-(void)HemaReplyOK:(HemaReplyVC*)reply content:(NSString*)content
{
    [dataSource setObject:content?content:@"" forKey:@"selfsign"];
    [self.mytable reloadData];
}
#pragma mark- UIImagePickerControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [SystemFunction fixPick:navigationController myVC:viewController];
}
- (void)imagePickerController:(UIImagePickerController *)picker
        didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    image = [HemaFunction getImage:image];
    _headImg = image;
    [self.mytable reloadData];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark- TableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (0 == section)
    {
        return 1;
    }
    return 5;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.section)
    {
        //头像
        static NSString *CellIdentifier = @"000";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if(cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = BB_White_Color;
            
            //用来查看大图寻找起始图像的
            HemaImgView *temHeadView = [[HemaImgView alloc]init];
            temHeadView.tag = 999;
            temHeadView.frame = CGRectMake((UI_View_Width-90)/2, 23, 90, 90);
            [HemaFunction addbordertoView:temHeadView radius:45.0f width:2.0f color:BB_White_Color];
            [cell.contentView addSubview:temHeadView];
            
            HemaButton *btnImg = [HemaButton buttonWithType:UIButtonTypeCustom];
            [btnImg setFrame:CGRectMake((UI_View_Width-90)/2, 23, 90, 90)];
            btnImg.tag = 10;
            [btnImg addTarget:self action:@selector(gotoImg:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:btnImg];
        }
        HemaImgView *temHeadView = (HemaImgView*)[cell viewWithTag:999];
        
        if (self.headImg)
        {
            [temHeadView setImage:_headImg];
        }else
        {
            if (isRegister)
            {
                [SystemFunction cashImgView:temHeadView url:[dataSource objectForKey:@"avatar"] firstImg:@"R资料相框.png"];
            }else
            {
                [SystemFunction cashImgView:temHeadView url:[dataSource objectForKey:@"avatar"] firstImg:@"R默认小头像.png"];
            }
        }
        return cell;
    }
    static NSString *CellIdentifier = @"all";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.backgroundColor = BB_White_Color;
        
        //左侧
        UILabel *labLeft = [[UILabel alloc]init];
        labLeft.backgroundColor = [UIColor clearColor];
        labLeft.textAlignment = NSTextAlignmentLeft;
        labLeft.font = [UIFont systemFontOfSize:14];
        labLeft.textColor = BB_Gray_Color;
        labLeft.frame = CGRectMake(17, 0, 80, 44);
        labLeft.tag = 10;
        [cell.contentView addSubview:labLeft];
        
        //右侧
        UILabel *labRight = [[UILabel alloc]init];
        labRight.backgroundColor = [UIColor clearColor];
        labRight.textAlignment = NSTextAlignmentRight;
        labRight.textColor = BB_Blake_Color;
        labRight.font = [UIFont systemFontOfSize:14];
        labRight.tag = 11;
        labRight.numberOfLines = 0;
        [cell.contentView addSubview:labRight];
        
        UIImageView *picImgView = [[UIImageView alloc]init];
        [picImgView setImage:[UIImage imageNamed:@"R必填选项红星.png"]];
        picImgView.tag = 12;
        [cell.contentView addSubview:picImgView];
        
        UIImageView *arrowImgView = [[UIImageView alloc]init];
        [arrowImgView setImage:[UIImage imageNamed:@"R右侧蓝色箭头.png"]];
        [arrowImgView setFrame:CGRectMake(UI_View_Width-25, 13.5, 11, 17)];
        arrowImgView.tag = 13;
        [cell.contentView addSubview:arrowImgView];
    }
    NSMutableArray *temArr = [[NSMutableArray alloc]initWithObjects:@"昵称",@"出生日期",@"性别",@"家乡",@"个性签名",@"所在地",@"公司",@"职业",@"车辆",@"学校",nil];
    
    UILabel *labLeft = (UILabel*)[cell viewWithTag:10];
    labLeft.text = [temArr objectAtIndex:indexPath.row+(indexPath.section-1)*5];
    
    UILabel *labRight = (UILabel*)[cell viewWithTag:11];
    
    UIImageView *picImgView = (UIImageView*)[cell viewWithTag:12];
    [picImgView setHidden:YES];
    CGSize temSize = [HemaFunction getSizeWithStrNo:labLeft.text width:80 font:14];
    [picImgView setFrame:CGRectMake(17+temSize.width+3, 10, 6, 6)];
    
    UIImageView *arrowImgView = (UIImageView*)[cell viewWithTag:13];
    if (isSelf)
    {
        [arrowImgView setHidden:NO];
        [labRight setFrame:CGRectMake(100, 0, UI_View_Width-130, 44)];
    }else
    {
        [arrowImgView setHidden:YES];
        [labRight setFrame:CGRectMake(100, 0, UI_View_Width-117, 44)];
    }
    
    if (1 == indexPath.section)
    {
        if (0 == indexPath.row)
        {
            [picImgView setHidden:NO];
            labRight.text = [dataSource objectForKey:@"nickname"];
        }
        if (1 == indexPath.row)
        {
            [picImgView setHidden:NO];
            labRight.text = [dataSource objectForKey:@"birthday"];
        }
        if (2 == indexPath.row)
        {
            [picImgView setHidden:NO];
            labRight.text = [dataSource objectForKey:@"sex"];
        }
        if (3 == indexPath.row)
        {
            labRight.text = [dataSource objectForKey:@"hometown"];
        }
        if (4 == indexPath.row)
        {
            labRight.text = [dataSource objectForKey:@"selfsign"];
            
            CGSize rightSize = [HemaFunction getSizeWithStrNo:labRight.text width:labRight.width font:14];
            if (rightSize.height>20)
            {
                [labRight setFrame:CGRectMake(100, 13.5-7, labRight.width, 13.5+rightSize.height)];
            }
        }
    }
    if (2 == indexPath.section)
    {
        if (0 == indexPath.row)
        {
            labRight.text = [dataSource objectForKey:@"location"];
        }
        if (1 == indexPath.row)
        {
            labRight.text = [dataSource objectForKey:@"company"];
        }
        if (2 == indexPath.row)
        {
            labRight.text = [dataSource objectForKey:@"job"];
        }
        if (3 == indexPath.row)
        {
            labRight.text = [dataSource objectForKey:@"motocar_name"];
        }
        if (4 == indexPath.row)
        {
            labRight.text = [dataSource objectForKey:@"school"];
        }
    }
    
    return cell;
}
#pragma mark- TableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.section)
    {
        return 143;
    }
    if (1 == indexPath.section)
    {
        if (4 == indexPath.row)
        {
            CGSize rightSize = [HemaFunction getSizeWithStrNo:[dataSource objectForKey:@"selfsign"] width:isSelf?(UI_View_Width-130):(UI_View_Width-117) font:14];
            if (rightSize.height>20)
            {
                return 27+rightSize.height;
            }
        }
    }
    return 44;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 8;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *) indexPath
{
    if (!isSelf)
    {
        return;
    }
    if (1 == indexPath.section)
    {
        //昵称
        if (0 == indexPath.row)
        {
            HemaEditorVC *editor = [[HemaEditorVC alloc]init];
            editor.editorType = EditorTypeSinleInput;
            editor.key = @"nickname";
            editor.title = @"昵称";
            editor.content = [dataSource objectForKey:@"nickname"];
            editor.explanation = @"昵称不能超过八个字";
            editor.mymaxlength = 8;
            editor.keyBoardType = UIKeyboardTypeDefault;
            editor.delegate = self;
            [self.navigationController pushViewController:editor animated:YES];
        }
        //出生日期
        if (1 == indexPath.row)
        {
            HemaEditorVC *editor = [[HemaEditorVC alloc]init];
            editor.editorType = EditorTypeYMDPick;
            editor.key = @"birthday";
            editor.title = @"出生日期";
            if ([HemaFunction xfunc_check_strEmpty:[dataSource objectForKey:@"birthday"]])
            {
                editor.content = @"1990-01-01";
            }else
            {
                editor.content = [dataSource objectForKey:@"birthday"];
            }
            editor.explanation = @"";
            editor.mymaxlength = 20;
            editor.keyBoardType = UIKeyboardTypeNumberPad;
            editor.delegate = self;
            [self.navigationController pushViewController:editor animated:YES];
        }
        //性别
        if (2 == indexPath.row)
        {
            UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:@"性别" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"男",@"女",Button_Cancel, nil];
            [SystemFunction setActionSheet:actionSheet index:2 myVC:self];
        }
        //家乡
        if (3 == indexPath.row)
        {
            
        }
        //个性签名
        if (4 == indexPath.row)
        {
            HemaReplyVC *myVC = [[HemaReplyVC alloc]init];
            myVC.keyName = @"selfsign";
            myVC.titleName = @"个性签名";
            myVC.publishContent = [dataSource objectForKey:@"selfsign"];
            myVC.placeholder = @"请输入您的个性签名...";
            myVC.delegate = self;
            [self.navigationController pushViewController:myVC animated:YES];
        }
    }
    if (2 == indexPath.section)
    {
        //所在地
        if (0 == indexPath.row)
        {
            
        }
        //公司
        if (1 == indexPath.row)
        {
            HemaEditorVC *editor = [[HemaEditorVC alloc]init];
            editor.editorType = EditorTypeSinleInput;
            editor.key = @"company";
            editor.title = @"公司";
            editor.content = [dataSource objectForKey:@"company"];
            editor.explanation = @"";
            editor.mymaxlength = 20;
            editor.keyBoardType = UIKeyboardTypeDefault;
            editor.delegate = self;
            [self.navigationController pushViewController:editor animated:YES];
        }
        //职业
        if (2 == indexPath.row)
        {
            HemaEditorVC *editor = [[HemaEditorVC alloc]init];
            editor.editorType = EditorTypeSinleInput;
            editor.key = @"job";
            editor.title = @"职业";
            editor.content = [dataSource objectForKey:@"job"];
            editor.explanation = @"";
            editor.mymaxlength = 20;
            editor.keyBoardType = UIKeyboardTypeDefault;
            editor.delegate = self;
            [self.navigationController pushViewController:editor animated:YES];
        }
        //车辆
        if (3 == indexPath.row)
        {
            ActionStringDoneBlock done = ^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue)
            {
                NSLog(@"选取的内容：%@", selectedValue);
                [dataSource setObject:selectedValue forKey:@"motocar_name"];
                [self.mytable reloadData];
            };
            ActionStringCancelBlock cancel = ^(ActionSheetStringPicker *picker)
            {
                NSLog(@"取消选择");
            };
            NSArray *colors = @[@"宝马", @"奔驰", @"大众", @"吉普",@"红旗"];
            
            NSInteger index = 0;
            if (![HemaFunction xfunc_check_strEmpty:[dataSource objectForKey:@"motocar_name"]])
            {
                for (int i=0; i<colors.count; i++)
                {
                    if ([[dataSource objectForKey:@"motocar_name"]isEqualToString:[colors objectAtIndex:i]])
                    {
                        index = i;
                        break;
                    }
                }
            }
            
            ActionSheetStringPicker* picker = [[ActionSheetStringPicker alloc] initWithTitle:@"选择车辆" rows:colors initialSelection:index doneBlock:done cancelBlock:cancel origin:self.view];
            picker.tapDismissAction = TapActionCancel;
            [picker showActionSheetPicker];
        }
        //学校
        if (4 == indexPath.row)
        {
            HemaEditorVC *editor = [[HemaEditorVC alloc]init];
            editor.editorType = EditorTypeSinleInput;
            editor.key = @"school";
            editor.title = @"学校";
            editor.content = [dataSource objectForKey:@"school"];
            editor.explanation = @"";
            editor.mymaxlength = 20;
            editor.keyBoardType = UIKeyboardTypeDefault;
            editor.delegate = self;
            [self.navigationController pushViewController:editor animated:YES];
        }
    }
}
#pragma mark- 连接服务器
#pragma mark 个人资料
- (void)requestGetInfor
{
    NSString *token = [[HemaManager sharedManager] userToken];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:token forKey:@"token"];
    [dic setObject:self.userId forKey:@"id"];
    
    [HemaRequest requestWithURL:[NSString stringWithFormat:@"%@%@",REQUEST_MAINLINK,REQUEST_CLIENT_GET] target:self selector:@selector(responseGetInfor:) parameter:dic];
}
- (void)responseGetInfor:(NSDictionary*)info
{
    if(1 == [[info objectForKey:@"success"] intValue])
    {
        if(![HemaFunction xfunc_check_strEmpty:[info objectForKey:@"infor"]])
        {
            if (!dataSource)
                dataSource = [[NSMutableDictionary alloc]init];
            dataSource = [SystemFunction getDicFromDic:[[info objectForKey:@"infor"] objectAtIndex:0]];
            
            if (isSelf)
            {
                HemaManager *myManager = [HemaManager sharedManager];
                myManager.myInfor = dataSource;
            }else
            {
                if ([[dataSource objectForKey:@"friendflag"]integerValue] == 1)
                {
                    [self initDown:@"删除好友" twoStr:@"聊天"];
                }else
                {
                    [self initDown:@"添加好友" twoStr:@""];
                }
            }
            [self.mytable reloadData];
        }
    }else
    {
        [HemaFunction openIntervalHUD:[info objectForKey:@"msg"]];
    }
}
#pragma mark 用户注册
- (void)requestRegister
{
    if ([HemaFunction xfunc_check_strEmpty:[dataSource objectForKey:@"nickname"]])
    {
        [HemaFunction openIntervalHUD:@"昵称不能为空"];
        return;
    }
    if ([HemaFunction xfunc_check_strEmpty:[dataSource objectForKey:@"birthday"]])
    {
        [HemaFunction openIntervalHUD:@"出生日期不能为空"];
        return;
    }
    if ([HemaFunction xfunc_check_strEmpty:[dataSource objectForKey:@"sex"]])
    {
        [HemaFunction openIntervalHUD:@"性别不能为空" ];
        return;
    }
    if ([[dataSource objectForKey:@"nickname"]length] > 8)
    {
        [HemaFunction openIntervalHUD:@"昵称不能超过八个字"];
        return;
    }
    waitMB = [HemaFunction openHUD:@"正在注册"];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:[[[HemaManager sharedManager]fromDic]objectForKey:@"token"] forKey:@"temp_token"];
    [dic setObject:[dataSource objectForKey:@"nickname"] forKey:@"nickname"];
    [dic setObject:[HemaFunction xfuncGetAppdelegate].mycity forKey:@"district_name"];
    [dic setObject:[[[HemaManager sharedManager]fromDic]objectForKey:@"mobile"] forKey:@"username"];
    [dic setObject:[[[HemaManager sharedManager]fromDic]objectForKey:@"password"] forKey:@"password"];
    [dic setObject:[dataSource objectForKey:@"sex"]?[dataSource objectForKey:@"sex"]:@"男" forKey:@"sex"];
    [dic setObject:[dataSource objectForKey:@"hometown"]?[dataSource objectForKey:@"hometown"]:@"山东省济南市" forKey:@"hometown"];
    [dic setObject:[dataSource objectForKey:@"selfsign"]?[dataSource objectForKey:@"selfsign"]:@"无" forKey:@"selfsign"];
    [dic setObject:[dataSource objectForKey:@"location"]?[dataSource objectForKey:@"location"]:@"无" forKey:@"location"];
    [dic setObject:[dataSource objectForKey:@"birthday"]?[dataSource objectForKey:@"birthday"]:@"" forKey:@"birthday"];
    [dic setObject:[dataSource objectForKey:@"company"]?[dataSource objectForKey:@"company"]:@"无" forKey:@"company"];
    [dic setObject:[dataSource objectForKey:@"school"]?[dataSource objectForKey:@"school"]:@"无" forKey:@"school"];
    [dic setObject:[dataSource objectForKey:@"motocar_id"]?[dataSource objectForKey:@"motocar_id"]:@"0" forKey:@"motocar_id"];
    [dic setObject:[dataSource objectForKey:@"job"]?[dataSource objectForKey:@"job"]:@"无" forKey:@"job"];
    
    [HemaRequest requestWithURL:[NSString stringWithFormat:@"%@%@",REQUEST_MAINLINK,REQUEST_CLIENT_ADD] target:self selector:@selector(responseRegister:) parameter:dic];
}
- (void)responseRegister:(NSDictionary*)info
{
    if(1 == [[info objectForKey:@"success"] intValue])
    {
        [[NSUserDefaults standardUserDefaults] setValue:@"yes" forKey:BB_XCONST_ISAUTO_LOGIN];
        [[NSUserDefaults standardUserDefaults] setValue:[[[HemaManager sharedManager]fromDic]objectForKey:@"mobile"] forKey:BB_XCONST_LOCAL_LOGINNAME];
        [[NSUserDefaults standardUserDefaults] setValue:[[[HemaManager sharedManager]fromDic]objectForKey:@"password"] forKey:BB_XCONST_LOCAL_PASSWORD];
        
        NSString *mytoken = [[[info objectForKey:@"infor"] objectAtIndex:0] objectForKey:@"token"];
        [[[HemaManager sharedManager] fromDic] setObject:mytoken forKey:@"token"];
        
        if (_headImg)
        {
            NSData *temData = UIImageJPEGRepresentation(_headImg, 0.8);
            [self requestPublishFile:temData];
        }else
        {
            [[NSUserDefaults standardUserDefaults] setValue:[[[HemaManager sharedManager]fromDic]objectForKey:@"mobile"] forKey:BB_XCONST_LOCAL_LOGINNAME];
            [[NSUserDefaults standardUserDefaults] setValue:[[[HemaManager sharedManager]fromDic]objectForKey:@"password"] forKey:BB_XCONST_LOCAL_PASSWORD];
            [[HemaFunction xfuncGetAppdelegate]requestLogin];
        }
    }
    else
    {
        [HemaFunction closeHUD:waitMB];
        [HemaFunction openIntervalHUD:[info objectForKey:@"msg"]];
    }
}
#pragma mark 上传文件
- (void)requestPublishFile:(NSData*)data
{
    NSString *token = nil;
    if (isRegister)
    {
        token = [[[HemaManager sharedManager]fromDic]objectForKey:@"token"];
    }else
    {
        token = [[HemaManager sharedManager] userToken];
    }
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:token forKey:@"token"];
    [dic setObject:@"1" forKey:@"keytype"];
    [dic setObject:@"0" forKey:@"keyid"];
    [dic setObject:@"0" forKey:@"duration"];
    [dic setObject:@"0" forKey:@"orderby"];
    [dic setObject:data forKey:@"temp_file"];
    [dic setObject:@"无" forKey:@"content"];
    
    [HemaRequest requestWithURL:[NSString stringWithFormat:@"%@%@",REQUEST_MAINLINK,REQUEST_FILE_UPLOAD] target:self selector:@selector(responsePublishFile:) parameter:dic];
}
- (void)responsePublishFile:(NSDictionary*)info
{
    if(1 == [[info objectForKey:@"success"] intValue])
    {
        if (isRegister)
        {
            //登录去首页
            [[NSUserDefaults standardUserDefaults] setValue:[[[HemaManager sharedManager]fromDic]objectForKey:@"mobile"] forKey:BB_XCONST_LOCAL_LOGINNAME];
            [[NSUserDefaults standardUserDefaults] setValue:[[[HemaManager sharedManager]fromDic]objectForKey:@"password"] forKey:BB_XCONST_LOCAL_PASSWORD];
            [[HemaFunction xfuncGetAppdelegate]requestLogin];
            return;
        }
        [HemaFunction closeHUD:waitMB];
        [HemaFunction openIntervalHUDOK:@"保存成功"];
        [self leftbtnPressed:nil];
    }else
    {
        [HemaFunction closeHUD:waitMB];
        [HemaFunction openIntervalHUD:[info objectForKey:@"msg"]];
    }
}
#pragma mark 保存个人资料
- (void)requestSaveClient
{
    waitMB = [HemaFunction openHUD:@"正在保存"];
    
    NSString *token = [[HemaManager sharedManager] userToken];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:token forKey:@"token"];
    [dic setObject:[HemaFunction xfuncGetAppdelegate].mycity forKey:@"district_name"];
    [dic setObject:[dataSource objectForKey:@"nickname"]?[dataSource objectForKey:@"nickname"]:@"美女" forKey:@"nickname"];
    [dic setObject:[dataSource objectForKey:@"sex"]?[dataSource objectForKey:@"sex"]:@"男" forKey:@"sex"];
    [dic setObject:[dataSource objectForKey:@"hometown"]?[dataSource objectForKey:@"hometown"]:@"山东省济南市" forKey:@"hometown"];
    [dic setObject:[dataSource objectForKey:@"selfsign"]?[dataSource objectForKey:@"selfsign"]:@"无" forKey:@"selfsign"];
    [dic setObject:[dataSource objectForKey:@"location"]?[dataSource objectForKey:@"location"]:@"无" forKey:@"location"];
    [dic setObject:[dataSource objectForKey:@"birthday"]?[dataSource objectForKey:@"birthday"]:@"" forKey:@"birthday"];
    [dic setObject:[dataSource objectForKey:@"company"]?[dataSource objectForKey:@"company"]:@"无" forKey:@"company"];
    [dic setObject:[dataSource objectForKey:@"school"]?[dataSource objectForKey:@"school"]:@"无" forKey:@"school"];
    [dic setObject:[dataSource objectForKey:@"motocar_id"]?[dataSource objectForKey:@"motocar_id"]:@"0" forKey:@"motocar_id"];
    [dic setObject:[dataSource objectForKey:@"job"]?[dataSource objectForKey:@"job"]:@"无" forKey:@"job"];
    
    [HemaRequest requestWithURL:[NSString stringWithFormat:@"%@%@",REQUEST_MAINLINK,REQUEST_CLIENT_SAVE] target:self selector:@selector(responseSaveClient:) parameter:dic];
}
- (void)responseSaveClient:(NSDictionary*)info
{
    if(1 == [[info objectForKey:@"success"] intValue])
    {
        if (_headImg)
        {
            NSData *temData = UIImageJPEGRepresentation(_headImg, 0.8);
            [self requestPublishFile:temData];
        }else
        {
            [HemaFunction closeHUD:waitMB];
            [HemaFunction openIntervalHUDOK:@"资料保存成功"];
            [self leftbtnPressed:nil];
        }
    }else
    {
        [HemaFunction closeHUD:waitMB];
        [HemaFunction openIntervalHUD:[info objectForKey:@"msg"]];
    }
}
#pragma mark 加好友
- (void)requestAdd
{
    NSString *token = [[HemaManager sharedManager] userToken];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:token forKey:@"token"];
    [dic setObject:[dataSource objectForKey:@"id"] forKey:@"friendid"];
    
    waitMB = [HemaFunction openHUD:@"正在申请"];
    
    [HemaRequest requestWithURL:[NSString stringWithFormat:@"%@%@",REQUEST_MAINLINK,REQUEST_FRIEND_ADD] target:self selector:@selector(responseAdd:) parameter:dic];
}
- (void)responseAdd:(NSDictionary*)info
{
    [HemaFunction closeHUD:waitMB];
    if(1 == [[info objectForKey:@"success"] intValue])
    {
        [HemaFunction openIntervalHUD:@"已向对方申请，敬请等待"];
        [self.mytable reloadData];
    }else
    {
        [HemaFunction openIntervalHUD:[info objectForKey:@"msg"]];
    }
}
#pragma mark 删除好友
- (void)requestDelete
{
    NSString *token = [[HemaManager sharedManager] userToken];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:token forKey:@"token"];
    [dic setObject:[dataSource objectForKey:@"id"] forKey:@"friendid"];
    
    waitMB = [HemaFunction openHUD:@"正在删除"];
    
    [HemaRequest requestWithURL:[NSString stringWithFormat:@"%@%@",REQUEST_MAINLINK,REQUEST_FRIEND_REMOVE] target:self selector:@selector(responseDelete:) parameter:dic];
}
- (void)responseDelete:(NSDictionary*)info
{
    [HemaFunction closeHUD:waitMB];
    if(1 == [[info objectForKey:@"success"] intValue])
    {
        [dataSource setObject:@"0" forKey:@"friendflag"];
        [self initDown:@"添加好友" twoStr:@""];
        [self.mytable reloadData];
    }else
    {
        [HemaFunction openIntervalHUD:[info objectForKey:@"msg"]];
    }
}
@end
