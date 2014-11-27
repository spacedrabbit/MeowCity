//
//  BRKPictureTableViewCell.m
//  BarkCity
//
//  Created by Charles Coutu-Nadeau on 11/27/14.
//  Copyright (c) 2014 com.rosamcgee. All rights reserved.
//

#import "BRKPictureTableViewCell.h"

@implementation BRKPictureTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [self autoLayout];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) autoLayout {
    
    [self.contentView removeConstraints:[self.contentView constraints]];
    
    NSLayoutConstraint *pictureLeading =
    [NSLayoutConstraint constraintWithItem:self.picture
                                 attribute:NSLayoutAttributeLeft
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.contentView
                                 attribute:NSLayoutAttributeLeft
                                multiplier:1
                                  constant:0];
    
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
    
    NSLayoutConstraint *pictureBottom =
    [NSLayoutConstraint constraintWithItem:self.picture
                                 attribute:NSLayoutAttributeBottom
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.contentView
                                 attribute:NSLayoutAttributeBottom
                                multiplier:1
                                  constant:0];
    
    // Set picture height to 200 points
    NSLayoutConstraint *pictureHeight =
    [NSLayoutConstraint constraintWithItem:self.picture
                                 attribute:NSLayoutAttributeHeight
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.contentView
                                 attribute:NSLayoutAttributeHeight
                                multiplier:0
                                  constant:200];
    
    [self.contentView addConstraints:@[pictureLeading, pictureTrailing, pictureTop, pictureBottom, pictureHeight]];
}

@end
