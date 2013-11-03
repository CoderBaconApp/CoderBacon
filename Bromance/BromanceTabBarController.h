//
//  BromanceTabBarController.h
//  Bromance
//
//  Created by Therin Irwin on 11/3/13.
//  Copyright (c) 2013 Pamela Ocampo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BromanceTabBarController : UITabBarController

+ (BOOL)isLoggedIn;
- (void)showSplashScreen;

@end
