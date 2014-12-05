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
#import "BRKHomeViewController.h"
#import "BRKVenueDetailTableViewController.h"
#import "BRKScrollView.h"
#import "BRKPictureTableViewCell.h"
#import "BRKVenuesViewController.h"
#import "BRKUIManager.h"

@interface BRKHomeViewController () <UIScrollViewDelegate, CLLocationManagerDelegate, BRKDetailTableViewSegueDelegate>

@property (strong, nonatomic) UIView * resultsView;
@property (strong, nonatomic) BRKScrollView * venueCategoryScroll;
@property (strong, nonatomic) BRKScrollView * venueTableScroll;
@property (strong, nonatomic) CLLocation * currentLocation;

@property (strong, nonatomic) NSArray * venueCategories;
@property (strong, nonatomic) NSMutableArray * venueTableControllers;

@end

@implementation BRKHomeViewController

/**********************************************************************************
 *
 *                  View methods
 *
 ***********************************************************************************/
#pragma mark - View Methods -
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.venueTableControllers = [[NSMutableArray alloc] init];
    
    // -- getting info -- //
    self.foursquareClient = [BRKFoursquareClient sharedClient];
    
    self.numberOfLocationsToShow = 5;
    
    self.locationManager = [BRKLocationManager sharedLocationManager];
    
    [self.locationManager startUpdatingLocation];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleLocationChange:)
                                                 name:@"locationChanged"
                                               object:nil];
    
    self.navigationController.navigationBar.topItem.title = @"Bark City";
    
    // -- SEARCH BUTTON -- //
    UIBarButtonItem * searchButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(displaySearchViewController)];
    [self.navigationController.navigationBar.topItem setRightBarButtonItem:searchButton animated:YES];
    
    // -- Scroll Views -- //
    [self createAndArrangeScrollViews];
    
    // -- Location Start -- //
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
 *                  Creating custom scroll views
 *
 ***********************************************************************************/
#pragma mark - Creating Scroll Views -
-(void)createAndArrangeScrollViews{
    
    // -- Category details are filled in from API -- //
    self.venueCategories = @[ @"Bars", @"Parks", @"Bakery", @"Shopping", @"Cookies" ];
    
    // -- Setting up some rects -- //
    CGRect screenRect = [UIScreen mainScreen].bounds;
    CGPoint originWithNavBarAndMenu = CGPointMake(0.0, 64.0);
    CGFloat categoryBarHeight = 60.0;
    
    CGRect categoryScrollViewFrame = CGRectMake(originWithNavBarAndMenu.x , originWithNavBarAndMenu.y, [UIScreen mainScreen].bounds.size.width, categoryBarHeight);
    CGRect tableScrollViewFrame = CGRectMake(originWithNavBarAndMenu.x, originWithNavBarAndMenu.y + categoryBarHeight, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - categoryBarHeight - originWithNavBarAndMenu.y);
    
    // -- Adding a background image -- //
    UIView * background = [[UIView alloc] initWithFrame:screenRect];
    [background setBackgroundColor:[UIColor lightGrayColor]];
    
    self.resultsView = [[UIView alloc] initWithFrame:screenRect];
    
    [self.resultsView addSubview:background];
    
    [self setView:self.resultsView];
    
    // -- creating scroll views -- //
    self.venueCategoryScroll = [self createCategoryScrollWithCategories:self.venueCategories inFrame:categoryScrollViewFrame];
    [self.view addSubview:self.venueCategoryScroll];
    
    self.venueTableScroll = [self createScrollingTableFromVenues:self.venueCategories inFrame:tableScrollViewFrame];
    [self.view addSubview:self.venueTableScroll];
    
    // -- setting scroll delegates -- //
    self.venueCategoryScroll.delegate = self;
    self.venueTableScroll.delegate = self;
    
}

-(BRKScrollView *) createCategoryScrollWithCategories:(NSArray *)categories inFrame:(CGRect)labelRect {
    
    NSMutableArray * labelsForCategories = [NSMutableArray array];
    for (NSInteger i= 0; i<[categories count]; i++) {
        
        UILabel * newLabel = [[UILabel alloc] init];
        newLabel.attributedText = [[NSAttributedString alloc] initWithString:categories[i] attributes:@{ NSFontAttributeName: [BRKUIManager venueCategoryScrollFont]}];

        
        newLabel.accessibilityLabel = categories[i];
        [newLabel setAdjustsFontSizeToFitWidth:YES];
        [newLabel setTextAlignment:NSTextAlignmentCenter];
        [newLabel setBackgroundColor:[BRKUIManager venueCategoryScrollColor]];
        
        [labelsForCategories addObject:newLabel];
        
    }
    
    BRKScrollView * scrollNav = [BRKScrollView createScrollViewFromFrame:labelRect withSubViews:labelsForCategories ofFullWidth:YES];
    [scrollNav setShowsVerticalScrollIndicator:NO];
    [scrollNav setShowsHorizontalScrollIndicator:NO];
  
    return scrollNav;
}

-(BRKScrollView *) createScrollingTableFromVenues:(NSArray *)venues inFrame:(CGRect)frame{

    NSMutableArray * tableViewsForCategories = [NSMutableArray array];
    for (NSInteger i= 0; i< [venues count]; i++) {
        
        UIImageView *backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"placeholder"]];
        
        BRKVenuesViewController * newTableController = [[BRKVenuesViewController alloc] initWithQuery:self.venueCategories[i] andBackgroundView:backgroundImage];
        newTableController.venueDetailSegueDelegate = self;
        [self.venueTableControllers addObject:newTableController];
        
        [tableViewsForCategories addObject:newTableController.view];
    }
    
    BRKScrollView * scrollNavTables = [BRKScrollView createScrollViewFromFrame:frame withSubViews:tableViewsForCategories];
    
    return scrollNavTables;
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
        
    } else if (scrollView == self.venueTableScroll){
        [self.venueCategoryScroll setContentOffset:CGPointMake(offset.x, 0.0)]; // we don't need to translate the Y offset for labels
    }else{
        //this case is for each vertical scroll of the tableview.. do not remove this logic
        //NSLog(@"This is a different scroll!");
    }

}


/**********************************************************************************
 *
 *                  FourSquare/Location Fetches
 *
 ***********************************************************************************/
#pragma mark - FourSquare/Location Fetches -

- (void)handleLocationChange:(NSNotification *)notification {
    
    NSDictionary *userInfo = notification.userInfo;
    CLLocation *newLocation = userInfo[@"newLocation"];
    if (!self.currentLocation) {
        [self.venueTableControllers makeObjectsPerformSelector:@selector(setLocation:) withObject:newLocation];
    }
}

/**********************************************************************************
 *
 *                  Segue Delegate To DetailViewController
 *
 ***********************************************************************************/
#pragma mark - Segue Delegate To DetailViewController -
- (void)segueToDetailTableViewWithVenue:(BRKVenue *)venue
{
    BRKVenueDetailTableViewController * selectedVenue = [[BRKVenueDetailTableViewController alloc] init];
    selectedVenue.venue = venue;

    [self.navigationController pushViewController:selectedVenue animated:YES];
}

@end
