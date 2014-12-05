//
//  BRKVenuesViewController.m
//  BarkCity
//
//  Created by Mykel Pereira on 12/5/14.
//  Copyright (c) 2014 com.rosamcgee. All rights reserved.
//

#import "BRKVenuesViewController.h"
#import "BRKFoursquareClient.h"
#import "BRKVenue.h"
#import "BRKPictureTableViewCell.h"
#import "BRKVenuesTableViewCell.h"
#import "BRKVenueDetailTableViewController.h"
#import "BRKTableView.h"

@interface BRKVenuesViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic) BRKTableView *tableView;
@property (nonatomic) UIView *backgroundView;
@property (nonatomic) NSInteger numberOfLocationsToShow;
@property (nonatomic) BRKFoursquareClient *foursquareClient;
@property (nonatomic) NSArray *venues;

@property (strong, nonatomic) NSString * query;
@end

@implementation BRKVenuesViewController

- (instancetype) initWithQuery:(NSString *) query
{
    self = [super init];
    if (self) {
        _query = query;
        _tableView = [[BRKTableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        _tableView.separatorColor = [UIColor clearColor];
        // Retrieve Nib of the two custom cell types.
        UINib *pictureCellNib = [UINib nibWithNibName:@"BRKPictureTableViewCell" bundle:nil];
        [_tableView registerNib:pictureCellNib forCellReuseIdentifier:@"PictureCell"];
        
        UINib *dynamicCelllNib = [UINib nibWithNibName:@"BRKVenuesTableViewCell" bundle:nil];
        [_tableView registerNib:dynamicCelllNib forCellReuseIdentifier:@"VenueCell"];
        
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 200.0;
        
        _foursquareClient = [BRKFoursquareClient sharedClient];
        
        _numberOfLocationsToShow = 5;
    }
    return self;
}

- (instancetype)initWithQuery:(NSString *)query andBackgroundView:(UIView *)view
{
    self = [super init];
    if (self) {
        _query = query;
        
        _tableView = [[BRKTableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        
        _backgroundView = view;
        
        _tableView.separatorColor = [UIColor clearColor];
        // Retrieve Nib of the two custom cell types.
        UINib *dynamicCelllNib = [UINib nibWithNibName:@"BRKVenuesTableViewCell" bundle:nil];
        [_tableView registerNib:dynamicCelllNib forCellReuseIdentifier:@"VenueCell"];
        
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 200.0;
        
        _foursquareClient = [BRKFoursquareClient sharedClient];
        
        _numberOfLocationsToShow = 5;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (self.backgroundView) {
        [self.view addSubview:self.backgroundView];
    }
    [self.view addSubview:self.tableView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleLocationChange:)
                                                 name:@"locationChanged"
                                               object:nil];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    if (self.backgroundView) {
        self.backgroundView.frame = (CGRect){
            .origin.x = 0.0f,
            .origin.y = 0,
            .size.width = self.view.frame.size.width,
            .size.height = self.view.frame.size.height / 3
        };
    }
    
    self.tableView.frame = (CGRect){
        .origin.x = 0.0f,
        .origin.y = 0,
        .size.width = self.view.frame.size.width,
        .size.height = self.view.frame.size.height
    };
    
    self.tableView.contentInset = UIEdgeInsetsMake(self.backgroundView ? self.backgroundView.frame.size.height : 0, 0, 0, 0);
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(self.backgroundView ? self.backgroundView.frame.size.height : 0, 0, 0, 0);
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
    return self.venues.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
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

#pragma mark - Navigation

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSLog(@"The table selected: %li", tableView.tag);
    NSLog(@"Selected Section:%li inRow:%li ", indexPath.section, indexPath.row);
    
    [self.venueDetailSegueDelegate segueToDetailTableViewWithVenue:self.venues[indexPath.row]];
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

- (void)handleLocationChange:(NSNotification *)notification
{
    
    NSDictionary *userInfo = notification.userInfo;
    CLLocation *newLocation = userInfo[@"newLocation"];
    if (!self.location) {
        self.location = newLocation;
    }
    [self fetchVenuesForLocation];
}

@end
