//  UserProfileViewController.m
//
//  Copyright (C) 2013 CoderBacon
//
//  Licensed under Creative Commons BY-NC-SA
//  http://creativecommons.org/licenses/by-nc-sa/3.0/deed.en_US

#import "UserProfileViewController.h"
#import "MessageDetailViewController.h"

@interface UserProfileViewController ()

@end

@implementation UserProfileViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setup];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    
    return self;
}

- (void)setup {
    //self.hidesBottomBarWhenPushed = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = self.user.name;
    self.locationLabel.text = self.user.location;
    self.ageLabel.text = self.user.age > 0 ? [NSString stringWithFormat:@"%li", (long)self.user.age] : @"";
    self.bioLabel.text = self.user.bio;
    self.profileImageView.image = self.user.profilePhoto;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    MessageDetailViewController *mdvc = (MessageDetailViewController *)[segue destinationViewController];
    
    mdvc.title = self.user.name;
    mdvc.messages = [[NSArray alloc] init];
    mdvc.otherUser = self.user.pfUser;
}

- (IBAction)blockUser:(id)sender {
    //TODO: Add confirmation message
    
    PFObject *blocker = [[PFObject alloc] initWithClassName:@"BlockedUser"];
    PFObject *blockee = [[PFObject alloc] initWithClassName:@"BlockedUser"];
    
    blocker[@"user"] = [PFUser currentUser];
    blocker[@"blockedUserString"] = self.user.objectId;
    
    blockee[@"user"] = self.user.pfUser;
    blockee[@"blockedUserString"] = [PFUser currentUser].objectId;
    
    [blocker saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        NSLog(@"Blocker Succeeded: %d %@", succeeded, error);
    }];
    
    [blockee saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        NSLog(@"Blockee Succeeded: %d %@", succeeded, error);
    }];
    
    //TODO: Pop back to user list.
}

@end
