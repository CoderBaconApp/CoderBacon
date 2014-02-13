//  MessageViewController.m
//
//  Copyright (C) 2013 CoderBacon
//
//  Licensed under Creative Commons BY-NC-SA
//  http://creativecommons.org/licenses/by-nc-sa/3.0/deed.en_US

#import "CBAMessageViewController.h"
#import "CBAMessage.h"
#import "CBAUser.h"
#import "CBAMessageCell.h"
#import "CBAMessageDetailViewController.h"
#import <UIImageView+AFNetworking.h>
#import "CBACommon.h"

#define MESSAGE_DETAIL_SEGUE @"MessageDetailSegue"

@interface CBAMessageViewController ()

@property (strong, nonatomic) NSMutableDictionary *messages;
@property (strong, nonatomic) PFUser *selectedUser;
@property (strong, nonatomic) NSMutableDictionary *users;

@end

@implementation CBAMessageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self registerForRemoteNotificationsWithApplication:[UIApplication sharedApplication]];
    
    UINib *messageNib = [UINib nibWithNibName:@"CBAMessageCell" bundle:nil];
    [self.tableView registerNib:messageNib forCellReuseIdentifier:@"CBAMessageCell"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clearData)
                                                 name:LOG_OUT_NOTIFICATION object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self reload];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section      {
    return [_messages count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CBAMessageCell";
    CBAMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSString *username = [[_messages allKeys] objectAtIndex:indexPath.row];
    NSArray *userMessages = [_messages objectForKey:username];
    NSString *userFacebookId = [((PFObject *) _users[username]) objectForKey:@"facebookId"];
    CBAMessage *firstMessage = [userMessages objectAtIndex:userMessages.count - 1];
    
    cell.lastMessageLabel.text = firstMessage.text;
    cell.nameLabel.text = [((PFObject *) _users[username]) objectForKey:@"name"];
    

    NSURL *profilePictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=square", userFacebookId]];
    NSURLRequest *profilePictureURLRequest = [NSURLRequest requestWithURL:profilePictureURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0f]; // Facebook profile picture cache policy: Expires in 2 weeks

    [cell.userImageView setImageWithURLRequest:profilePictureURLRequest placeholderImage:nil success:nil
                                       failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        NSLog(@"%@", error);
    }];
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    CBAMessageDetailViewController *mdvc = (CBAMessageDetailViewController *)[segue destinationViewController];
    
    mdvc.title = [_selectedUser objectForKey:@"name"];
    mdvc.messages = _messages[_selectedUser.objectId];
    mdvc.otherUser = _selectedUser;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    _selectedUser = _users[[[_messages allKeys] objectAtIndex:indexPath.row]];
    [self performSegueWithIdentifier:MESSAGE_DETAIL_SEGUE sender:self];
}

- (void)reload {
    [CBAMessage allMessagesForLoggedInUserWithCompletion:^(NSMutableDictionary *msgs, NSMutableDictionary *users, NSError *error) {
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
- (IBAction)logoutButtonClicked:(UIBarButtonItem *)sender {
    [PFUser logOut];
    [[NSNotificationCenter defaultCenter] postNotificationName:LOG_OUT_NOTIFICATION object:self];
}

- (void)clearData {
    _messages = [[NSMutableDictionary alloc] init];
    _users = [[NSMutableDictionary alloc] init];
    [self.tableView reloadData];
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
