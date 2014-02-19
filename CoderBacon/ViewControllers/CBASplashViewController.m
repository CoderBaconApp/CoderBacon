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
//    else if ([PFUser currentUser]) {
//        [self logInUser];
//    }
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
@end
