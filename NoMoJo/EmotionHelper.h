//
//  EmotionHelper.h
//  NoMoJo
//
//  Created by Zach Whelchel on 7/19/15.
//  Copyright (c) 2015 Napkn Apps. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    Sad = 0,
    Meh,
    Happy
} Emotion;

@interface EmotionHelper : NSObject

+ (Emotion)emotionFromString:(NSString *)string;

@end
