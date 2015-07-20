//
//  CreateEntryViewController.m
//  NoMoJo
//
//  Created by Zach Whelchel on 7/15/15.
//  Copyright (c) 2015 Napkn Apps. All rights reserved.
//

#import "CreateEntryViewController.h"
#import <Firebase/Firebase.h>
#import "FirebaseHelper.h"
#import "EmotionHelper.h"
#import "DefaultsHelper.h"

@interface CreateEntryViewController () <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;
@property (weak, nonatomic) IBOutlet UIImageView *unHappyImageView;
@property (weak, nonatomic) IBOutlet UIImageView *mehImageView;
@property (weak, nonatomic) IBOutlet UIImageView *happyImageView;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIView *progressView;

@property (nonatomic) int keyboardHeight;
@property (nonatomic, strong) NSDate *date;

@property (nonatomic, strong) NSNumber *overrideEmotion;


@end

@implementation CreateEntryViewController

@synthesize date = _date;
@synthesize overrideEmotion = _overrideEmotion;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    
    self.textView.delegate = self;
    self.textView.autocorrectionType = UITextAutocorrectionTypeNo;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
    
    self.textView.hidden = YES;
    self.progressView.hidden = YES;
    self.saveButton.enabled = NO;

    self.happyImageView.alpha = 0.3;
    self.mehImageView.alpha = 0.3;
    self.unHappyImageView.alpha = 0.3;
    
    self.date = [NSDate date];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMMM dd"];
    
    self.title = [dateFormatter stringFromDate:self.date];

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    

    [self.textView becomeFirstResponder];
}

- (void)keyboardWasShown:(NSNotification *)notification
{
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    self.keyboardHeight = keyboardSize.height;
    
    self.textView.frame = CGRectMake(10, 100, self.view.frame.size.width - 20, self.view.frame.size.height - 100 - self.keyboardHeight - 40);
    
    self.progressView.frame = CGRectMake(0, self.view.frame.size.height - self.keyboardHeight - 30, 0, 20);
    
    self.textView.hidden = NO;
    self.progressView.hidden = NO;
}

- (IBAction)sadSelected:(id)sender
{
    self.overrideEmotion = [NSNumber numberWithInt:Sad];
    self.happyImageView.alpha = 0.3;
    self.mehImageView.alpha = 0.3;
    self.unHappyImageView.alpha = 1.0;
}

- (IBAction)mehSelected:(id)sender
{
    self.overrideEmotion = [NSNumber numberWithInt:Meh];
    self.happyImageView.alpha = 0.3;
    self.mehImageView.alpha = 1.0;
    self.unHappyImageView.alpha = 0.3;
}

- (IBAction)happySelected:(id)sender
{
    self.overrideEmotion = [NSNumber numberWithInt:Happy];
    self.happyImageView.alpha = 1.0;
    self.mehImageView.alpha = 0.3;
    self.unHappyImageView.alpha = 0.3;
}

- (void)textViewDidChange:(UITextView *)textView
{
    
    self.overrideEmotion = nil;
    
    float percentageDone = textView.text.length / 200.0;
    
    
    if (textView.text.length <= 200 && textView.text.length >= 1) {
        self.saveButton.enabled = YES;
    }
    else {
        self.saveButton.enabled = NO;
    }
    
    self.progressView.frame = CGRectMake(0, self.view.frame.size.height - self.keyboardHeight - 30, percentageDone * self.view.frame.size.width, 20);

    Emotion emotion = [EmotionHelper emotionFromString:textView.text];
    
    if (emotion == Happy) {
        self.happyImageView.alpha = 1.0;
        self.mehImageView.alpha = 0.3;
        self.unHappyImageView.alpha = 0.3;
    }
    else if (emotion == Meh) {
        self.happyImageView.alpha = 0.3;
        self.mehImageView.alpha = 1.0;
        self.unHappyImageView.alpha = 0.3;
    }
    else if (emotion == Sad) {
        self.happyImageView.alpha = 0.3;
        self.mehImageView.alpha = 0.3;
        self.unHappyImageView.alpha = 1.0;
    }
    
}

- (IBAction)doneSelected:(id)sender
{
    Firebase *ref = [[FirebaseHelper baseFirebaseReference] childByAppendingPath:[NSString stringWithFormat:@"/users/%@", [FirebaseHelper userUID]]];
    
    Firebase *entriesRef = [ref childByAppendingPath:@"entries"];
    
    Emotion emotion;
    
    if (self.overrideEmotion) {
        emotion = [self.overrideEmotion intValue];
    }
    else {
        emotion = [EmotionHelper emotionFromString:self.textView.text];
    }
    
    NSDictionary *entry = @{
                            @"content": self.textView.text,
                            @"emotion": [NSNumber numberWithInt:emotion],
                            @"timeSince1970": [NSNumber numberWithInt:[self.date timeIntervalSince1970]]
                            };
    
    Firebase *entryRef = [entriesRef childByAutoId];
    [entryRef setValue: entry];
    
    [DefaultsHelper setLastEntryDate];
    
    [self.navigationController popViewControllerAnimated:YES];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
