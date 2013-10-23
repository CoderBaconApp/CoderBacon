//
//  Message.m
//  Bromance
//
//  Created by Therin Irwin on 10/19/13.
//  Copyright (c) 2013 Pamela Ocampo. All rights reserved.
//

#import "Message.h"
#define MESSAGE @"Message"

@implementation Message

- (id)init
{
    self = [super initWithClassName:MESSAGE];
    
    if (self) {
        // Custom initialization
    }
    return self;
}

+ (void)allMessagesForLoggedInUserWithCompletion:(void (^)(NSArray *messages, NSError *error))complete
{
    PFQuery *query = [PFQuery queryWithClassName:@"Message"];
    
    [query whereKey:@"receiver" equalTo:[PFUser currentUser]];
    
    [query findObjectsInBackgroundWithBlock:complete];
}

@end
