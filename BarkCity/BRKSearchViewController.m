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
#import "BRKScrollView.h"
#import "BRKLocationManager.h"
#import "BRKVenuesTableViewController.h"

@interface BRKSearchViewController () <UITextFieldDelegate, MKMapViewDelegate, UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) BRKVenuesTableViewController *venueTableViewController;
@property (strong, nonatomic) BRKScrollView * scrollingContainerView;
@property (strong, nonatomic) UITextField * searchTextField;
@property (strong, nonatomic) UITextField * locationTextField;
@property (strong, nonatomic) UITableView *venueResultsTable;

@property (strong, nonatomic) MKMapView * currentLocationView;

@property (strong, nonatomic) CLLocation * currentLocation;

@property (nonatomic) CGRect screenRect;
@property (nonatomic) BOOL tableViewIsHidden;

@end

@implementation BRKSearchViewController

#pragma mark - UIViewController Standard Methods -
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // -- getting info -- //
    self.foursquareClient = [BRKFoursquareClient sharedClient];
    
    self.numberOfLocationsToShow = 5;
    
    self.locationManager = [BRKLocationManager sharedLocationManager];
    
    [self.locationManager startUpdatingLocation];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleLocationChange:)
                                                 name:@"locationChanged"
                                               object:nil];


    // handling moving content when keyboard appears ...
    NSOperationQueue * keyBoardHandlingQueue = [[NSOperationQueue alloc] init];
    [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillShowNotification
                                                      object:nil
                                                       queue:keyBoardHandlingQueue
                                                  usingBlock:^(NSNotification *note)
    {
        // the userInfo dict has info on KB size/location
        CGRect keyboardTopPoint = [[note.userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
        CGRect keyboardBottomPoint = [[note.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];

        // because this involves an animation, it gets placed on the main queue
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self updateSearchViewWithTopRect:keyboardTopPoint andBottomRect:keyboardBottomPoint];
        }];
    }];
    
    // ... and when it disappears
    [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillHideNotification
                                                      object:nil
                                                       queue:keyBoardHandlingQueue
                                                  usingBlock:^(NSNotification *note)
    {
        //NSLog(@"The info: %@", note.userInfo);
        //NSLog(@"The Keyboard will disappear");
    }];    
}

