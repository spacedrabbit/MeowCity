//
//  BRKTableView.m
//  BarkCity
//
//  Created by Mykel Pereira on 12/5/14.
//  Copyright (c) 2014 com.rosamcgee. All rights reserved.
//

#import "BRKTableView.h"

@implementation BRKTableView

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    if (point.y < 0) {
        return nil;
    }
    
    return self;
}

@end
