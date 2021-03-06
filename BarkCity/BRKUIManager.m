//
//  BRKUIManager.m
//  BarkCity
//
//  Created by Charles Coutu-Nadeau on 12/2/14.
//  Copyright (c) 2014 com.rosamcgee. All rights reserved.
//

#import "BRKUIManager.h"

@implementation BRKUIManager

// AppDelegate: Navigation controller

+ (NSDictionary *) navBarAttributes {
    NSString *fontName = @"Avenir-Heavy";
    CGFloat fontSize = 21.0f;
    UIFont *font = [UIFont fontWithName:fontName size:fontSize];
    UIColor *fontColor = [UIColor colorWithRed:.1607 green:.1607 blue:.1607 alpha:1.0];
    NSShadow *navTextShadow = [[NSShadow alloc] init];
    [navTextShadow setShadowColor:[UIColor grayColor]];
    [navTextShadow setShadowOffset:CGSizeMake(1, 1)];
    
    NSDictionary *attributes = @{NSFontAttributeName:font,
                                 NSForegroundColorAttributeName:fontColor,
                                 NSShadowAttributeName: navTextShadow};
    
    return attributes;
}


// BRKVenueTableViewCell: outlets

+ (UIFont *) venueNameFont {
    NSString *fontName = @"Avenir-Heavy";
    CGFloat fontSize = 18.0f;
    return [UIFont fontWithName:fontName size:fontSize];
}

+ (UIFont *) venueRatingFont {
    NSString *fontName = @"Avenir-Light";
    CGFloat fontSize = 16.0f;
    return [UIFont fontWithName:fontName size:fontSize];
}

+ (UIFont *) venueDistanceFont {
    NSString *fontName = @"Avenir-Light";
    CGFloat fontSize = 16.0f;
    return [UIFont fontWithName:fontName size:fontSize];
}

+ (UIFont *) venueDescriptiveBodyFont {
    NSString *fontName = @"AvenirNext-UltraLight";
    CGFloat fontSize = 14.0f;
    return [UIFont fontWithName:fontName size:fontSize];
}

// BRKHomeViewController: venue category scroll view

+ (UIFont *) venueCategoryScrollFont {
    NSString *fontName = @"Avenir-Heavy";
    CGFloat fontSize = 18.0f;
    return [UIFont fontWithName:fontName size:fontSize];
}

+ (UIColor *) venueCategoryScrollColor {
    UIColor *color = [UIColor darkGrayColor];
    return color;
}

// BRKSearchViewController

+ (UIFont *) sniffAroundLabelFont {
    NSString *fontName = @"Avenir-Heavy";
    CGFloat fontSize = 18.0f;
    return [UIFont fontWithName:fontName size:fontSize];
}

+ (UIFont *) closeButtonFont {
    NSString *fontName = @"Avenir-Medium";
    CGFloat fontSize = 16.0f;
    return [UIFont fontWithName:fontName size:fontSize];
}

+ (NSDictionary *) searchFieldPlaceHolderAttributes {
    NSString *fontName = @"AvenirNext-UltraLight";
    CGFloat fontSize = 148.0f;
    UIFont *font = [UIFont fontWithName:fontName size:fontSize];
    UIColor *fontColor = [UIColor orangeColor];
    
    NSDictionary *attributes = @{NSFontAttributeName:font,
                                 NSForegroundColorAttributeName:fontColor};
    
    return attributes;
}

// BRKDetailTableViewCell
+ (UIFont *) detailNameFont {
    return [BRKUIManager venueNameFont];
}

+ (UIFont *) detailRatingFont {
    NSString *fontName = @"Avenir-Light";
    CGFloat fontSize = 14.0f;
    return [UIFont fontWithName:fontName size:fontSize];
}

+ (UIFont *) detailPriceFont {
    return [BRKUIManager detailRatingFont];
}

+ (UIFont *) detailDistanceFont {
    return [BRKUIManager detailRatingFont];
}

+ (UIFont *) detailPhoneFont {
    NSString *fontName = @"Avenir-Medium";
    CGFloat fontSize = 14.0f;
    return [UIFont fontWithName:fontName size:fontSize];
}

+ (UIFont *) detailWebsiteFont {
    NSString *fontName = @"Avenir-Medium";
    CGFloat fontSize = 14.0f;
    return [UIFont fontWithName:fontName size:fontSize];
}

+ (UIFont *) detailOtherFont {
    return [BRKUIManager detailRatingFont];
}

// BRKCommentTableViewCell
+ (UIFont *) commentUserNameFont {
    NSString *fontName = @"Avenir-Medium";
    CGFloat fontSize = 16.0f;
    return [UIFont fontWithName:fontName size:fontSize];
}

+ (UIFont *) commentCommentFont {
    NSString *fontName = @"AvenirNext-UltraLight";
    CGFloat fontSize = 14.0f;
    return [UIFont fontWithName:fontName size:fontSize];
}

+ (UIFont *) commentDateFont {
    NSString *fontName = @"AvenirNext-UltraLight";
    CGFloat fontSize = 14.0f;
    return [UIFont fontWithName:fontName size:fontSize];
}



#pragma mark - MockUp Colors -

// -- Category Colors From Mock-Ups -- //
+(UIColor *) shoppingCategoryYellow{
    return [UIColor colorWithRed:0.9059 green:0.7490 blue:0.3569 alpha:1.0];
}
+(UIColor *) snackCategoryBlue{
    return [UIColor colorWithRed:0.1176 green:0.7137 blue:0.8941 alpha:1.0];
}
+(UIColor *) cafeCategoryTeal{
    return [UIColor colorWithRed:0.0039 green:0.6627 blue:0.6392 alpha:1.0];
}
+(UIColor *) playOutsideCategorySalmon{
    return [UIColor colorWithRed:0.9961 green:0.4196 blue:0.4000 alpha:1.0];
}
+(UIColor *) doSomethingAwesomeCerulean{
    return [UIColor colorWithRed:0.0000 green:0.5765 blue:0.6980 alpha:1.0];
}
+(UIColor *) categoryDotOrage{
    return [UIColor colorWithRed:0.9686 green:0.4431 blue:0.0510 alpha:1.0];
}
+(UIColor *) neutralNavBar{
    return [UIColor colorWithRed:0.937 green:0.937 blue:0.937 alpha:1.0];
}

// -- Font Colors from Mock-Ups -- //
+(UIColor *) venueTitleTextColor{
    return [UIColor colorWithRed:0.0471 green:0.6980 blue:0.8980 alpha:1.0];
}
+(UIColor *) allOtherTextGray{
    return [UIColor colorWithRed:0.2941 green:0.3020 blue:0.3098 alpha:1.0];
}

@end
