//  Message.h
//
//  Copyright (C) 2013 CoderBacon
//
//  Licensed under Creative Commons BY-NC-SA
//  http://creativecommons.org/licenses/by-nc-sa/3.0/deed.en_US

#import <Foundation/Foundation.h>
#import "CBAUser.h"

@interface CBAMessage : NSObject

@property (strong, nonatomic) NSString* text;
@property (strong, nonatomic) CBAUser* sender;
@property (strong, nonatomic) CBAUser* receiver;

+ (void)allMessagesForLoggedInUserWithCompletion:(void (^)(NSMutableDictionary *messages, NSMutableDictionary *users, NSError *error))complete;
- (id)initWithText:(NSString *) text andReceiver:(CBAUser *)receiver;

@end
