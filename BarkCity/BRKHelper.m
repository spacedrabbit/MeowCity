//
//  BRKHelper.m
//  BarkCity
//
//  Created by Mykel Pereira on 12/1/14.
//  Copyright (c) 2014 com.rosamcgee. All rights reserved.
//

#import "BRKHelper.h"

@implementation BRKHelper
+ (CGFloat)normalizationWithValue:(CGFloat)value withMinimum:(CGFloat)minimum withMaximum:(CGFloat)maximum
{
    return (value - minimum) / (maximum - minimum);
}

+ (CGFloat)lerpWithNormal:(CGFloat)normal withMinimum:(CGFloat)minimum withMaximum:(CGFloat)maximum
{
    return (maximum - minimum) * normal + minimum;
}
@end
