//  MessageSentCell.h
//
//  Copyright (C) 2013 BromanceApp

#import <UIKit/UIKit.h>

@interface MessageSentCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UIView *messageBubbleView;

@end
