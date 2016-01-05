//
//  AddressBook.h
//  AddressBook
//
//  Created by bangyibang on 14-5-15.
//  Copyright (c) 2014年 bangyibang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBookUI/AddressBookUI.h>
#import <AddressBook/AddressBook.h>

@protocol AddressBookDelegate <NSObject>

- (void) addressBookWithName:(NSString *)name number:(NSString *)num;

@end

@interface AddressBook : NSObject<ABPeoplePickerNavigationControllerDelegate>
@property (assign, nonatomic) id<AddressBookDelegate> delegate;
@property (weak, nonatomic) UIViewController *delegateViewController;

+ (AddressBook *)shareAddressBook;
- (void)addressBookGetPhoneNumberWithViewController:(UIViewController *)viewController;
@end
