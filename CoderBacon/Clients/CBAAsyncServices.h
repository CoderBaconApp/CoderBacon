//  AsyncServices.h
//
//  Copyright (C) 2013 CoderBacon
//
//  Licensed under Creative Commons BY-NC-SA
//  http://creativecommons.org/licenses/by-nc-sa/3.0/deed.en_US

#import <Foundation/Foundation.h>

#define GEO_LOCATION_UPDATED @"GeoLocationUpdated"
#define LAT_LNG_UPDATED @"LatLngUpdated"

@interface CBAAsyncServices : NSObject <CLLocationManagerDelegate>

@property (strong, nonatomic) NSString *geoLocation;
@property (strong, nonatomic) CLLocation *lastLocation;

+ (CBAAsyncServices *)instance;
- (void)saveInitialUserData;
- (void)initLocationManager;

@end
