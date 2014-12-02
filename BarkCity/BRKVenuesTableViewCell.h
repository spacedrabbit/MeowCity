//
//  BRKVenuesTableViewCell.h
//  BarkCity
//
//  Created by Charles Coutu-Nadeau on 11/27/14.
//  Copyright (c) 2014 com.rosamcgee. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BRKVenue;

@interface BRKVenuesTableViewCell : UITableViewCell

@property (strong, nonatomic)BRKVenue *venue;
@property (weak, nonatomic) IBOutlet UILabel *descriptiveBody;

@end
