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
    [self performSegueWithIdentifier:@"tabBarControllerSegue" sender:self];
}

- (void)saveFacebookUserData {
    [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            
            NSDictionary<FBGraphUser> *currentFBGraphUser = (NSDictionary<FBGraphUser> *)result;
            // Store the Facebook Id
            [[PFUser currentUser] setObject:currentFBGraphUser.id forKey:@"facebookId"];

            CLLocation *deviceLocation = _locationManager.location;
            CLLocationCoordinate2D coordinate = [deviceLocation coordinate];
            PFGeoPoint *geoPoint = [PFGeoPoint geoPointWithLatitude:coordinate.latitude
                                                          longitude:coordinate.longitude];
            
            
            NSString *name = [result objectForKey:@"first_name"];
            
            
            [[PFUser currentUser] setObject:name forKey:@"name"];
            [[PFUser currentUser] setObject:geoPoint forKey:@"device_location"];
            
            [[PFUser currentUser] saveInBackground];
        }
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
    
    CLGeocoder * geoCoder = [[CLGeocoder alloc] init];
    
    [geoCoder reverseGeocodeLocation:[locations lastObject] completionHandler:^(NSArray *placemarks, NSError *error) {
        
        if(!error)
        {
            for (CLPlacemark * placemark in placemarks)
            {
                NSString *updatedLocation = [NSString stringWithFormat:@"%@, %@ %@ %@", placemark.locality, placemark.administrativeArea, placemark.postalCode, placemark.ISOcountryCode];
                NSLog(@"%@", updatedLocation);
                [[PFUser currentUser] setObject:updatedLocation forKey:@"location"];
                [[PFUser currentUser] saveInBackground];
                
            }
            
        }
        else
        {
            NSLog(@"failed getting updated location: %@", [error description]);
        }
        
    }];
    
    [self deviceLocation:[locations lastObject]];
}
- (NSString *)deviceLocation:(CLLocation *)location {
    return [NSString stringWithFormat:@"(%f, %f)", location.coordinate.latitude, location.coordinate.longitude];
}
@end
