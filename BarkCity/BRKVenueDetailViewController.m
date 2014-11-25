//
//  BRKVenueDetailViewController.m
//  BarkCity
//
//  Created by Richard McAteer on 11/25/14.
//  Copyright (c) 2014 com.rosamcgee. All rights reserved.
//

#import "BRKVenueDetailViewController.h"
#import "BRKVenueDetailView.h"
#import "BRKVenue.h"

@interface BRKVenueDetailViewController ()

@property (strong, nonatomic) IBOutlet BRKVenueDetailView *venueDetailView;

@end

@implementation BRKVenueDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
        self.venueDetailView.nameLabel.text = self.venue.name;
        self.venueDetailView.ratingLabel.text = [NSString stringWithFormat:@"%@", self.venue.rating];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

//- (void)setVenue:(BRKVenue *)venue
//{
//    _venue = venue;
//    self.venueDetailView.nameLabel.text = _venue.name;
//    self.venueDetailView.ratingLabel.text = [NSString stringWithFormat:@"%@", _venue.rating];
//}

@end
