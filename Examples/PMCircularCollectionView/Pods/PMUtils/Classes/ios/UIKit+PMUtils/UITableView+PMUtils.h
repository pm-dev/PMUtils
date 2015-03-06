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
//  UITableView+PMUtils.h
//  Created by Peter Meyers on 3/2/14.
//

#import <UIKit/UIKit.h>

@interface UITableView (PMUtils)

/**
 *  Convenience method equivalent to [self reloadRowsAtIndexPaths:[self indexPathsForVisibleRows] withRowAnimation:animation]; Reloading a row causes the table view to ask its data source for a new cell for that row. The table animates that new cell in as it animates the old row out. Call this method if you want to alert the user that the value of a cell is changing. If, however, notifying the user is not important—that is, you just want to change the value that a cell is displaying—you can get the cell for a particular row and set its new value. When this method is called in an animation block defined by the beginUpdates and endUpdates methods, it behaves similarly to deleteRowsAtIndexPaths:withRowAnimation:. The indexes that UITableView passes to the method are specified in the state of the table view prior to any updates. This happens regardless of ordering of the insertion, deletion, and reloading method calls within the animation block.
 *
 *  @param animation A constant that indicates how the reloading is to be animated, for example, fade out or slide out from the bottom. See “Table Cell Insertion and Deletion Animation” for descriptions of these constants. The animation constant affects the direction in which both the old and the new rows slide. For example, if the animation constant is UITableViewRowAnimationRight, the old rows slide out to the right and the new cells slide in from the right.
 */
- (void) reloadVisibleRowsWithRowAnimation:(UITableViewRowAnimation)animation;

@end
