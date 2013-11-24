//  SplashViewController.m
//
//  Copyright (C) 2013 CoderBaconApp
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

#import <Parse/Parse.h>
#import "SplashViewController.h"
#import "Message.h"
#import "AsyncServices.h"
#import "TabBarController.h"

@interface SplashViewController ()

- (IBAction)loginPressed:(id)sender;

@end

@implementation SplashViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([TabBarController isLoggedIn]) {
        [[AsyncServices instance] saveInitialUserData];
        [self closeSplashScreen];
    }
    else if ([PFUser currentUser]) {
        [self logInUser];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)closeSplashScreen
{
    [[AsyncServices instance] saveInitialUserData];
    [((TabBarController *) self.tabBarController) loadTabs];
}

#pragma mark PFLogInViewControllerDelegate
// Sent to the delegate when a PFUser is logged in.
- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user {
    [self dismissViewControllerAnimated:YES completion:NULL];
    [[AsyncServices instance] saveInitialUserData];
    [self closeSplashScreen];
}

// Sent to the delegate when the log in attempt fails.
- (void)logInViewController:(PFLogInViewController *)logInController didFailToLogInWithError:(NSError *)error {
    NSLog(@"Failed to log in...");
}

// Sent to the delegate when the log in screen is dismissed.
- (void)logInViewControllerDidCancelLogIn:(PFLogInViewController *)logInController {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)loginPressed:(id)sender {
    if (![TabBarController isLoggedIn]) {
        [self logInUser];
    }
}

- (void)logInUser {
    // Customize the Log In View Controller
    PFLogInViewController *logInViewController = [[PFLogInViewController alloc] init];
    [logInViewController setDelegate:self];
    
    [logInViewController setFacebookPermissions:[NSArray arrayWithObjects:@"user_likes", @"user_location", @"user_about_me", @"user_photos", nil]];
    [logInViewController setFields:  PFLogInFieldsFacebook | PFLogInFieldsDismissButton];
    
    // Present Log In View Controller
    [self presentViewController:logInViewController animated:YES completion:NULL];
}

@end
