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
    CGFloat fontSize = 18.0f;
    UIFont *font = [UIFont fontWithName:fontName size:fontSize];
    UIColor *fontColor = [UIColor blackColor];
    
    NSDictionary *attributes = @{NSFontAttributeName:font,
                                 NSForegroundColorAttributeName:fontColor};
    
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

#pragma warning - searchFieldPlaceHolderAttributes doesn't work right now
+ (NSDictionary *) searchFieldPlaceHolderAttributes {
    NSString *fontName = @"AvenirNext-UltraLight";
    CGFloat fontSize = 148.0f;
    UIFont *font = [UIFont fontWithName:fontName size:fontSize];
    UIColor *fontColor = [UIColor blackColor];
    
    NSDictionary *attributes = @{NSFontAttributeName:font,
                                 NSForegroundColorAttributeName:fontColor};
    
    return attributes;
}


@end
