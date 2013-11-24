//  Message.h
//
//  Copyright (C) 2013 BromanceApp

#import <Parse/Parse.h>
#import <Foundation/Foundation.h>

@interface Message : NSObject

@property (strong, nonatomic) NSString* text;
@property (strong, nonatomic) PFUser* sender;
@property (strong, nonatomic) PFUser* receiver;

+ (void)allMessagesForLoggedInUserWithCompletion:(void (^)(NSMutableDictionary *messages, NSMutableDictionary *users, NSError *error))complete;
+ (void)allMessagesBetweenUser:(PFUser *)user withCompletion:(void (^)(NSArray *messages, NSError *error))complete;
+ (Message *) fromPFObject:(PFObject *) object;

- (id)initWithText:(NSString *) text andReceiver:(PFUser *)receiver;
- (PFObject *)toPFObject;

@end
