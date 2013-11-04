//
//  MessageViewController.m
//  Bromance
//
//  Created by Therin Irwin on 10/19/13.
//  Copyright (c) 2013 Pamela Ocampo. All rights reserved.
//

#import "MessageViewController.h"
#import "Message.h"
#import "User.h"
#import "MessageCell.h"
#import "MessageDetailViewController.h"
#import <UIImageView+AFNetworking.h>

#define MESSAGE_DETAIL_SEGUE @"MessageDetailSegue"

@interface MessageViewController ()

@property (strong, nonatomic) NSMutableDictionary *messages;
@property (strong, nonatomic) PFUser *selectedUser;
@property (strong, nonatomic) NSMutableDictionary *users;

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
    
    [self registerForRemoteNotificationsWithApplication:[UIApplication sharedApplication]];
    
    UINib *messageNib = [UINib nibWithNibName:@"MessageCell" bundle:nil];
    [self.tableView registerNib:messageNib forCellReuseIdentifier:@"MessageCell"];
    
    [self reload];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 48.f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section      {
    return [_messages count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MessageCell";
    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSString *username = [[_messages allKeys] objectAtIndex:indexPath.row];
    NSArray *userMessages = [_messages objectForKey:username];
    NSString *userFacebookId = [((PFObject *) _users[username]) objectForKey:@"facebookId"];
    Message *firstMessage = [userMessages objectAtIndex:userMessages.count - 1];
    
    cell.lastMessageLabel.text = firstMessage.text;
    cell.nameLabel.text = [((PFObject *) _users[username]) objectForKey:@"name"];
    

    NSURL *profilePictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=square", userFacebookId]];
    NSURLRequest *profilePictureURLRequest = [NSURLRequest requestWithURL:profilePictureURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0f]; // Facebook profile picture cache policy: Expires in 2 weeks
    
    [cell.imageView setImageWithURLRequest:profilePictureURLRequest placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        cell.imageView.image = image;
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        NSLog(@"%@", error);
    }];
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    MessageDetailViewController *mdvc = (MessageDetailViewController *)[segue destinationViewController];
    
    mdvc.title = [_selectedUser objectForKey:@"name"];
    mdvc.messages = _messages[_selectedUser.objectId];
    mdvc.otherUser = _selectedUser;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    _selectedUser = _users[[[_messages allKeys] objectAtIndex:indexPath.row]];
    [self performSegueWithIdentifier:MESSAGE_DETAIL_SEGUE sender:self];
}

- (void)reload {
    [Message allMessagesForLoggedInUserWithCompletion:^(NSMutableDictionary *msgs, NSMutableDictionary *users, NSError *error) {
        if (error) {
            NSLog(@"%@", error);
        }
        else if (msgs && msgs.count > 0) {
            _messages = msgs;
            _users = users;
        }
        
        [self.tableView reloadData];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Push Notifications
-(void)registerForRemoteNotificationsWithApplication:(UIApplication *) application {
    [application registerForRemoteNotificationTypes:
     UIRemoteNotificationTypeBadge |
     UIRemoteNotificationTypeAlert |
     UIRemoteNotificationTypeSound];
}

@end
