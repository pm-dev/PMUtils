// Copyright (c) 2013-2014 Peter Meyers
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//
//  PMCenteredCircularCollectionView.h
//  Created by Peter Meyers on 3/23/14.
//
//

#import "PMCircularCollectionView.h"
#import "PMCenteredCollectionViewFlowLayout.h"


@class PMCenteredCircularCollectionView;
@protocol PMCenteredCircularCollectionViewDelegate <UICollectionViewDelegateFlowLayout>

@optional
/**
 *  This method is called before the collection view centers the cell at an index. This may be called after
 *  scrolling the collection view or centering an item directly.
 *
 *  @param collectionView The collection view that is about to center an item.
 *  @param index          The index of the item to be centered. Remember, there is always only 1 section in a
 *  centered circular collection view.
 */
- (void) collectionView:(PMCenteredCircularCollectionView *)collectionView willCenterItemAtIndex:(NSUInteger)index;

@end


@interface PMCenteredCircularCollectionView : PMCircularCollectionView

/**
 *  The flow layout used to organize the collected view’s items. Assigning a new layout object to
 *  this property causes the new layout to be applied (without animations) to the collection view’s items.
 */
@property (nonatomic, strong) PMCenteredCollectionViewFlowLayout *collectionViewLayout;

/**
 *  The object that acts as the delegate of the collection view. The delegate
 *  must adopt the PMCenteredCircularCollectionViewDelegate protocol. The collection view maintains a weak
 *  reference to the delegate object. The delegate object is responsible for managing selection
 *  behavior and interactions with individual items.
 */
@property (nonatomic, weak) id <PMCenteredCircularCollectionViewDelegate> delegate;

/**
 *  The index of the cell currently centered in the collection view. Set this property to 
 *  center an index immediately, or call -setCenteredIndex:animated: to animate the scrolling.
 */
@property (nonatomic) NSUInteger centeredIndex;

/**
 *  Centers a cell at the given index in the collection view.
 *
 *  @param centeredIndex The index of the cell to center in the reciever.
 *  @param aniamted      Specify YES to animate the scrolling behavior or NO to adjust the 
 *  collection view’s visible content immediately.
 */
- (void) setCenteredIndex:(NSUInteger)centeredIndex animated:(BOOL)aniamted;

/**
 *  Centers the given cell in the collection view.
 *
 *  @param cell     The cell to center.
 *  @param animated Specify YES to animate the scrolling behavior or NO to adjust the
 *  collection view’s visible content immediately.
 */
- (void) setCenteredCell:(UICollectionViewCell *)cell animated:(BOOL)animated;

/**
 *  Factory method which initializes and returns a newly allocated collection view object with the specified
 *  frame and layout. Use this method when initializing a collection view object programmatically.
 *
 *  @param frame  The frame rectangle for the collection view, measured in points. The origin
 *  of the frame is relative to the superview in which you plan to add it. This frame is passed to the superclass during initialization.
 *  @param layout The layout object to use for organizing items. The collection view
 *  stores a strong reference to the specified object. Must not be nil.
 *
 *  @return An initialized collection view object or nil if the object could not be created.
 */
+ (instancetype) collectionViewWithFrame:(CGRect)frame collectionViewLayout:(PMCenteredCollectionViewFlowLayout *)layout;

/** Initializes and returns a newly allocated collection view object with the specified
 *  frame and layout. Use this method when initializing a collection view object programmatically.
 *
 *  @param frame  The frame rectangle for the collection view, measured in points. The origin
 * of the frame is relative to the superview in which you plan to add it. This frame is passed
 *  to the superclass during initialization.
 *
 *  @param layout The layout object to use for organizing items. The collection view
 *  stores a strong reference to the specified object. Must not be nil.
 *
 *  @return An initialized collection view object or nil if the object could not be created.
 */
- (instancetype) initWithFrame:(CGRect)frame collectionViewLayout:(PMCenteredCollectionViewFlowLayout *)layout;

@end




