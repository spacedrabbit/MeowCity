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