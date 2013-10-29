//
//  UserListViewController.m
//  Bromance
//
//  Created by Justin Steffen on 10/28/13.
//  Copyright (c) 2013 Pamela Ocampo. All rights reserved.
//

#import "UserListViewController.h"
#import "User.h"
#import "UserCell.h"

@interface UserListViewController ()
@property (strong, nonatomic) NSArray *users;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation UserListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
	[self reload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableViewDataSource methods

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    User *user = self.users[indexPath.row];
    UserCell *cell = (UserCell* )[self.tableView dequeueReusableCellWithIdentifier:@"UserListViewCell" forIndexPath:indexPath];
    cell.nameLabel.text = user.name;
    cell.locationLabel.text = user.location;
    cell.distanceLabel.text = @"69";
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.users.count;
}

#pragma mark Private Methods
- (void)reload
{
    [User allUsersWithCompletion:^(NSArray *users, NSError *error) {
        if (error) {
            NSLog(@"%@", error);
        }
        else if (users && users.count > 0) {
            self.users = users;
        }
        
        [self.tableView reloadData];
    }];
}

@end
