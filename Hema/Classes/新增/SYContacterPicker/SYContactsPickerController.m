//
//  SYContactsPickerController.m
//  SYContactsPicker
//
//  Created by reesun on 15/12/30.
//  Copyright © 2015年 SY. All rights reserved.
//

#import "SYContactsPickerController.h"
#import <AddressBook/AddressBook.h>
#import <Contacts/Contacts.h>
#import "SYContacter.h"
#import "NSString+SY.h"
#import "SYContactsHelper.h"
#import <MessageUI/MessageUI.h>
#import "SYCell.h"

@interface SYContactsPickerController () <UITableViewDataSource, UITableViewDelegate,UINavigationControllerDelegate,MFMessageComposeViewControllerDelegate> {
@private
    
    NSMutableArray *_phoneArr;
    NSInteger *_page;
}

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation SYContactsPickerController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor colorWithRed:252.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:0.8];
    [self createTopBar];
    _phoneArr = [[NSMutableArray alloc]init];
    
    __weak SYContactsPickerController *weakSelf = self;
    
    [SYContactsHelper fetchContacts:^(NSArray <SYContacter *> *contacts, BOOL success) {
        if (success) {
            [weakSelf reloadContacts:contacts];
        }
        else {
            [weakSelf showUserDenied];
        }
    }];
}

- (void)createTopBar {
    UIView *vTopBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    vTopBar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    vTopBar.backgroundColor = BB_Red_Color;
    CGFloat btnWidth = 100;
    
    // 标题
    UIButton *_btnTitle = [[UIButton alloc] initWithFrame:CGRectMake(btnWidth, 20, self.view.frame.size.width - btnWidth * 2, 44)];
    _btnTitle.titleLabel.font = [UIFont systemFontOfSize:20.0];
    _btnTitle.exclusiveTouch = YES;
    [_btnTitle setTitle:@"邀请好友" forState:UIControlStateNormal];
    [_btnTitle setTitleColor:BB_White_Color forState:UIControlStateNormal];
    
    // 左按钮
    UIButton *_btnLeft = [[UIButton alloc] initWithFrame:CGRectMake(15, 29, 18, 24)];
    _btnLeft.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _btnLeft.exclusiveTouch = YES;
    _btnLeft.titleEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
    [_btnLeft setBackgroundImage:[UIImage imageNamed:@"lg_back"] forState:UIControlStateNormal];
    [_btnLeft addTarget:self action:@selector(onClickBtnBack:) forControlEvents: UIControlEventTouchUpInside];
    
    // 右按钮
    UIButton *_btnRight = [[UIButton alloc] initWithFrame:CGRectMake(UI_View_Width-110, 10, 100, 30)];
//    _btnRight.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    _btnRight.titleLabel.font = [UIFont systemFontOfSize:16.0];
//    _btnRight.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 15);
    _btnRight.layer.borderWidth = 1;
    _btnRight.layer.borderColor = [BB_Red_Color CGColor];
    _btnRight.backgroundColor = BB_White_Color;
    _btnRight.exclusiveTouch = YES;
    [_btnRight setTitle:@"确定" forState:UIControlStateNormal];
    [_btnRight setTitleColor:BB_Red_Color forState:UIControlStateNormal];
    [_btnRight addTarget:self action:@selector(onClickBtnSave:) forControlEvents: UIControlEventTouchUpInside];
    
    [vTopBar addSubview:_btnTitle];
    [vTopBar addSubview:_btnLeft];
    [self.view addSubview:vTopBar];
    //下方视图
    UIView *lastView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.height - 50, UI_View_Width, 50)];
    lastView.backgroundColor = BB_White_Color;
    [self.view addSubview:lastView];
    [lastView addSubview:_btnRight];
    
    UIButton *selectBtn = [[UIButton alloc]initWithFrame:CGRectMake(16, 14, 22, 22)];
    [selectBtn setBackgroundImage:[UIImage imageNamed:@"selected"] forState:UIControlStateNormal];
    [selectBtn setBackgroundImage:[UIImage imageNamed:@"selected_h"] forState:UIControlStateSelected];
    [selectBtn addTarget:self action:@selector(selectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [selectBtn setSelected:NO];
//    [lastView addSubview:selectBtn];
    
    UILabel *allLabel = [[UILabel alloc]initWithFrame:CGRectMake(57, 15, 50, 20)];
    allLabel.text = @"全选";
    allLabel.font = [UIFont systemFontOfSize:15];
//    [lastView addSubview:allLabel];
    
}

- (void)onClickBtnBack:(UIButton *)btn {
    if (self.delegate && [self.delegate respondsToSelector:@selector(contactsPickerControllerDidCancel:)]) {
        [self.delegate contactsPickerControllerDidCancel:self];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)onClickBtnSave:(UIButton *)btn {
    NSArray *selectedContacts = [self savedContacts];
    if (selectedContacts.count > 0) {
//        if (self.delegate && [self.delegate respondsToSelector:@selector(contactsPickerController:didFinishPickingContacts:)]) {
//            [self.delegate contactsPickerController:self didFinishPickingContacts:selectedContacts];
//        }
//        NSLog(@"%@",selectedContacts);
//        [self dismissViewControllerAnimated:YES completion:nil];
//        for (SYContacter *contacter in selectedContacts) {
//            contacter.phone
//        }
        
        
        [self sendMessage:selectedContacts];
    }
    else {
        NSLog(@"还未选择联系人!!!");
    }
    
}

- (NSArray *)savedContacts {
    NSMutableArray *contacts = [[NSMutableArray alloc] init];
    for (NSArray *section in _arrContacts) {
        for (SYContacter *contacter in section) {
            if (contacter.selected)
                [contacts addObject:contacter];
        }
    }
    
    return contacts;
}

- (void)reloadContacts:(NSArray *)contactsTemp {
    if (!_arrContacts) {
        _arrContacts = [[NSMutableArray alloc] init];
    }
    [_arrContacts removeAllObjects];
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 124) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.view addSubview:_tableView];
        _tableView.tableFooterView = [[UIView alloc] init];
    }
    
    UILocalizedIndexedCollation *theCollation = [UILocalizedIndexedCollation currentCollation];
    for (SYContacter *contacter in contactsTemp) {
        NSInteger sect = [theCollation sectionForObject:contacter
                                collationStringSelector:@selector(getContacterName)];
        contacter.section = sect;
    }
    
    NSInteger highSection = [[theCollation sectionTitles] count];
    NSMutableArray *sectionArrays = [NSMutableArray arrayWithCapacity:highSection];
    for (NSInteger i = 0; i <= highSection; i++) {
        NSMutableArray *sectionArray = [NSMutableArray arrayWithCapacity:1];
        [sectionArrays addObject:sectionArray];
    }
    
    for (SYContacter *addressBook in contactsTemp) {
        [(NSMutableArray *)[sectionArrays objectAtIndex:addressBook.section] addObject:addressBook];
    }
    
    //getContactName 如果这个返回的是nil会有问题
    for (NSMutableArray *sectionArray in sectionArrays) {
        NSArray *sortedSection = [theCollation sortedArrayFromArray:sectionArray collationStringSelector:@selector(getContacterName)];
        [_arrContacts addObject:sortedSection];
    }
    [self.tableView reloadData];
}

