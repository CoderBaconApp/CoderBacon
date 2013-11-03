//
//  BromanceTabBarController.m
//  Bromance
//
//  Created by Therin Irwin on 11/3/13.
//  Copyright (c) 2013 Pamela Ocampo. All rights reserved.
//

#import <Parse/Parse.h>
#import "AsyncServices.h"
#import "BromanceTabBarController.h"

@interface BromanceTabBarController ()

@end

@implementation BromanceTabBarController

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
    [[AsyncServices instance] initLocationManager];
    
    [self showSplashScreen];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+ (BOOL)isLoggedIn {
    return [PFUser currentUser] && [[FBSession activeSession] isOpen];
}

- (void)showSplashScreen {
    if (![BromanceTabBarController isLoggedIn]) {
        [self performSegueWithIdentifier:@"SplashSegue" sender:self];
    }
    else {
        [[AsyncServices instance] saveInitialUserData];
    }
}

@end
