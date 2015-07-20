//
//  LogInViewController.h
//  NoMoJo
//
//  Created by Zach Whelchel on 7/16/15.
//  Copyright (c) 2015 Napkn Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LogInViewController;

@protocol LogInViewControllerDelegate

@required

- (void)logInViewControllerDidLogin:(LogInViewController *)logInViewController;

@end

@interface LogInViewController : UIViewController

@property (nonatomic, weak) id <LogInViewControllerDelegate> delegate;

@end
