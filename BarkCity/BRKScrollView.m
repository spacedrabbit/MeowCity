//
//  BRKScrollView.m
//  BarkCity
//
//  Created by Louis Tur on 11/24/14.
//  Copyright (c) 2014 com.rosamcgee. All rights reserved.
//

#import "BRKScrollView.h"

@implementation BRKScrollView

+(instancetype) createScrollViewWithRect:(CGRect)scrollRect andSubViews:(NSArray *)views {
    
    // -- Views set up -- //
    BRKScrollView * brkScrollView = [[BRKScrollView alloc] init];
    [brkScrollView setUserInteractionEnabled:YES];
    [brkScrollView setShowsHorizontalScrollIndicator:YES];
    
    UIView * brkContentView = [[UIView alloc] init];
    [brkContentView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [brkScrollView addSubview:brkContentView];
    
    // -- Parameters for Visual Formatting -- //
    NSDictionary * rectMetrics = @{ @"originX"  : [NSNumber numberWithDouble:   scrollRect.origin.x     ],
                                    @"originY"  : [NSNumber numberWithDouble:   scrollRect.origin.y     ],
                                    @"width"    : [NSNumber numberWithDouble:   scrollRect.size.width   ],
                                    @"height"   : [NSNumber numberWithDouble:   scrollRect.size.height  ]  };
    
    NSDictionary * rectBindings = NSDictionaryOfVariableBindings(brkContentView, brkScrollView);

    // -- Method Variables -- //
    NSInteger subViewCount = [views count];
    CGFloat contentViewWidth = [rectMetrics[@"width"] doubleValue] * subViewCount;
    
    // -- Extract subviews -- //
    NSMutableDictionary * viewsReference = [[NSMutableDictionary alloc] init];
    NSMutableString * subViewFormatString = [[NSMutableString alloc] init];
    for (NSInteger i = 0; i < subViewCount; i++) {
        
        id currentView = views[i];
        
        [brkContentView addSubview:currentView];
        NSString * viewName = [NSString stringWithFormat:@"%@-%li", NSStringFromClass([currentView class]), (long)i];
        [viewsReference setObject:currentView forKey:viewName];
        
        [subViewFormatString appendFormat:@"%@|",viewName]; // to pass to format string in constraints
    }
    
    
    /**********************************************************************************
     *
     *      Programmatic Layout -- Content
     *
     ***********************************************************************************/
    
    NSArray * brkContentHorizontal = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|brkContentView|"
                                                                             options:0
                                                                             metrics:rectMetrics
                                                                               views:rectBindings];
    
    NSArray * brkContentVertical = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|brkContentView(==height)"
                                                                           options:0
                                                                           metrics:rectMetrics
                                                                             views:rectBindings];
    [brkScrollView addConstraints:brkContentHorizontal];
    [brkScrollView addConstraints:brkContentVertical];
    
    /**********************************************************************************
     *
     *      Programmatic Layout -- Views
     *
     ***********************************************************************************/
#pragma -- To do --
    NSArray * allSubViewsHorizontalContraints = [NSLayoutConstraint constraintsWithVisualFormat:@""
                                                                                        options:0
                                                                                        metrics:nil
                                                                                          views:nil];
    NSArray * allSubViewsVerticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@""
                                                                                       options:0
                                                                                       metrics:nil
                                                                                         views:nil];
    
    return self;
}

+(instancetype) createScrollViewFromFrame:(CGRect)frameRect withSubViews:(NSArray *)views{
    
    // -- rando method variables -- //
    NSInteger subViewCount = [views count];
    
    // -------------------//
    // -- Views set up -- //
    // -------------------//
    
    // setting the frame for the scroll view will define it's proper location in it's super view
    BRKScrollView * brkScrollView = [[BRKScrollView alloc] initWithFrame:frameRect];
    [brkScrollView setUserInteractionEnabled:YES];
    [brkScrollView setShowsHorizontalScrollIndicator:YES];
    
    // the content view will be drawn relative to the scroll view, so it's origin will be 0,0
    // though, the width will be dependant on the screen size and number of views passed in
    UIView * brkContentView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, frameRect.size.width * subViewCount, frameRect.size.height)];
    [brkContentView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    // -- adding content view to scroll, setting some values
    [brkScrollView addSubview:brkContentView];
    [brkScrollView setContentSize:brkContentView.frame.size];
    [brkScrollView setPagingEnabled:YES];

    // iterates over the array of views, placing them on in the content view
    for (NSInteger i = 0; i < subViewCount; i++ ){
        
        UIView * currentView = (UIView *)views[i];
        // updated this CGRect's x value, as it should account for frames that are offset from 0.0
        [currentView setFrame:CGRectMake( i * (frameRect.size.width + frameRect.origin.x), 0.0, frameRect.size.width,  frameRect.size.height)];
        [brkContentView addSubview:currentView];
        
    }
    
    return brkScrollView;
}

+(instancetype) createScrollViewWithRect:(CGRect)scrollRect{
    return [self createScrollViewWithRect:scrollRect andSubViews:nil];
}

+(instancetype) createScrollViewFromCurrentDisplay{
    
    CGFloat kScreenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat kScreenHeight = [UIScreen mainScreen].bounds.size.height;
    
    return [self createScrollViewWithRect:CGRectMake(0.0, 0.0, kScreenWidth, kScreenHeight) andSubViews:nil];
}


@end
