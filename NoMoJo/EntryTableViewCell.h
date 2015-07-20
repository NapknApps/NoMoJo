//
//  EntryTableViewCell.h
//  NoMoJo
//
//  Created by Zach Whelchel on 7/18/15.
//  Copyright (c) 2015 Napkn Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EntryTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *emotionImageView;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end
