//
//  BRKVenueDetailTableViewCell.h
//  BarkCity
//
//  Created by Charles Coutu-Nadeau on 11/24/14.
//  Copyright (c) 2014 com.rosamcgee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BRKVenueDetailTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *userProfileImage;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userCommentLabel;
@property (weak, nonatomic) IBOutlet UILabel *datePostedLabel;

@end
