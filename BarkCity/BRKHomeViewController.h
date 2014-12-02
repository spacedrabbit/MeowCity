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

@interface BRKHomeViewController : UIViewController

@property (strong, nonatomic) BRKLocationManager *locationManager;
@property (nonatomic) BRKFoursquareClient *foursquareClient;
@property (nonatomic) NSInteger numberOfLocationsToShow;
@property (nonatomic) NSArray *venues;

@end
