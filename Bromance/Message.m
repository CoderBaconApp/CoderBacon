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

- (id)initWithText:(NSString *)text andReceiver:(PFUser *)receiver {
    self = [super init];
    
    if (self) {
        // Custom initialization
        self.text = text;
        self.sender = [PFUser currentUser];
        self.receiver = receiver;
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
    Message *message = [[Message alloc] initWithText:object[TEXT] andReceiver:object[RECEIVER]];
    message.sender = object[SENDER];
    return message;
}

+ (void)allMessagesForLoggedInUserWithCompletion:(void (^)(NSMutableDictionary *messages, NSMutableDictionary *users, NSError *error))complete {
    PFQuery *receiverQuery = [PFQuery queryWithClassName:MESSAGE];
    [receiverQuery whereKey:RECEIVER equalTo:[PFUser currentUser]];
    
    PFQuery *senderQuery = [PFQuery queryWithClassName:MESSAGE];
    [senderQuery whereKey:SENDER equalTo:[PFUser currentUser]];
    //[senderQuery whereKey:RECEIVER equalTo:[PFUser currentUser]];
    
    //[senderQuery includeKey:SENDER]; // include user data about the sender
    //[senderQuery includeKey:RECEIVER]; // include user data about the receiver
    
    PFQuery *orQuery = [PFQuery orQueryWithSubqueries:@[receiverQuery, senderQuery]];
    [orQuery orderByAscending:CREATED_AT];
    
    [orQuery findObjectsInBackgroundWithBlock:^(NSArray *messages, NSError *error) {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        NSMutableDictionary *userDict = [[NSMutableDictionary alloc] init];
        
        for (int i = 0; i < messages.count; i++) {
            Message *msg = [Message fromPFObject:messages[i]];
            PFUser *other = ([msg.sender.objectId isEqualToString:[PFUser currentUser].objectId]) ? msg.receiver : msg.sender;
            
            if (!dict[other.objectId]) {
                dict[other.objectId] = [[NSMutableArray alloc] init];
                userDict[other.objectId] = other;
            }
            
            [dict[other.objectId] addObject:msg];
        }
        
        complete(dict, userDict, nil);
    }];
}

@end
