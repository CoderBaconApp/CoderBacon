//  MessageSentCell.m
//
//  Copyright (C) 2013 BromanceApp

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
