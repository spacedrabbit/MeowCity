//
//  BRKReview.m
//  BarkCity
//
//  Created by Richard McAteer on 12/2/14.
//  Copyright (c) 2014 com.rosamcgee. All rights reserved.
//

#import "BRKReviewView.h"

@interface BRKReviewView ()

@property (strong, nonatomic) IBOutlet UIView *view;

@end

@implementation BRKReviewView

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:@"BRKReviewView" owner:self options:nil];
        [self addSubview:self.view];
    }
    return self;
}


@end
