//
//  BRKUIManager.h
//  BarkCity
//
//  Created by Charles Coutu-Nadeau on 12/2/14.
//  Copyright (c) 2014 com.rosamcgee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface BRKUIManager : NSObject

// AppDelegate: Navigation controller
+ (NSDictionary *) navBarAttributes;

// BRKVenueTableViewCell: outlets
+ (UIFont *) venueNameFont;
+ (UIFont *) venueRatingFont;
+ (UIFont *) venueDistanceFont;
+ (UIFont *) venueDescriptiveBodyFont;

// BRKHomeViewController: venue category scroll view
+ (UIFont *) venueCategoryScrollFont;
+ (UIColor *) venueCategoryScrollColor;

// BRKSearchViewController
+ (UIFont *) sniffAroundLabelFont;
+ (UIFont *) closeButtonFont;
+ (NSDictionary *) searchFieldPlaceHolderAttributes;

// BRKDetailTableViewCell
+ (UIFont *) detailNameFont;
+ (UIFont *) detailRatingFont;
+ (UIFont *) detailPriceFont;
+ (UIFont *) detailDistanceFont;
+ (UIFont *) detailOtherFont;

// BRKHomeTabBar
+(UIColor *) shoppingCategoryYellow;
+(UIColor *) snackCategoryBlue;
+(UIColor *) cafeCategoryTeal;
+(UIColor *) playOutsideCategorySalmon;
+(UIColor *) doSomethingAwesomeCerulean;
+(UIColor *) categoryDotOrage;
@end
