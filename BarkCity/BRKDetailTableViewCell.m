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

@synthesize delegate;

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
    self.phone.titleLabel.font = [BRKUIManager detailPhoneFont];
    //
    [self.phone setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.website.titleLabel.font = [BRKUIManager detailWebsiteFont];
    //
    [self.website setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.hours.font = [BRKUIManager detailOtherFont];
}

- (IBAction)phoneButtonTapped:(id)sender {
    
    [self.delegate call:self phone:self.phone.titleLabel.text];
    
}

- (IBAction)websiteButtonTapped:(id)sender {
    NSURL *url = [NSURL URLWithString:self.website.titleLabel.text];
    [[UIApplication  sharedApplication] openURL:url];
}

- (void) setVenue:(BRKVenue *) venue{
    
    [self.contentView removeConstraints:self.contentView.constraints];
    
    // Name
    if (venue.name) {
        self.name.text = venue.name;
        //[self.name sizeToFit];
    } else {
        [self shrinkHorizontally:self.name];
    }
    
    // Rating
    if (venue.rating) {
        self.rating.text = [NSString stringWithFormat:@"%.1f", [venue.rating floatValue]];
        //[self.rating sizeToFit];
    } else {
        [self shrinkHorizontally:self.rating];
    }
    
    // Price
    if (venue.price) {
        self.price.text = [NSString stringWithFormat:@"%@", venue.price];
        //[self.price sizeToFit];
    } else {
        [self shrinkHorizontally:self.price];
    }
    
    // Distance
    if (venue.distance) {
        self.distance.text = [NSString stringWithFormat:@"%@", venue.distance];
        //[self.distance sizeToFit];
    } else {
        [self shrinkHorizontally:self.distance];
    }
    
    // Address
    if (venue.formattedAddress) {
        self.address.text = venue.formattedAddress;
        [self fitText:self.address andIcon:self.addressIcon];
    } else {
        [self shrinkText:self.address andIcon:self.addressIcon];
    }
    
    // Phone number
    if (venue.formattedPhone) {
        [self.phone setTitle:venue.formattedPhone forState:UIControlStateNormal];
        [self fitText:self.phone andIcon:self.phoneIcon];
        
    } else {
        [self shrinkText:self.phone andIcon:self.phoneIcon];
    }
    
    // Website
    if (venue.website) {
        [self.website setTitle:venue.website forState:UIControlStateNormal];
        [self fitText:self.website andIcon:self.websiteIcon];
    } else {
        [self shrinkText:self.website andIcon:self.websiteIcon];
    }
    
    // Hours of operation
    if (venue.hours) {
        self.hours.text = venue.hours;
        [self fitText:self.hours andIcon:self.hoursIcon];
    } else {
        [self shrinkText:self.hours andIcon:self.hoursIcon];
    }
    
    [self completeAutoLayout];
}

- (void) completeAutoLayout {
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_name, _rating, _price, _distance, _address, _addressIcon, _phone, _phoneIcon, _website, _websiteIcon, _hours, _hoursIcon);
    
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
    
    [self.rating setContentHuggingPriority:1000 forAxis:UILayoutConstraintAxisHorizontal];
    [self.price setContentHuggingPriority:1000 forAxis:UILayoutConstraintAxisHorizontal];
    
    NSArray *addressRow = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_addressIcon]-[_address]-|"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:views];
    
    [self.contentView addConstraints:addressRow];
    
//    [self.address setContentCompressionResistancePriority:1000 forAxis:UILayoutConstraintAxisHorizontal];
//    [self.address setContentCompressionResistancePriority:1000 forAxis:UILayoutConstraintAxisVertical];
    
    NSArray *phoneRow = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_phoneIcon]-[_phone]-|"
                                                                  options:0
                                                                  metrics:nil
                                                                    views:views];
    
    [self.contentView addConstraints:phoneRow];
    
    [self.phone setContentCompressionResistancePriority:1000 forAxis:UILayoutConstraintAxisHorizontal];
    self.phone.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    NSArray *websiteRow = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_websiteIcon]-[_website]-|"
                                                                  options:0
                                                                  metrics:nil
                                                                    views:views];
    
    [self.contentView addConstraints:websiteRow];
    
    [self.website setContentCompressionResistancePriority:1000 forAxis:UILayoutConstraintAxisHorizontal];
    self.website.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    NSArray *hoursRow = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_hoursIcon]-[_hours]-|"
                                                                  options:0
                                                                  metrics:nil
                                                                    views:views];
    
    [self.contentView addConstraints:hoursRow];
    
}

- (void) fitText:(id)text andIcon:(UIImageView *)icon {
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
    NSLayoutConstraint *textInLine =
    [NSLayoutConstraint constraintWithItem:text
                                 attribute:NSLayoutAttributeCenterY
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:icon
                                 attribute:NSLayoutAttributeCenterY
                                multiplier:1
                                  constant:0];
    
    [self.contentView addConstraints:@[iconHeight, iconWidth, textInLine]];
}

- (void) shrinkHorizontally:(UILabel *)label {
    NSLayoutConstraint *labelZero =
    [NSLayoutConstraint constraintWithItem:label
                                 attribute:NSLayoutAttributeWidth
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.contentView
                                 attribute:NSLayoutAttributeWidth
                                multiplier:0
                                  constant:0];
    [self.contentView addConstraints:@[labelZero]];
}

- (void) shrinkText:(id)text andIcon:(UIImageView *)icon {
    NSLayoutConstraint *textZero =
    [NSLayoutConstraint constraintWithItem:text
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
    
    [self.contentView addConstraints:@[textZero, iconZero]];
}

@end
