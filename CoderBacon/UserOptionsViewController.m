//  UserOptionsViewController.m
//
//  Copyright (C) 2013 CoderBacon
//
//  Licensed under Creative Commons BY-NC-SA
//  http://creativecommons.org/licenses/by-nc-sa/3.0/deed.en_US

#import "UserOptionsViewController.h"

@interface UserOptionsViewController ()
@property (strong, nonatomic) IBOutlet UIButton *cancelButton;

@end

@implementation UserOptionsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.cancelButton.backgroundColor = [UIColor whiteColor];
    self.cancelButton.layer.cornerRadius = 8.0f;
}

- (IBAction)cancelButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end