- (void)onClickBtnSetting:(UIButton *)btn {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root"]];
}

- (void)showUserDenied {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;
    label.textColor = [UIColor redColor];
    [self.view addSubview:label];
    
    NSString *str = [NSString stringWithFormat:@"您没有权限访问通讯录\n\n请到“设置-隐私-通讯录”里\n允许”SYContactsPicker“访问"];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:str];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20.0] range:[str rangeOfString:@"您没有权限访问通讯录"]];
    label.attributedText = attributedString;
    [label sizeToFit];
    label.frame = CGRectMake(0, 0, label.frame.size.width, label.frame.size.height);
    label.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2);
    
    UIButton *settingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    settingBtn.frame = CGRectMake(0, 0, 140, 40);
    settingBtn.backgroundColor = [UIColor blueColor];
    settingBtn.layer.cornerRadius = 5;
    settingBtn.layer.masksToBounds = YES;
    [settingBtn setTitle:@"去设置" forState:UIControlStateNormal];
    [settingBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    settingBtn.center = CGPointMake(self.view.frame.size.width / 2, label.center.y + 5 + 20 + label.frame.size.height / 2);
    [settingBtn addTarget:self action:@selector(onClickBtnSetting:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:settingBtn];
}

- (void)checkButtonTapped:(UIButton *)sender event:(id)event {
    NSSet *touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint: currentTouchPosition];
    
    if (indexPath) {
        [self accessoryButtonTappedForRowWithIndexPath:indexPath];
    }
    
    
}

