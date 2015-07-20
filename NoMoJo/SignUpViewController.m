//
//  SignUpViewController.m
//  NoMoJo
//
//  Created by Zach Whelchel on 7/16/15.
//  Copyright (c) 2015 Napkn Apps. All rights reserved.
//

#import "SignUpViewController.h"
#import <Firebase/Firebase.h>
#import "FirebaseHelper.h"

@interface SignUpViewController ()

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@property (weak, nonatomic) IBOutlet UIButton *signUpButton;

@end

@implementation SignUpViewController

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

- (IBAction)signUpSelected:(id)sender
{
    if ([self emailAndPasswordInputsAreValid]) {
        Firebase *ref = [FirebaseHelper baseFirebaseReference];
        [ref createUser:self.emailTextField.text password:self.passwordTextField.text withValueCompletionBlock:^(NSError *error, NSDictionary *result) {
            if (error) {
                
                UIAlertController *alertController = [UIAlertController
                                                      alertControllerWithTitle:@"Error"
                                                      message:@"There was an error while creating your account."
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
                [self.delegate signUpViewControllerDidLogin:self];
            }
        }];
    }
    else {
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:@"Invalid Input"
                                              message:@"Please enter a valid email and password to create an account."
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
