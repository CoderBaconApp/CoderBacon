//
//  MessageViewController.m
//  Bromance
//
//  Created by Therin Irwin on 10/19/13.
//  Copyright (c) 2013 Pamela Ocampo. All rights reserved.
//

#import "MessageViewController.h"
#import "Message.h"

@interface MessageViewController () {
    NSArray *_messages;
}

@end

@implementation MessageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self reload];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self reload];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 48.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section      {
    return [_messages count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    PFObject *message = _messages[indexPath.row];
    cell.text = [message objectForKey:@"text"];
    
    return cell;
}

- (void)reload
{
    [Message allMessagesForLoggedInUserWithCompletion:^(NSArray *msgs, NSError *error) {
        if (msgs && msgs.count > 0) {
            _messages = msgs;
        }
        
        [self.tableView reloadData];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
