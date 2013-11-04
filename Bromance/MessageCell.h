//
//  MessageCell.h
//  Bromance
//
//  Created by Therin Irwin on 10/23/13.
//  Copyright (c) 2013 Pamela Ocampo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastMessageLabel;
@property (weak, nonatomic) UIImageView *profilePhoto;

@end
