//
//  BRKVenueDetailTableViewController.m
//  BarkCity
//
//  Created by Charles Coutu-Nadeau on 11/27/14.
//  Copyright (c) 2014 com.rosamcgee. All rights reserved.
//

#import "BRKVenueDetailTableViewController.h"
#import "BRKVenueDetailTableViewCell.h"
#import "BRKPictureTableViewCell.h"

@interface BRKVenueDetailTableViewController ()

@end

@implementation BRKVenueDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // No separator between rows
    self.tableView.separatorColor = [UIColor clearColor];
    
    // Retrieve Nib of the two custom cell types.
    UINib *pictureCellNib = [UINib nibWithNibName:@"BRKPictureTableViewCell" bundle:nil];
    [self.tableView registerNib:pictureCellNib forCellReuseIdentifier:@"PictureCell"];
    
    UINib *dynamicCelllNib = [UINib nibWithNibName:@"BRKVenueDetailTableViewCell" bundle:nil];
    [self.tableView registerNib:dynamicCelllNib forCellReuseIdentifier:@"VenueDetailCell"];
    
    // Set dynamic row height and estimate for scrolling cursror
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 200.0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        BRKPictureTableViewCell *cell = (BRKPictureTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"PictureCell"];
        return cell;
    }
    
    BRKVenueDetailTableViewCell *cell = (BRKVenueDetailTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"VenueDetailCell" forIndexPath:indexPath];
    
    // conditional to test the dynamic length of the cells
    
    if (indexPath.row %2 == 0) {
        cell.userNameLabel.text = @"Mr. Jones";
        cell.userCommentLabel.text = @"I liked it.";
        cell.datePostedLabel.text = @"Today";
    } else {
        cell.userNameLabel.text = @"Ms. Jones";
        cell.userCommentLabel.text = @"I am not sure if I enjoyed it. At times, I can be very complicated regarding what I like and what I don't. I might like it one day but the other day I don't. It just takes me a very, ver, very long time to make up my mind, but when I do, I can do it clearly.";
        cell.datePostedLabel.text = @"A month ago";
    }
    
    return cell;
}

@end
