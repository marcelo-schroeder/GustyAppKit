//
// Created by Marcelo Schroeder on 17/03/2014.
// Copyright (c) 2014 InfoAccent Pty Limited. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

#import "IFACollectionViewController.h"

@protocol IFAGridViewDataSource;
@protocol IFAGridViewDelegate;

@interface IFAGridViewController : IFACollectionViewController <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, weak) id<IFAGridViewDataSource> gridViewDataSource;
@property (nonatomic, weak) id<IFAGridViewDelegate> gridViewDelegate;
@property (nonatomic, strong, readonly) UICollectionViewFlowLayout *layout;

/**
* This property indicates whether the view controller needs to support paging. The default value is NO.
* Supporting paging currently means that this view controller will make sure that the collection view's content offset is always matching the current page, even when interface orientation changes occur.
* When set to YES, this property will only make sense if self.collectionView.pagingEnabled is also set to YES.
*/
@property (nonatomic) BOOL shouldSupportPaging;

@end

@protocol IFAGridViewDataSource <NSObject>

- (NSUInteger)numberOfGridRows;
- (NSUInteger)numberOfGridColumns;
- (CGFloat)interTileSpace;
- (UICollectionViewScrollDirection)scrollDirection;

@optional

// Used to set the collection view's content inset
- (UIEdgeInsets)contentInset;

// Used to set the collection view's section inset
- (UIEdgeInsets)sectionInset;

// Used in size calculations only to reserve space for bars, revealing collection items partially, inter page spacing, etc
- (UIEdgeInsets)reservedEdgeSpace;

- (BOOL)shouldAdjustLastColumnWidth;
- (BOOL)shouldAdjustLastRowHeight;

/**
* Implement this method to force the item width calculation to be based on the item height.
* When this method is implemented, implementing shouldAdjustLastColumnWidth will have no effect.
*
* @returns Number that multiplied by the item height will result in the item width. Returning zero will have no effect.
*/
- (CGFloat)itemHeightMultiplierForItemWidth;

/**
* Implement this method to force the item height calculation to be based on the item width.
* When this method is implemented, implementing shouldAdjustLastRowHeight will have no effect.
*
* @returns Number that multiplied by the item width will result in the item height. Returning zero will have no effect.
*/
- (CGFloat)itemWidthMultiplierForItemHeight;

@end

@protocol IFAGridViewDelegate <NSObject>

@optional

// Called at various life cycle phases when the view layout needs to be updated (if required)
// Extra configuration can be done here
- (void)didUpdateCollectionViewFlowLayout:(UICollectionViewFlowLayout *)a_collectionViewFlowLayout;

@end