//  TabBarController.h
//
//  Copyright (C) 2013 CoderBaconApp
//
//  Licensed under Creative Commons BY-NC-SA
//  http://creativecommons.org/licenses/by-nc-sa/3.0/deed.en_US

#import <UIKit/UIKit.h>

@interface CBATabBarController : UITabBarController

+ (BOOL)isLoggedIn;
- (void)loadTabs;

@end
