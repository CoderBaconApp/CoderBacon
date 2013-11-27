//
//  MessageViewControllerTests.m
//  CoderBacon
//
//  Created by Pamela Ocampo on 11/26/13.
//  Copyright (c) 2013 Pamela Ocampo. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "OCMock.h"
#import "MessageViewController.h"
#import "MessageCell.h"

@interface MessageViewControllerTests : XCTestCase
@property (nonatomic, strong) MessageViewController *controller;
@end

@implementation MessageViewControllerTests

- (void)setUp
{
    [super setUp];
    _controller = [[MessageViewController alloc] init];

}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}
- (void)testControllerSetsUpCellCorrectly {
    id mockUINib = [OCMockObject mockForClass:[UINib class]];
    id mockTableView = [OCMockObject mockForClass:[UITableView class]];
    [[[mockTableView expect] andReturn:mockUINib] dequeueReusableCellWithIdentifier:@"MessageCell" forIndexPath:nil];
    
    UITableViewCell *cell = [_controller tableView:mockTableView cellForRowAtIndexPath:nil];
    
    XCTAssertNotNil(cell, @"returns a cell");
    XCTAssertEqualObjects(@"Hello World!", cell.textLabel.text, @"sets label");
    [mockTableView verify];
}
@end
