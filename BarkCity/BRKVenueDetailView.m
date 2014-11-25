//
//  BRKVenueDetailView.m
//  BarkCity
//
//  Created by Charles Coutu-Nadeau on 11/24/14.
//  Copyright (c) 2014 com.rosamcgee. All rights reserved.
//

#import "BRKVenueDetailView.h"
#import "BRKVenueDetailTableViewCell.h"

@interface BRKVenueDetailView()

@property (strong, nonatomic) IBOutlet UIView *view;
@property (weak, nonatomic) IBOutlet UITableView *commentsTableView;

@end

@implementation BRKVenueDetailView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:@"BRKVenueDetail" owner:self options:nil];
        self.commentsTableView.delegate = self;
        self.commentsTableView.dataSource = self;
        [self.commentsTableView registerNib:[UINib nibWithNibName:@"BRKVenueDetailTableViewCell" bundle:nil] forCellReuseIdentifier:@"CellIdentifier"];
        [self addSubview:self.view];
    }
    NSLog(@"Brought in with Storyboards");
    return self;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Write code to deselect row
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifer = @"CellIdentifier";
    BRKVenueDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifer];
    
    if (cell == nil) {
        cell = [[BRKVenueDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifer];
    }
    
    cell.userNameLabel.text = [NSString stringWithFormat:@"%ld", indexPath.row];
    
    return cell;
}


@end
