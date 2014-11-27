//
//  BRKVenuesTableViewCell.h
//  BarkCity
//
//  Created by Charles Coutu-Nadeau on 11/27/14.
//  Copyright (c) 2014 com.rosamcgee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BRKVenuesTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *rating;
@property (weak, nonatomic) IBOutlet UILabel *distance;
@property (weak, nonatomic) IBOutlet UIImageView *picture;
@property (weak, nonatomic) IBOutlet UILabel *descriptiveBody;

@end
