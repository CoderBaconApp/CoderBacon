//  User.h
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

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface User : NSObject
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *location;
@property (strong, nonatomic) NSString *objectId;
@property (strong, nonatomic) NSString *facebookId;
@property (nonatomic) double latitude;
@property (nonatomic) double longitude;
@property (nonatomic) NSInteger age;
@property (strong, nonatomic) NSString *bio;
@property (strong, nonatomic) NSMutableData *fbGraphData;
@property (strong, nonatomic) UIImage *profilePhoto;
@property (nonatomic) double distance;
@property (readonly) NSString *distanceFormat;
-(PFObject *) toPFObject;
#pragma mark Class Methods
+ (void)allUsersWithCompletion:(void (^)(NSArray *users, NSError *error))complete;
+ (User *)fromPFObject:(PFObject *)object;
@end
