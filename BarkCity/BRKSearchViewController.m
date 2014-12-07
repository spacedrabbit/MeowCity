//
// BRKSearchViewController.m
// BarkCity
//
// Created by Richard McAteer on 11/24/14.
// Copyright (c) 2014 com.rosamcgee. All rights reserved.
//
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "BRKSearchViewController.h"
#import "BRKSearchBarContainer.h"
#import "BRKLocationManager.h"
#import "BRKVenuesTableViewController.h"
#import "BRKVenuesViewController.h"
#import "BRKUIManager.h"
#import "BRKTableView.h"

@interface BRKSearchViewController () <UITextFieldDelegate, MKMapViewDelegate, BRKDetailTableViewSegueDelegate, BRKSearchBarContainerDelegate>

@property (strong, nonatomic) BRKLocationManager *locationManager;
@property (strong, nonatomic) UITextField * searchTextField;
@property (strong, nonatomic) UIButton *locationButton;
@property (strong, nonatomic) BRKSearchBarContainer *searchBarContainer;
@property (strong, nonatomic) BRKVenuesViewController *venuesViewController;
@property (strong, nonatomic) UIView *venuesView;
@property (strong, nonatomic) MKMapView * currentLocationView;
@property (strong, nonatomic) CLLocation * currentLocation;
@property (nonatomic) CGRect screenRect;

@end

@implementation BRKSearchViewController
#pragma mark - UIViewController Standard Methods -
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.locationManager = [BRKLocationManager sharedLocationManager];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.screenRect = [UIScreen mainScreen].bounds;
    // -- modal blur view -- //
    UIVisualEffectView * searchViewBlur = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    [searchViewBlur setFrame : [UIScreen mainScreen].bounds];
    [self.view addSubview : searchViewBlur ];
    [self setUpInitialViewsForSearchView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dismiss
{
    [self.searchBarContainer resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - AutoLayout -
-(void) setUpInitialViewsForSearchView
{
    // ------------------------- //
    // -- Search Container -- //
    // ------------------------- //
    NSArray *subviewArray = [[NSBundle mainBundle] loadNibNamed:@"BRKSearchBarContainer" owner:self options:nil];
    self.searchBarContainer = [subviewArray objectAtIndex:0];
    self.searchBarContainer.delegate = self;
    [self.searchBarContainer.layer setCornerRadius:4.0];
    [self.searchBarContainer setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:self.searchBarContainer];
    NSArray * searchBarContainerHorizontal = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_searchBarContainer]|"
                                                                                     options:0
                                                                                     metrics:nil
                                                                                       views:NSDictionaryOfVariableBindings(_searchBarContainer)
                                              ];
    NSArray * searchBarContainerVertical = [NSLayoutConstraint constraintsWithVisualFormat:
                                            @"V:|-64.0-[_searchBarContainer(==100)]-(>=0)-|"
                                                                                   options:0
                                                                                   metrics:nil
                                                                                     views:NSDictionaryOfVariableBindings(_searchBarContainer)
                                            ];
    [self.view addConstraints:searchBarContainerHorizontal];
    [self.view addConstraints:searchBarContainerVertical];

}

- (void)setUpResultsViewForSearchViewWithQuery:(NSString *)query
{
    [self setUpMap];
    self.venuesViewController = [[BRKVenuesViewController alloc] initWithQuery:query andBackgroundView:self.currentLocationView];
    self.venuesViewController.venueDetailSegueDelegate = self;
    self.venuesViewController.location = self.locationManager.location;
    self.venuesView = self.venuesViewController.view;
    self.venuesView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.venuesView];
    NSLayoutConstraint *venueTableLeft = [NSLayoutConstraint constraintWithItem:_venuesView
                                                                      attribute:NSLayoutAttributeLeft
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self.view
                                                                      attribute:NSLayoutAttributeLeft
                                                                     multiplier:1.0
                                                                       constant:0];
    NSLayoutConstraint *venueTableRight = [NSLayoutConstraint constraintWithItem:_venuesView
                                                                       attribute:NSLayoutAttributeRight
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:self.view
                                                                       attribute:NSLayoutAttributeRight
                                                                      multiplier:1.0
                                                                        constant:0];
    NSLayoutConstraint *venueTableTop = [NSLayoutConstraint constraintWithItem:_venuesView
                                                                     attribute:NSLayoutAttributeTop
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.searchBarContainer
                                                                     attribute:NSLayoutAttributeBottom
                                                                    multiplier:1.0
                                                                      constant:0];
    NSLayoutConstraint *venueTableBottom = [NSLayoutConstraint constraintWithItem:_venuesView
                                                                        attribute:NSLayoutAttributeBottom
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self.view
                                                                        attribute:NSLayoutAttributeBottom
                                                                       multiplier:1.0
                                                                         constant:0];
    [self.view addConstraints:@[venueTableLeft, venueTableRight, venueTableTop, venueTableBottom]];
}

- (void)setUpMap
{
    self.currentLocationView = [[MKMapView alloc] init];
    CLLocation * currentLocation = [[BRKLocationManager sharedLocationManager] location];
    CLLocationCoordinate2D zoomLocation = currentLocation.coordinate;
    MKCoordinateRegion region = MKCoordinateRegionMake(zoomLocation , MKCoordinateSpanMake(0.003, 0.003));
    [self.currentLocationView setRegion:region animated:YES];
    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    point.coordinate = zoomLocation;
    NSLog(@"The lat: %f, the long: %f", currentLocation.coordinate.latitude, currentLocation.coordinate.longitude);
    [self.currentLocationView addAnnotation:point];
}

#pragma mark - DetailSegueDelegate
- (void)segueToDetailTableViewWithVenue:(BRKVenue *)venue
{
    BRKVenueDetailTableViewController * selectedVenue = [[BRKVenueDetailTableViewController alloc] init];
    selectedVenue.venue = venue;
    [self.navigationController pushViewController:selectedVenue animated:YES];
}
#pragma mark - BRKSearchBarDelegate
- (void)searchFieldBeganNewSearch
{
    [self.venuesView removeFromSuperview];
    self.venuesView = nil;
}
- (void)searchFieldDidReturnWithText:(NSString *)searchText
{
    [self setUpResultsViewForSearchViewWithQuery:searchText];
}

- (void)searchByLocation:(UIButton *)sender {
    [self.venuesView removeFromSuperview];
    self.venuesView = nil;
    [self.searchBarContainer resignFirstResponder];
    [self setUpResultsViewForSearchViewWithQuery:self.searchTextField.text];
}

@end