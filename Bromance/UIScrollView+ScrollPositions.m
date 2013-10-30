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
    CGPoint topOffset = CGPointMake(0, 0);
    [self setContentOffset:topOffset];
}

- (void)scrollToBottom {
    CGPoint bottomOffset = CGPointMake(0, self.contentSize.height - self.frame.size.height + self.contentInset.bottom);
    [self setContentOffset:bottomOffset]; 
}

@end
