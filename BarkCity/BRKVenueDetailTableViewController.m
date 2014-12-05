//
//  BRKVenueDetailTableViewController.m
//  BarkCity
//
//  Created by Charles Coutu-Nadeau on 11/27/14.
//  Copyright (c) 2014 com.rosamcgee. All rights reserved.
//

#import "BRKVenueDetailTableViewController.h"
#import "BRKPictureTableViewCell.h"
#import "BRKDetailTableViewCell.h"
#import "BRKCommentTableViewCell.h"
#import "BRKVenue.h"
#import "BRKReviewViewController.h"

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
    
    UINib *detailCellNib = [UINib nibWithNibName:@"BRKDetailTableViewCell" bundle:nil];
    [self.tableView registerNib:detailCellNib forCellReuseIdentifier:@"DetailCell"];
    
    UINib *dynamicCelllNib = [UINib nibWithNibName:@"BRKCommentTableViewCell" bundle:nil];
    [self.tableView registerNib:dynamicCelllNib forCellReuseIdentifier:@"CommentCell"];
    
    // Set dynamic row height and estimate for scrolling cursror
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 200.0;
    
    
    // -- SEARCH BUTTON -- //
    UIBarButtonItem * reviewButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(displayReviewViewController)];
    [self.navigationController.navigationBar.topItem setRightBarButtonItem:reviewButton animated:YES];

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
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
        cell.picture.image = self.venue.previewImage;
        cell.delegate = self;
        return cell;
    }
    
    if (indexPath.row == 1) {
        BRKDetailTableViewCell *cell = (BRKDetailTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"DetailCell"];
        return cell;
    }
    
    BRKCommentTableViewCell *cell = (BRKCommentTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"CommentCell" forIndexPath:indexPath];
    
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

- (void) displayReviewViewController {
    BRKReviewViewController *vc = [[BRKReviewViewController alloc] init];
    [self presentViewController:vc animated:YES completion:^{
        NSLog(@"New review");
    }];
}

@end
