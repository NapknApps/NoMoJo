//
//  RemindersViewController.m
//  NoMoJo
//
//  Created by Zach Whelchel on 7/20/15.
//  Copyright (c) 2015 Napkn Apps. All rights reserved.
//

#import "RemindersViewController.h"

@interface RemindersViewController ()

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

@end

@implementation RemindersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)setDailyReminderSelected:(id)sender
{
    NSDate *selectedDate = [self.datePicker date];
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *dc = [cal components: (NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:selectedDate];
    selectedDate = [cal dateFromComponents:dc]; // now you have an NSDate with zero seconds for your alarm

    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    localNotification.fireDate = selectedDate;
    localNotification.alertBody = [NSString stringWithFormat:@"Time to journal!"];
    localNotification.repeatInterval = kCFCalendarUnitDay;
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    
    NSLog(@"%@", [[UIApplication sharedApplication] scheduledLocalNotifications]);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
