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
#import "BRKLocationTableViewCell.h"

@interface BRKVenuesResultsTable () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView * venueResultsTable;
@property (strong, nonatomic) NSArray * venues;

@end

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
- (void)fetchVenuesForLocation:(CLLocation *)location withQuery:(NSString *)query{
    
    [[BRKFoursquareClient sharedClient] requestVenuesForQuery:query location:location limit:15 success:^(NSArray *venues) {
        self.venues = venues;
        [self.venueResultsTable reloadData];
    } failure:^(NSError *error) {
        NSLog(@"%@", error);
    }];
    
}
- (void)fetchVenuesForLocation:(CLLocation *)location
{
    [self fetchVenuesForLocation:location withQuery:@"Dog Friendly Restaurants"];
}


/**********************************************************************************
 *
 *              UITableView Delegate Methods
 *
 ***********************************************************************************/
#pragma mark - Table View Delegate -
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    BRKVenue *venue = self.venues[indexPath.row];
    BRKLocationTableViewCell * cell;
    
    if (!cell) {
        cell = (BRKLocationTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"Location" forIndexPath:indexPath];
    }
    
    cell.nameLabel.text = venue.name;
    cell.ratingLabel.text = [venue.rating description];
    cell.distanceLabel.text = @"1.0 mi";
    cell.detailTextLabel.text = @"This restaurant is great for dogs";
    
    return cell;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.venues count];
}

@end
