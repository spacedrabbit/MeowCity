//
//  BRKHomeView.h
//  BarkCity
//
//  Created by Charles Coutu-Nadeau on 11/26/14.
//  Copyright (c) 2014 com.rosamcgee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BRKHomeView : UIView <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UIView *view;
@property (weak, nonatomic) IBOutlet UITableView *venuesTableView;

@end
