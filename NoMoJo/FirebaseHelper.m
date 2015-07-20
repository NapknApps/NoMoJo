//
//  FirebaseHelper.m
//  NoMoJo
//
//  Created by Zach Whelchel on 7/16/15.
//  Copyright (c) 2015 Napkn Apps. All rights reserved.
//

#import "FirebaseHelper.h"

@implementation FirebaseHelper

+ (Firebase *)baseFirebaseReference
{
    return [[Firebase alloc] initWithUrl:@"https://nomojo.firebaseio.com"];
}

+ (BOOL)userIsLoggedIn
{
    Firebase *ref = [self baseFirebaseReference];
    return ref.authData == nil ? NO : YES;
}

+ (NSString *)userUID
{
    Firebase *ref = [self baseFirebaseReference];
    return [ref.authData uid];
}

+ (BOOL)stringIsValidEmail:(NSString *)string
{
    NSString *emailRegex = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:string];
}

@end
