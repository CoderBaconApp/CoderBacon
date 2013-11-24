//  TabBarController.h
//
//  Copyright (C) 2013 CoderBaconApp

#import <UIKit/UIKit.h>

@interface TabBarController : UITabBarController

+ (BOOL)isLoggedIn;
- (void)loadTabs;

@end
