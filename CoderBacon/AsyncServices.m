//  AsyncServices.m
//
//  Copyright (C) 2013 CoderBacon

#import <Parse/Parse.h>
#import "AsyncServices.h"
#import "TabBarController.h"

#define USER @"user"

@interface AsyncServices()

@property (strong, nonatomic) CLLocationManager *locationManager;

@end

@implementation AsyncServices

+ (AsyncServices *)instance {
    static AsyncServices *services;
    
    if (!services) {
        services = [[AsyncServices alloc] init];
    }
    
    return services;
}

- (void)initLocationManager {
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        [_locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
        [_locationManager setDelegate:self];
        
        [_locationManager startMonitoringSignificantLocationChanges];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    
    CLGeocoder * geoCoder = [[CLGeocoder alloc] init];
    _lastLocation = [locations lastObject];
    
    [geoCoder reverseGeocodeLocation:[locations lastObject] completionHandler:^(NSArray *placemarks, NSError *error) {
        
        if(!error) {
            for (CLPlacemark * placemark in placemarks) {
                NSString *updatedLocation = [NSString stringWithFormat:@"%@, %@ %@ %@", placemark.locality, placemark.administrativeArea, placemark.postalCode, placemark.ISOcountryCode];
                
                NSLog(@"%@", updatedLocation);
                _geoLocation = updatedLocation;
                
                [self updateGeoLocation];
            }
        }
        else {
            NSLog(@"failed getting updated Geocode Location: %@", [error description]);
        }
        
    }];
    
    [self updateLastLocation];
}

// These two methods should be called on every significant location change
- (void)updateGeoLocation {
    if ([TabBarController isLoggedIn]) {
        [[PFUser currentUser] setObject:[self geoLocation] forKey:@"location"];
    
        [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            [[NSNotificationCenter defaultCenter] postNotificationName:LAT_LNG_UPDATED object:self];
        }];
    }
}

- (void)updateLastLocation {
    if ([TabBarController isLoggedIn]) {
        CLLocationCoordinate2D coordinate = [self lastLocation].coordinate;
        PFGeoPoint *geoPoint = [PFGeoPoint geoPointWithLatitude:coordinate.latitude
                                                      longitude:coordinate.longitude];
    
        [[PFUser currentUser] setObject:geoPoint forKey:@"device_location"];
    
        [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            [[NSNotificationCenter defaultCenter] postNotificationName:GEO_LOCATION_UPDATED object:self];
        }];
    }
}

// Call this every time the user logs in to refresh data in Parse
- (void)saveInitialUserData {
    // Save user's device ID to Parse
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setObject:[PFUser currentUser] forKey:USER];
    [currentInstallation saveInBackground];
    
    // Save FB data to Parse
    [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            NSDictionary<FBGraphUser> *currentFBGraphUser = (NSDictionary<FBGraphUser> *)result;
            NSString *name = [result objectForKey:@"first_name"];
            CLLocationCoordinate2D coordinate = [self lastLocation].coordinate;
            PFGeoPoint *geoPoint = [PFGeoPoint geoPointWithLatitude:coordinate.latitude
                                                          longitude:coordinate.longitude];
            
            // Store the Facebook Id
            [[PFUser currentUser] setObject:currentFBGraphUser.id forKey:@"facebookId"];
            
            // Save these the first time the user is logged in just in case they've been updated already
            [[PFUser currentUser] setObject:[self geoLocation] forKey:@"location"];
            [[PFUser currentUser] setObject:geoPoint forKey:@"device_location"];
            
            [[PFUser currentUser] setObject:name forKey:@"name"];
            [[PFUser currentUser] saveInBackground];
        }
        else {
            NSLog(@"FB data retrieval error: %@", error);
        }
    }];
}

@end
