//
//  MessageSentCell.m
//  Bromance
//
//  Created by Justin Steffen on 10/26/13.
//  Copyright (c) 2013 Pamela Ocampo. All rights reserved.
//

#import "MessageSentCell.h"

@implementation MessageSentCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [_messageBubbleView.layer setCornerRadius:5];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [_messageBubbleView.layer setCornerRadius:5];
    }
    return self;
}

@end
