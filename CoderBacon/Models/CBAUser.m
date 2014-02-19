//  User.m
//
//  Copyright (C) 2013 CoderBacon
//
//  Licensed under Creative Commons BY-NC-SA
//  http://creativecommons.org/licenses/by-nc-sa/3.0/deed.en_US

#import "CBAUser.h"

#define USER @"User"
#define OBJECTID @"objectId"
#define FACEBOOK_ID @"facebookId"
#define NAME @"name"
#define LOCATION @"location"
#define DEVICELOCATION @"device_location"
#define BIO @"bio"
#define BLOCKEDUSER @"BlockedUser"

@interface CBAUser ()

@end

@implementation CBAUser

- (NSString *)distanceFormat {
    int distance = ceil(self.distance);
    return [NSString stringWithFormat:@"%d mi.", distance];
}


#pragma mark Class Methods
+ (void)allUsersWithCompletion:(void (^)(NSArray *users, NSError *error))complete {
//    PFQuery *blockedUsersQuery = [PFQuery queryWithClassName:BLOCKEDUSER];
//    [blockedUsersQuery whereKey:@"user" equalTo:[PFUser currentUser]];
//    
//    PFQuery *usersQuery = [PFUser query];
//    PFGeoPoint *currentGeoPoint = [PFUser currentUser][DEVICELOCATION];
//    [usersQuery whereKey:DEVICELOCATION nearGeoPoint:currentGeoPoint];
//    [usersQuery whereKey:@"objectId" doesNotMatchKey:@"blockedUserString" inQuery:blockedUsersQuery];
//    
//    [usersQuery findObjectsInBackgroundWithBlock:^(NSArray *users, NSError *error) {
//        NSMutableArray *usersArray = [[NSMutableArray alloc] init];
//        
//        for (int i = 0; i < users.count; i++) {
//            CBAUser *usr = [CBAUser fromPFObject:users[i]];
//            
//            if (![[[PFUser currentUser] objectId] isEqualToString:usr.objectId]) {
//                PFGeoPoint *userGeoPoint = users[i][DEVICELOCATION];
//                usr.distance = [ currentGeoPoint distanceInMilesTo: userGeoPoint];
//                [usersArray addObject:usr];
//            }
//        }
//        
//        complete(usersArray, error);
//    }];
}
@end
