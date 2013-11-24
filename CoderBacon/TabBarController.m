//  TabBarController.m
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
