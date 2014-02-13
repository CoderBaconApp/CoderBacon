//  UserListViewController.m
//
//  Copyright (C) 2013 CoderBacon
//
//  Licensed under Creative Commons BY-NC-SA
//  http://creativecommons.org/licenses/by-nc-sa/3.0/deed.en_US
//

#import "CBAUserListViewController.h"
#import "CBAUser.h"
#import "CBAUserCell.h"
#import "CBAUserProfileViewController.h"
#import <UIImageView+AFNetworking.h>
#import "CBATabBarController.h"
#import "CBACommon.h"

@interface CBAUserListViewController ()

@property (strong, nonatomic) NSArray *users;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)logOutClicked:(id)sender;

@end

@implementation CBAUserListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    CBAUserProfileViewController *profileVC = (CBAUserProfileViewController *) segue.destinationViewController;
    profileVC.user = self.users[indexPath.row];
}

#pragma mark UITableViewDataSource methods

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CBAUser *user = self.users[indexPath.row];
    CBAUserCell *cell = (CBAUserCell* )[self.tableView dequeueReusableCellWithIdentifier:@"CBAUserListViewCell" forIndexPath:indexPath];
    
    NSURL *profilePictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=square", user.facebookId]];
    NSURLRequest *profilePictureURLRequest = [NSURLRequest requestWithURL:profilePictureURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0f]; // Facebook profile picture cache policy: Expires in 2 weeks
    
    [cell.profileImageView setImageWithURLRequest:profilePictureURLRequest placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        user.profilePhoto = image;
        cell.profileImageView.image = user.profilePhoto;
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        NSLog(@"%@", error);
    }];
    
    cell.nameLabel.text = user.name;
    cell.locationLabel.text = user.location;
    cell.distanceLabel.text = user.distanceFormat;

    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.users.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

#pragma mark Private Methods
- (void)reload
{
    [CBAUser allUsersWithCompletion:^(NSArray *users, NSError *error) {
        if (error) {
            NSLog(@"%@", error);
        }
        else if (users && users.count > 0) {
            self.users = users;
        }
        
        [self.tableView reloadData];
    }];
}

- (void)clearData {
    _users = @[];
    [self.tableView reloadData];
}

- (IBAction)logOutClicked:(id)sender {
    [PFUser logOut];
    [[NSNotificationCenter defaultCenter] postNotificationName:LOG_OUT_NOTIFICATION object:self];
}

@end
