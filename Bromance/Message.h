//
//  Message.h
//  Bromance
//
//  Created by Therin Irwin on 10/19/13.
//  Copyright (c) 2013 Pamela Ocampo. All rights reserved.
//

#import <Parse/Parse.h>
#import <Foundation/Foundation.h>

@interface Message : PFObject

//@property (strong, nonatomic) NSString* text;
//@property (strong, nonatomic) PFUser* sender;
//@property (strong, nonatomic) PFUser* receiver;

+ (void)allMessagesForLoggedInUserWithCompletion:(void (^)(NSArray *messages, NSError *error))complete;

@end