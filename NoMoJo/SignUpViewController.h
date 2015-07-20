//
//  SignUpViewController.h
//  NoMoJo
//
//  Created by Zach Whelchel on 7/16/15.
//  Copyright (c) 2015 Napkn Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SignUpViewController;

@protocol SignUpViewControllerDelegate

@required

- (void)signUpViewControllerDidLogin:(SignUpViewController *)signUpViewController;

@end

@interface SignUpViewController : UIViewController

@property (nonatomic, weak) id <SignUpViewControllerDelegate> delegate;

@end
