//
//  AddressBook.m
//  AddressBook
//
//  Created by bangyibang on 14-5-15.
//  Copyright (c) 2014年 bangyibang. All rights reserved.
//

#import "AddressBook.h"

@implementation AddressBook
@synthesize delegateViewController;

+ (AddressBook *)shareAddressBook
{
    static AddressBook *addressBook = nil;
    if (addressBook == nil) {
        addressBook = [[AddressBook alloc]init];
    }
    return addressBook;
}

- (void) addressBookGetPhoneNumberWithViewController:(UIViewController *)viewController
{
    self.delegateViewController = viewController;
    ABPeoplePickerNavigationController *picker = [[ABPeoplePickerNavigationController alloc] init];
    picker.displayedProperties = [NSArray arrayWithObject:[NSNumber numberWithInt:kABPersonPhoneProperty]];
    picker.peoplePickerDelegate = self;
    [viewController presentModalViewController:picker animated:YES];
}


- (void) peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker {
    [self.delegateViewController dismissModalViewControllerAnimated:YES];
}

- (BOOL) peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person {
    NSLog(@"got person record");
    return YES;
}

- (BOOL) peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier {
    //retrieve number
    NSLog(@"tapped number");
    ABMultiValueRef phoneNumbers = ABRecordCopyValue(person, property);
    NSString *phone = nil;
    if ((ABMultiValueGetCount(phoneNumbers) > 0)) {
        phone = (__bridge_transfer NSString *)ABMultiValueCopyValueAtIndex(phoneNumbers, identifier);
    } else {
        phone = @"[None]";
    }
    NSLog(@"retrieved number: %@", phone);
    
    //retrieve first and last name
    NSString* firstName = (__bridge_transfer NSString*)ABRecordCopyValue(person, kABPersonFirstNameProperty);
    NSString* lastName = (__bridge_transfer NSString*)ABRecordCopyValue(person, kABPersonLastNameProperty);
    NSLog(@"retrieved first name: %@", firstName);
    NSLog(@"retrieve last name: %@", lastName);
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(addressBookWithName:number:)]) {
        NSString *name = [NSString stringWithFormat:@"%@%@",lastName?lastName:@"",firstName?firstName:@""];
        [self.delegate addressBookWithName:name number:phone];
    }
    
    [self.delegateViewController dismissModalViewControllerAnimated:YES];
    return NO;
}
@end
