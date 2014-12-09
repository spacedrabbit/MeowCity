//
//  BRKFoursquareClient.m
//  BarkCity
//
//  Created by Mykel Pereira on 11/24/14.
//  Copyright (c) 2014 com.rosamcgee. All rights reserved.
//

#import "BRKFoursquareClient.h"
#import "AFHTTPRequestOperationManager.h"
#import "BRKVenue.h"

#define CLIENT_ID @"BLU5G2IFZJ03ITEMFCFSCNFQHHE5ZCV0H3F24IWSBX0PPRC5"
#define CLIENT_SECRET @"MRLRF0F3XOU00440F1CONS2TSE5B12J2J02TS4B5FJB3JXJC"

@implementation BRKFoursquareClient
{
    AFHTTPRequestOperationManager *_requestOperationManager;
}

+ (instancetype)sharedClient
{
    static BRKFoursquareClient *sharedClient;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedClient = [[self alloc] init];
    });
    return sharedClient;
}

- (instancetype)init
{
    if (self = [super init]) {
        _requestOperationManager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:@"https://api.foursquare.com/"]];
    }
    return self;
}

- (void)requestVenuesForQuery:(NSString *)query location:(CLLocation *)location limit:(NSUInteger)limit success:(void (^)(NSArray *venues))success failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"client_id"] = CLIENT_ID;
    parameters[@"client_secret"] = CLIENT_SECRET;
    parameters[@"query"] = query;
    parameters[@"v"] = @"20140408";
    parameters[@"limit"] = @(limit);
    parameters[@"venuePhotos"] = @1; //change depending on how many we would like
    parameters[@"ll"] = [NSString stringWithFormat:@"%f,%f", location.coordinate.latitude, location.coordinate.longitude];
    
    NSString *queryString = @"https://api.foursquare.com/v2/venues/explore";
    [_requestOperationManager GET:queryString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            NSArray *groups = responseObject[@"response"][@"groups"];
            if (groups) {
                NSMutableArray *venues = [[NSMutableArray alloc] init];
                for (NSDictionary *groupDictionary in groups) {
                    if ([groupDictionary[@"name"] isEqualToString:@"recommended"]) {
                        for (NSDictionary *itemDictionary in groupDictionary[@"items"]) {
                            
                            // Venue dictionary is the first layer of dictionary we receive from Foursquare
                            NSDictionary *venueDictionary = itemDictionary[@"venue"];
                            
                            BRKVenue *venue = [[BRKVenue alloc] init];
                            venue.foursquareId = [venueDictionary objectForKey:@"id"];
                            venue.name = [venueDictionary objectForKey:@"name"];
                            venue.rating = [venueDictionary objectForKey:@"rating"];
                            venue.website = [venueDictionary objectForKey:@"url"];
                            
                            NSDictionary *locationDictionary = [venueDictionary objectForKey:@"location"];
                            venue.address = [locationDictionary objectForKey:@"address"];
                            venue.city = [locationDictionary objectForKey:@"city"];
                            venue.state = [locationDictionary objectForKey:@"state"];
                            venue.postalCode = [locationDictionary objectForKey:@"postalCode"];
                            venue.latitude = [locationDictionary objectForKey:@"lat"];
                            venue.longitude = [locationDictionary objectForKey:@"lng"];
                            venue.distance = [locationDictionary objectForKey:@"distance"];
                            // Formatted address is an array. Need to convert in a string.
                            NSArray *formattedAddressArray = [locationDictionary objectForKey:@"formattedAddress"];
                            if ([formattedAddressArray count] > 1) {
                                //Just taking the address (0th element) and city (1st element).
                                venue.formattedAddress = [NSString stringWithFormat:@"%@, %@", formattedAddressArray[0], formattedAddressArray[1]];
                            } else if ([formattedAddressArray count] == 1) {
                                venue.formattedAddress = venue.address;
                            }
                            
                            NSDictionary *photoGroupDictionary = [venueDictionary[@"photos"][@"groups"] firstObject];
                            NSDictionary *photoDictionary = [photoGroupDictionary[@"items"] firstObject];
                            
                            venue.foursquareImagePrefix = [photoDictionary objectForKey:@"prefix"];
                            venue.foursquareImageSuffix = [photoDictionary objectForKey:@"suffix"];
                            
                            // Contact dictionary
                            NSDictionary *contactDictionary = [venueDictionary objectForKey:@"contact"];
                            venue.phone = [contactDictionary objectForKey:@"phone"];
                            venue.formattedPhone = [contactDictionary objectForKey:@"formattedPhone"];
                            
                            // Hours dictionary
                            NSDictionary *hoursDictionary = [venueDictionary objectForKey:@"hours"];
                            venue.hours = [hoursDictionary objectForKey:@"status"];
                            
                            // Price dictionary
                            NSDictionary *priceDictionary = [venueDictionary objectForKey:@"price"];
                            venue.price = [priceDictionary objectForKey:@"tier"];
                            
                            // Tips Array contains dictionaries for each tip
                            venue.tips = [venueDictionary objectForKey:@"tips"];
                            if ([venue.tips count] > 0) {
                                NSDictionary *firstTipDictionary = venue.tips[0];
                                venue.firstTip = [firstTipDictionary objectForKey:@"text"];
                            }
                            
                            [venues addObject:venue];
                        }
                    }
                }
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                        success(venues);
                }];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}
@end
