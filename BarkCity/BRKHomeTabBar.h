//
//  BRKHomeTabBar.h
//  BarkCity
//
//  Created by Louis Tur on 12/7/14.
//  Copyright (c) 2014 com.rosamcgee. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BRKHomeTabBarDelegate <NSObject>
@required
-(void)didSelectTabButton:(NSInteger)tabButtonIndex;

@optional
-(void) checkForSelectedTab;

@end

@interface BRKHomeTabBar : UIView

@property (strong, nonatomic) IBOutlet UIView *tabBarView;

@property (weak, nonatomic) IBOutlet UIButton *firstTabButton;
@property (weak, nonatomic) IBOutlet UIButton *secondTabButton;
@property (weak, nonatomic) IBOutlet UIButton *thirdTabButton;
@property (weak, nonatomic) IBOutlet UIButton *fourthTabButton;
@property (weak, nonatomic) IBOutlet UIButton *fifthTabButton;

@property (weak, nonatomic) id<BRKHomeTabBarDelegate> delegate;

@end
