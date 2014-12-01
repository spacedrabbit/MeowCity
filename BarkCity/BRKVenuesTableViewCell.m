//
//  BRKVenuesTableViewCell.m
//  BarkCity
//
//  Created by Charles Coutu-Nadeau on 11/27/14.
//  Copyright (c) 2014 com.rosamcgee. All rights reserved.
//

#import "BRKVenuesTableViewCell.h"

@implementation BRKVenuesTableViewCell

- (void)awakeFromNib {
    // Initialization code
    //[self autoLayout];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) autoLayout {
    
    [self.contentView removeConstraints:[self.contentView constraints]];
    
    // Venue name constraints (pin to the top left above the rating and left of the picture)
    
    NSLayoutConstraint *nameLeading =
    [NSLayoutConstraint constraintWithItem:self.name
                                 attribute:NSLayoutAttributeLeft
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.contentView
                                 attribute:NSLayoutAttributeLeft
                                multiplier:1
                                  constant:0];
    
    NSLayoutConstraint *nameTrailing =
    [NSLayoutConstraint constraintWithItem:self.name
                                 attribute:NSLayoutAttributeRight
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.picture
                                 attribute:NSLayoutAttributeRight
                                multiplier:1
                                  constant:0];
    
    NSLayoutConstraint *nameTop =
    [NSLayoutConstraint constraintWithItem:self.name
                                 attribute:NSLayoutAttributeTop
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.contentView
                                 attribute:NSLayoutAttributeTop
                                multiplier:1
                                  constant:0];
    
    NSLayoutConstraint *nameBottom =
    [NSLayoutConstraint constraintWithItem:self.name
                                 attribute:NSLayoutAttributeBottom
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.rating
                                 attribute:NSLayoutAttributeBottom
                                multiplier:1
                                  constant:0];
    
    [self.contentView addConstraints:@[nameLeading, nameTrailing, nameTop, nameBottom]];
    
    // Venue rating constraints (Pin to the left below the name, above the descriptive body and left of the picture)
    
    NSLayoutConstraint *ratingLeading =
    [NSLayoutConstraint constraintWithItem:self.rating
                                 attribute:NSLayoutAttributeLeft
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.contentView
                                 attribute:NSLayoutAttributeLeft
                                multiplier:1
                                  constant:0];
    
    NSLayoutConstraint *ratingTrailing =
    [NSLayoutConstraint constraintWithItem:self.rating
                                 attribute:NSLayoutAttributeRight
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.picture
                                 attribute:NSLayoutAttributeRight
                                multiplier:1
                                  constant:0];
    
    NSLayoutConstraint *ratingTop =
    [NSLayoutConstraint constraintWithItem:self.rating
                                 attribute:NSLayoutAttributeTop
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.name
                                 attribute:NSLayoutAttributeBottom
                                multiplier:1
                                  constant:0];
    
    NSLayoutConstraint *ratingBottom =
    [NSLayoutConstraint constraintWithItem:self.rating
                                 attribute:NSLayoutAttributeBottom
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.descriptiveBody
                                 attribute:NSLayoutAttributeTop
                                multiplier:1
                                  constant:0];
    
    [self.contentView addConstraints:@[ratingLeading, ratingTrailing, ratingTop, ratingBottom]];
    
    // Venue distance constraints (Left of the rating, below the name, above the descriptive body and left of the picture)
    
    NSLayoutConstraint *distanceLeading =
    [NSLayoutConstraint constraintWithItem:self.distance
                                 attribute:NSLayoutAttributeLeft
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.rating
                                 attribute:NSLayoutAttributeRight
                                multiplier:1
                                  constant:0];
    
    NSLayoutConstraint *distanceTrailing =
    [NSLayoutConstraint constraintWithItem:self.distance
                                 attribute:NSLayoutAttributeRight
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.picture
                                 attribute:NSLayoutAttributeLeft
                                multiplier:1
                                  constant:0];
    
    NSLayoutConstraint *distanceTop =
    [NSLayoutConstraint constraintWithItem:self.distance
                                 attribute:NSLayoutAttributeTop
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.name
                                 attribute:NSLayoutAttributeBottom
                                multiplier:1
                                  constant:0];
    
    NSLayoutConstraint *distanceBottom =
    [NSLayoutConstraint constraintWithItem:self.distance
                                 attribute:NSLayoutAttributeBottom
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.descriptiveBody
                                 attribute:NSLayoutAttributeTop
                                multiplier:1
                                  constant:0];
    
    [self.contentView addConstraints:@[distanceLeading, distanceTrailing, distanceTop, distanceBottom]];
    
    // Venue picture constraints (Pin to the top right of the screen, with a size of 100x100 points)
    
    NSLayoutConstraint *pictureTrailing =
    [NSLayoutConstraint constraintWithItem:self.picture
                                 attribute:NSLayoutAttributeRight
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.contentView
                                 attribute:NSLayoutAttributeRight
                                multiplier:1
                                  constant:0];
    
    NSLayoutConstraint *pictureTop =
    [NSLayoutConstraint constraintWithItem:self.picture
                                 attribute:NSLayoutAttributeTop
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.contentView
                                 attribute:NSLayoutAttributeTop
                                multiplier:1
                                  constant:0];
    
    NSLayoutConstraint *pictureWidth =
    [NSLayoutConstraint constraintWithItem:self.picture
                                 attribute:NSLayoutAttributeWidth
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.contentView
                                 attribute:NSLayoutAttributeWidth
                                multiplier:0
                                  constant:100];
    
    NSLayoutConstraint *pictureHeight =
    [NSLayoutConstraint constraintWithItem:self.picture
                                 attribute:NSLayoutAttributeHeight
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.contentView
                                 attribute:NSLayoutAttributeHeight
                                multiplier:0
                                  constant:100];
    
    [self.contentView addConstraints:@[pictureTrailing, pictureTop, pictureWidth, pictureHeight]];
    
    // Venue descriptiveBody constraints (Left, below rating and distance, picture on the left)
    
    NSLayoutConstraint *descriptiveBodyLeading =
    [NSLayoutConstraint constraintWithItem:self.descriptiveBody
                                 attribute:NSLayoutAttributeLeft
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.contentView
                                 attribute:NSLayoutAttributeLeft
                                multiplier:1
                                  constant:0];
    
    NSLayoutConstraint *descriptiveBodyTrailing =
    [NSLayoutConstraint constraintWithItem:self.descriptiveBody
                                 attribute:NSLayoutAttributeRight
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.picture
                                 attribute:NSLayoutAttributeLeft
                                multiplier:1
                                  constant:0];
    
    NSLayoutConstraint *descriptiveBodyTop =
    [NSLayoutConstraint constraintWithItem:self.descriptiveBody
                                 attribute:NSLayoutAttributeTop
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.rating
                                 attribute:NSLayoutAttributeBottom
                                multiplier:1
                                  constant:0];
    
    NSLayoutConstraint *descriptiveBodyBottom =
    [NSLayoutConstraint constraintWithItem:self.descriptiveBody
                                 attribute:NSLayoutAttributeBottom
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.contentView
                                 attribute:NSLayoutAttributeBottom
                                multiplier:1
                                  constant:0];
    
    [self.contentView addConstraints:@[descriptiveBodyLeading, descriptiveBodyTrailing, descriptiveBodyTop, descriptiveBodyBottom]];
    
}

@end