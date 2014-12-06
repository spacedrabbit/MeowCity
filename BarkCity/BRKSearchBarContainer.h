//
//  BRKSearchBarContainer.h
//  BarkCity
//
//  Created by Rosa McGee on 12/5/14.
//  Copyright (c) 2014 com.rosamcgee. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BRKSearchBarContainerDelegate <NSObject>
- (void)searchFieldBeganNewSearch;
- (void)searchFieldDidReturnWithText:(NSString *)searchText;
@end

@interface BRKSearchBarContainer : UIView
@property (nonatomic, weak) id <BRKSearchBarContainerDelegate> delegate;
@end
