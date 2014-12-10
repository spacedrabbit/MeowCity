//
//  MenuCollectionViewController.h
//  BarkCity
//
//  Created by Rosa McGee on 12/9/14.
//  Copyright (c) 2014 com.rosamcgee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuViewController : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic) NSArray *imagesArray;
@property (nonatomic) UICollectionView *collectionView;

@end
