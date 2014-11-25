//
//  BRKFoursquareClient.h
//  BarkCity
//
//  Created by Mykel Pereira on 11/24/14.
//  Copyright (c) 2014 com.rosamcgee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface BRKFoursquareClient : NSObject
+ (instancetype)sharedClient;
- (void)requestVenuesForQuery:(NSString *)query location:(CLLocation *)location limit:(NSUInteger)limit success:(void (^)(NSArray *venues))success failure:(void (^)(NSError *error))failure;
@end
