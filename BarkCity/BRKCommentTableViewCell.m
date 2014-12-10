//
//  BRKVenueDetailTableViewCell.m
//  BarkCity
//
//  Created by Charles Coutu-Nadeau on 11/24/14.
//  Copyright (c) 2014 com.rosamcgee. All rights reserved.
//

#import "BRKCommentTableViewCell.h"
#import "BRKUIManager.h"

@implementation BRKCommentTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    // Make profile image circular
    self.userProfileImage.layer.cornerRadius = self.userProfileImage.frame.size.width / 2;
    self.userProfileImage.clipsToBounds = YES;
    // Picture for now
    
    NSInteger color = arc4random_uniform(5);
    
    switch (color) {
        case 0:
            self.userProfileImage.backgroundColor = [UIColor colorWithRed:76.0/255.0 green:181.0/255.0 blue:225.0/255.0 alpha:1];
            break;
            
        case 1:
            self.userProfileImage.backgroundColor = [UIColor colorWithRed:37.0/255.0 green:145.0/255.0 blue:175.0/255.0 alpha:1];
            break;
        case 2:
            self.userProfileImage.backgroundColor = [UIColor colorWithRed:234.0/255.0 green:124.0/255.0 blue:50.0/255.0 alpha:1];
            break;
        case 3:
            self.userProfileImage.backgroundColor = [UIColor colorWithRed:231.0/255.0 green:191.0/255.0 blue:91.0/255.0 alpha:1];
            break;
        case 4:
            self.userProfileImage.backgroundColor = [UIColor colorWithRed:1.0/255.0 green:169.0/255.0 blue:163.0/255.0 alpha:1];
            break;
        case 5:
            self.userProfileImage.backgroundColor = [UIColor colorWithRed:239.0/255.0 green:123.0/255.0 blue:111.0/255.0 alpha:1];
            break;
        default:
            break;
    }
    self.userProfileImage.tintColor = [UIColor whiteColor];
    
    [self setLook];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setLook {
    self.userNameLabel.font = [BRKUIManager commentUserNameFont];
    self.userCommentLabel.font = [BRKUIManager commentCommentFont];
    self.datePostedLabel.font = [BRKUIManager commentDateFont];
}

@end
