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
//  PMCollectionViewSwipeCell.h
//  Created by Peter Meyers on 8/21/14.
//
//

#import <UIKit/UIKit.h>
#import "PMSwipeCellDelegate.h"

@interface PMCollectionViewSwipeCell : UICollectionViewCell

/**
 *  A boolean value that controls whether the swiping functionality provided by this class is enabled.
 */
@property (nonatomic) BOOL swipeEnabled;

/**
 *  The view that sits below the content view when the content view is swipped right. The view sits in the coordinate system
 *	system of the cell. A common use of a utility view is a button which commits some action related to the cell, such as deleting
 *	it from the collection view.
 */
@property (nonatomic, strong) UIView *leftUtilityView;

/**
 *  The view that sits below the content view when the content view is swipped left. The view sits in the coordinate system
 *	system of the cell. A common use of a utility view is a button which commits some action related to the cell, such as deleting
 *	it from the collection view.
 */
@property (nonatomic, strong) UIView *rightUtilityView;

/**
 *  The object that acts as the delegate of the swipe cell. The delegate must adopt
 *	the PMCollectionViewSwipeCellDelegate protocol. The collection view maintains a weak reference to the delegate object.
 */
@property (nonatomic, weak) id<PMSwipeCellDelegate> delegate;

/**
 *  A Boolean value that controls whether the content view bounces past the right edge of the left utility view
 *	when swiping right, or the left edge of the right utility view when swiping left. Bouncing visually indicates that
 *	scrolling has reached an edge of the content. The default value is YES.
 */
@property (nonatomic) BOOL bouncesOpen;

/**
 *  The position of the content view. The content view is considered PMCellPositionCentered if its frame's
 *	origin is at (0,0) in the cell's cordinate system. A utility view is considered visible once it is completely visible.
 *	This property only changes once the cell is done transitioning to a new position.
 */
@property (nonatomic) PMCellPosition cellPosition;

/**
 *  Scrolls the content view to a position, allowing the scroll to animate.
 *
 *  @param position The position of the content view. The content view is considered PMCellPositionCentered if its frame's
 *	origin is at (0,0) in the cell's cordinate system.
 *  @param animated A flag indicating whether the transition to the new position should be animated.
 */
- (void) setCellPosition:(PMCellPosition)position animated:(BOOL)animated;

@end
