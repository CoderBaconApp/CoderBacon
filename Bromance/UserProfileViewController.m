//
//  UserProfileViewController.m
//  Bromance
//
//  Created by Justin Steffen on 10/29/13.
//  Copyright (c) 2013 Pamela Ocampo. All rights reserved.
//

#import "UserProfileViewController.h"

@interface UserProfileViewController ()

@end

@implementation UserProfileViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = self.user.name;
    self.locationLabel.text = self.user.location;
    self.ageLabel.text = self.user.age > 0 ? [NSString stringWithFormat:@"%i", self.user.age] : @"";
    self.bioLabel.text = self.user.bio;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    //This makes the modal display as transparent.
    self.navigationController.modalPresentationStyle = UIModalPresentationCurrentContext;
}

@end
