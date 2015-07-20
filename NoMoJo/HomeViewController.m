//
//  HomeViewController.m
//  NoMoJo
//
//  Created by Zach Whelchel on 7/15/15.
//  Copyright (c) 2015 Napkn Apps. All rights reserved.
//

#import "HomeViewController.h"
#import "AccountViewController.h"
#import "FirebaseHelper.h"
#import "DefaultsHelper.h"
#import "FirebaseUI.h"
#import "Entry.h"
#import "EntryTableViewCell.h"
#import "EmotionHelper.h"

@interface HomeViewController () <UITableViewDelegate, AccountViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) FirebaseTableViewDataSource *firebaseTableViewDataSource;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@end

@implementation HomeViewController

@synthesize firebaseTableViewDataSource = _firebaseTableViewDataSource;
@synthesize dateFormatter = _dateFormatter;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleLightContent;

    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateFormat:@"MMMM dd"];
    
    self.tableView.hidden = YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Account"]) {
        UINavigationController *navigationController = segue.destinationViewController;
        AccountViewController *accountViewController = (AccountViewController *)navigationController.viewControllers.firstObject;
        accountViewController.delegate = self;
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (![DefaultsHelper introShown]) {
        [self performSegueWithIdentifier:@"Intro" sender:self];
    }
    else if (![FirebaseHelper userIsLoggedIn]) {
        [self performSegueWithIdentifier:@"Account" sender:self];
    }
    else {
        [self loadFirebaseData];
        
        self.tableView.hidden = NO;

        
        self.title = @"NoMoJo";

        UIBarButtonItem *settingsButton = [[UIBarButtonItem alloc]
                                           initWithTitle:@"Settings"
                                           style:UIBarButtonItemStylePlain
                                           target:self
                                           action:@selector(settingsSelected:)];
        self.navigationItem.leftBarButtonItem = settingsButton;

        UIBarButtonItem *addButton = [[UIBarButtonItem alloc]
                                       initWithTitle:@"Add"
                                       style:UIBarButtonItemStylePlain
                                       target:self
                                       action:@selector(addSelected:)];
        self.navigationItem.rightBarButtonItem = addButton;
    }
}

- (void)settingsSelected:(id)sender
{
    [self performSegueWithIdentifier:@"Settings" sender:self];
}

- (void)addSelected:(id)sender
{
    if ([DefaultsHelper canEnterEntry]) {
        [self performSegueWithIdentifier:@"Entry" sender:self];
    }
    else {
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:@"Already Entered Today's Entry"
                                              message:@"Wait until tomorrow!"
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

- (void)loadFirebaseData
{
    if (self.firebaseTableViewDataSource == nil) {
        Firebase *ref = [[FirebaseHelper baseFirebaseReference] childByAppendingPath:[NSString stringWithFormat:@"/users/%@", [FirebaseHelper userUID]]];
        
        Firebase *entriesRef = [ref childByAppendingPath:@"entries"];
        
        self.firebaseTableViewDataSource = [[FirebaseTableViewDataSource alloc] initWithRef:entriesRef model:[Entry class] layout:[EntryTableViewCell class] reuseIdentifier:@"EntryTableViewCell" context:self.tableView];
        
        [self.firebaseTableViewDataSource populateCellWithBlock:^(EntryTableViewCell *cell, Entry *entry) {
            
            if ([entry.emotion intValue] == Happy) {
                [cell.emotionImageView setImage:[UIImage imageNamed:@"happy.png"]];
            }
            else if ([entry.emotion intValue] == Meh) {
                [cell.emotionImageView setImage:[UIImage imageNamed:@"meh.png"]];
            }
            else if ([entry.emotion intValue] == Sad) {
                [cell.emotionImageView setImage:[UIImage imageNamed:@"unhappy.png"]];
            }

            [cell.contentTextView setFont:[UIFont systemFontOfSize:20]];
            [cell.contentTextView setTextColor:[UIColor darkGrayColor]];
            [cell.contentTextView setText:entry.content];
            
            [cell.dateLabel setText:[self.dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[entry.timeSince1970 intValue]]]];
            
            [cell.contentTextView setFrame:CGRectMake(cell.contentTextView.frame.origin.x, cell.contentTextView.frame.origin.y, self.view.frame.size.width - 90, 1000)];
            
            [cell.contentTextView sizeToFit];
        }];
        
        self.tableView.dataSource = self.firebaseTableViewDataSource;
        self.tableView.delegate = self;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FDataSnapshot *snap = [self.firebaseTableViewDataSource.array objectAtIndex:indexPath.row];
    
    Entry *entry = [[Entry alloc] init];
    [entry setValuesForKeysWithDictionary:snap.value];
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width - 90, 0)];
    [textView setFont:[UIFont systemFontOfSize:20]];
    [textView setText:entry.content];
    [textView sizeToFit];
    
    float height = textView.frame.size.height + 47;
    
    return height < 80 ? 80 : height;
}

- (void)accountViewControllerDidLogin:(AccountViewController *)accountViewController
{
    NSLog(@"Did log in");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
