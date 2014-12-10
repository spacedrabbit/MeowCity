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
#import "BRKHomeTabBar.h"
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>

// alllll the delegates
@interface BRKHomeViewController () <UIScrollViewDelegate, CLLocationManagerDelegate, BRKDetailTableViewSegueDelegate, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate, BRKHomeTabBarDelegate>

@property (strong, nonatomic) UIView            * homeView;

@property (strong, nonatomic) CLLocation        * currentLocation;

@property (strong, nonatomic) BRKScrollView     * venueCategoryScroll;
@property (strong, nonatomic) BRKScrollView     * venueTableScroll;
@property (strong, nonatomic) BRKHomeTabBar     * homeTabBar;

@property (strong, nonatomic) NSArray           * venueCategories;
@property (strong, nonatomic) NSArray           * venueCategoryHeroImages;
@property (strong, nonatomic) NSMutableArray    * venueTableControllers;

@property (nonatomic) NSInteger previousTab;

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
    self.navigationController.navigationBar.topItem.title = @"Bark City";

    // -- FOURSQUARE -- //
    self.foursquareClient = [BRKFoursquareClient sharedClient];
    self.numberOfLocationsToShow = 8;
    self.locationManager = [BRKLocationManager sharedLocationManager];
    [self.locationManager startUpdatingLocation];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleLocationChange:)
                                                 name:@"locationChanged"
                                               object:nil];

    // -- SEARCH BUTTON -- //
    UIBarButtonItem * searchButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(displaySearchViewController)];
    [self.navigationController.navigationBar.topItem setRightBarButtonItem:searchButton animated:YES];

    // - LOGOUT BUTTON/HAMBURGER MENU/SORRY --//
    UIBarButtonItem *logoutButton = [[UIBarButtonItem alloc] initWithTitle:@"| | |" style:UIBarButtonItemStylePlain target:self action:@selector(logout:)];
    [self.navigationController.navigationBar.topItem setLeftBarButtonItem:logoutButton animated:YES];

    // -- TABBAR AND TABLESCROLL -- //
    [self createAndArrangeScrollViews];

    // -- Location Start -- //
    [self.locationManager requestInUseAuthorization];
}


-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


/**********************************************************************************
 *
 *                  Nav Bar Items
 *
 ***********************************************************************************/
- (void)logout:(UIBarButtonItem *)sender {
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser) {
        [PFUser logOut];
    }
    NSLog(@"User logged out!");
}

- (void)displaySearchViewController
{
    BRKSearchViewController * searchViewController = [[BRKSearchViewController alloc] init];

    UINavigationController * navControl = [[UINavigationController alloc] initWithRootViewController:searchViewController ];
    navControl.navigationBar.topItem.title = @"Sniff Around!";
    navControl.navigationBar.topItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:searchViewController action:@selector(dismissModalViewControllerAnimated:)];
    [navControl setModalPresentationStyle:UIModalPresentationOverCurrentContext];

    [self presentViewController:navControl animated:YES completion:nil];

}

/**********************************************************************************
 *
 *                  Creating home view
 *
 ***********************************************************************************/
#pragma mark - Creating Scroll Views -
-(void)createAndArrangeScrollViews{

    // -- RECTS -- //
    CGRect screenRect = [UIScreen mainScreen].bounds;
    CGPoint originWithNavBarAndMenu = CGPointMake(0.0, 64.0);
    CGFloat categoryBarHeight = 44.0;
    CGRect categoryScrollViewFrame = CGRectMake(originWithNavBarAndMenu.x , originWithNavBarAndMenu.y, [UIScreen mainScreen].bounds.size.width, categoryBarHeight);
    CGRect tableScrollViewFrame = CGRectMake(originWithNavBarAndMenu.x, originWithNavBarAndMenu.y + categoryBarHeight, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - categoryBarHeight - originWithNavBarAndMenu.y);

    // -- SELF.VIEW -- //
    UIView * background = [[UIView alloc] initWithFrame:screenRect];
    [background setBackgroundColor:[BRKUIManager neutralNavBar]];

    self.homeView = [[UIView alloc] initWithFrame:screenRect];
    [self.homeView addSubview:background];
    [self setView:self.homeView];

        // -- TABBAR -- //
    self.homeTabBar = [self createBRKTabBarInFrame:categoryScrollViewFrame];
    [self.view addSubview:self.homeTabBar];
    self.homeTabBar.delegate        = self;

        // -- SCROLLBAR -- //
    self.venueTableScroll = [self createScrollingTableFromVenues:self.venueCategories
                                                         inFrame:tableScrollViewFrame];
    [self.view addSubview:self.venueTableScroll];
    self.venueTableScroll.delegate  = self;




}

