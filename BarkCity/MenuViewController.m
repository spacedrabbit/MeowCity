//
//  MenuCollectionViewController.m
//  BarkCity
//
//  Created by Rosa McGee on 12/9/14.
//  Copyright (c) 2014 com.rosamcgee. All rights reserved.
//

#import "MenuViewController.h"
#import "MenuCollectionViewCell.h"

@interface MenuViewController()

@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createImages];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(110.0, 110.0);
    layout.minimumInteritemSpacing = 1.0;
    layout.minimumLineSpacing = 1.0;
//    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:layout];
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 160, self.view.frame.size.height) collectionViewLayout:layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerClass:[MenuCollectionViewCell class] forCellWithReuseIdentifier:@"photo"];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView reloadData];
    [self.view addSubview:self.collectionView];
    
    [self constrainViews];
    
    
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
}

- (void)constrainViews {
    [self.view removeConstraints:self.view.constraints];
    
    UICollectionView *collectionView = self.collectionView;
    
    NSDictionary *views = NSDictionaryOfVariableBindings(collectionView);
    NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[collectionView]"
                                                                   options:NSLayoutFormatAlignAllLeft
                                                                   metrics:nil
                                                                     views:views];
    [self.view addConstraints:constraints];
}


- (void)createImages {
    UIImage *oneMenuIcon = [UIImage imageNamed:@"icon-16"];
    UIImage *twoMenuIcon = [UIImage imageNamed:@"icon-17"];
    UIImage *threeMenuIcon = [UIImage imageNamed:@"icon-18"];
    UIImage *fourMenuIcon = [UIImage imageNamed:@"icon-19"];
    UIImage *fiveMenuIcon = [UIImage imageNamed:@"icon-20"];
    UIImage *sixMenuIcon = [UIImage imageNamed:@"icon-21"];
    self.imagesArray = @[oneMenuIcon,twoMenuIcon,threeMenuIcon,fourMenuIcon,fiveMenuIcon,sixMenuIcon];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.collectionView reloadData];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 6;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MenuCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"photo" forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor whiteColor];
    cell.imageView.image = [self.imagesArray objectAtIndex:indexPath.row];

    return cell;
}

@end
