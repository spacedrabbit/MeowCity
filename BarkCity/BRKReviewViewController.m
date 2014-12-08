//
//  BRKReviewViewController.m
//  BarkCity
//
//  Created by Richard McAteer on 12/2/14.
//  Copyright (c) 2014 com.rosamcgee. All rights reserved.
//

#import "BRKReviewViewController.h"
#import "BRKReviewView.h"
#import <ParseUI/ParseUI.h>
#import <Parse/Parse.h>

@interface BRKReviewViewController ()

@end

@implementation BRKReviewViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (![PFUser currentUser]) {
        PFLogInViewController *loginViewController = [[PFLogInViewController alloc] init];
        [loginViewController setDelegate:self];
        
        PFSignUpViewController *signupViewController = [[PFSignUpViewController alloc] init];
        [signupViewController setDelegate:self];
        
        [loginViewController setSignUpController:signupViewController];
        
        [self presentViewController:loginViewController animated:YES completion:nil];
    } else {
        NSLog(@"Current user is %@:", [PFUser currentUser]);
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    NSArray *xibContents = [[NSBundle mainBundle] loadNibNamed:@"BRKReviewView" owner:self options:nil];
//    BRKReviewView *newReviewView = [xibContents lastObject];
//    [self.view addSubview:newReviewView];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/**********************************************************************************
 *
 *                  LoginViewControllerDelegate
 *
 ***********************************************************************************/
- (BOOL)logInViewController:(PFLogInViewController *)logInController shouldBeginLogInWithUsername:(NSString *)username password:(NSString *)password {
    if (username && password && username.length != 0 && password.length != 0) {
        return YES;
    }
    
    [[[UIAlertView alloc] initWithTitle:@"Oops! Looks like you missed some information."
                                message:@"Please fill out all the fields!"
                               delegate:nil
                      cancelButtonTitle:@"ok"
                      otherButtonTitles:nil] show];
    return NO;
}
- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)logInViewController:(PFLogInViewController *)logInController didFailToLogInWithError:(NSError *)error {
    NSLog(@"Failed to log in...");
}

- (void)logInViewControllerDidCancelLogIn:(PFLogInViewController *)logInController {
    [self.navigationController popViewControllerAnimated:YES];
}

/**********************************************************************************
 *
 *                  SignUpViewControllerDelegate
 *
 ***********************************************************************************/

- (BOOL)signUpViewController:(PFSignUpViewController *)signUpController shouldBeginSignUp:(NSDictionary *)info {
    BOOL informationComplete = YES;
    
    for (id key in info) {
        NSString *field = [info objectForKey:key];
        if (!field || field.length == 0) {
            informationComplete = NO;
            break;
        }
    }
    
    if (!informationComplete) {
        [[[UIAlertView alloc] initWithTitle:@"Oops! Looks like you missed some information."
                                    message:@"Please fill out all the fields!"
                                   delegate:nil
                          cancelButtonTitle:@"ok"
                          otherButtonTitles:nil] show];
    }
    
    return informationComplete;
}

- (void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user {
    [self dismissModalViewControllerAnimated:YES];
}

- (void)signUpViewController:(PFSignUpViewController *)signUpController didFailToSignUpWithError:(NSError *)error {
    NSLog(@"Failed to sign up...");
}

- (void)signUpViewControllerDidCancelSignUp:(PFSignUpViewController *)signUpController {
    NSLog(@"User dismissed the signUpViewController");
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
