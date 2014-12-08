//
//  VenueDetailTableViewCell.h
//  BarkCity
//
//  Created by Charles Coutu-Nadeau on 12/4/14.
//  Copyright (c) 2014 com.rosamcgee. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BRKVenue;

@interface BRKDetailTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *rating;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *distance;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumber;
@property (weak, nonatomic) IBOutlet UILabel *website;
@property (weak, nonatomic) IBOutlet UILabel *hours;

- (void) setVenue:(BRKVenue*)venue;

@end
