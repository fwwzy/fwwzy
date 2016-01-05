//
//  MineAdressVC.m
//  Hema
//
//  Created by Lsy on 16/1/5.
//  Copyright © 2016年 Hemaapp. All rights reserved.
//

#import "MineAdressVC.h"
#import "AddressBook.h"

@interface MineAdressVC ()<AddressBookDelegate>

@end

@implementation MineAdressVC

-(void)loadSet{
    AddressBook *addressBook = [AddressBook shareAddressBook];
    addressBook.delegate = self;
    [addressBook addressBookGetPhoneNumberWithViewController:self];
    _label = [[UILabel alloc]initWithFrame:CGRectMake(50, 50, 50, 50)];
    [self.view addSubview:_label];
    [self.view addSubview:_numLabel];
}
- (void)addressBookWithName:(NSString *)name number:(NSString *)num{
    _label.text = name;
    _numLabel.text = num;
    
}


@end
