//
//  MessageTests.m
//  CoderBacon
//
//  Created by Pamela Ocampo on 11/26/13.
//  Copyright (c) 2013 Pamela Ocampo. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Message.h"

@interface MessageTests : XCTestCase
@property (nonatomic,strong) Message *message;
@end

@implementation MessageTests


- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}

- (void)testInitWithText
{

    _message = [[Message alloc] initWithText:@"A test message" andReceiver:nil];

    XCTAssertTrue([_message.text isEqualToString:@"A test message"], @"");

}

@end