-(void)viewWillAppear:(BOOL)animated{
    self.screenRect = [UIScreen mainScreen].bounds;
    self.tableViewIsHidden = YES; // search table begins hidden
    
    // -- modal blur view -- //
    UIVisualEffectView * searchViewBlur = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    [searchViewBlur setFrame    :   [UIScreen mainScreen].bounds];
    [self.view      addSubview  :   searchViewBlur              ];

    [self setUpMap];
    [self setUpViews];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Updating Constraints based on Keyboard -
// -- Not implemented --//
/* 
    The idea is to run this when theis view controller detects that the keyboard has (dis)appeared
    Implementation Ideas:
          1) Change the bottom inset of the tableView's content to match the height of the keyboard
          2) Get the array of currently visible cells
          3) Tell the tableView to scroll to the first visbile cell in that array

    Effectively, this would push the content of the tableview up and then center on the visible cells
*/
-(void)updateSearchViewWithTopRect:(CGRect)topOfRect andBottomRect:(CGRect)bottomOfRect{
    
    if (!self.tableViewIsHidden) {
        
        [self.venueTableViewController.tableView setContentInset:UIEdgeInsetsMake(0.0, 0.0, bottomOfRect.size.height, 0.0)];
        
        NSArray * visible = [self.venueTableViewController.tableView visibleCells];
        [self.venueTableViewController.tableView scrollToRowAtIndexPath:[self.venueTableViewController.tableView indexPathForCell:visible[0]]
                                                  atScrollPosition:UITableViewScrollPositionMiddle
                                                          animated:YES];
    }
}

-(void)toggleTableViewAndUnhide:(BOOL)unHide{ 
    
    CGFloat alphaValue;
    if (self.tableViewIsHidden) {
        alphaValue = 1.0;
    }else{
        alphaValue = 0.0;
    }
    //adds a fade animation to the results disapearing
    [UIView animateWithDuration:0.25
                     animations:^
     {
         [self.venueTableViewController.tableView setAlpha:alphaValue];
     }
                     completion:^(BOOL finished)
     {
         if (finished) {
             self.tableViewIsHidden = !self.tableViewIsHidden;
         }
     }];
    
}

#pragma mark - AutoLayout -
-(void) setUpViews{
    
    // ------------------------- //
    // -- Fake Nav+Status Bar -- //
    // ------------------------- //
    
    UIView * fakeNavBar = [[UIView alloc] init];
    [fakeNavBar setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:fakeNavBar];
    
    NSArray * fakeNavBarHorizontal = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[fakeNavBar]|"
                                                                                     options:0
                                                                                     metrics:nil
                                                                                       views:NSDictionaryOfVariableBindings(fakeNavBar)];
    
    [self.view addConstraints:fakeNavBarHorizontal];
    
    // ------------------------- //
    // --  Fake NavBar Items  -- //
    // ------------------------- //
    UILabel * barkCityLabel = [[UILabel alloc] init];
    [barkCityLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [barkCityLabel setTextAlignment:NSTextAlignmentCenter];
    [barkCityLabel setFont:[UIFont boldSystemFontOfSize:18.0]];
    [barkCityLabel setText:@"Sniff Around!"];
    [fakeNavBar addSubview:barkCityLabel];
    
    // -- Just the label -- //
    NSArray * fakeNavBarItemsHorizontal = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[barkCityLabel]|"
                                                                                  options:0
                                                                                  metrics:nil
                                                                                    views:NSDictionaryOfVariableBindings(barkCityLabel)];
    // 20pts from top since this sits in the UINavBar, which is under the status bar
    NSArray * fakeNavBarItemsVertical = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(==20)-[barkCityLabel]|"
                                                                                options:0
                                                                                metrics:nil
                                                                                  views:NSDictionaryOfVariableBindings(barkCityLabel)];
    [fakeNavBar addConstraints:fakeNavBarItemsHorizontal];
    [fakeNavBar addConstraints:fakeNavBarItemsVertical];
    
    // -- The Close Button -- //
    // pinned to right + 8pts, set to a width of 40pts. pinned to bottom, with top space at least 20pts.
    UIButton * closeButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [closeButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [closeButton setTitle:@"Close" forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(cancelBarButtonItemPressed:) forControlEvents:UIControlEventTouchUpInside];
    [fakeNavBar addSubview:closeButton];
    
    NSArray * fakeNavBarCloseButtonHorizontal = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[closeButton]-|"
                                                                                        options:0
                                                                                        metrics:nil
                                                                                          views:NSDictionaryOfVariableBindings(closeButton)];
    NSArray * fakeNavBarCloseButtonVertical = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(==20)-[closeButton]|"
                                                                                        options:0
                                                                                        metrics:nil
                                                                                          views:NSDictionaryOfVariableBindings(closeButton)];
    [fakeNavBar addConstraints:fakeNavBarCloseButtonHorizontal];
    [fakeNavBar addConstraints:fakeNavBarCloseButtonVertical];
    
    // ------------------------- //
    // --  Search Container   -- //
    // ------------------------- //
    UIView * searchBarContainer = [[UIView alloc] init];
    [searchBarContainer.layer setCornerRadius:4.0];
    [searchBarContainer setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:searchBarContainer];
    
    NSArray * searchBarContainerHorizontal = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[searchBarContainer]|"
                                                                                options:0
                                                                                metrics:nil
                                                                                  views:NSDictionaryOfVariableBindings(searchBarContainer)
                                         ];
    NSArray * searchBarContainerVertical = [NSLayoutConstraint constraintsWithVisualFormat:
                                                    @"V:|[fakeNavBar(==64.0)][searchBarContainer(==100)]-(>=0)-|"
                                                                                   options:0
                                                                                   metrics:nil
                                                                                     views:NSDictionaryOfVariableBindings(fakeNavBar,searchBarContainer)
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
    [searchBarContainer   addSubview        :   self.searchTextField];
    
    self.locationTextField = [[UITextField alloc] init];
    [self.locationTextField setTranslatesAutoresizingMaskIntoConstraints:NO                 ];
    [self.locationTextField setBackgroundColor  :   [UIColor whiteColor]                    ];
    [self.locationTextField setLayoutMargins    :   UIEdgeInsetsMake(0.0, 8.0, 0.0, 8.0)    ];
    [self.locationTextField setBorderStyle      :   UITextBorderStyleRoundedRect            ];
    [self.locationTextField setPlaceholder      :   @"Current Location"                     ];
    [self.locationTextField setKeyboardType     :   UIKeyboardTypeASCIICapable              ];
    [self.locationTextField setReturnKeyType    :   UIReturnKeySearch                       ];
    [self.locationTextField.layer setShadowColor:   [UIColor blueColor].CGColor             ];
    [self.locationTextField.layer setShadowOffset:  CGSizeMake(0.0, 2.0)                    ];
    [self.locationTextField.layer setShadowOpacity: .25                                     ];
    [self.locationTextField.layer setShadowRadius:  5.0                                     ];
    [self.locationTextField.layer setMasksToBounds: NO                                      ];
    [self.locationTextField setDelegate         :   self                                    ];
    [searchBarContainer addSubview:self.locationTextField];
    
    NSArray * searchTextHorizontal = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_searchTextField]-|"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:NSDictionaryOfVariableBindings(_searchTextField)];
    
    NSArray * locationTextHorizontal = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_locationTextField]-|"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:NSDictionaryOfVariableBindings(_locationTextField)];
    NSArray * textFieldsVertical = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[_searchTextField(==40)]-(>=0)-[_locationTextField(==40)]-|"
                                                                           options:0
                                                                           metrics:nil
                                                                             views:NSDictionaryOfVariableBindings(_locationTextField, _searchTextField)];
    [self.view addConstraints:searchTextHorizontal];
    [self.view addConstraints:locationTextHorizontal];
    [self.view addConstraints:textFieldsVertical];
    
    // ------------------------- //
    // --  BRKTable View      -- //
    // ------------------------- //
    self.venueTableViewController = [[BRKVenuesTableViewController alloc] init];
    self.venueResultsTable = self.venueTableViewController.tableView;
    [self.venueResultsTable setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.venueResultsTable setBackgroundColor:[UIColor blueColor]];
    [self.venueResultsTable setSeparatorStyle:UITableViewCellSeparatorStyleSingleLineEtched];
    [self.venueResultsTable setSeparatorColor:[UIColor lightGrayColor]];
    [self.venueResultsTable setSeparatorInset:UIEdgeInsetsZero];
    [self.venueResultsTable setAlpha:0.0];
    // -- needs search logic -- //
    [self.view addSubview:self.venueResultsTable];
    
    // -- DELETE THIS LATER -- //
    UINib *dynamicCelllNib = [UINib nibWithNibName:@"BRKVenuesTableViewCell" bundle:nil];
    [self.venueResultsTable registerNib:dynamicCelllNib forCellReuseIdentifier:@"VenueCell"];
    
    self.venueResultsTable.rowHeight = UITableViewAutomaticDimension;
    self.venueResultsTable.estimatedRowHeight = 200.0;
    
    [self.venueResultsTable setDelegate:self];
    [self.venueResultsTable setDataSource:self];
    
    // -- DELETE THIS LATER -- //
    
    NSArray * venuesTableHorizontal = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_venueResultsTable]|"
                                                                              options:0
                                                                              metrics:nil
                                                                                views:NSDictionaryOfVariableBindings(_venueResultsTable)];
    NSArray * venuesTableVertical = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[searchBarContainer]-[_venueResultsTable]-|"
                                                                              options:0
                                                                              metrics:nil
                                                                                views:NSDictionaryOfVariableBindings(_venueResultsTable, searchBarContainer)];
    [self.view addConstraints:venuesTableHorizontal];
    [self.view addConstraints:venuesTableVertical];
    

