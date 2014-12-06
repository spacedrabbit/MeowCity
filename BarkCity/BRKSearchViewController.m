//
//  BRKSearchViewController.m
//  BarkCity
//
//  Created by Richard McAteer on 11/24/14.
//  Copyright (c) 2014 com.rosamcgee. All rights reserved.
//

#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "BRKSearchViewController.h"
#import "BRKSearchBarContainer.h"
#import "BRKLocationManager.h"
#import "BRKVenuesViewController.h"
#import "BRKUIManager.h"
#import "BRKTableView.h"

@interface BRKSearchViewController () <UITextFieldDelegate, MKMapViewDelegate, BRKDetailTableViewSegueDelegate, BRKSearchBarContainerDelegate>

@property (strong, nonatomic) BRKLocationManager *locationManager;
@property (strong, nonatomic) UITextField * searchTextField;
@property (strong, nonatomic) UIButton *locationButton;
@property (strong, nonatomic) BRKVenuesViewController *venuesViewController;
@property (strong, nonatomic) UIView *searchBarContainer; //change to BRKSearchBarContainer
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
    [searchViewBlur setFrame    :   [UIScreen mainScreen].bounds];
    [self.view      addSubview  :   searchViewBlur              ];

    [self setUpInitialViewsForSearchView];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - AutoLayout -
-(void) setUpInitialViewsForSearchView
{
    // ------------------------- //
    // --  Search Container   -- //
    // ------------------------- //
    self.searchBarContainer = [[UIView alloc] init];

//    self.searchBarContainer = [[BRKSearchBarContainer alloc] init];
//    self.searchBarContainer.delegate = self;


    [self.searchBarContainer.layer setCornerRadius:4.0];
    [self.searchBarContainer setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:self.searchBarContainer];

    NSArray * searchBarContainerHorizontal = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_searchBarContainer]|"
                                                                                     options:0
                                                                                     metrics:nil
                                                                                       views:NSDictionaryOfVariableBindings(_searchBarContainer)
                                              ];
    NSArray * searchBarContainerVertical = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-64.0-[_searchBarContainer(==100)]-(>=0)-|"
                                                                                   options:0
                                                                                   metrics:nil
                                                                                     views:NSDictionaryOfVariableBindings(_searchBarContainer)
                                            ];


    [self.view addConstraints:searchBarContainerHorizontal];
    [self.view addConstraints:searchBarContainerVertical];

    // ------------------------- //
    // --  UIText SearchField -- //
    // ------------------------- //
     self.searchTextField = [[UITextField alloc] init];
    [self.searchTextField setTranslatesAutoresizingMaskIntoConstraints:NO                   ];
    [self.searchTextField setBackgroundColor    :   [UIColor whiteColor]                    ];
    [self.searchTextField setBorderStyle        :   UITextBorderStyleRoundedRect            ];
    [self.searchTextField setLayoutMargins      :   UIEdgeInsetsMake(0.0, 8.0, 0.0, 8.0)    ];
    [self.searchTextField setPlaceholder        :   @"What are you looking for?"            ];
    [self.searchTextField setKeyboardType       :   UIKeyboardTypeASCIICapable              ];
    [self.searchTextField setReturnKeyType      :   UIReturnKeySearch                       ];
    [self.searchTextField.layer setShadowColor  :   [UIColor blueColor].CGColor             ];
    [self.searchTextField.layer setShadowOffset :   CGSizeMake(0.0, -2.0)                   ];
    [self.searchTextField.layer setShadowOpacity:   .25                                     ];
    [self.searchTextField.layer setShadowRadius :   5.0                                     ];
    [self.searchTextField.layer setMasksToBounds:   NO                                      ];
    [self.searchTextField setDelegate           :   self                                    ];
    [self.searchBarContainer   addSubview        :   self.searchTextField];


    self.locationButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.locationButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.locationButton addTarget:self
                            action:@selector(searchByLocation:)
                  forControlEvents:UIControlEventTouchUpInside];
    [self.locationButton setTitle:@"Use My Current Location" forState:UIControlStateNormal];
    [self.locationButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.locationButton setBackgroundColor:[UIColor blackColor]];
    [self.searchBarContainer addSubview:self.locationButton];

    NSArray * searchTextHorizontal = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_searchTextField]-|"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:NSDictionaryOfVariableBindings(_searchTextField)];

    NSArray * locationButtonHorizontal = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_locationButton]-|"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:NSDictionaryOfVariableBindings(_locationButton)];
    NSArray * textFieldsVertical = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[_searchTextField(==40)]-(>=0)-[_locationButton(==40)]-|"
                                                                           options:0
                                                                           metrics:nil
                                                                             views:NSDictionaryOfVariableBindings(_locationButton, _searchTextField)];
    [self.view addConstraints:searchTextHorizontal];
    [self.view addConstraints:locationButtonHorizontal];
    [self.view addConstraints:textFieldsVertical];
}

- (void)setUpResultsViewForSearchView
{
    [self setUpMap];
    self.venuesViewController = [[BRKVenuesViewController alloc] initWithQuery:self.searchTextField.text andBackgroundView:self.currentLocationView];
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
    self.currentLocationView  = [[MKMapView alloc] init];
    CLLocation * currentLocation = [[BRKLocationManager sharedLocationManager] location];
    CLLocationCoordinate2D zoomLocation = currentLocation.coordinate;


    MKCoordinateRegion region = MKCoordinateRegionMake(zoomLocation , MKCoordinateSpanMake(0.003, 0.003));

    [self.currentLocationView setRegion:region animated:YES];

    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    point.coordinate = zoomLocation;

    NSLog(@"The lat: %f, the long: %f", currentLocation.coordinate.latitude, currentLocation.coordinate.longitude);

    [self.currentLocationView addAnnotation:point];
}

#pragma mark - UITextDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self.venuesView removeFromSuperview];
    self.venuesView = nil;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self setUpResultsViewForSearchView];
    return [textField resignFirstResponder];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
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
    [self setUpResultsViewForSearchView];
}

- (void)searchByLocation:(UIButton *)sender
{
    NSLog(@"I'm trying to get here!");
    [self.venuesView removeFromSuperview];
    self.venuesView = nil;
    [self.searchTextField resignFirstResponder];

    [self setUpResultsViewForSearchView];
}

@end
