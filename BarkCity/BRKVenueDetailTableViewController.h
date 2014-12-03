//
//  BRKVenueDetailTableViewController.h
//  BarkCity
//
//  Created by Charles Coutu-Nadeau on 11/27/14.
//  Copyright (c) 2014 com.rosamcgee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BRKPictureTableViewCell.h"

@class BRKVenue;

@protocol BRKDetailTableViewSegueDelegate <NSObject>

- (void)segueToDetailTableViewWithVenue:(BRKVenue *)venue;

@end

@interface BRKVenueDetailTableViewController : UITableViewController <BRKPictureTableViewCellDelegate>

@property (strong, nonatomic) BRKVenue *venue;

@end