//    [self.currentLocationView setTranslatesAutoresizingMaskIntoConstraints:NO];
//    [self.currentLocationView setDelegate:self];
//    [self.view addSubview:self.currentLocationView];
//    
//    NSArray * mapTableHorizontal = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_currentLocationView]|"
//                                                                              options:0
//                                                                              metrics:nil
//                                                                                views:NSDictionaryOfVariableBindings(_currentLocationView)];
//    NSArray * mapTableVertical = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[searchBarContainer]-[_currentLocationView]-|"
//                                                                            options:0
//                                                                            metrics:nil
//                                                                              views:NSDictionaryOfVariableBindings(_currentLocationView, searchBarContainer)];
//    
//    [self.view addConstraints:mapTableHorizontal];
//    [self.view addConstraints:mapTableVertical];
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

// -- shows/hides results table, needs further work

- (void)cancelBarButtonItemPressed:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITextDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == self.searchTextField) {
        NSString *query = self.searchTextField.text;
        [self fetchVenuesForQuery:query withCompletionHandler:^(BOOL success) {
            
            if (success) {
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    [self.venueTableViewController.tableView reloadData];
                }];
            }else{
                NSLog(@"Nothing found");
            }
            
        }];
        
    } else if (textField == self.locationTextField) {
        
        [self fetchVenuesForLocation:self.locationManager.location withCompletionHandler:^(BOOL success) {
            if (success) {
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    [self.venueTableViewController.tableView reloadData];
                }];
            }else{
                NSLog(@"Nothing found");
            }
        }];
    }
    
    
    [self toggleTableViewAndUnhide:YES];
    return [textField resignFirstResponder];
}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
}

