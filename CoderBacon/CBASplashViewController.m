//  SplashViewController.m
//
//  Copyright (C) 2013 CoderBacon
//
//  Licensed under Creative Commons BY-NC-SA
//  http://creativecommons.org/licenses/by-nc-sa/3.0/deed.en_US

#import "CBASplashViewController.h"
#import "CBAMessage.h"
#import "CBAAsyncServices.h"
#import "CBATabBarController.h"

@interface CBASplashViewController ()

- (IBAction)loginPressed:(id)sender;

@end

@implementation CBASplashViewController

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
    
    if ([CBATabBarController isLoggedIn]) {
        [[CBAAsyncServices instance] saveInitialUserData];
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
    [[CBAAsyncServices instance] saveInitialUserData];
    [((CBATabBarController *) self.tabBarController) loadTabs];
}

#pragma mark PFLogInViewControllerDelegate
// Sent to the delegate when a PFUser is logged in.
- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user {
    [self dismissViewControllerAnimated:YES completion:NULL];
    [[CBAAsyncServices instance] saveInitialUserData];
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
    if (![CBATabBarController isLoggedIn]) {
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
