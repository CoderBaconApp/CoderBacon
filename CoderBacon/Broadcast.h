//  Broadcast.h
//
//  Copyright (C) 2013 BromanceApp
//
//  Licensed under Creative Commons BY-NC-SA
//  http://creativecommons.org/licenses/by-nc-sa/3.0/deed.en_US

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
