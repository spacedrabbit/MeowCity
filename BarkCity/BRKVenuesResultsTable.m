//
//  BRKVenuesResultsTable.m
//  BarkCity
//
//  Created by Louis Tur on 11/25/14.
//  Copyright (c) 2014 com.rosamcgee. All rights reserved.
//

/*************************************************************
 *
 *          Instatiates table to display search
 *           results. Prepares it for display in a UIView
 *
 *************************************************************/

#import "BRKVenue.h"
#import "BRKFoursquareClient.h"
#import "BRKVenuesResultsTable.h"
#import "BRKVenuesTableViewCell.h"

@interface BRKVenuesResultsTable () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSArray * venues;
@property (strong, nonatomic) UINib * cellNib;

@implementation BRKVenuesResultsTable

/**********************************************************************************
 *
 *              Init
 *
 ***********************************************************************************/
#pragma mark - View Init -
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        
        _venueResultsTable = [[UITableView alloc] init];
        [_venueResultsTable setDelegate:self];
        [_venueResultsTable setDataSource:self];
        
        [_venueResultsTable registerNib:[UINib nibWithNibName:@"BRKLocationTableViewCell" bundle:nil] forCellReuseIdentifier:@"Location"];

        [self addSubview:_venueResultsTable];
    }
    return self;
}

- (void)updateTableViewFrame
{
    _venueResultsTable.frame = self.bounds;
}
/**********************************************************************************
 *
 *              API Calls
 *
 ***********************************************************************************/
#pragma mark - API Calls -

- (void)fetchVenuesForLocation:(CLLocation *)location
{
    [[BRKFoursquareClient sharedClient] requestVenuesForQuery:@"Dog Friendly Restaurants" location:location limit:15 success:^(NSArray *venues) {
        self.venues = venues;
        [self.venueResultsTable reloadData];
    } failure:^(NSError *error) {
        NSLog(@"%@", error);
    }];
}

/**********************************************************************************
 *
 *              UITableView Delegate Methods
 *
 ***********************************************************************************/
#pragma mark - Table View Delegate -
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    BRKVenue *venue = self.venues[indexPath.row];
    BRKVenuesTableViewCell * cell;
    
    if (!cell) {
        cell = (BRKVenuesTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"Location" forIndexPath:indexPath];
    }
    
    cell.name.text = venue.name;
    cell.rating.text = [venue.rating description];
    cell.distance.text = @"1.0 mi";
    cell.descriptiveBody.text = @"This restaurant is great for dogs";
    
    return cell;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.venues count];
}

@end
