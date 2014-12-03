//
//  BRKPictureTableViewCell.h
//  BarkCity
//
//  Created by Charles Coutu-Nadeau on 11/27/14.
//  Copyright (c) 2014 com.rosamcgee. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BRKVenue;

@protocol BRKPictureTableViewCellDelegate <NSObject>

- (void)segueToReviewViewController;

@end

@interface BRKPictureTableViewCell : UITableViewCell

@property (nonatomic, strong) id delegate;
@property (weak, nonatomic) IBOutlet UIImageView *picture;
@property (strong, nonatomic) IBOutlet UIButton *reviewButton;
- (IBAction)reviewButtonTapped:(id)sender;


@end
