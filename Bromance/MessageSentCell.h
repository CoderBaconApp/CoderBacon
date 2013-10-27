//
//  MessageSentCell.h
//  Bromance
//
//  Created by Justin Steffen on 10/26/13.
//  Copyright (c) 2013 Pamela Ocampo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageSentCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UIView *messageBubbleView;

@end