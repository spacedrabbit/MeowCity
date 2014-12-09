//
//  BRKVenue.h
//  BarkCity
//
//  Created by Mykel Pereira on 11/24/14.
//  Copyright (c) 2014 com.rosamcgee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

extern NSString * const BRKVenueImageDidUpdateNotification;

@interface BRKVenue : NSObject
@property (nonatomic) NSString *foursquareId;
@property (nonatomic) NSString *name;
@property (nonatomic) NSString *address;
@property (nonatomic) NSString *website;
@property (nonatomic) NSString *city;
@property (nonatomic) NSString *state;
@property (nonatomic) NSString *postalCode;
@property (nonatomic) NSNumber *distance;

@property (nonatomic) NSString *foursquareImagePrefix;
@property (nonatomic) NSString *foursquareImageSuffix;
@property (nonatomic) NSNumber *rating;
@property (nonatomic) NSNumber *price;
@property (nonatomic) NSString *hours;
@property (nonatomic) NSString *phone;
@property (nonatomic) NSString *formattedPhone;
@property (nonatomic) NSArray *tips;
@property (nonatomic) NSString *firstTip;

@property (nonatomic) UIImage *previewImage;

@property (nonatomic) NSNumber *latitude;
@property (nonatomic) NSNumber *longitude;

@property (nonatomic) NSString *formattedAddress;

- (void)downloadPreviewImageInBackground;

- (NSURL *)imageURLForOriginalSize;
- (NSURL *)imageURLForSize:(CGSize)size;
@end
