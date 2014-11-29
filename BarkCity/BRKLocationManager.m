//
//  BRKLocationManager.m
//  BarkCity
//
//  Created by Rosa McGee on 11/25/14.
//  Copyright (c) 2014 com.rosamcgee. All rights reserved.
//

#import "BRKLocationManager.h"
#import <UIKit/UIKit.h>
#import "BRKFoursquareClient.h"

@implementation BRKLocationManager

// singleton
+ (instancetype)sharedLocationManager
{
    static BRKLocationManager *_sharedLocationManager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedLocationManager = [[self alloc] init];
    });
    
    return _sharedLocationManager;
}


- (instancetype)init
{
    self = [super init];
    
    if (self) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        self.locationManager.delegate = self;
    }
    
    return self;
}

- (void)startUpdatingLocation
{
    NSLog(@"I'm starting to update the location, you guise. ");
    [self.locationManager startUpdatingLocation];
}

//- (void)requestInUseAuthorization
//{
//    [self.locationManager requestWhenInUseAuthorization];
//}

- (void)requestInUseAuthorization {
    [self.locationManager requestAlwaysAuthorization];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    if (self.location != locations.lastObject) {
        CLLocation *newLocation = locations.lastObject;
        NSDictionary *dataDict = [NSDictionary dictionaryWithObject:newLocation forKey:@"newLocation"];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"locationChanged"
                                                            object:self
                                                          userInfo:dataDict];
    }
    
    self.location = locations.lastObject;
    NSLog(@"latitude %+.6f, longitude %+.6f\n", self.location.coordinate.latitude, self.location.coordinate.longitude);
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *currentLocation = newLocation;
    
    if (currentLocation != nil) {
        NSLog(@"%@",[NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude]);
        NSLog(@"%@",[NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude]);
    }
}


- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    
    UIAlertView *errorAlert = [[UIAlertView alloc]initWithTitle:@"Error"
                                                        message:@"There was an error retrieving your location"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
    
    [errorAlert show];
    
    NSLog(@"Error: %@",error.localizedDescription);
}

@end
