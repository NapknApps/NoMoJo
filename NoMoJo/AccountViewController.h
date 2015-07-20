//
//  AccountViewController.h
//  NoMoJo
//
//  Created by Zach Whelchel on 7/16/15.
//  Copyright (c) 2015 Napkn Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AccountViewController;

@protocol AccountViewControllerDelegate

@required

- (void)accountViewControllerDidLogin:(AccountViewController *)accountViewController;

@end

@interface AccountViewController : UIViewController

@property (nonatomic, weak) id <AccountViewControllerDelegate> delegate;

@end
