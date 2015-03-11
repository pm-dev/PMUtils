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
//  PMCircularCollectionView.h
//  Created by Peter Meyers on 3/19/14.
//
//

#import <UIKit/UIKit.h>

//  **NOTE** This class currently only supports one section. This class will not call
//  -numberOfSectionsInCollectionView: on its dataSource.

@interface PMCircularCollectionView : UICollectionView

/**
 *  An optional CGFloat defining the radius of the shadow on both of the 
 *  scrolling sides of the collection view. For example, if the collection view scrolls
 *  vertially, the shadow is placed on the top and bottom edges. Right and left for horizontal scrolling.
 *  Defaults to 0.0.
 */
@property (nonatomic) CGFloat shadowRadius;

/**
 *  The color of the optional shadow placed at both scrolling sides of the collection view. For example,
 *  if the collection view scrolls vertially, the shadow is placed on the top and bottom edges. 
 *  Right and left for horizontal scrolling.
 */
@property (nonatomic, strong) UIColor *shadowColor;

/**
 *  The number of items in section 0. This class currently only supports 1 section.
 */
@property (nonatomic, readonly) NSUInteger itemCount;

/**
 *  A BOOL that determines whether the recieve continuously scrolls in both directions
 *  in a carousel like fashion.
 */
@property (nonatomic) BOOL circularDisabled;

/**
 *  A BOOL that returns whether the collection view is able to continuously scroll in both directions.
 *  This property would return NO even if circularDisabled was set to NO iff the content in the collection
 *  view is less than the size of the collection view in the scrollign direction.
 */
@property (nonatomic, readonly) BOOL circularActive;

/**
 *  The flow layout used to organize the collected view’s items. Assigning a new layout object to 
 *  this property causes the new layout to be applied (without animations) to the collection view’s items.
 */
@property (nonatomic, strong) UICollectionViewFlowLayout *collectionViewLayout;

/**
 *  The object that acts as the delegate of the collection view. The delegate
 *  must adopt the UICollectionViewDelegateFlowLayout protocol. The collection view maintains a weak
 *  reference to the delegate object. The delegate object is responsible for managing selection 
 *  behavior and interactions with individual items.
 */
@property (nonatomic, weak) id <UICollectionViewDelegateFlowLayout> delegate;

/**
 *  Returns a normalized index path given an index path reported by one of the delegate methods.
 *  To allow the circular scrolling, this class creates more items than are returned by the delegate.
 *  This method is required to translate the reported index path into the correct index path.
 *
 *  @param indexPath An index path reported by one of the delegate methods
 *
 *  @return A normalized index path in the range {0..n-1} where n is the number reported by the delegate
 *  in -collectionView:numberOfItemsInSection:
 */
- (NSIndexPath *) normalizedIndexPath:(NSIndexPath *)indexPath;

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
- (instancetype) initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewFlowLayout *)layout;

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
+ (instancetype) collectionViewWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewFlowLayout *)layout;

/**
 *  Factory method which initializes and returns a newly allocated collection view object.
 *  Use this method when initializing a collection view object programmatically.
 *
 *  @return An initialized collection view object or nil if the object could not be created.
 */
+ (instancetype) collectionView;

@end