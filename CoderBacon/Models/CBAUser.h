//  User.h
//
//  Copyright (C) 2013 CoderBacon
//
//  Licensed under Creative Commons BY-NC-SA
//  http://creativecommons.org/licenses/by-nc-sa/3.0/deed.en_US

#import <Foundation/Foundation.h>


@interface CBAUser : NSObject
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


#pragma mark Class Methods
+ (void)allUsersWithCompletion:(void (^)(NSArray *users, NSError *error))complete;

@end
