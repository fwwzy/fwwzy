//
//  DMPasscodeInternalViewController.h
//  Pods
//
//  Created by Dylan Marriott on 20/09/14.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol DMPasscodeInternalViewControllerDelegate <NSObject>

- (void)enteredCode:(NSString *)code;
- (void)canceled;

@end

@interface DMPasscodeInternalViewController : AllVC
@property(nonatomic,strong)UITextField* input;//输入
- (id)initWithDelegate:(id<DMPasscodeInternalViewControllerDelegate>)delegate;
- (void)reset;
- (void)setErrorMessage:(NSString *)errorMessage;
- (void)setInstructions:(NSString *)instructions;

@end
