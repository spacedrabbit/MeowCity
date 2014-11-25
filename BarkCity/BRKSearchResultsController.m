//
//  BRKSearchResultsController.m
//  BarkCity
//
//  Created by Louis Tur on 11/25/14.
//  Copyright (c) 2014 com.rosamcgee. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import "BRKSearchResultsController.h"
#import "BRKVenuesResultsTable.h"
#import "BRKScrollView.h"

@interface BRKSearchResultsController () <UIScrollViewDelegate>

@property (strong, nonatomic) UIView * resultsView;
@property (strong, nonatomic) BRKScrollView * topScrollNav;
@property (strong, nonatomic) BRKScrollView * venueTablesScrollNav;

@property (strong, nonatomic) NSArray * venuesSearchTables;
@property (strong, nonatomic) CLLocationManager * locationManager;
@property (strong, nonatomic) CLLocation * location;

@end

@implementation BRKSearchResultsController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.resultsView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self setView:self.resultsView];
    [self.resultsView setBackgroundColor:[UIColor greenColor]];
    
    self.venuesSearchTables = @[ [[UITableView alloc] initWithFrame:CGRectMake(0, 82.0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height ) style:UITableViewStylePlain], [[UITableView alloc] initWithFrame:CGRectMake(0, 82.0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height ) style:UITableViewStylePlain], [[UITableView alloc] initWithFrame:CGRectMake(0, 82.0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height ) style:UITableViewStylePlain] ];
    
    for (BRKVenuesResultsTable * venueTable in self.venuesSearchTables) {
        [venueTable setBackgroundColor:[UIColor blueColor]];
    }
    
    UILabel * restaurantsLabel = [[UILabel alloc] init];
    restaurantsLabel.text = @"Restaurants";
    [restaurantsLabel setAdjustsFontSizeToFitWidth:YES];
    [restaurantsLabel setBackgroundColor:[UIColor redColor]];
    [restaurantsLabel setTextAlignment:NSTextAlignmentCenter];
    
    UILabel * parksLabel = [[UILabel alloc] init];
    parksLabel.text = @"Parks";
    [parksLabel setAdjustsFontSizeToFitWidth:YES];
    [parksLabel setBackgroundColor:[UIColor blueColor]];
    [parksLabel setTextAlignment:NSTextAlignmentCenter];
    
    UILabel * barsLabel = [[UILabel alloc] init];
    barsLabel.text = @"Bars";
    [barsLabel setAdjustsFontSizeToFitWidth:YES];
    [barsLabel setBackgroundColor:[UIColor orangeColor]];
    [barsLabel setTextAlignment:NSTextAlignmentCenter];
    
    self.topScrollNav = [BRKScrollView createScrollViewFromFrame:CGRectMake(0.0, 22.0, [UIScreen mainScreen].bounds.size.width, 60.0) withSubViews:@[restaurantsLabel, parksLabel, barsLabel]];
    [self.view addSubview:self.topScrollNav];
    
    self.venueTablesScrollNav = [BRKScrollView createScrollViewFromFrame:CGRectMake(0.0, 82.0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-82.0) withSubViews:self.venuesSearchTables];
    [self.view addSubview:self.venueTablesScrollNav];
    
    self.venueTablesScrollNav.delegate = self;
    self.topScrollNav.delegate = self;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - CORE LOCATION GET LOCATION

- (void)viewWillAppear:(BOOL)animated {
    [self.locationManager requestWhenInUseAuthorization];
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView == self.topScrollNav) {
        self.venueTablesScrollNav.contentOffset = scrollView.contentOffset;
    } else {
        self.topScrollNav.contentOffset = scrollView.contentOffset;
    }
    
}

@end
