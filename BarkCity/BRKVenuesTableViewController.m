//
//  BRKHomeTableViewController.m
//  BarkCity
//
//  Created by Richard McAteer on 11/24/14.
//  Copyright (c) 2014 com.rosamcgee. All rights reserved.


#import "BRKVenuesTableViewController.h"
#import "BRKFoursquareClient.h"
#import "BRKVenue.h"
#import "BRKPictureTableViewCell.h"
#import "BRKVenuesTableViewCell.h"
#import "BRKVenueDetailTableViewController.h"
#import "BRKTableView.h"

@interface BRKVenuesTableViewController ()

@property (nonatomic) NSInteger numberOfLocationsToShow;
@property (nonatomic) BRKFoursquareClient *foursquareClient;
@property (nonatomic) NSArray *venues;

@property (strong, nonatomic) NSString * query;
@end

@implementation BRKVenuesTableViewController

- (instancetype)initWithQuery:(NSString *)query
{
    self = [super init];
    if (self) {
        _query = query;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView = [[BRKTableView alloc] init];
    self.tableView.separatorColor = [UIColor clearColor];
    // Retrieve Nib of the two custom cell types.
    UINib *pictureCellNib = [UINib nibWithNibName:@"BRKPictureTableViewCell" bundle:nil];
    [self.tableView registerNib:pictureCellNib forCellReuseIdentifier:@"PictureCell"];
    
    UINib *dynamicCelllNib = [UINib nibWithNibName:@"BRKVenuesTableViewCell" bundle:nil];
    [self.tableView registerNib:dynamicCelllNib forCellReuseIdentifier:@"VenueCell"];
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 200.0;
    
    self.foursquareClient = [BRKFoursquareClient sharedClient];
    
    self.numberOfLocationsToShow = 5;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setLocation:(CLLocation *)location
{
    if (location.coordinate.latitude != _location.coordinate.latitude || location.coordinate.longitude != _location.coordinate.longitude) {
        _location = location;
        [self fetchVenuesForLocation];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.venues.count + 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == 0) {
        BRKPictureTableViewCell *cell = (BRKPictureTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"PictureCell"];
        return cell;
    }
    
    BRKVenuesTableViewCell *cell = (BRKVenuesTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"VenueCell" forIndexPath:indexPath];
    
    BRKVenue *venue = self.venues[indexPath.row - 1];
    cell.venue = venue;
    
    // conditional to test the dynamic length of the cells
    
    if (indexPath.row %2 == 0) {
        cell.descriptiveBody.text = @"This restaurant is great for dogs";
    } else {
        cell.descriptiveBody.text = @"This is a very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very long version of the cell";
    }
    
    return cell;
}

#pragma mark - Navigation

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSLog(@"The table selected: %li", tableView.tag);
    NSLog(@"Selected Section:%li inRow:%li ", indexPath.section, indexPath.row);
    if (indexPath.row != 0) {
        [self.venueDetailSegueDelegate segueToDetailTableViewWithVenue:self.venues[indexPath.row - 1]];
    }
}

- (void)fetchVenuesForLocation
{
    if (!self.query) {
        self.query = @"Dog Friendly";
    }
    
    [self.foursquareClient requestVenuesForQuery:self.query location:self.location limit:self.numberOfLocationsToShow success:^(NSArray *venues) {
        self.venues = venues;
        for (BRKVenue *venue in venues) {
            [venue downloadPreviewImageInBackground];
        }
        
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        NSLog(@"%@", error);
    }];
}

@end
