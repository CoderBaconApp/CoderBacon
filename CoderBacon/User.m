//  User.m
//
//  Copyright (C) 2013 CoderBacon
//
//  Licensed under Creative Commons BY-NC-SA
//  http://creativecommons.org/licenses/by-nc-sa/3.0/deed.en_US

#import "User.h"
#import <Parse/Parse.h>

#define USER @"User"
#define OBJECTID @"objectId"
#define FACEBOOK_ID @"facebookId"
#define NAME @"name"
#define LOCATION @"location"
#define DEVICELOCATION @"device_location"
#define BIO @"bio"
#define BLOCKEDUSER @"BlockedUser"

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
    object.objectId = self.objectId;
    object[FACEBOOK_ID] = self.facebookId;
    object[DEVICELOCATION] =[PFGeoPoint geoPointWithLatitude:self.latitude longitude:self.longitude];
    object[BIO] = self.bio ? self.bio : [NSNull null];
    return object;
}

#pragma mark Class Methods
+ (void)allUsersWithCompletion:(void (^)(NSArray *users, NSError *error))complete {
    PFQuery *blockedUsersQuery = [PFQuery queryWithClassName:BLOCKEDUSER];
    [blockedUsersQuery whereKey:@"user" equalTo:[PFUser currentUser]];
    
    PFQuery *usersQuery = [PFUser query];
    PFGeoPoint *currentGeoPoint = [PFUser currentUser][DEVICELOCATION];
    [usersQuery whereKey:DEVICELOCATION nearGeoPoint:currentGeoPoint];
    [usersQuery whereKey:@"objectId" doesNotMatchKey:@"blockedUserString" inQuery:blockedUsersQuery];
    
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
    user.pfUser = (PFUser*)object;
    
    PFGeoPoint *geoPoint = (PFGeoPoint *)object[DEVICELOCATION];
    if (geoPoint) {
        user.latitude = geoPoint.latitude;
        user.longitude = geoPoint.longitude;
    }
    
    return user;
}
@end