#pragma mark - API call
- (void)fetchVenuesForLocation:(CLLocation *)location withCompletionHandler:(void (^)(BOOL))success
{
    [self.foursquareClient requestVenuesForQuery:@"Restaurants" location:location limit:15 success:^(NSArray *venues) {
        self.venues = venues;
        if (self.venues) {
            success(YES);
        }
    } failure:^(NSError *error) {
        NSLog(@"%@", error);
    }];
}

- (void)fetchVenuesForQuery:(NSString *)query withCompletionHandler:(void (^)(BOOL))success {
    [self.foursquareClient requestVenuesForQuery:query location:self.locationManager.location limit:15 success:^(NSArray *venues) {
        self.venues = venues;
        if (self.venues) {
            success(YES);
        }
    } failure:^(NSError *error) {
        NSLog(@"%@", error);
    }];
    
}


- (void)handleLocationChange:(NSNotification *)notification {
    
    NSDictionary *userInfo = notification.userInfo;
    CLLocation *newLocation = userInfo[@"newLocation"];
    if (!self.currentLocation) {
        self.currentLocation = newLocation;
    }
    
    [self fetchVenuesForLocation:newLocation withCompletionHandler:^(BOOL success) {
        
        if (success) {
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [self.venueTableViewController.tableView reloadData];
            }];
        }else{
            NSLog(@"Nothing found");
        }
        
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.numberOfLocationsToShow;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BRKVenuesTableViewCell *cell = (BRKVenuesTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"VenueCell" forIndexPath:indexPath];
    
    BRKVenue *venue = self.venues[indexPath.row];
    cell.venue = venue;
    
    // conditional to test the dynamic length of the cells
    
    if (indexPath.row %2 == 0) {
        cell.descriptiveBody.text = @"This restaurant is great for dogs";
    } else {
        cell.descriptiveBody.text = @"This is a very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very long version of the cell";
    }
    
    return cell;
}

@end
