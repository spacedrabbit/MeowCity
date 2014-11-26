//
//  BRKLocationManager.h
//  BarkCity
//
//  Created by Rosa McGee on 11/25/14.
//  Copyright (c) 2014 com.rosamcgee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface BRKLocationManager : NSObject <CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *location;

+ (instancetype)sharedLocationManager;
- (void)startUpdatingLocation;
- (void)requestInUseAuthorization;

@end
