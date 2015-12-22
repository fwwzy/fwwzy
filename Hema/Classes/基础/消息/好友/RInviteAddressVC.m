//
//  RInviteAddressVC.m
//  Hema
//
//  Created by LarryRodic on 15/10/9.
//  Copyright (c) 2015年 Hemaapp. All rights reserved.
//

#import "RInviteAddressVC.h"

#import <MessageUI/MessageUI.h>
#import <AddressBookUI/AddressBookUI.h>
#import <AddressBook/AddressBook.h>

#import "RFriendSearchVC.h"

@interface RInviteAddressVC ()<MFMessageComposeViewControllerDelegate>
@property(nonatomic,strong)NSMutableArray *dataSource;//通讯录里的所有数据
@property(nonatomic,strong)NSMutableArray *dataHave;//已安装的
@property(nonatomic,strong)NSMutableArray *dataNoHave;//未安装的
@end

@implementation RInviteAddressVC
@synthesize dataSource;
@synthesize dataHave;
@synthesize dataNoHave;

-(void)loadSet
{
    [self.navigationItem setNewTitle:@"添加好友"];
    [SystemFunction setTableSeparatorInset:self.mytable left:10];
    
    [self forbidPullRefresh];
    [self initTopView];
}
-(void)loadData
{
    dataSource = [[NSMutableArray alloc]init];
    dataHave = [[NSMutableArray alloc]init];
    dataNoHave = [[NSMutableArray alloc]init];
    
    [NSTimer scheduledTimerWithTimeInterval:0.25 target:self selector:@selector(timerSetRead:) userInfo:nil repeats:NO];
}
-(void)initTopView
{
    UIView *topView = [[UIView alloc]init];
    [topView setFrame:CGRectMake(0, 0, UI_View_Width, 56)];
    self.mytable.tableHeaderView = topView;
    
    //搜索相关
    UISearchBar *searcher = [[UISearchBar alloc] initWithFrame:CGRectZero];
    searcher.barStyle = UIBarButtonItemStylePlain;
    searcher.placeholder = @"搜索";
    [searcher setTintColor:[UIColor blackColor]];
    searcher.translucent = NO;
    searcher.backgroundColor = [UIColor clearColor];
    [searcher sizeToFit];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    [imageView setFrame:CGRectMake(0, -20, UI_View_Width, 64)];
    imageView.backgroundColor = RGB_UI_COLOR(227, 227, 227);
    [searcher insertSubview:imageView atIndex:1];
    
    [searcher setFrame:CGRectMake(0, 5, UI_View_Width, 44)];
    [topView addSubview:searcher];
    
    //点击跳页的按钮
    UIButton *temBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [temBtn setFrame:CGRectMake(0, 0, UI_View_Width, 44)];
    [temBtn addTarget:self action:@selector(searchPressed:) forControlEvents:UIControlEventTouchUpInside];
    [searcher addSubview:temBtn];
}
//搜索所有人员
-(void)searchPressed:(id)sender
{
    RFriendSearchVC *myVC = [[RFriendSearchVC alloc]init];
    myVC.searchType = 2;
    [[SystemFunction getFirstVCFromVC:self].navigationController pushViewController:myVC animated:NO];
}
#pragma mark- 自定义
#pragma mark 事件
-(void)timerSetRead:(NSTimer*)sender
{
    [self readAllPeoples];
    [sender invalidate];
}
#pragma mark 方法
//读取所有联系人
-(void)readAllPeoples
{
    //取得本地通信录名柄
    ABAddressBookRef tmpAddressBook = nil;
    
    tmpAddressBook=ABAddressBookCreateWithOptions(NULL, NULL);
    dispatch_semaphore_t sema=dispatch_semaphore_create(0);
    ABAddressBookRequestAccessWithCompletion(tmpAddressBook, ^(bool greanted, CFErrorRef error){
        dispatch_semaphore_signal(sema);
    });
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    
    //取得本地所有联系人记录
    if (tmpAddressBook == nil)
    {
        return ;
    };
    CFArrayRef herePeoples = ABAddressBookCopyArrayOfAllPeople(tmpAddressBook);
    NSArray* tmpPeoples = (__bridge NSArray*)herePeoples;
    
    for(id tmpPerson in tmpPeoples)
    {
        //获取的联系人单一属性:First name
        CFTypeRef oneFirstName = ABRecordCopyValue((__bridge ABRecordRef)(tmpPerson), kABPersonFirstNameProperty);
        NSString* tmpFirstName = (__bridge NSString*)oneFirstName;
        
        //获取的联系人单一属性:Last name
        CFTypeRef oneLastName = ABRecordCopyValue((__bridge ABRecordRef)(tmpPerson), kABPersonLastNameProperty);
        NSString* tmpLastName = (__bridge NSString*)oneLastName;
        
        NSString *mobilename = [NSString stringWithFormat:@"%@%@",tmpLastName,tmpFirstName];
        if ([HemaFunction xfunc_check_strEmpty:tmpLastName])
        {
            if ([HemaFunction xfunc_check_strEmpty:tmpFirstName])
            {
                mobilename = @"";
            }else
            {
                mobilename = tmpFirstName;
            }
        }else
        {
            if ([HemaFunction xfunc_check_strEmpty:tmpFirstName])
            {
                mobilename = tmpLastName;
            }else
            {
                mobilename = [NSString stringWithFormat:@"%@%@",tmpLastName,tmpFirstName];
            }
        }
        //获取的联系人单一属性:Generic phone number
        ABMultiValueRef tmpPhones = ABRecordCopyValue((__bridge ABRecordRef)(tmpPerson), kABPersonPhoneProperty);
        for(NSInteger j = 0; j < ABMultiValueGetCount(tmpPhones); j++)
        {
            CFTypeRef onePhoneIndex = ABMultiValueCopyValueAtIndex(tmpPhones, j);
            NSString* tmpPhoneIndex = (__bridge NSString*)onePhoneIndex;
            
            NSString *phone = [tmpPhoneIndex stringByReplacingOccurrencesOfString:@"-" withString:@""];
            if ([HemaFunction xfunc_isMobileNumber:phone])
            {
                if ([phone isEqualToString:[[[HemaManager sharedManager] myInfor] objectForKey:@"mobile"]])
                {
                    break;
                }
                //添加数据
                NSMutableDictionary *temDic = [[NSMutableDictionary alloc]initWithObjectsAndKeys:mobilename,@"nickname",phone,@"mobile",@"1",@"have", nil];
                [dataSource addObject:temDic];
                
                NSMutableDictionary *temDic1 = [[NSMutableDictionary alloc]initWithObjectsAndKeys:mobilename,@"nickname",phone,@"mobile",@"1",@"have", nil];
                [dataNoHave addObject:temDic1];
            }
            CFRelease(onePhoneIndex);
        }
        if (tmpPhones)
            CFRelease(tmpPhones);
        if (oneFirstName)
            CFRelease(oneFirstName);
        if (oneLastName)
            CFRelease(oneLastName);
    }
    if (tmpAddressBook)
        CFRelease(tmpAddressBook);
    if (herePeoples)
        CFRelease(herePeoples);
    
    [self requestGetMobileList];
}
#pragma mark - Message Delegate
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [controller dismissViewControllerAnimated:YES completion:nil];
    
    if (result == MessageComposeResultCancelled)
    {
        
    }else if (result == MessageComposeResultSent)
    {
        [HemaFunction openIntervalHUDOK:@"发送成功"];
    }else
    {
        [HemaFunction openIntervalHUD:@"发送失败"];
    }
}
#pragma mark- TableView DataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1+dataHave.count+dataNoHave.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.row)
    {
        static NSString *CellIdentifier = @"000";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if(cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = BB_White_Color;
            
            //左侧
            UILabel *labLeft = [[UILabel alloc]init];
            labLeft.backgroundColor = [UIColor clearColor];
            labLeft.textAlignment = NSTextAlignmentLeft;
            labLeft.font = [UIFont systemFontOfSize:14];
            labLeft.textColor = BB_Gray_Color;
            labLeft.frame = CGRectMake(20, 0, 200, 40);
            labLeft.text = @"通讯录好友";
            labLeft.numberOfLines = 0;
            [cell.contentView addSubview:labLeft];
            
            UIView *leftView = [[UIView alloc]init];
            [leftView setFrame:CGRectMake(10, 12.5, 4, 15)];
            [leftView setBackgroundColor:BB_Blue_Color];
            [HemaFunction addbordertoView:leftView radius:2 width:0.0 color:[UIColor clearColor]];
            [cell.contentView addSubview:leftView];
        }
        return cell;
    }
    static NSString *CellIdentifier = @"all";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.contentView.backgroundColor = BB_White_Color;
        
        //左侧
        UILabel *labLeft = [[UILabel alloc]init];
        labLeft.backgroundColor = [UIColor clearColor];
        labLeft.textAlignment = NSTextAlignmentLeft;
        labLeft.font = [UIFont systemFontOfSize:15];
        [labLeft setFrame:CGRectMake(10, 0, UI_View_Width-100, 56)];
        labLeft.tag = 10;
        [labLeft setTextColor:BB_Blake_Color];
        [cell.contentView addSubview:labLeft];
        
        //内容
        UILabel *labInvite = [[UILabel alloc]init];
        labInvite.backgroundColor = [UIColor clearColor];
        labInvite.textAlignment = NSTextAlignmentCenter;
        labInvite.textColor = BB_Green_Color;
        labInvite.font = [UIFont systemFontOfSize:15];
        labInvite.frame = CGRectMake(UI_View_Width-67, 12, 56, 32);
        labInvite.tag = 11;
        [cell.contentView addSubview:labInvite];
    }
    NSMutableDictionary *temDic = nil;
    if (dataHave.count>=indexPath.row)
    {
        temDic = [dataHave objectAtIndex:indexPath.row-1];
    }else
    {
        temDic = [dataNoHave objectAtIndex:indexPath.row-1-dataHave.count];
    }
    
    //左侧
    UILabel *labLeft = (UILabel*)[cell viewWithTag:10];
    if (![HemaFunction xfunc_check_strEmpty:[temDic objectForKey:@"nickname"]])
    {
        [labLeft setText:[temDic objectForKey:@"nickname"]];
    }
    
    //内容
    UILabel *labInvite = (UILabel*)[cell viewWithTag:11];
    
    if (dataHave.count>=indexPath.row)
    {
        if ([[temDic objectForKey:@"friendflag"]integerValue] == 1)
        {
            [labInvite setText:@"已添加"];
            
            [HemaFunction addbordertoView:labInvite radius:4 width:0.5 color:BB_Border_Color];
            [labInvite setTextColor:BB_Gray_Color];
        }else
        {
            [labInvite setText:@"添加"];
            
            [HemaFunction addbordertoView:labInvite radius:4 width:0.5 color:BB_Blue_Color];
            [labInvite setTextColor:BB_Blue_Color];
        }
    }else
    {
        [labInvite setText:@"邀请"];
        
        [HemaFunction addbordertoView:labInvite radius:4 width:0.5 color:BB_Blue_Color];
        [labInvite setTextColor:BB_Blue_Color];
    }
    
    return cell;
}
#pragma mark- TableView Delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.row)
    {
        return 40;
    }
    return 56;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *) indexPath
{
    if (0 == indexPath.row)
    {
        return;
    }
    
    NSMutableDictionary *temDic = nil;
    if (dataHave.count>=indexPath.row)
    {
        temDic = [dataHave objectAtIndex:indexPath.row-1];
    }else
    {
        temDic = [dataNoHave objectAtIndex:indexPath.row-1-dataHave.count];
    }
    
    if (dataHave.count>=indexPath.row)
    {
        if ([[temDic objectForKey:@"friendflag"]integerValue] == 0)
        {
            [self requestSaveFriend:[temDic objectForKey:@"id"]];
        }
        return;
    }
    
    if( [MFMessageComposeViewController canSendText] )
    {
        NSMutableDictionary *infor = [[HemaManager sharedManager] myInitInfor];
        NSString *msg_invite = [infor objectForKey:@"msg_invite"];
        
        MFMessageComposeViewController * controller = [[MFMessageComposeViewController alloc] init];
        controller.recipients = [NSArray arrayWithObject:[temDic objectForKey:@"mobile"]];
        controller.body = msg_invite;
        controller.messageComposeDelegate = self;
        [[SystemFunction getFirstVCFromVC:self] presentViewController:controller animated:YES completion:nil];
        return;
    }
    else
    {
        [HemaFunction openIntervalHUD:@"不支持发短信！"];
    }
}
#pragma mark - 连接服务器
#pragma mark 通讯录的人员
- (void)requestGetMobileList
{
    NSString *temStr = nil;
    if (dataSource.count != 0)
    {
        temStr = [[dataSource objectAtIndex:0]objectForKey:@"mobile"];
        for (int i = 1; i<dataSource.count; i++)
        {
            temStr = [NSString stringWithFormat:@"%@,%@",temStr,[[dataSource objectAtIndex:i]objectForKey:@"mobile"]];
        }
    }else
    {
        return;
    }
    
    NSString *token = [[HemaManager sharedManager] userToken];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:token forKey:@"token"];
    [dic setObject:temStr forKey:@"mobile_list"];
    
    [HemaRequest requestWithURL:[NSString stringWithFormat:@"%@%@",REQUEST_MAINLINK,REQUEST_MOBILE_LIST] target:self selector:@selector(responseGetMobileList:) parameter:dic];
}
- (void)responseGetMobileList:(NSDictionary*)info
{
    [self.mytable setHidden:NO];
    if(1 == [[info objectForKey:@"success"] intValue])
    {
        if(![HemaFunction xfunc_check_strEmpty:[info objectForKey:@"infor"]])
        {
            [dataHave removeAllObjects];
            
            NSMutableArray *temArr = [info objectForKey:@"infor"];
            
            for (int i = 0; i<temArr.count; i++)
            {
                NSMutableDictionary *dict = [SystemFunction getDicFromDic:[temArr objectAtIndex:i]];
                [dataHave addObject:dict];
                
                for (int i = 0; i<dataSource.count; i++)
                {
                    if ([[[dataNoHave objectAtIndex:i]objectForKey:@"mobile"] isEqualToString:[dict objectForKey:@"mobile"]])
                    {
                        [dataNoHave removeObjectAtIndex:i];
                        break;
                    }
                }
            }
        }
        [self.mytable reloadData];
    }else
    {
        [HemaFunction openIntervalHUD:[info objectForKey:@"msg"]];
    }
}
#pragma mark 添加好友
- (void)requestSaveFriend:(NSString*)friendid
{
    NSString *token = [[HemaManager sharedManager] userToken];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:token forKey:@"token"];
    [dic setObject:friendid forKey:@"friendid"];
    
    waitMB = [HemaFunction openHUD:@"正在申请"];
    
    [HemaRequest requestWithURL:[NSString stringWithFormat:@"%@%@",REQUEST_MAINLINK,REQUEST_FRIEND_ADD] target:self selector:@selector(responseSaveFriend:) parameter:dic];
}
- (void)responseSaveFriend:(NSDictionary*)info
{
    [HemaFunction closeHUD:waitMB];
    if(1 == [[info objectForKey:@"success"] intValue])
    {
        [HemaFunction openIntervalHUD:@"已向对方申请，敬请等待"];
    }else
    {
        [HemaFunction openIntervalHUD:[info objectForKey:@"msg"]];
    }
}
@end
