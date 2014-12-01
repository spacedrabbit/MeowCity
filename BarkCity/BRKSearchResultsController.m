//
//  BRKSearchResultsController.m
//  BarkCity
//
//  Created by Louis Tur on 11/25/14.
//  Copyright (c) 2014 com.rosamcgee. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import "BRKSearchViewController.h"
#import "BRKFoursquareClient.h"
#import "BRKSearchResultsController.h"
#import "BRKVenuesResultsTable.h"
#import "BRKScrollView.h"
#import "BRKPictureTableViewCell.h"

@interface BRKSearchResultsController () <UIScrollViewDelegate, CLLocationManagerDelegate, UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UIView * resultsView;
@property (strong, nonatomic) BRKScrollView * venueCategoryScroll;
@property (strong, nonatomic) BRKScrollView * venueTableScroll;
@property (strong, nonatomic) NSArray * venuesSearchTables;
@property (strong, nonatomic) CLLocation * currentLocation;

@end

@implementation BRKSearchResultsController

-(void)loadView{
    [super loadView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // -- SEARCH BUTTON -- //
    UIBarButtonItem * searchButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(displaySearchViewController)];
    [self.navigationController.navigationBar.topItem setRightBarButtonItem:searchButton animated:YES];
    
    // -- Category details are filled in from API -- //
    NSArray * venueCategories = @[ @"Bars", @"Parks", @"Bakery", @"Shopping", @"Cookies" ];

    // -- Setting up some rects -- //
    CGRect screenRect = [UIScreen mainScreen].bounds;
    CGPoint originWithNavBarAndMenu = CGPointMake(0.0, 64.0);
    CGFloat categoryBarHeight = 60.0;
    
    CGRect categoryScrollViewFrame = CGRectMake(originWithNavBarAndMenu.x , originWithNavBarAndMenu.y, [UIScreen mainScreen].bounds.size.width, categoryBarHeight);
    CGRect tableScrollViewFrame = CGRectMake(originWithNavBarAndMenu.x, originWithNavBarAndMenu.y + categoryBarHeight, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - categoryBarHeight);
    
    // -- Adding a background image -- //
    UIImageView * barkbox = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"barkboxLogo"]];
    [barkbox setFrame:screenRect];
    [barkbox setContentMode:UIViewContentModeRight];
    self.resultsView = [[UIView alloc] initWithFrame:screenRect];
    [self.resultsView addSubview:barkbox];

    [self setView:self.resultsView];
    
    // -- creating scroll views -- //
    self.venueCategoryScroll = [self createCategoryScrollWithCategories:venueCategories inFrame:categoryScrollViewFrame];
    [self.view addSubview:self.venueCategoryScroll];
    
    self.venueTableScroll = [self createScrollingTableFromVenues:venueCategories inFrame:tableScrollViewFrame];
    [self.view addSubview:self.venueTableScroll];
    
    // -- setting scroll delegates -- //
    self.venueCategoryScroll.delegate = self;
    self.venueTableScroll.delegate = self;
    
    // -- getting info -- //
    self.foursquareClient = [BRKFoursquareClient sharedClient];
    
    self.numberOfLocationsToShow = 5;
    
    self.locationManager = [BRKLocationManager sharedLocationManager];
    
    [self.locationManager startUpdatingLocation];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleLocationChange:)
                                                 name:@"locationChanged"
                                               object:nil];

    
}


/**********************************************************************************
 *
 *                  Creating custom scroll views
 *
 ***********************************************************************************/

-(BRKScrollView *) createCategoryScrollWithCategories:(NSArray *)categories inFrame:(CGRect)labelRect {
    
    NSMutableArray * labelsForCategories = [NSMutableArray array];
    for (NSInteger i= 0; i<[categories count]; i++) {
        
        UIFont * sysFont = [UIFont systemFontOfSize:16.0];
        
        UILabel * newLabel = [[UILabel alloc] init];
        newLabel.attributedText = [[NSAttributedString alloc] initWithString:categories[i] attributes:@{ NSFontAttributeName: sysFont}];

        
        newLabel.accessibilityLabel = categories[i];
        [newLabel setAdjustsFontSizeToFitWidth:YES];
        [newLabel setTextAlignment:NSTextAlignmentCenter];
        [newLabel setBackgroundColor:[UIColor lightGrayColor]];
        
        [labelsForCategories addObject:newLabel];
        
    }
    
    BRKScrollView * scrollNav = [BRKScrollView createScrollViewFromFrame:labelRect withSubViews:labelsForCategories ofFullWidth:YES];
    [scrollNav setShowsVerticalScrollIndicator:NO];
    [scrollNav setShowsHorizontalScrollIndicator:NO];
  
    return scrollNav;
}

