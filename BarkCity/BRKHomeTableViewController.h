//
//  BRKHomeTableViewController.h
//  BarkCity
//
//  Created by Richard McAteer on 11/24/14.
//  Copyright (c) 2014 com.rosamcgee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "BRKLocationManager.h"

@interface BRKHomeTableViewController : UITableViewController

@property (strong, nonatomic) BRKLocationManager *locationManager;

@end
