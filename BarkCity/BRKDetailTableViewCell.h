//
//  VenueDetailTableViewCell.h
//  BarkCity
//
//  Created by Charles Coutu-Nadeau on 12/4/14.
//  Copyright (c) 2014 com.rosamcgee. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BRKDetailTableViewCell;

@protocol BRKDetailTableViewCellDelegate <NSObject>

- (void) call:(BRKDetailTableViewCell *)sender phone:(NSString*)phone;

@end

@class BRKVenue;

@interface BRKDetailTableViewCell : UITableViewCell

@property (strong, nonatomic) id <BRKDetailTableViewCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *rating;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *distance;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UIButton *phone;
@property (weak, nonatomic) IBOutlet UIButton *website;
@property (weak, nonatomic) IBOutlet UILabel *hours;

- (IBAction)phoneButtonTapped:(id)sender;
- (IBAction)websiteButtonTapped:(id)sender;

- (void) setVenue:(BRKVenue*)venue;

@end
