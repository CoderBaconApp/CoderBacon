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
    self.hidesBottomBarWhenPushed = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = self.user.name;
    self.locationLabel.text = self.user.location;
    self.ageLabel.text = self.user.age > 0 ? [NSString stringWithFormat:@"%li", (long)self.user.age] : @"";
    self.bioLabel.text = self.user.bio;
    [self getUserImage:self.user.facebookId];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    //This makes the modal display as transparent.
    self.navigationController.modalPresentationStyle = UIModalPresentationCurrentContext;
}
-(void)getUserImage:(NSString *) facebookId{
    NSURL *profilePictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=square", facebookId]];
    NSURLRequest *profilePictureURLRequest = [NSURLRequest requestWithURL:profilePictureURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0f]; // Facebook profile picture cache policy: Expires in 2 weeks
    [NSURLConnection connectionWithRequest:profilePictureURLRequest delegate:self];
}
#pragma mark - NSURLConnectionDataDelegate
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    _fbGraphData = [[NSMutableData alloc] init];
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [_fbGraphData appendData:data];
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    self.profileImageView.image = [UIImage imageWithData:_fbGraphData];
}

@end
