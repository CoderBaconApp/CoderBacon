//  BromanceTabBarController.h
//
//  Copyright (C) 2013 BromanceApp

#import <UIKit/UIKit.h>

@interface BromanceTabBarController : UITabBarController

+ (BOOL)isLoggedIn;
- (void)loadTabs;

@end
