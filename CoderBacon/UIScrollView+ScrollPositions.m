//  UIScrollView+ScrollPositions.m
//
//  Copyright (C) 2013 BromanceApp

#import "UIScrollView+ScrollPositions.h"

@implementation UIScrollView (ScrollPositions)

- (void)scrollToTop {
    CGPoint point = CGPointMake(0, -self.contentInset.top);
    [self setContentOffset:point];
}

- (void)scrollToBottom {
    CGPoint bottomOffset = CGPointMake(0, self.contentSize.height - self.frame.size.height + self.contentInset.bottom);
    [self setContentOffset:bottomOffset]; 
}

@end
