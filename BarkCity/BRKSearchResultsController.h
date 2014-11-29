//
//  BRKSearchResultsController.h
//  BarkCity
//
//  Created by Louis Tur on 11/25/14.
//  Copyright (c) 2014 com.rosamcgee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "BRKLocationManager.h"
#import "BRKFoursquareClient.h"
#import "BRKVenue.h"
#import "BRKVenuesTableViewCell.h"

@interface BRKSearchResultsController : UIViewController

@property (strong, nonatomic) BRKLocationManager *locationManager;
@property (nonatomic) NSInteger numberOfLocationsToShow;
@property (nonatomic) BRKFoursquareClient *foursquareClient;
@property (nonatomic) NSArray *venues;

@end
