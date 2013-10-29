//
//  UserCell.h
//  Bromance
//
//  Created by Justin Steffen on 10/29/13.
//  Copyright (c) 2013 Pamela Ocampo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *locationLabel;
@property (nonatomic, weak) IBOutlet UILabel *distanceLabel;
@property (nonatomic, weak) IBOutlet UIImageView *profileImageView;
@end
