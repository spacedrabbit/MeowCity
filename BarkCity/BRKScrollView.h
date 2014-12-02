//
//  BRKScrollView.h
//  BarkCity
//
//  Created by Louis Tur on 11/24/14.
//  Copyright (c) 2014 com.rosamcgee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BRKScrollView : UIScrollView

-(void) reloadBRKSubViews;

+(instancetype) createScrollViewFromFrame:(CGRect)frameRect withSubViews:(NSArray *)views;

+(instancetype) createScrollViewFromFrame:(CGRect)frameRect withSubViews:(NSArray *)views ofFullWidth:(BOOL)fullWidth;

@end
