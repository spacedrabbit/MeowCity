//
//  BRKVenue.h
//  BarkCity
//
//  Created by Mykel Pereira on 11/24/14.
//  Copyright (c) 2014 com.rosamcgee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface BRKVenue : NSObject
@property (nonatomic) NSString *foursquareId;
@property (nonatomic) NSString *name;
@property (nonatomic) NSString *address;
@property (nonatomic) NSString *city;
@property (nonatomic) NSString *state;
@property (nonatomic) NSString *postalCode;
@property (nonatomic) NSString *foursquareImagePrefix;
@property (nonatomic) NSString *foursquareImageSuffix;
@property (nonatomic) NSNumber *rating;
@property (nonatomic) NSNumber *price;
@property (nonatomic) NSString *hours;
@property (nonatomic) NSString *phone;
@property (nonatomic) NSArray *tips;

@property (nonatomic) UIImage *previewImage;

@property (nonatomic) NSNumber *latitude;
@property (nonatomic) NSNumber *longitude;

@property (nonatomic, readonly) NSString *formattedAddress;

- (void)downloadPreviewImageInBackground;
@end
