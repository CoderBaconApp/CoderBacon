//
//  SplashViewController.m
//  Bromance
//
//  Created by Therin Irwin on 10/19/13.
//  Copyright (c) 2013 Pamela Ocampo. All rights reserved.
//

#import <Parse/Parse.h>
#import <CoreLocation/CoreLocation.h>
#import "SplashViewController.h"
#import "Message.h"

@interface SplashViewController ()
- (IBAction)loginPressed:(id)sender;

@end

@implementation SplashViewController
- (CLLocationManager *)locationManager {
    if (_locationManager != nil) {
        return _locationManager;
    }
    
    _locationManager = [[CLLocationManager alloc] init];
    [_locationManager setDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
    [_locationManager setDelegate:self];
    
    return _locationManager;
}
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
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Messages" style:UIBarButtonSystemItemAction target:self action:@selector(messageListPressed)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Users" style:UIBarButtonSystemItemAction target:self action:@selector(userListPressed)];
    
    if ([self isLoggedIn]) {
        //[self closeSplashScreen];
        
        [self.locationManager startMonitoringSignificantLocationChanges];
        
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
    [self saveFacebookUserData];
    [self performSegueWithIdentifier:@"navSegue" sender:self];
}

- (void)saveFacebookUserData {
    [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        NSString *name = [result objectForKey:@"first_name"];
        NSString *location = [[result objectForKey:@"location"] objectForKey:@"name"];
        CLLocation *deviceLocation = _locationManager.location;

        CLLocationCoordinate2D coordinate = [deviceLocation coordinate];
        PFGeoPoint *geoPoint = [PFGeoPoint geoPointWithLatitude:coordinate.latitude
                                                      longitude:coordinate.longitude];
        
        [[PFUser currentUser] setObject:name forKey:@"name"];
        [[PFUser currentUser] setObject:location forKey:@"location"];
        PFObject *object = [PFObject objectWithClassName:@"Location"];
        [object setObject:geoPoint forKey:@"device_location"];
        NSLog(@"%@", [self deviceLocation:deviceLocation]);        
        [[PFUser currentUser] saveInBackground];
    }];
}

- (BOOL)isLoggedIn {
    return [PFUser currentUser] && [[FBSession activeSession] isOpen];
}

#pragma mark PFLogInViewControllerDelegate
// Sent to the delegate when a PFUser is logged in.
- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user {
    [self dismissViewControllerAnimated:YES completion:NULL];
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
    if (![self isLoggedIn]) {
        [self logInUser];
    }
    else {
        [self closeSplashScreen];
    }
}

- (void)userListPressed {
    [self performSegueWithIdentifier:@"userListSegue" sender:self];
}

- (void)messageListPressed {
    [self performSegueWithIdentifier:@"messageListSegue" sender:self];
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
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{

    [self deviceLocation:[locations lastObject]];
}
- (NSString *)deviceLocation:(CLLocation *)location {
    return [NSString stringWithFormat:@"(%f, %f)", location.coordinate.latitude, location.coordinate.longitude];
}
@end
