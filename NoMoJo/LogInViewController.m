//
//  LogInViewController.m
//  NoMoJo
//
//  Created by Zach Whelchel on 7/16/15.
//  Copyright (c) 2015 Napkn Apps. All rights reserved.
//

#import "LogInViewController.h"
#import <Firebase/Firebase.h>
#import "FirebaseHelper.h"

@interface LogInViewController ()

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *logInButton;

@end

@implementation LogInViewController

@synthesize delegate = _delegate;

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.emailTextField becomeFirstResponder];
}

- (IBAction)logInPressed:(id)sender
{
    if ([self emailAndPasswordInputsAreValid]) {
        Firebase *ref = [FirebaseHelper baseFirebaseReference];
        [ref authUser:self.emailTextField.text password:self.passwordTextField.text withCompletionBlock:^(NSError *error, FAuthData *authData) {
            if (error) {
                
                UIAlertController *alertController = [UIAlertController
                                                      alertControllerWithTitle:@"Error"
                                                      message:@"No account found for the entered email and password."
                                                      preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *cancelAction = [UIAlertAction
                                               actionWithTitle:@"OK"
                                               style:UIAlertActionStyleCancel
                                               handler:^(UIAlertAction *action)
                                               {
                                                   
                                               }];
                
                [alertController addAction:cancelAction];
                [self presentViewController:alertController animated:YES completion:nil];

            } else {
                [self.delegate logInViewControllerDidLogin:self];
            }
        }];
    }
    else {
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:@"Invalid Input"
                                              message:@"Please enter a valid email and password to log in to your account."
                                              preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancelAction = [UIAlertAction
                                       actionWithTitle:@"OK"
                                       style:UIAlertActionStyleCancel
                                       handler:^(UIAlertAction *action)
                                       {
                                           
                                       }];
        
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

- (BOOL)emailAndPasswordInputsAreValid
{
    if ([FirebaseHelper stringIsValidEmail:self.emailTextField.text] && self.passwordTextField.text.length > 4) {
        return YES;
    }
    else {
        return NO;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
