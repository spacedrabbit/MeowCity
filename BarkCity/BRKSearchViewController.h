//
//  BRKSearchViewController.h
//  BarkCity
//
//  Created by Richard McAteer on 11/24/14.
//  Copyright (c) 2014 com.rosamcgee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "BRKLocationManager.h"
#import "BRKFoursquareClient.h"
#import "BRKVenue.h"
#import "BRKVenuesTableViewCell.h"

@interface BRKSearchViewController : UIViewController

@property (strong, nonatomic) BRKLocationManager *locationManager;
@property (nonatomic) NSInteger numberOfLocationsToShow;
@property (nonatomic) BRKFoursquareClient *foursquareClient;
@property (nonatomic) NSArray *venues;


@end
