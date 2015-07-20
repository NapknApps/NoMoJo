//
//  AccountViewController.m
//  NoMoJo
//
//  Created by Zach Whelchel on 7/16/15.
//  Copyright (c) 2015 Napkn Apps. All rights reserved.
//

#import "AccountViewController.h"
#import "SignUpViewController.h"
#import "LogInViewController.h"
#import "FirebaseHelper.h"
#import <Firebase/Firebase.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface AccountViewController () <SignUpViewControllerDelegate, LogInViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@end

@implementation AccountViewController

@synthesize delegate = _delegate;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.iconImageView.clipsToBounds = YES;
    self.iconImageView.layer.cornerRadius = 20;
    self.iconImageView.layer.borderWidth = 5;
    self.iconImageView.layer.borderColor = [[UIColor whiteColor] CGColor];

}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)loginWithFacebook:(id)sender
{
    Firebase *ref = [FirebaseHelper baseFirebaseReference];
    FBSDKLoginManager *facebookLogin = [[FBSDKLoginManager alloc] init];
    [facebookLogin logInWithReadPermissions:@[@"email"] handler:^(FBSDKLoginManagerLoginResult *facebookResult, NSError *facebookError) {
        if (facebookError) {
            NSLog(@"Facebook login failed. Error: %@", facebookError);
        } else if (facebookResult.isCancelled) {
            NSLog(@"Facebook login got cancelled.");
        } else {
            NSString *accessToken = [[FBSDKAccessToken currentAccessToken] tokenString];
            [ref authWithOAuthProvider:@"facebook" token:accessToken withCompletionBlock:^(NSError *error, FAuthData *authData) {
                if (error) {
                    NSLog(@"Login failed. %@", error);
                } else {
                    NSLog(@"Logged in! %@", authData);
                    
                    [self dismissViewControllerAnimated:NO completion:^{
                        [self.delegate accountViewControllerDidLogin:self];
                    }];
                }
            }];
        }
    }];
}

- (void)signUpViewControllerDidLogin:(SignUpViewController *)signUpViewController
{
    [self dismissViewControllerAnimated:NO completion:^{
        [self.delegate accountViewControllerDidLogin:self];
    }];
}

- (void)logInViewControllerDidLogin:(LogInViewController *)logInViewController
{
    [self dismissViewControllerAnimated:NO completion:^{
        [self.delegate accountViewControllerDidLogin:self];
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"SignUp"]) {
        SignUpViewController *signUpViewController = (SignUpViewController *)segue.destinationViewController;
        signUpViewController.delegate = self;
    }
    else if ([segue.identifier isEqualToString:@"LogIn"]) {
        LogInViewController *logInViewController = (LogInViewController *)segue.destinationViewController;
        logInViewController.delegate = self;
    }
}

@end
