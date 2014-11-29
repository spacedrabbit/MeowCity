//
//  BRKScrollView.m
//  BarkCity
//
//  Created by Louis Tur on 11/24/14.
//  Copyright (c) 2014 com.rosamcgee. All rights reserved.
//

#import "BRKScrollView.h"

@implementation BRKScrollView

+(instancetype) createScrollViewFromFrame:(CGRect)frameRect withSubViews:(NSArray *)views ofFullWidth:(BOOL)fullWidth{
    
    // --  method variables -- //
    NSInteger subViewCount = !views ? 1 : [views count];
    
    // -------------------//
    // -- Views set up -- //
    // -------------------//
    
    // setting the frame for the scroll view will define it's proper location in it's super view
    BRKScrollView * brkScrollView = [[BRKScrollView alloc] initWithFrame:frameRect];
    [brkScrollView setUserInteractionEnabled:YES];
    [brkScrollView setShowsHorizontalScrollIndicator:YES];
    
    UIView * brkContentView = [[UIView alloc] init];
    if (fullWidth) {
        // the content view will be drawn relative to the scroll view, so it's origin will be 0,0
        [brkContentView setFrame:CGRectMake(0.0, 0.0, frameRect.size.width * subViewCount, frameRect.size.height)];
    }
    else{
        // !! not fully implemented
        CGFloat largestWidth = 0.0;
        for (UILabel * view in views) {
            NSDictionary * attributeValues = [view.attributedText attributesAtIndex:0 effectiveRange:nil];
            CGSize labelSizes = [view.attributedText.string sizeWithAttributes:attributeValues];
            //NSLog(@"Size: W:%f   H:%f ", labelSizes.width, labelSizes.height );
            if (labelSizes.width > largestWidth) {
                largestWidth = labelSizes.width;
            }
        }
        [brkContentView setFrame:CGRectMake(0.0, 0.0, (largestWidth+10) * subViewCount, frameRect.size.height)];
    }
    [brkScrollView addSubview:brkContentView];
    [brkScrollView setContentSize:brkContentView.frame.size];
    [brkScrollView setPagingEnabled:YES];
    
    // iterates over the array of views, placing them on in the content view
    for (NSInteger i = 0; i < subViewCount; i++ ){
        
        UIView * currentView = (UIView *)views[i];
        [currentView setFrame:CGRectMake( i * frameRect.size.width, 0.0, frameRect.size.width,  frameRect.size.height)];
        [brkContentView addSubview:currentView];
        
    }
    
    return brkScrollView;

}
+(instancetype) createScrollViewFromFrame:(CGRect)frameRect withSubViews:(NSArray *)views{
    return [self createScrollViewFromFrame:frameRect withSubViews:views ofFullWidth:YES];
}
+(instancetype) createScrollViewFromFrame:(CGRect)frameRect{
    return [self createScrollViewFromFrame:frameRect withSubViews:nil];
}
+(instancetype) createScrollViewFromCurrentDisplay{
    
    CGFloat kScreenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat kScreenHeight = [UIScreen mainScreen].bounds.size.height;
    
    return [self createScrollViewFromFrame:CGRectMake(0.0, 0.0, kScreenWidth, kScreenHeight) withSubViews:nil];
}

// AutoLayout Version - To Do
//
//+(instancetype) createScrollViewWithRect:(CGRect)scrollRect andSubViews:(NSArray *)views {
//    
//    // -- Views set up -- //
//    BRKScrollView * brkScrollView = [[BRKScrollView alloc] init];
//    [brkScrollView setUserInteractionEnabled:YES];
//    [brkScrollView setShowsHorizontalScrollIndicator:YES];
//    
//    UIView * brkContentView = [[UIView alloc] init];
//    [brkContentView setTranslatesAutoresizingMaskIntoConstraints:NO];
//    [brkScrollView addSubview:brkContentView];
//    
//    // -- Parameters for Visual Formatting -- //
//    NSDictionary * rectMetrics = @{ @"originX"  : [NSNumber numberWithDouble:   scrollRect.origin.x     ],
//                                    @"originY"  : [NSNumber numberWithDouble:   scrollRect.origin.y     ],
//                                    @"width"    : [NSNumber numberWithDouble:   scrollRect.size.width   ],
//                                    @"height"   : [NSNumber numberWithDouble:   scrollRect.size.height  ]  };
//    
//    NSDictionary * rectBindings = NSDictionaryOfVariableBindings(brkContentView, brkScrollView);
//    
//    // -- Method Variables -- //
//    NSInteger subViewCount = [views count];
//    CGFloat contentViewWidth = [rectMetrics[@"width"] doubleValue] * subViewCount;
//    
//    // -- Extract subviews -- //
//    NSMutableDictionary * viewsReference = [[NSMutableDictionary alloc] init];
//    NSMutableString * subViewFormatString = [[NSMutableString alloc] init];
//    for (NSInteger i = 0; i < subViewCount; i++) {
//        
//        id currentView = views[i];
//        
//        [brkContentView addSubview:currentView];
//        NSString * viewName = [NSString stringWithFormat:@"%@-%li", NSStringFromClass([currentView class]), (long)i];
//        [viewsReference setObject:currentView forKey:viewName];
//        
//        [subViewFormatString appendFormat:@"%@|",viewName]; // to pass to format string in constraints
//    }
//    
//    
//    /**********************************************************************************
//     *
//     *      Programmatic Layout -- Content
//     *
//     ***********************************************************************************/
//    
//    NSArray * brkContentHorizontal = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|brkContentView|"
//                                                                             options:0
//                                                                             metrics:rectMetrics
//                                                                               views:rectBindings];
//    
//    NSArray * brkContentVertical = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|brkContentView(==height)"
//                                                                           options:0
//                                                                           metrics:rectMetrics
//                                                                             views:rectBindings];
//    [brkScrollView addConstraints:brkContentHorizontal];
//    [brkScrollView addConstraints:brkContentVertical];
//    
//    /**********************************************************************************
//     *
//     *      Programmatic Layout -- Views
//     *
//     ***********************************************************************************/
//#pragma -- To do --
//    NSArray * allSubViewsHorizontalContraints = [NSLayoutConstraint constraintsWithVisualFormat:@""
//                                                                                        options:0
//                                                                                        metrics:nil
//                                                                                          views:nil];
//    NSArray * allSubViewsVerticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@""
//                                                                                       options:0
//                                                                                       metrics:nil
//                                                                                         views:nil];
//    
//    return self;
//}



@end
