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

@interface BRKSearchResultsController () <UIScrollViewDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) UIView * resultsView;
@property (strong, nonatomic) BRKScrollView * venueCategoryScroll;
@property (strong, nonatomic) BRKScrollView * venueTableScroll;

@property (strong, nonatomic) NSArray * venuesSearchTables;
@property (strong, nonatomic) CLLocationManager * locationManager;
@property (strong, nonatomic) CLLocation * location;

@end

@implementation BRKSearchResultsController

-(void)loadView{
    [super loadView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem * searchButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(displaySearchViewController)];
    [searchButton setWidth:44.0];
    [self.navigationController.navigationBar.topItem setRightBarButtonItem:searchButton animated:YES];
    
    // -- Category details are filled in from API -- //
    NSArray * venueCategories = @[ @"Bars", @"Parks", @"Bakery", @"Shopping", @"Cookies" ];

    // -- Setting up some rects -- //
    CGRect screenRect = [UIScreen mainScreen].bounds;
    CGPoint originWithNavBarAndMenu = CGPointMake(0.0, 64.0);
    //CGPoint originWithNavBarandNoMenu = CGPointMake(0.0, 44.0);
    //CGPoint originWithMenuBarAndNoNav = CGPointMake(0.0, 20.0);
    CGFloat categoryBarHeight = 60.0;
    
    CGRect categoryScrollViewFrame = CGRectMake(originWithNavBarAndMenu.x , originWithNavBarAndMenu.y, [UIScreen mainScreen].bounds.size.width, categoryBarHeight);
    CGRect tableScrollViewFrame = CGRectMake(originWithNavBarAndMenu.x, originWithNavBarAndMenu.y + categoryBarHeight, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - categoryBarHeight);
    
    // -- Creating the view for this view controller and setting it -- //
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
    
}


/**********************************************************************************
 *
 *                  Creating custom scroll views
 *
 ***********************************************************************************/

-(BRKScrollView *) createCategoryScrollWithCategories:(NSArray *)categories inFrame:(CGRect)labelRect {
    
    NSMutableArray * labelsForCategories = [NSMutableArray array];
    for (NSInteger i= 0; i<[categories count]; i++) {
        
        UILabel * newLabel = [[UILabel alloc] init];
        newLabel.text = categories[i];
        newLabel.accessibilityLabel = categories[i];
        [newLabel setAdjustsFontSizeToFitWidth:YES];
        [newLabel setTextAlignment:NSTextAlignmentCenter];
        [newLabel setBackgroundColor:[UIColor blueColor]];
        
        [labelsForCategories addObject:newLabel];
        
    }
    
    BRKScrollView * scrollNav = [BRKScrollView createScrollViewFromFrame:labelRect withSubViews:labelsForCategories];
    [scrollNav setShowsVerticalScrollIndicator:NO];
    [scrollNav setShowsHorizontalScrollIndicator:NO];
    
    return scrollNav;
}

-(BRKScrollView *) createScrollingTableFromVenues:(NSArray *)venues inFrame:(CGRect)frame{
    
    NSMutableArray * tableViewsForCategories = [NSMutableArray array];
    for (NSInteger i= 0; i< [venues count]; i++) {
        
        UITableView * newTable = [[UITableView alloc] initWithFrame:frame];
        [newTable setBackgroundColor:[UIColor whiteColor]];
        [newTable setAccessibilityLabel:venues[i]];
        [newTable setSeparatorColor:[UIColor grayColor]];
        [newTable setSeparatorInset:UIEdgeInsetsZero];
        [newTable setSeparatorStyle:UITableViewCellSeparatorStyleSingleLineEtched];
        [newTable setSeparatorEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
        [newTable registerNib:[UINib nibWithNibName:@"BRKLocationTableViewCell" bundle:nil] forCellReuseIdentifier:@"Location"];
        
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
    [self.locationManager requestWhenInUseAuthorization];
}

-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(void)displaySearchViewController{
    
    BRKSearchViewController * searchViewController = [[BRKSearchViewController alloc] init];
    [self presentViewController:searchViewController animated:YES completion:^{
        NSLog(@"Presented search");
    }];
    
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
}


@end
