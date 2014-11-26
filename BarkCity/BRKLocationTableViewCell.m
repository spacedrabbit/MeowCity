//
//  BRKLocationTableViewCell.m
//  BarkCity
//
//  Created by Richard McAteer on 11/24/14.
//  Copyright (c) 2014 com.rosamcgee. All rights reserved.
//

#import "BRKLocationTableViewCell.h"
#import "Masonry.h"

@implementation BRKLocationTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//- (void)setupConstraints {
//    
//    UIEdgeInsets padding = UIEdgeInsetsMake(10, 10, 10, 10);
//    
//    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.mas_top).with.offset(padding.top);
//        make.left.equalTo(self.mas_left).with.offset(padding.left);
//        make.height.equalTo(@25);
//        make.width.equalTo(@200);
//    }];
//    
//    [self.ratingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.nameLabel.mas_bottom).with.offset(2);
//        make.left.equalTo(self.mas_left).with.offset(padding.left);
//        make.height.equalTo(@25);
//        make.width.equalTo(@100);
//    }];
//    
//    [self.distanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.nameLabel.mas_bottom).with.offset(2);
//        make.right.equalTo(self.nameLabel.mas_right).with.offset(-2);
//        
//    }];
//}


@end