- (void)accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    SYContacter *contacter = (SYContacter *)[[_arrContacts objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    BOOL checked = !contacter.selected;
    contacter.selected = checked;
    
    SYCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    
    [cell.button setSelected:checked];
}

#pragma mark -
#pragma mark UITableViewDataSource & UITableViewDelegate

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return [[NSArray array] arrayByAddingObjectsFromArray:
            [[UILocalizedIndexedCollation currentCollation] sectionIndexTitles]];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return [[UILocalizedIndexedCollation currentCollation] sectionForSectionIndexTitleAtIndex:index];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [_arrContacts count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [[_arrContacts objectAtIndex:section] count] ? [[[UILocalizedIndexedCollation currentCollation] sectionTitles] objectAtIndex:section] : nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return [[_arrContacts objectAtIndex:section] count] ? tableView.sectionHeaderHeight : 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[_arrContacts objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *kCellID = @"kCellID";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
    SYCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
    
    if (cell == nil) {
        cell = [[SYCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellID];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
//        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [cell.button setFrame:CGRectMake(16, 16, 22, 22)];
        [cell.button setBackgroundImage:[UIImage imageNamed:@"selected"] forState:UIControlStateNormal];
        [cell.button setBackgroundImage:[UIImage imageNamed:@"selected_h"] forState:UIControlStateSelected];
        [cell.button addTarget:self action:@selector(checkButtonTapped:event:) forControlEvents:UIControlEventTouchUpInside];
        [cell.button setSelected:NO];
        
//        [cell addSubview:button];
        
        cell.nameLabel.frame = CGRectMake(70, 15, 100, 20);
        
    }
    SYContacter *addressBook = (SYContacter *)[[_arrContacts objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    if ([[addressBook.name sy_trim] length] > 0) {
        
        cell.nameLabel.text = addressBook.name;
    }
    else {
        
        cell.nameLabel.text = @"无名氏";
    }
    
//    UIButton *button = (UIButton *)cell.button;
    
    [cell.button setSelected:addressBook.selected];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.delegate && [self.delegate respondsToSelector:@selector(contactsPickerController:didSelectRowAtIndexPath:)]) {
        [self.delegate contactsPickerController:self didSelectRowAtIndexPath:indexPath];
    }
    
    SYContacter *contacter = (SYContacter *)[[_arrContacts objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];

    if (self.delegate && [self.delegate respondsToSelector:@selector(contactsPickerController:didSelectContacter:)]) {
        [self.delegate contactsPickerController:self didSelectContacter:contacter];
    }

    [self accessoryButtonTappedForRowWithIndexPath:indexPath];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}
//==============================================
#pragma mark - 发送短信
-(void)sendMessage:(NSArray *)selectedContacts
{
    //用于判断是否有发送短信的功能（模拟器上就没有短信功能）
    Class messageClass = (NSClassFromString(@"MFMessageComposeViewController"));
    
    //判断是否有短信功能
    if (messageClass != nil) {
        //有发送功能要做的事情
        if ([messageClass canSendText]) {
            //发送短信
            MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
            messageController.delegate = self;
            messageController.messageComposeDelegate= self;
            
            //拼接并设置短信内容
            NSString *messageContent = @"假肢是狗假肢是狗假肢就是一只狗";
            messageController.body = messageContent;
            
            //设置发送给谁
            for (SYContacter * contacter in selectedContacts) {
                if (contacter.phone != nil) {
                    [_phoneArr addObject:contacter.phone];
                }
                
                
            }
            messageController.recipients = _phoneArr;
            
            //推到发送试图控制器
            [self presentViewController:messageController animated:YES completion:^{
                
            }];
           
        }else
        {
            UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"该设备没有发送短信的功能~" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [alterView show];
        }
    }
    else
    {
        
        UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"iOS版本过低（iOS4.0以后）" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
        
        [alterView show];
    }
    
}


-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    NSString *tipContent;
    switch (result) {
        case MessageComposeResultCancelled:
            tipContent = @"发送短信已经取消";
            [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
            break;
        case MessageComposeResultFailed:
            tipContent = @"发送短信失败";
            [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
            break;
            
        case MessageComposeResultSent:
            tipContent = @"发送成功";
            [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
            break;
            
        default:
            break;
    }
    
    UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:@"提示" message:tipContent delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
    [alterView show];
}

-(void)selectBtnClick:(UIButton *)sender{
    if (sender.selected == NO) {
        for (NSArray *arr in _arrContacts) {
            for (SYContacter *contacter in arr) {
                if (contacter.selected ==NO) {
                    contacter.selected = YES;
                }
            }
        }
    }else{
        for (NSArray *arr in _arrContacts) {
            for (SYContacter *contacter in arr) {
                contacter.selected = NO;
            }
        }
    }
    sender.selected = !sender.selected;
    [_tableView reloadData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