-(BRKHomeTabBar *) createBRKTabBarInFrame:(CGRect) frame{

    self.venueCategories = @[ @"Restaurant", @"Cafe", @"Bar", @"Shopping", @"Outdoors" ];
    self.venueCategoryHeroImages = @[ [UIImage imageNamed:@"snackHero"],
                                      [UIImage imageNamed:@"cafeHero"],
                                      [UIImage imageNamed:@"drinkHero"],
                                      [UIImage imageNamed:@"shopHero"],
                                      [UIImage imageNamed:@"playHero"]
                                      ];

    BRKHomeTabBar * categoryTabs = [[[NSBundle mainBundle] loadNibNamed:@"BRKHomeTabBar"
                                                                  owner:self
                                                                options:nil] firstObject];
    [categoryTabs setFrame:frame];
    [categoryTabs.tabBarView setBackgroundColor:[self updateTabColor:categoryTabs.currentlySelectedTab]];
    self.previousTab = categoryTabs.currentlySelectedTab;

    return categoryTabs;
}

-(BRKScrollView *) createScrollingTableFromVenues:(NSArray *)venues inFrame:(CGRect)frame{

    __block NSMutableArray * tableViewsForCategories = [NSMutableArray array];
    [venues enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {

        UIImageView *backgroundImage = [[UIImageView alloc] initWithImage:self.venueCategoryHeroImages[idx]];
        [backgroundImage setContentMode:UIViewContentModeScaleToFill];
        
        BRKVenuesViewController * newTableController = [[BRKVenuesViewController alloc] initWithQuery:self.venueCategories[idx]
                                                                                    andBackgroundView:backgroundImage];
        newTableController.venueDetailSegueDelegate = self;
        [self.venueTableControllers addObject:newTableController];

        [tableViewsForCategories addObject:newTableController.view];

    }];
    BRKScrollView * scrollNavTables = [BRKScrollView createScrollViewFromFrame:frame withSubViews:tableViewsForCategories];
    [scrollNavTables.layer setBorderColor:[BRKUIManager neutralNavBar].CGColor];
    [scrollNavTables.layer setBorderWidth:2.0];
    
    return scrollNavTables;
}

/**********************************************************************************
 *
 *                  BRKTabBar Delegates & Helpers
 *
 ***********************************************************************************/

-(void)didSelectTabButton:(NSInteger)tabButtonIndex
{

    UIColor * newTabColor = [self updateTabColor:tabButtonIndex];
    NSInteger tabDistanceChange = labs(self.previousTab - tabButtonIndex);

    CGFloat timeInterval = .25 + (tabDistanceChange * 0.11); //smooths the change for larger distances

    [UIView animateWithDuration:timeInterval animations:^{
        [self.homeTabBar.tabBarView setBackgroundColor:newTabColor];
        [self updateVisibleVenueTable:tabButtonIndex];
    } completion:^(BOOL finished) {
        self.previousTab = tabButtonIndex;
    }];
}

-(void) updateVisibleVenueTable:(NSInteger)tabIndex
{
    CGFloat     pageWidth               =   [UIScreen mainScreen].bounds.size.width   ;
    CGFloat currentOffset = pageWidth * tabIndex;
    [self.venueTableScroll setContentOffset:CGPointMake(currentOffset, 0.0) animated:NO];
}

- (UIColor *)updateTabColor:(NSInteger)tabIndex
{
    UIColor * updatedColor;
    switch (tabIndex) {
        case 0:
            updatedColor = [BRKUIManager snackCategoryBlue];
            break;
        case 1:
            updatedColor = [BRKUIManager cafeCategoryTeal];
            break;
        case 2:
            updatedColor = [BRKUIManager categoryDotOrage];
            break;
        case 3:
            updatedColor = [BRKUIManager shoppingCategoryYellow];
            break;
        case 4:
            updatedColor = [BRKUIManager playOutsideCategorySalmon];
            break;
        default:
            break;
    }
    return updatedColor;
}
/**********************************************************************************
 *
 *                  Scroll Delegate
 *
 ***********************************************************************************/
#pragma mark - Scroll Delegate -
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    CGFloat pageWidth = scrollView.frame.size.width;
    CGPoint offset = scrollView.contentOffset;
    NSInteger pageNumber = lroundf(offset.x / pageWidth);
    
    UIColor * newTabColor = [self updateTabColor:pageNumber];
    NSInteger tabDistanceChange = labs(self.previousTab - pageNumber);
    CGFloat timeInterval = .25 + (tabDistanceChange * 0.11); //smooths the change for larger distances
    
    [UIView animateWithDuration:timeInterval animations:^{
        [self.homeTabBar.tabBarView setBackgroundColor:newTabColor];
    } completion:^(BOOL finished) {
        self.previousTab = pageNumber;
    }];
    
    
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
 *                  Segues
 *
 ***********************************************************************************/
#pragma mark - Segues -
- (void)segueToDetailTableViewWithVenue:(BRKVenue *)venue
{
    BRKVenueDetailTableViewController * selectedVenue = [[BRKVenueDetailTableViewController alloc] init];
    selectedVenue.venue = venue;

    [self.navigationController pushViewController:selectedVenue animated:YES];
}

@end
