//
//  User.m
//  Bromance
//
//  Created by Justin Steffen on 10/28/13.
//  Copyright (c) 2013 Pamela Ocampo. All rights reserved.
//

#import "User.h"
#import <Parse/Parse.h>

#define USER @"User"
#define OBJECTID @"objectId"
#define NAME @"name"
#define LOCATION @"location"
#define DEVICELOCATION @"device_location"

@interface User ()

@end

@implementation User

- (PFObject *) toPFObject {
    PFObject *object = [[PFObject alloc] initWithClassName:USER];
    object[NAME] = self.name;
    object[LOCATION] = self.location;
    object[OBJECTID] = self.objectId;
    object[DEVICELOCATION] =[PFGeoPoint geoPointWithLatitude:self.latitude longitude:self.longitude];
    return object;
}

#pragma mark Class Methods
+ (void)allUsersWithCompletion:(void (^)(NSArray *users, NSError *error))complete {
    PFQuery *usersQuery = [PFUser query];
    
    [usersQuery findObjectsInBackgroundWithBlock:^(NSArray *users, NSError *error) {
        NSMutableArray *usersArray = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < users.count; i++) {
            User *usr = [User fromPFObject:users[i]];
            
            if (![[[PFUser currentUser] objectId] isEqualToString:usr.objectId]) {
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
    
    PFGeoPoint *geoPoint = (PFGeoPoint *)object[DEVICELOCATION];
    if (geoPoint) {
        user.latitude = geoPoint.latitude;
        user.longitude = geoPoint.longitude;
    }
    
    return user;
}

@end
