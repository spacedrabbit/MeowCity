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
#import "BRKTip.h"
#import "BRKReviewViewController.h"
#import "BRKFoursquareClient.h"
#import <NSDate+DateTools.h>

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
    self.tableView.estimatedRowHeight = 100.0;
    
    // -- COMMENT BUTTON -- //
    //UIBarButtonItem * reviewButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(displayReviewViewController)];
    //[self.navigationItem setRightBarButtonItem:reviewButton animated:YES];
    BRKFoursquareClient *apiClient = [BRKFoursquareClient sharedClient];
    [apiClient requestTipsForPlace:self.venue limit:8 success:^(NSArray *tips) {
        self.venue.tips = [NSArray arrayWithArray:tips];
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self.tableView reloadData];
        }];
    } failure:^(NSError *error) {
        NSLog(@"Error requesting tips: %@", error.localizedDescription);
    }];
    

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
    return 2+[self.venue.tips count];
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
        cell.delegate = self;
        [cell setVenue:self.venue];
        return cell;
    }
    
    BRKCommentTableViewCell *cell = (BRKCommentTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"CommentCell" forIndexPath:indexPath];
    
    BRKTip *newTip = self.venue.tips[indexPath.row-2];
    if (newTip.lastName) {
        cell.userNameLabel.text = [NSString stringWithFormat:@"%@ %@", newTip.firstName, newTip.lastName];
    } else {
        cell.userNameLabel.text = [NSString stringWithFormat:@"%@", newTip.firstName];
    }
    cell.userCommentLabel.text = newTip.text;
    
    NSDate *timeAgoDate = [NSDate dateWithTimeIntervalSince1970:[newTip.createdAt integerValue]];
    cell.datePostedLabel.text = timeAgoDate.timeAgoSinceNow;
    
    return cell;
}

- (void) displayReviewViewController {
    BRKReviewViewController *vc = [[BRKReviewViewController alloc] init];
    [self presentViewController:vc animated:YES completion:^{
        NSLog(@"New review");
    }];
}

- (void) call:(BRKDetailTableViewCell *)sender phone:(NSString *)phone {
    
    NSString *cleanPhone = [phone stringByReplacingOccurrencesOfString:@"(" withString:@""];
    cleanPhone = [cleanPhone stringByReplacingOccurrencesOfString:@")" withString:@""];
    cleanPhone = [cleanPhone stringByReplacingOccurrencesOfString:@" " withString:@""];
    cleanPhone = [cleanPhone stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"Call"
                                          message:phone
                                          preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction
                                   actionWithTitle:NSLocalizedString(@"Cancel", @"Cancel action")
                                   style:UIAlertActionStyleCancel
                                   handler:^(UIAlertAction *action)
                                   {
                                       NSLog(@"Cancel action");
                                   }];
    
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                                   NSLog(@"OK action");
                                   NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", cleanPhone]];
                                   [[UIApplication  sharedApplication] openURL:url];
                               }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
