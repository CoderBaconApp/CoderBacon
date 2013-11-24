//  Broadcast.h
//
//  Copyright (C) 2013 BromanceApp

#import <Parse/Parse.h>
#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface Broadcast : NSObject

@property (strong, nonatomic) PFUser *user;
@property (strong, nonatomic) NSString *location;
@property (strong, nonatomic) NSString *text;
@property (strong, nonatomic) NSDate *expiresAt;
@property (strong, nonatomic) NSDate *createdAt;

@end
