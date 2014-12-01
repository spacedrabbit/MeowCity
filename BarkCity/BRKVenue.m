//
//  BRKVenue.m
//  BarkCity
//
//  Created by Mykel Pereira on 11/24/14.
//  Copyright (c) 2014 com.rosamcgee. All rights reserved.
//

#import "BRKVenue.h"
#import <AFNetworking/AFHTTPRequestOperation.h>

NSString * const BRKVenueImageDidUpdateNotification = @"BRKVenueImageDidUpdateNotification";

@implementation BRKVenue
- (void)downloadPreviewImageInBackground
{
    NSMutableURLRequest *imageRequest = [NSMutableURLRequest requestWithURL:[self imageURLForOriginalSize]];
    [imageRequest addValue:@"image/*" forHTTPHeaderField:@"Accept"];
    
    AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:imageRequest];
    requestOperation.responseSerializer = [AFImageResponseSerializer serializer];
    
    __weak typeof (self) weakSelf = self;
    [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, UIImage *image) {
        typeof (self) strongSelf = weakSelf;
        if (strongSelf) {
            // may not need this, depends on size of images we would like to use
//            CGSize newSize = CGSizeMake(168.0f, 168.0f);
//            UIGraphicsBeginImageContext(newSize);
//            [image drawInRect:(CGRect){.origin = CGPointZero, .size = newSize}];
//            UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
//            UIGraphicsEndImageContext();
            
            strongSelf.previewImage = image;
            [[NSNotificationCenter defaultCenter] postNotificationName:BRKVenueImageDidUpdateNotification object:strongSelf];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
    }];
    [requestOperation start];
}

- (NSURL *)imageURLForOriginalSize
{
    NSString *imageURL = [NSString stringWithFormat:@"%@original%@", self.foursquareImagePrefix, self.foursquareImageSuffix];
    return [NSURL URLWithString:imageURL];
}

- (NSURL *)imageURLForSize:(CGSize)size
{
    CGFloat width = [[self class] roundToValidSize:size.width];
    NSString *imageURL = [NSString stringWithFormat:@"%@width%d%@", self.foursquareImagePrefix, (int)width, self.foursquareImageSuffix];
    return [NSURL URLWithString:imageURL];
}

+ (CGFloat)roundToValidSize:(CGFloat)value
{
    CGFloat newValue;
    if (value < 36.f) {
        newValue = 36.f;
    } else if (value < 100.f) {
        newValue = 100.f;
    } else if (value < 300.f) {
        newValue = 300.f;
    } else {
        newValue = 500.f;
    }
    return newValue;
}

@end
