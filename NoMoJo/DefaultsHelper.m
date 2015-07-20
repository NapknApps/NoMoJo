//
//  DefaultsHelper.m
//  NoMoJo
//
//  Created by Zach Whelchel on 7/16/15.
//  Copyright (c) 2015 Napkn Apps. All rights reserved.
//

#import "DefaultsHelper.h"

#define kIntroShown @"kIntroShown"
#define kLastEntryDate @"kLastEntryDate"

@implementation DefaultsHelper

+ (BOOL)introShown
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:kIntroShown];
}

+ (void)setIntroShown
{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kIntroShown];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSDate *)lastEntryDate
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:kLastEntryDate];
}

+ (void)setLastEntryDate
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:kLastEntryDate];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)canEnterEntry
{
    return YES;
    
    /*
    NSCalendar* calendar = [NSCalendar currentCalendar];
    
    if ([self lastEntryDate]) {
        if ([calendar isDate:[NSDate date] inSameDayAsDate:[self lastEntryDate]]) {
            return NO;
        }
        else {
            return YES;
        }
    }
    else {
        return YES;
    }
    */
}

@end
