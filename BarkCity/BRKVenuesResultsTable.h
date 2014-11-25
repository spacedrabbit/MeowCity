//
//  BRKVenuesResultsTable.h
//  BarkCity
//
//  Created by Louis Tur on 11/25/14.
//  Copyright (c) 2014 com.rosamcgee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BRKVenuesResultsTable : UIView

- (void)updateTableViewFrame;
- (void)fetchVenuesForLocation:(CLLocation *)location;
- (void)fetchVenuesForLocation:(CLLocation *)location withQuery:(NSString *)query;

@end
