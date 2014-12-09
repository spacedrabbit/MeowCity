//
//  BRKTip.h
//  BarkCity
//
//  Created by Mykel Pereira on 12/9/14.
//  Copyright (c) 2014 com.rosamcgee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BRKTip : NSObject
@property (nonatomic, readonly) NSString *text;
@property (nonatomic, readonly) NSNumber *createdAt;
@property (nonatomic, readonly) NSNumber *likes;
@property (nonatomic, readonly) NSString *firstName;
@property (nonatomic, readonly) NSString *lastName;

- (instancetype)initWithText:(NSString *)text createdAt:(NSNumber *)createdAt likes:(NSNumber *)likes firstName:(NSString *)firstName lastName:(NSString *)lastName;
@end
