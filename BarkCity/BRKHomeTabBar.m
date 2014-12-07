//
//  BRKHomeTabBar.m
//  BarkCity
//
//  Created by Louis Tur on 12/7/14.
//  Copyright (c) 2014 com.rosamcgee. All rights reserved.
//

#import "BRKHomeTabBar.h"

@implementation BRKHomeTabBar

-(void)awakeFromNib{
    [super awakeFromNib];
    [self removeConstraints:self.constraints];
    
    NSLog(@"Awaking from Nib");
    
    CGRect screenWidth = [UIScreen mainScreen].bounds;
    CGFloat buttonWidth = screenWidth.size.width / 5.0;
    CGFloat buttonHeight = 44.0;
    
    self.tabBarView = [[UIView alloc] init];
    [self addSubview:self.tabBarView];
    
    [self setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.tabBarView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.firstTabButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.secondTabButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.thirdTabButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.firstTabButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.fifthTabButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    NSArray * tabViewHorizontal = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_tabBarView]|"
                                                                          options:0
                                                                          metrics:nil
                                                                            views:NSDictionaryOfVariableBindings(_tabBarView)];
    NSArray * tabViewVertical = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_tabBarView(>=buttonHeight)]|"
                                                                        options:0
                                                                        metrics: @{ @"buttonHeight" : [NSNumber numberWithFloat:buttonHeight]}
                                                                        views:NSDictionaryOfVariableBindings(_tabBarView)];
    [self addConstraints:tabViewHorizontal];
    [self addConstraints:tabViewVertical];
    
    
    [self.tabBarView setBackgroundColor:[UIColor redColor]];
    [self.firstTabButton setBackgroundColor:[UIColor greenColor]];
    
    [self.tabBarView addSubview:self.firstTabButton];
    [self.tabBarView addSubview:self.secondTabButton];
    [self.tabBarView addSubview:self.thirdTabButton];
    [self.tabBarView addSubview:self.fourthTabButton];
    [self.tabBarView addSubview:self.fifthTabButton];
    
    NSDictionary * buttonsDictionary = NSDictionaryOfVariableBindings(_firstTabButton, _secondTabButton, _thirdTabButton, _fourthTabButton, _fifthTabButton);
    
    NSDictionary * buttonMetrics = @{ @"buttonWidth"  : [NSNumber numberWithFloat:buttonWidth],
                                      @"height" : [NSNumber numberWithFloat:buttonHeight]};
    
    NSArray * buttonsHorizontal = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_firstTabButton(>=buttonWidth)][_secondTabButton(==_firstTabButton)][_thirdTabButton(==_firstTabButton)][_fourthTabButton(==_firstTabButton)][_fifthTabButton(==_firstTabButton)]|"
                                                                          options:0
                                                                          metrics:buttonMetrics
                                                                            views:buttonsDictionary];
    NSArray * firstVertical = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_firstTabButton(>=height)]|"
                                                                        options:0
                                                                        metrics:buttonMetrics
                                                                          views:buttonsDictionary];
    NSArray * secondVertical = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_secondTabButton(==_firstTabButton)]|"
                                                                        options:0
                                                                        metrics:buttonMetrics
                                                                          views:buttonsDictionary];
    
    NSArray * thirdVertical = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_thirdTabButton(==_firstTabButton)]|"
                                                                       options:0
                                                                       metrics:buttonMetrics
                                                                         views:buttonsDictionary];
    NSArray * fourthVertical = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_fourthTabButton(==_firstTabButton)]|"
                                                                      options:0
                                                                      metrics:buttonMetrics
                                                                        views:buttonsDictionary];
    NSArray * fifthVertical = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_fifthTabButton(==_firstTabButton)]|"
                                                                      options:0
                                                                      metrics:buttonMetrics
                                                                        views:buttonsDictionary];
    [self addConstraints:buttonsHorizontal];
    [self addConstraints:firstVertical];
    [self addConstraints:secondVertical];
    [self addConstraints:thirdVertical];
    [self addConstraints:fourthVertical];
    [self addConstraints:fifthVertical];
    
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        NSLog(@"Init from coder");
    }
    return self;
}
-(instancetype)init{
    self = [super init];
    if (self) {
        NSLog(@"Inited");
        
    }
    return self;
}

@end
