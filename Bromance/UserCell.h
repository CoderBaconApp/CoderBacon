//  UserCell.h
//
//  Copyright (C) 2013 BromanceApp

#import <UIKit/UIKit.h>

@interface UserCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *locationLabel;
@property (nonatomic, weak) IBOutlet UILabel *distanceLabel;
@property (nonatomic, weak) IBOutlet UIImageView *profileImageView;
@end
