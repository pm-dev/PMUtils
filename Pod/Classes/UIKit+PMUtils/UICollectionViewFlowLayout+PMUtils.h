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
//  UICollectionViewFlowLayout+PMUtils.h
//  Created by Peter Meyers on 4/9/14.
//
//

#import <UIKit/UIKit.h>

@interface UICollectionViewFlowLayout (PMUtils)

/**
 *  Determines if the receiver would need to change its content offset if -[UICollectionView scrollToItemAtIndexPath:atScrollPosition:animated]
 *	were to be called.
 *
 *	@param indexPath The index path the receiver would scroll to.
 *
 *	@param scrollPosition An option that specifies where the item should be positioned when scrolling finishes. 
 *	For a list of possible values, see “UICollectionViewScrollPosition”.
 *
 *	@see -[UICollectionView scrollToItemAtIndexPath:atScrollPosition:animated]
 *  @return Yes if the receiver would need to change its content offset if -[UICollectionView scrollToItemAtIndexPath:atScrollPosition:animated]
 *	were to be called, otherwise NO.
 */
- (BOOL) requiresScrollAnimationToIndexPath:(NSIndexPath *)indexPath atPosition:(UICollectionViewScrollPosition)scrollPosition;

@end
