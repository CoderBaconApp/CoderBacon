//
//  Broadcast.h
//  Bromance
//
//  Created by Therin Irwin on 10/19/13.
//  Copyright (c) 2013 Pamela Ocampo. All rights reserved.
//

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
