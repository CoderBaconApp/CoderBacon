//  UserProfileViewController.m
//
//  Copyright (C) 2013 CoderBacon
//
//  Licensed under Creative Commons BY-NC-SA
//  http://creativecommons.org/licenses/by-nc-sa/3.0/deed.en_US

#import "CBAUserProfileViewController.h"
#import "CBAMessageDetailViewController.h"

#define BLOCKEDUSERTITLE @"Block User"

@interface CBAUserProfileViewController ()

@end

@implementation CBAUserProfileViewController

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
    CBAMessageDetailViewController *mdvc = (CBAMessageDetailViewController *)[segue destinationViewController];
    
    mdvc.title = self.user.name;
    mdvc.messages = [[NSArray alloc] init];
    mdvc.otherUser = self.user.pfUser;
}
- (IBAction)blockUserPressed {
    [self showActionSheet];
}

- (void)blockUser {
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
}

#pragma mark ActionSheet
- (void)showActionSheet {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:BLOCKEDUSERTITLE
                                            otherButtonTitles:nil, nil];
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:BLOCKEDUSERTITLE]) {
        [self blockUser];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
