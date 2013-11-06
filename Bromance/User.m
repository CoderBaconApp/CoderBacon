//  User.m
//
//  Copyright (C) 2013 BromanceApp
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

#import "User.h"
#import <Parse/Parse.h>

#define USER @"User"
#define OBJECTID @"objectId"
#define FACEBOOK_ID @"facebookId"
#define NAME @"name"
#define LOCATION @"location"
#define DEVICELOCATION @"device_location"
#define BIO @"bio"

@interface User ()

@end

@implementation User

- (NSString *)distanceFormat {
    int distance = ceil(self.distance);
    return [NSString stringWithFormat:@"%d mi.", distance];
}

- (PFObject *) toPFObject {
    PFObject *object = [[PFObject alloc] initWithClassName:USER];
    object[NAME] = self.name;
    object[LOCATION] = self.location;
    object[OBJECTID] = self.objectId;
    object[FACEBOOK_ID] = self.facebookId;
    object[DEVICELOCATION] =[PFGeoPoint geoPointWithLatitude:self.latitude longitude:self.longitude];
    object[BIO] = self.bio;
    return object;
}

#pragma mark Class Methods
+ (void)allUsersWithCompletion:(void (^)(NSArray *users, NSError *error))complete {
    PFQuery *usersQuery = [PFUser query];
    PFGeoPoint *currentGeoPoint = [PFUser currentUser][DEVICELOCATION];
    [usersQuery whereKey:DEVICELOCATION nearGeoPoint:currentGeoPoint];
    
    [usersQuery findObjectsInBackgroundWithBlock:^(NSArray *users, NSError *error) {
        NSMutableArray *usersArray = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < users.count; i++) {
            User *usr = [User fromPFObject:users[i]];
            
            if (![[[PFUser currentUser] objectId] isEqualToString:usr.objectId]) {
                PFGeoPoint *userGeoPoint = users[i][DEVICELOCATION];
                usr.distance = [ currentGeoPoint distanceInMilesTo: userGeoPoint];
                [usersArray addObject:usr];
            }
        }
        
        complete(usersArray, error);
    }];
}

+ (User *) fromPFObject:(PFObject *) object {
    User *user = [[User alloc] init];
    user.name = object[NAME];
    user.location = object[LOCATION];
    user.objectId = object.objectId;
    user.facebookId = object[FACEBOOK_ID];
    user.bio = object[BIO];
    
    PFGeoPoint *geoPoint = (PFGeoPoint *)object[DEVICELOCATION];
    if (geoPoint) {
        user.latitude = geoPoint.latitude;
        user.longitude = geoPoint.longitude;
    }
    
    return user;
}
@end
