//  MessageSentCell.h
//
//  Copyright (C) 2013 BromanceApp
//
//  Licensed under Creative Commons BY-NC-SA
//  http://creativecommons.org/licenses/by-nc-sa/3.0/deed.en_US

#import <UIKit/UIKit.h>

@interface MessageSentCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UIView *messageBubbleView;

@end
