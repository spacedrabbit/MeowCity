//
//  BRKVenue.m
//  BarkCity
//
//  Created by Mykel Pereira on 11/24/14.
//  Copyright (c) 2014 com.rosamcgee. All rights reserved.
//

#import "BRKVenue.h"
#import <AFNetworking/AFHTTPRequestOperation.h>

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

@end
