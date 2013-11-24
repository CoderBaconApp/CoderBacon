//  TabBarController.m
//
//  Copyright (C) 2013 CoderBaconApp
//
//  Licensed under Creative Commons BY-NC-SA
//  http://creativecommons.org/licenses/by-nc-sa/3.0/deed.en_US

#import <Parse/Parse.h>
#import "AsyncServices.h"
#import "TabBarController.h"
#import "SplashViewController.h"
#import "Common.h"

@interface TabBarController ()

@property (strong, nonatomic) NSArray *contentVCs;

@end

@implementation TabBarController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _contentVCs = self.viewControllers;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadTabs)
                                                 name:LOG_OUT_NOTIFICATION object:nil];
    
    [self loadTabs];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+ (BOOL)isLoggedIn {
    return [PFUser currentUser] && [[FBSession activeSession] isOpen];
}

- (void)loadTabs {
    if (![TabBarController isLoggedIn]) {
        SplashViewController *splash = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SplashVC"];

        [self setViewControllers:@[splash] animated:NO];
        self.tabBar.hidden = YES;
    }
    else {
        [[AsyncServices instance] initLocationManager];
        [[AsyncServices instance] saveInitialUserData];
        [self setViewControllers:_contentVCs];
        self.tabBar.hidden = NO;
    }
}

@end
