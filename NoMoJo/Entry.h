//
//  Entry.h
//  NoMoJo
//
//  Created by Zach Whelchel on 7/18/15.
//  Copyright (c) 2015 Napkn Apps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Entry : NSObject

@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSNumber *emotion;
@property (nonatomic, strong) NSNumber *timeSince1970;

@end
