//
//  BRKHomeTableViewController.m
//  BarkCity
//
//  Created by Richard McAteer on 11/24/14.
//  Copyright (c) 2014 com.rosamcgee. All rights reserved.
//

#import "BRKHomeTableViewController.h"
#import "BRKLocationTableViewCell.h"
#import "BRKFoursquareClient.h"
#import "BRKVenue.h"
#import "BRKVenueDetailViewController.h"

@interface BRKHomeTableViewController ()

@property (nonatomic) NSInteger numberOfLocationsToShow;
@property (nonatomic) BRKFoursquareClient *foursquareClient;
@property (nonatomic) NSArray *venues;
@end

@implementation BRKHomeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.separatorColor = [UIColor clearColor];
    [self.tableView registerNib:[UINib nibWithNibName:@"BRKLocationTableViewCell" bundle:nil] forCellReuseIdentifier:@"Location"];
    
    self.foursquareClient = [BRKFoursquareClient sharedClient];
    
    self.numberOfLocationsToShow = 5;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    if ([CLLocationManager locationServicesEnabled]) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        [self.locationManager startUpdatingLocation];//
        
        self.location = [[CLLocation alloc] init];
    } else {
        NSLog(@"Ish don't think so.");
    }
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
    return 2 + self.numberOfLocationsToShow;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
        cell.textLabel.text = @"Restaurants Bars Outdoor Events";
        // Scroll view ("Restaurants", "Bars", "Outdoor", "Events")
        return cell;
    }
    
    else if (indexPath.row == 1) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
        cell.textLabel.text = @"Image";
        // Image
        return cell;
    }
    
    else {
        BRKVenue *venue = self.venues[indexPath.row];
        BRKLocationTableViewCell *cell = (BRKLocationTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"Location" forIndexPath:indexPath];
        cell.nameLabel.text = venue.name;
        cell.ratingLabel.text = [venue.rating description];
        cell.distanceLabel.text = @"1.0 mi";
        cell.detailTextLabel.text = @"This restaurant is great for dogs";
        return cell;
    }
    
    return nil;
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
        
        NSIndexPath *path = [self.tableView indexPathForSelectedRow];
        BRKVenueDetailViewController *targetVC = (BRKVenueDetailViewController *)segue.destinationViewController;
        targetVC.venue = (BRKVenue *)self.venues[path.row];
    }
}

#pragma mark - CORE LOCATION GET LOCATION

- (void)viewWillAppear:(BOOL)animated {
    [self.locationManager requestWhenInUseAuthorization];
}


-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    
    UIAlertView *errorAlert = [[UIAlertView alloc]initWithTitle:@"Error"
                                                        message:@"There was an error retrieving your location"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
    
    [errorAlert show];
    
    NSLog(@"Error: %@",error.description);
    
}


- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    if (self.location != locations.lastObject) {
        [self fetchVenuesForLocation:locations.lastObject];
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
