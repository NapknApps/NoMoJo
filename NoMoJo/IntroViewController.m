//
//  IntroViewController.m
//  NoMoJo
//
//  Created by Zach Whelchel on 7/16/15.
//  Copyright (c) 2015 Napkn Apps. All rights reserved.
//

#import "IntroViewController.h"
#import "DefaultsHelper.h"

@interface IntroViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (strong, nonatomic) NSArray *explanations;
@property (nonatomic) int currentPage;

@end

@implementation IntroViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setUpIntro];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)setUpIntro
{
    self.explanations = [NSArray arrayWithObjects:
                         [NSString stringWithFormat:@"Journaling is a great way to be proactive."],
                         [NSString stringWithFormat:@"But a big blank page can be daunting."],
                         [NSString stringWithFormat:@"So start small."],
                         [NSString stringWithFormat:@"Each day spend 30 seconds recording some thoughts."],
                         [NSString stringWithFormat:@"Who knows? You might finally pick up the habit :)"],
                         nil];
    
    for (int i = 0; i < self.explanations.count; i++) {

        CGRect frame;
        frame.origin.x = self.scrollView.frame.size.width * i;
        frame.origin.y = 0;
        frame.size = self.scrollView.frame.size;
        
        UIView *subview = [[UIView alloc] initWithFrame:frame];
        
        UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(20, 40, self.view.frame.size.width - 40, 400)];
        
        [textView setFont:[UIFont systemFontOfSize:32]];
        [textView setTextColor:[UIColor whiteColor]];
        textView.backgroundColor = [UIColor clearColor];
        textView.userInteractionEnabled = NO;
        [textView setText:[self.explanations objectAtIndex:i]];
        
        [subview addSubview:textView];

        [self.scrollView addSubview:subview];
    }
    
    [self.scrollView setPagingEnabled:YES];
    self.scrollView.alwaysBounceHorizontal = YES;
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * (self.explanations.count), self.scrollView.frame.size.height);
}

- (IBAction)nextButtonSelected:(id)sender
{
    if (self.currentPage < self.explanations.count) {
        self.currentPage++;
        [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x + self.scrollView.frame.size.width, 0) animated:NO];
    }
    
    if (self.currentPage == self.explanations.count - 1) {
        [self.nextButton setTitle:@"Start" forState:UIControlStateNormal];
    }
    else if (self.currentPage == self.explanations.count) {
        [DefaultsHelper setIntroShown];
        [self dismissViewControllerAnimated:NO completion:^{
        }];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
