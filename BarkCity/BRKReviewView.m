//
//  BRKReview.m
//  BarkCity
//
//  Created by Richard McAteer on 12/2/14.
//  Copyright (c) 2014 com.rosamcgee. All rights reserved.
//

#import "BRKReviewView.h"
#import "Masonry.h"

@implementation BRKReviewView

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:@"BRKReviewView" owner:self options:nil];
    }
    NSLog(@"Brought in with Storyboards");
    return self;
}

- (void)autolayout {
    [self.reviewTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(self.bounds.size.height);
        make.width.mas_equalTo(self.bounds.size.width);
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.mas_left);
    }];
}


@end
