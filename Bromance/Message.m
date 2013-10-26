//
//  Message.m
//  Bromance
//
//  Created by Therin Irwin on 10/19/13.
//  Copyright (c) 2013 Pamela Ocampo. All rights reserved.
//

#import "Message.h"
#define MESSAGE @"Message"

#define TEXT @"text"
#define SENDER @"sender"
#define RECEIVER @"receiver"

@implementation Message

- (id)initWithText:(NSString *) text {
    self = [super init];
    
    if (self) {
        // Custom initialization
        self.text = text;
        self.sender = [PFUser currentUser];
        self.receiver = [PFUser currentUser];
    }
    return self;
}

- (PFObject *) toPFObject {
    PFObject *object = [[PFObject alloc] initWithClassName:MESSAGE];
    object[TEXT] = self.text;
    object[SENDER] = self.sender;
    object[RECEIVER] = self.receiver;
    return object;
}


+ (Message *) fromPFObject:(PFObject *) object {
    Message *message = [[Message alloc] initWithText:object[TEXT]];
    message.sender = object[SENDER];
    message.receiver = object[RECEIVER];
    return message;
}

+ (void)allMessagesForLoggedInUserWithCompletion:(void (^)(NSArray *messages, NSError *error))complete {
    PFQuery *query = [PFQuery queryWithClassName:@"Message"];
    
    [query whereKey:@"receiver" equalTo:[PFUser currentUser]];
    
    [query findObjectsInBackgroundWithBlock:complete];
}

@end