-(BRKScrollView *) createScrollingTableFromVenues:(NSArray *)venues inFrame:(CGRect)frame{
    
    UINib *pictureCellNib = [UINib nibWithNibName:@"BRKPictureTableViewCell" bundle:nil];
    UINib *dynamicCelllNib = [UINib nibWithNibName:@"BRKVenuesTableViewCell" bundle:nil];
    
    NSMutableArray * tableViewsForCategories = [NSMutableArray array];
    for (NSInteger i= 0; i< [venues count]; i++) {
        
        UITableView * newTable = [[UITableView alloc] initWithFrame:frame];

        [newTable registerNib:pictureCellNib forCellReuseIdentifier:@"PictureCell"];
        [newTable registerNib:dynamicCelllNib forCellReuseIdentifier:@"VenueCell"];
        
        newTable.rowHeight = UITableViewAutomaticDimension;
        newTable.estimatedRowHeight = 200.0;
        
        [newTable setDelegate:self];
        [newTable setDataSource:self];
        
        [tableViewsForCategories addObject:newTable];
        
    }
    
    BRKScrollView * scrollNavTables = [BRKScrollView createScrollViewFromFrame:frame withSubViews:tableViewsForCategories];
    
    return scrollNavTables;
}

/**********************************************************************************
 *
 *                  View helpers
 *
 ***********************************************************************************/
#pragma mark - View helpers -
- (void)viewWillAppear:(BOOL)animated {
    [self.locationManager requestInUseAuthorization];
}

-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(void)displaySearchViewController{
    
    
    BRKSearchViewController * searchViewController = [[BRKSearchViewController alloc] init];
    [searchViewController setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    
    [self presentViewController:searchViewController animated:YES completion:nil];
    
}

/**********************************************************************************
 *
 *                  Scroll Delegate
 *
 ***********************************************************************************/
#pragma mark - Scroll Delegate -
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGPoint offset = scrollView.contentOffset;
    if (scrollView == self.venueCategoryScroll) {
        self.venueTableScroll.contentOffset = offset;
    } else {
        [self.venueCategoryScroll setContentOffset:CGPointMake(offset.x, 0.0)]; // we don't need to translate the Y offset for labels
    }
    // stops horizontal bounces
//    if (offset.x < 0) {
//        [scrollView setContentOffset:CGPointMake(0.0, 0.0) animated:NO];
//    }
//
//    if (offset.x > scrollView.contentSize.width - [UIScreen mainScreen].bounds.size.width) {
//        [scrollView setContentOffset:CGPointMake(scrollView.contentSize.width - [UIScreen mainScreen].bounds.size.width, 0.0) animated:NO];
//    }
}

- (void)handleLocationChange:(NSNotification *)notification {
    
    NSDictionary *userInfo = notification.userInfo;
    CLLocation *newLocation = userInfo[@"newLocation"];
    if (!self.currentLocation) {
        self.currentLocation = newLocation;
    }
    [self fetchVenuesForLocation:newLocation withCompletionHandler:^(bool success) {
        
        if (success) {
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [self.venueTableScroll reloadBRKSubViews];
            }];
        }else{
            NSLog(@"Nothing found");
        }
        
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.row == 0) {
        BRKPictureTableViewCell *cell = (BRKPictureTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"PictureCell"];
        return cell;
    }
    
    BRKVenuesTableViewCell *cell = (BRKVenuesTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"VenueCell" forIndexPath:indexPath];
    
    BRKVenue *venue = self.venues[indexPath.row];
    cell.name.text = venue.name;
    cell.rating.text = [venue.rating description];
    cell.distance.text = @"1.0 mi";
    
    // conditional to test the dynamic length of the cells
    
    if (indexPath.row %2 == 0) {
        cell.descriptiveBody.text = @"This restaurant is great for dogs";
    } else {
        cell.descriptiveBody.text = @"This is a very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very long version of the cell";
    }
    
    return cell;
    
}

- (void)fetchVenuesForLocation:(CLLocation *)location withCompletionHandler:(void (^)(bool))success
{
    [self.foursquareClient requestVenuesForQuery:@"Dog Friendly Restaurants" location:location limit:15 success:^(NSArray *venues) {
        self.venues = venues;
        if (self.venues) {
           success(YES);
        }
    } failure:^(NSError *error) {
        NSLog(@"%@", error);
    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.venues count]; //? 1 : [self.venues count];
}
@end
