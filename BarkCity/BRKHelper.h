//
//  BRKHelper.h
//  BarkCity
//
//  Created by Mykel Pereira on 12/1/14.
//  Copyright (c) 2014 com.rosamcgee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@interface BRKHelper : NSObject
+ (CGFloat)normalizationWithValue:(CGFloat)value withMinimum:(CGFloat)minimum withMaximum:(CGFloat)maximum;
+ (CGFloat)lerpWithNormal:(CGFloat)normal withMinimum:(CGFloat)minimum withMaximum:(CGFloat)maximum;
@end
