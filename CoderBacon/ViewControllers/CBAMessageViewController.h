//  MessageViewController.h
//
//  Copyright (C) 2013 CoderBacon
//
//  Licensed under Creative Commons BY-NC-SA
//  http://creativecommons.org/licenses/by-nc-sa/3.0/deed.en_US

#import <UIKit/UIKit.h>
#import "CBAMessageDetailViewController.h"

@interface CBAMessageViewController : UITableViewController

@property (strong, nonatomic) NSMutableDictionary *detailViews;

@end
