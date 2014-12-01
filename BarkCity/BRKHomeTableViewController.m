//
//  BRKHomeTableViewController.m
//  BarkCity
//
//  Created by Richard McAteer on 11/24/14.
//  Copyright (c) 2014 com.rosamcgee. All rights reserved.


#import "BRKHomeTableViewController.h"
#import "BRKFoursquareClient.h"
#import "BRKVenue.h"
#import "BRKPictureTableViewCell.h"
#import "BRKVenuesTableViewCell.h"

@interface BRKHomeTableViewController ()

@property (nonatomic) NSInteger numberOfLocationsToShow;
@property (nonatomic) BRKFoursquareClient *foursquareClient;
@property (nonatomic) NSArray *venues;
@end

@implementation BRKHomeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //self.tableView.separatorColor = [UIColor clearColor];
    
    // Retrieve Nib of the two custom cell types.
    UINib *pictureCellNib = [UINib nibWithNibName:@"BRKPictureTableViewCell" bundle:nil];
    [self.tableView registerNib:pictureCellNib forCellReuseIdentifier:@"PictureCell"];
    
    UINib *dynamicCelllNib = [UINib nibWithNibName:@"BRKVenuesTableViewCell" bundle:nil];
    [self.tableView registerNib:dynamicCelllNib forCellReuseIdentifier:@"VenueCell"];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 200.0;
    
    
    
    self.foursquareClient = [BRKFoursquareClient sharedClient];
    
    self.numberOfLocationsToShow = 5;
    
    self.locationManager = [BRKLocationManager sharedLocationManager];
    
    [self.locationManager startUpdatingLocation];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleLocationChange:)
                                                 name:@"locationChanged"
                                               object:nil];
}

- (void)handleLocationChange:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    CLLocation *newLocation = userInfo[@"newLocation"];
    [self fetchVenuesForLocation:newLocation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.numberOfLocationsToShow + 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        BRKPictureTableViewCell *cell = (BRKPictureTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"PictureCell"];
        return cell;
    }
    
    BRKVenuesTableViewCell *cell = (BRKVenuesTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"VenueCell" forIndexPath:indexPath];
    
    BRKVenue *venue = self.venues[indexPath.row];
    cell.venue = venue;
    
    // conditional to test the dynamic length of the cells
    
    if (indexPath.row %2 == 0) {
        cell.descriptiveBody.text = @"This restaurant is great for dogs";
    } else {
        cell.descriptiveBody.text = @"This is a very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very long version of the cell";
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row > 1) {
        [self performSegueWithIdentifier:@"homeToVenueDetailSegue" sender:self];
    }
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"homeToSearchSegue"]) {
        NSLog(@"Search");
    }
    
    else if ([segue.identifier isEqualToString:@"homeToVenueDetailSegue"]) {
        
//        NSIndexPath *path = [self.tableView indexPathForSelectedRow];
//        BRKVenueDetailViewController *targetVC = (BRKVenueDetailViewController *)segue.destinationViewController;
//        targetVC.venue = (BRKVenue *)self.venues[path.row];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.locationManager requestInUseAuthorization];
}


- (void)fetchVenuesForLocation:(CLLocation *)location
{
    [self.foursquareClient requestVenuesForQuery:@"Dog Friendly Restaurants" location:location limit:15 success:^(NSArray *venues) {
        self.venues = venues;
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        NSLog(@"%@", error);
    }];
}

@end
