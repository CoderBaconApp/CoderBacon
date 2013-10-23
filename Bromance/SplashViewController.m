//
//  SplashViewController.m
//  Bromance
//
//  Created by Therin Irwin on 10/19/13.
//  Copyright (c) 2013 Pamela Ocampo. All rights reserved.
//

#import <Parse/Parse.h>
#import "SplashViewController.h"
#import "Message.h"

@interface SplashViewController ()

@end

@implementation SplashViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)facebookLoginButton:(id)sender
{
    if (![PFUser currentUser]) {
        [PFUser logInWithUsernameInBackground:@"JustinDSN" password:@"password"
                                        block:^(PFUser *user, NSError *error) {
                                            if (user) {
                                                NSLog(@"Logged in!");
                                                [self displayHomepage];
                                            } else {
                                                NSLog(@"Error! @%", error);
                                            }
                                        }];
    }
    else {
        [self displayHomepage];
    }
}

- (void)displayHomepage
{
    [self performSegueWithIdentifier:@"navSegue" sender:self];
}
@end
