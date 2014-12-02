//
//  BRKHomeTableViewController.h
//  BarkCity
//
//  Created by Richard McAteer on 11/24/14.
//  Copyright (c) 2014 com.rosamcgee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "BRKVenueDetailTableViewController.h"
#import "BRKLocationManager.h"

@interface BRKVenuesTableViewController : UITableViewController

@property (nonatomic, weak) id <BRKDetailTableViewSegueDelegate> venueDetailSegueDelegate;
@property (strong, nonatomic) CLLocation * location;

- (instancetype) initWithQuery:(NSString *) query;

@end
