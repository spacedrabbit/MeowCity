//
//  BRKSearchViewController.m
//  BarkCity
//
//  Created by Richard McAteer on 11/24/14.
//  Copyright (c) 2014 com.rosamcgee. All rights reserved.
//

#import "BRKSearchViewController.h"
#import "BRKScrollView.h"

@interface BRKSearchViewController ()

- (IBAction)cancelBarButtonItemPressed:(UIBarButtonItem *)sender;
@property (strong, nonatomic) IBOutlet UITextField *searchTextField;
@property (strong, nonatomic) IBOutlet UITextField *locationTextField;


@end

@implementation BRKSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    // -- Uncomment to test scroll view -- //
    /*
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        
        CGRect screenRect = [UIScreen mainScreen].bounds;
        CGFloat screenWidth = screenRect.size.width;
        CGFloat screenHalfHeight = screenRect.size.height/2.0;
        CGRect bottomHalfScreenRect = CGRectMake(0, screenHalfHeight, screenWidth, screenHalfHeight);
        
        UIView * view1 = [[UIView alloc] initWithFrame:bottomHalfScreenRect];
        [view1 setBackgroundColor:[UIColor redColor]];
        
        UIView * view2 = [[UIView alloc] initWithFrame:bottomHalfScreenRect];
        [view2 setBackgroundColor:[UIColor blueColor]];
        
        UIView * view3 = [[UIView alloc] initWithFrame:bottomHalfScreenRect];
        [view3 setBackgroundColor:[UIColor grayColor]];
        
        UIView * view4 = [[UIView alloc] initWithFrame:bottomHalfScreenRect];
        [view4 setBackgroundColor:[UIColor greenColor]];
        
        UIView * view5 = [[UIView alloc] initWithFrame:bottomHalfScreenRect];
        [view5 setBackgroundColor:[UIColor purpleColor]];
        
        [self.view setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        BRKScrollView * testScrollView = [BRKScrollView createScrollViewFromFrame:CGRectMake(0, screenHalfHeight, screenWidth, screenHalfHeight)
                                                                    withSubViews:@[ view1, view2, view3, view4, view5 ]];
        
           [self.view addSubview:testScrollView];
    }];*/
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(void)viewDidLayoutSubviews{
    
    
}
- (IBAction)cancelBarButtonItemPressed:(UIBarButtonItem *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
