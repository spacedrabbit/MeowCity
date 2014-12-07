//
//  BRKSearchBarContainer.m
//  BarkCity
//
//  Created by Rosa McGee on 12/5/14.
//  Copyright (c) 2014 com.rosamcgee. All rights reserved.
//

#import "BRKSearchBarContainer.h"

@interface BRKSearchBarContainer()
@property (weak, nonatomic) IBOutlet UITextField *searchField;
@end

@implementation BRKSearchBarContainer

- (void)awakeFromNib {
    self.searchField.delegate = self;
}

- (BOOL)resignFirstResponder {
    return [self.searchField resignFirstResponder];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self.delegate searchFieldBeganNewSearch];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.delegate searchFieldDidReturnWithText:self.searchField.text];
    return [textField resignFirstResponder];
}

@end
