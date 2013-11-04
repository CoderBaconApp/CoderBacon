//
//  UIScrollView+ScrollPositions.m
//  Bromance
//
//  Created by Therin Irwin on 10/30/13.
//  Copyright (c) 2013 Pamela Ocampo. All rights reserved.
//

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
