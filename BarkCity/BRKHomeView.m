//
//  BRKHomeView.m
//  BarkCity
//
//  Created by Charles Coutu-Nadeau on 11/26/14.
//  Copyright (c) 2014 com.rosamcgee. All rights reserved.
//

#import "BRKHomeView.h"
#import "BRKLocationTableViewCell.h"
#import "BRKPictureTableViewCell.h"

@interface BRKHomeView()

@end

@implementation BRKHomeView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:@"BRKHome" owner:self options:nil];
        self.venuesTableView.delegate = self;
        self.venuesTableView.dataSource = self;
        
        UINib *pictureCellNib = [UINib nibWithNibName:@"BRKPictureTableViewCell" bundle:nil];
        [self.venuesTableView registerNib:pictureCellNib forCellReuseIdentifier:@"PictureCell"];
        
        [self.venuesTableView registerNib:[UINib nibWithNibName:@"BRKLocationTableViewCell" bundle:nil] forCellReuseIdentifier:@"VenueCell"];
        
        [self addSubview:self.view];
    }
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
    
    // Picture cell on top
    if (indexPath.row == 0) {
         BRKPictureTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PictureCell"];
        return cell;
    }
    
    // Venues cell below picture
    else {
        BRKLocationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VenueCell"];
        // Configure cell
        return cell;
    }
    return nil;
}

@end
