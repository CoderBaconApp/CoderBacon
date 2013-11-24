//  MessageSentCell.m
//
//  Copyright (C) 2013 BromanceApp
//
//  Licensed under Creative Commons BY-NC-SA
//  http://creativecommons.org/licenses/by-nc-sa/3.0/deed.en_US

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
