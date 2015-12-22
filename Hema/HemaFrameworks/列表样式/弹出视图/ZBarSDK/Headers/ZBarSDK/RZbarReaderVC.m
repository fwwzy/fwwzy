//
//  RZbarReaderVC.m
//  Hema
//
//  Created by geyang on 15/11/4.
//  Copyright © 2015年 Hemaapp. All rights reserved.
//

#import "RZbarReaderVC.h"

@interface RZbarReaderVC ()

@end

@implementation RZbarReaderVC

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

#pragma mark- UIImagePickerControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [SystemFunction fixPick:navigationController myVC:viewController];
    
    [self.navigationBar setBarTintColor:Nav_Color];
    [self.navigationBar setTranslucent:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}
@end
