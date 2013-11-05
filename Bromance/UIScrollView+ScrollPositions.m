//  UIScrollView+ScrollPositions.m
//
//  Copyright (C) 2013 BromanceApp
//
//  This program is free software; you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation; either version 3 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.

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
