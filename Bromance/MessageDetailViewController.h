//
//  ViewController.h
//  Bromance
//
//  Created by Justin Steffen on 10/26/13.
//  Copyright (c) 2013 Pamela Ocampo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface MessageDetailViewController : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource, UITextFieldDelegate>

@property (strong, nonatomic) PFUser *otherUser;
@property (strong, nonatomic) NSArray *messages;
@property (weak, nonatomic) IBOutlet UICollectionView *messageCollectionView;

@end
