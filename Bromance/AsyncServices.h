//
//  AsyncServices.h
//  Bromance
//
//  Created by Therin Irwin on 11/3/13.
//  Copyright (c) 2013 Pamela Ocampo. All rights reserved.
//

#import <Foundation/Foundation.h>

#define GEO_LOCATION_UPDATED @"GeoLocationUpdated"
#define LAT_LNG_UPDATED @"LatLngUpdated"

@interface AsyncServices : NSObject <CLLocationManagerDelegate>

@property (strong, nonatomic) NSString *geoLocation;
@property (strong, nonatomic) CLLocation *lastLocation;

+ (AsyncServices *)instance;
- (void)saveInitialUserData;
- (void)initLocationManager;

@end
