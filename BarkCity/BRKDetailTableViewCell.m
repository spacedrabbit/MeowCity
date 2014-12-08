//
//  VenueDetailTableViewCell.m
//  BarkCity
//
//  Created by Charles Coutu-Nadeau on 12/4/14.
//  Copyright (c) 2014 com.rosamcgee. All rights reserved.
//

#import "BRKDetailTableViewCell.h"
#import "BRKVenue.h"
#import "BRKUIManager.h"

@interface BRKDetailTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *addressIcon;
@property (weak, nonatomic) IBOutlet UIImageView *phoneIcon;
@property (weak, nonatomic) IBOutlet UIImageView *websiteIcon;
@property (weak, nonatomic) IBOutlet UIImageView *hoursIcon;

@end

@implementation BRKDetailTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [self setLook];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setLook {
    self.name.font = [BRKUIManager detailNameFont];
    self.rating.font = [BRKUIManager detailRatingFont];
    self.price.font = [BRKUIManager detailPriceFont];
    self.distance.font = [BRKUIManager detailDistanceFont];
    self.address.font = [BRKUIManager detailOtherFont];
    self.phoneNumber.font = [BRKUIManager detailOtherFont];
    self.website.font = [BRKUIManager detailOtherFont];
    self.hours.font = [BRKUIManager detailOtherFont];
}

- (void) setAutoLayout {
    
}

- (void) setVenue:(BRKVenue *) venue{
    
    [self.contentView removeConstraints:self.contentView.constraints];
    
    // Name
    if (venue.name) {
        self.name.text = venue.name;
        [self.name sizeToFit];
    } else {
        self.name.text = @"No name to show";
    }
    
    // Rating
    if (venue.rating) {
        self.rating.text = [NSString stringWithFormat:@"%@", venue.rating];
        [self.rating sizeToFit];
    } else {
        self.rating.text = @"No rating to show";
    }
    
    // Price
    if (venue.price) {
        self.price.text = [NSString stringWithFormat:@"%@", venue.price];
        [self.price sizeToFit];
    } else {
        self.price.text = @"No price to show";
    }
    
    // Distance
    if (NO) {
        //self.distance.text = [NSString stringWithFormat:@"%@", venue.distance];
        //[self.distance sizeToFit];
    } else {
        self.distance.text = @"No distance to show";
    }
    
    // Address
    if (venue.address) {
        self.address.text = venue.address;
        [self fitIcon:self.addressIcon andLabel:self.address];
    } else {
        [self shrinkLabel:self.address andIcon:self.addressIcon];
    }
    
    // Phone number
    if (venue.phone) {
        self.phoneNumber.text = venue.phone;
        [self.phoneNumber sizeToFit];
        [self fitIcon:self.phoneIcon andLabel:self.phoneNumber];
        
    } else {
        [self shrinkLabel:self.phoneNumber andIcon:self.phoneIcon];
    }
    
    // Website
    if (YES) {
        self.website.text = @"www.testdata.com";
        [self.website sizeToFit];
        [self fitIcon:self.websiteIcon andLabel:self.website];
    } else {
        //[self shrinkLabel:self.website andIcon:self.websiteIcon];
    }
    
    // Hours of operation
    if (venue.hours) {
        self.hours.text = venue.hours;
        [self.hours sizeToFit];
        [self fitIcon:self.hoursIcon andLabel:self.hours];
    } else {
        [self shrinkLabel:self.hours andIcon:self.hoursIcon];
    }
    
    [self completeAutoLayout];
}

- (void) completeAutoLayout {
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_name, _rating, _price, _distance, _address, _addressIcon, _phoneNumber, _phoneIcon, _website, _websiteIcon, _hours, _hoursIcon);
    
    NSArray *iconColumn = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[_name]-[_rating]-[_addressIcon]-[_phoneIcon]-[_websiteIcon]-[_hoursIcon]-|"
                                                                          options:0
                                                                          metrics:nil
                                                                            views:views];
    
    [self.contentView addConstraints:iconColumn];
    
    NSArray *namePosition = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_name]|"
                                                                  options:0
                                                                  metrics:nil
                                                                    views:views];
    
    [self.contentView addConstraints:namePosition];
    
    // Align rating, price and distance
    
    NSLayoutConstraint *priceInLine =
    [NSLayoutConstraint constraintWithItem:self.price
                                 attribute:NSLayoutAttributeCenterY
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.rating
                                 attribute:NSLayoutAttributeCenterY
                                multiplier:1
                                  constant:0];

    NSLayoutConstraint *distancelInLine =
    [NSLayoutConstraint constraintWithItem:self.distance
                                 attribute:NSLayoutAttributeCenterY
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.rating
                                 attribute:NSLayoutAttributeCenterY
                                multiplier:1
                                  constant:0];

    [self.contentView addConstraints:@[priceInLine, distancelInLine]];
    
    NSArray *ratingRow = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_rating]-[_price]-[_distance]-|"
                                                                          options:0
                                                                          metrics:nil
                                                                            views:views];

    [self.contentView addConstraints:ratingRow];
    
    NSArray *addressRow = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_addressIcon]-[_address]-|"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:views];
    
    [self.contentView addConstraints:addressRow];
    
    NSArray *phoneRow = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_phoneIcon]-[_phoneNumber]-|"
                                                                  options:0
                                                                  metrics:nil
                                                                    views:views];
    
    [self.contentView addConstraints:phoneRow];
    
    NSArray *websiteRow = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_websiteIcon]-[_website]-|"
                                                                  options:0
                                                                  metrics:nil
                                                                    views:views];
    
    [self.contentView addConstraints:websiteRow];
    
    NSArray *hoursRow = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_hoursIcon]-[_hours]-|"
                                                                  options:0
                                                                  metrics:nil
                                                                    views:views];
    
    [self.contentView addConstraints:hoursRow];
    
}

- (void) fitIcon:(UIImageView *)icon andLabel:(UILabel *)label {
    NSLayoutConstraint *iconHeight =
    [NSLayoutConstraint constraintWithItem:icon
                                 attribute:NSLayoutAttributeHeight
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.contentView
                                 attribute:NSLayoutAttributeWidth
                                multiplier:0
                                  constant:30];
    
    NSLayoutConstraint *iconWidth =
    [NSLayoutConstraint constraintWithItem:icon
                                 attribute:NSLayoutAttributeWidth
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.contentView
                                 attribute:NSLayoutAttributeWidth
                                multiplier:0
                                  constant:30];
    NSLayoutConstraint *labelInLine =
    [NSLayoutConstraint constraintWithItem:label
                                 attribute:NSLayoutAttributeCenterY
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:icon
                                 attribute:NSLayoutAttributeCenterY
                                multiplier:1
                                  constant:0];
    
    [self.contentView addConstraints:@[iconHeight, iconWidth, labelInLine]];
}

- (void) shrinkLabel:(UILabel *)label andIcon:(UIImageView *)icon {
    NSLayoutConstraint *labelZero =
    [NSLayoutConstraint constraintWithItem:label
                                 attribute:NSLayoutAttributeHeight
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.contentView
                                 attribute:NSLayoutAttributeHeight
                                multiplier:0
                                  constant:0];
    
    NSLayoutConstraint *iconZero =
    [NSLayoutConstraint constraintWithItem:icon
                                 attribute:NSLayoutAttributeHeight
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.contentView
                                 attribute:NSLayoutAttributeHeight
                                multiplier:0
                                  constant:0];
    
    [self.contentView addConstraints:@[labelZero, iconZero]];
}

@end
