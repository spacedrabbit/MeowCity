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

@property (nonatomic) CGSize backgroundImageSize;

@property (strong, nonatomic) NSString * query;
@end

@implementation BRKVenuesViewController
{
    UIActivityIndicatorView *_activityIndicatorView;
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
        
        // loading network data activity
        _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _activityIndicatorView.frame = CGRectMake(0.0f, 0.0f, 40.0f, 40.0f);
        _activityIndicatorView.center = self.view.center;
        [_activityIndicatorView startAnimating];
        [self.view addSubview:_activityIndicatorView];
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
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    if (self.backgroundView) {
        self.backgroundView.frame = (CGRect){
            .origin.x = 0.0f,
            .origin.y = 0,
            .size.width = self.view.frame.size.width,
            .size.height = (self.view.frame.size.height / 3)
        };
        self.backgroundImageSize = CGSizeMake(self.view.frame.size.width, (self.view.frame.size.height / 3));
    }
    
    self.tableView.frame = (CGRect){
        .origin.x = 0.0f,
        .origin.y = 0,
        .size.width = self.view.frame.size.width,
        .size.height = self.view.frame.size.height
    };
    
    // checking for background image to adjust insets
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
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
        [_activityIndicatorView stopAnimating];
        [_activityIndicatorView removeFromSuperview];
    } failure:^(NSError *error) {
        NSLog(@"%@", error);
    }];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
//    if ( scrollView.contentInset.top > self.backgroundImageSize.height){
//        NSLog(@"The Content Offset: %f    The ContentInset: %f ", scrollView.contentInset.top, self.backgroundImageSize.height);
//        CGFloat delta = scrollView.contentInset.top - self.backgroundImageSize.height;
//        CGFloat percentageOfImage = (fabs(scrollView.contentOffset.y)/scrollView.contentInset.top);
//        [self applyTransformToBackGroundImageForDeltaSize:percentageOfImage];
//        
//    }//else if (scrollView.contentOffset){
      //  self.backgroundView.transform  = CGAffineTransformInvert(self.backgroundView.transform);
    //}
    
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    NSLog(@"Did end Drag");
}
-(void)applyTransformToBackGroundImageForDeltaSize:(CGFloat)delta{
    NSLog(@"The delta: %f", delta);
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            self.backgroundView.transform = CGAffineTransformScale(self.backgroundView.transform, 1.0, delta);
    }];
    
}

@end
