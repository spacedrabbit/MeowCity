//
//  BRKHomeTabBar.m
//  BarkCity
//
//  Created by Louis Tur on 12/7/14.
//  Copyright (c) 2014 com.rosamcgee. All rights reserved.
//

#import "BRKHomeTabBar.h"
#import "BRKUIManager.h"
@interface BRKHomeTabBar()

enum tabLocations   {
    snackTab = 0,
    cafeTab,
    barTab,
    shoppingTab,
    playTab
};

@property (nonatomic)   NSInteger    lastSelectedTab     ;

@property (strong,  nonatomic) NSArray  *   iconImagesArray     ;
@property (strong,  nonatomic) NSArray  *   iconHighlightedArray;

@property (strong,  nonatomic) UIImageView  * tabIndicator;

@property (strong, nonatomic) NSArray * buttonsArray;

@end

@implementation BRKHomeTabBar

-(void)awakeFromNib{
    [super awakeFromNib];
    
    CGRect  screenWidth     = [UIScreen mainScreen].bounds;
    CGFloat buttonWidth     = screenWidth.size.width / 5.0;
    CGFloat buttonHeight    = 44.0;
    
    self.tabBarView = [[UIView alloc] init];
    [self addSubview:self.tabBarView];
    
    self.buttonsArray = @[self.firstTabButton, self.secondTabButton, self.thirdTabButton, self.fourthTabButton, self.fifthTabButton];
    
    [self.tabBarView        setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.firstTabButton    setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.secondTabButton   setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.thirdTabButton    setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.firstTabButton    setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.fifthTabButton    setTranslatesAutoresizingMaskIntoConstraints:NO];
    
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
    
    [self.tabBarView    addSubview: self.firstTabButton ];
    [self.tabBarView    addSubview: self.secondTabButton];
    [self.tabBarView    addSubview: self.thirdTabButton ];
    [self.tabBarView    addSubview: self.fourthTabButton];
    [self.tabBarView    addSubview: self.fifthTabButton ];
    
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
    
    self.iconImagesArray = @[ [UIImage imageNamed:@"eat"],
                              [UIImage imageNamed:@"cafe"],
                              [UIImage imageNamed:@"bar"],
                              [UIImage imageNamed:@"shopping"],
                              [UIImage imageNamed:@"play"]
                              ];
    self.iconHighlightedArray = @[ [UIImage imageNamed:@"eat_highlight"],
                                   [UIImage imageNamed:@"cafe_highlight"],
                                   [UIImage imageNamed:@"bar_highlight"],
                                   [UIImage imageNamed:@"shopping_highlight"],
                                   [UIImage imageNamed:@"play_highlight"]
                                  ];
    
    // -- Yea we fancy -- //
    [[self.tabBarView subviews] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIButton * currentButton = (UIButton *) obj;
        [currentButton setImage:self.iconImagesArray[idx] forState:UIControlStateNormal];
        [currentButton setImage:self.iconHighlightedArray[idx] forState:UIControlStateHighlighted];
        [currentButton setTag:idx];
        [currentButton.imageView setContentScaleFactor:2.0];
        [currentButton.imageView setContentMode:UIViewContentModeScaleToFill];
        [currentButton setTitle:@"" forState:UIControlStateNormal];
        [currentButton setBackgroundColor:[UIColor clearColor]];
        [currentButton addTarget:self
                          action:@selector(tabWasSelected:)
                forControlEvents:UIControlEventTouchUpInside];
    }];
    
    [self tabWasSelected:self.buttonsArray[0]]; //initially sets the correct state(s) for the buttons
    
}
-(void)layoutSubviews{
    [self.tabBarView insertSubview:self.tabIndicator atIndex:0];
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        
    }
    return self;
}
-(instancetype)init{
    self = [super init];
    if (self) {
        _lastSelectedTab = 0;
        
    }
    return self;
}

// -- a "selected" tab will be highlighted and 1.5X larger than the rest
-(void) tabWasSelected:(id) sender{
    
    UIButton * senderButton = (UIButton *)sender;
    NSInteger indexOfButton = senderButton.tag;
    
    [self updateTabSelectedTo:indexOfButton];
    
    [self.delegate didSelectTabButton:indexOfButton];
    
}
-(void) tabSelectedAtIndex:(NSInteger)index{
    UIButton * simulatedButton = self.buttonsArray[index];
    [self tabWasSelected:simulatedButton];
}
-(NSInteger) currentlySelectedTab{
    return self.lastSelectedTab;
}

-(void) updateTabSelectedTo:(NSInteger)indexOfButton{
    CGAffineTransform selectedTabScale = CGAffineTransformMakeScale(1.5, 1.5);
    
    [self.buttonsArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        UIButton * currentButton = (UIButton *)obj;
        if ( idx == indexOfButton && !CGAffineTransformEqualToTransform(currentButton.transform,selectedTabScale) )
        {
            [currentButton setHighlighted:NO];
            currentButton.transform = selectedTabScale;
        }else if( idx != indexOfButton )
        {
            [currentButton setHighlighted:YES];
            currentButton.transform = CGAffineTransformIdentity;
        }
        self.lastSelectedTab = indexOfButton;
    }];

}


// deprecated, was used for slider indicator
-(void) updateTabIndicatorTo:(NSInteger)tabIndex animated:(BOOL)animated
{
    CGPoint newCenterCoordinate;
    switch (tabIndex) {
        case 0:
            newCenterCoordinate = self.firstTabButton.center;
            break;
        case 1:
            newCenterCoordinate = self.secondTabButton.center;
            break;
        case 2:
            newCenterCoordinate = self.thirdTabButton.center;
            break;
        case 3:
            newCenterCoordinate = self.fourthTabButton.center;
            break;
        case 4:
            newCenterCoordinate = self.fifthTabButton.center;
            break;
        default:
            newCenterCoordinate = self.firstTabButton.center;
            break;
    }
    
    if (animated)
    {
        [UIView animateWithDuration:.25 animations:^{
            [self.tabIndicator setCenter:CGPointMake(newCenterCoordinate.x, 44.0)];
        }];
    }else
    {
        [self.tabIndicator setCenter:CGPointMake(newCenterCoordinate.x, 44.0)];
    }
    
}

@end
