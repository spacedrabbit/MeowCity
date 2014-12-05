//
//  BRKVenuesViewController.h
//  BarkCity
//
//  Created by Mykel Pereira on 12/5/14.
//  Copyright (c) 2014 com.rosamcgee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "BRKVenueDetailTableViewController.h"
#import "BRKLocationManager.h"
#import "BRKTableView.h"

@interface BRKVenuesViewController : UIViewController
@property (nonatomic, weak) id <BRKDetailTableViewSegueDelegate> venueDetailSegueDelegate;
@property (strong, nonatomic) CLLocation * location;

- (instancetype) initWithQuery:(NSString *) query;
- (instancetype) initWithQuery:(NSString *) query andBackgroundView:(UIView *)view;
@end
