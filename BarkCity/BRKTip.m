//
//  BRKTip.m
//  BarkCity
//
//  Created by Mykel Pereira on 12/9/14.
//  Copyright (c) 2014 com.rosamcgee. All rights reserved.
//

#import "BRKTip.h"

@implementation BRKTip
- (instancetype)initWithText:(NSString *)text createdAt:(NSNumber *)createdAt likes:(NSNumber *)likes firstName:(NSString *)firstName lastName:(NSString *)lastName
{
    self = [super init];
    if (self) {
        _text = [text copy];
        _createdAt = [createdAt copy];
        _likes = [likes copy];
        _firstName = [firstName copy];
        _lastName = [lastName copy];
    }
    
    return self;
}
@end
