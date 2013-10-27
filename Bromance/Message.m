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
#define CREATED_AT @"createdAt"

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

+ (void)allMessagesForLoggedInUserWithCompletion:(void (^)(NSMutableDictionary *messages, NSError *error))complete {
    PFQuery *receiverQuery = [PFQuery queryWithClassName:MESSAGE];
    [receiverQuery whereKey:RECEIVER equalTo:[PFUser currentUser]];
    
    PFQuery *senderQuery = [PFQuery queryWithClassName:MESSAGE];
    [senderQuery whereKey:SENDER equalTo:[PFUser currentUser]];
    
    PFQuery *orQuery = [PFQuery orQueryWithSubqueries:@[receiverQuery, senderQuery]];
    [orQuery orderByDescending:CREATED_AT];
    
    [orQuery findObjectsInBackgroundWithBlock:^(NSArray *messages, NSError *error) {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        
        for (int i = 0; i < messages.count; i++) {
            Message *msg = [Message fromPFObject:messages[i]];
            PFUser *other = (msg.sender.objectId == [PFUser currentUser].objectId) ? msg.receiver : msg.sender;
            
            
            if (!dict[other.objectId]) {
                dict[other.objectId] = [[NSMutableArray alloc] init];
            }
            
            [dict[other.objectId] addObject:msg];
        }
        
        complete(dict, nil);
    }];
}

@end
