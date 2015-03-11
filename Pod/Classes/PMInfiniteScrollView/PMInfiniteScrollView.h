//
//  PMInfiniteScrollView.h
//  Pods
//
//  Created by Peter Meyers on 9/29/14.
//
//

#import <UIKit/UIKit.h>
#import "UIKit+PMUtils.h"

@class PMInfiniteScrollView;
@protocol PMInfiniteScrollViewDelegate <UIScrollViewDelegate>

@optional

/**
 *  Tells the delegate when the scroll view needed to recenter its contentOffset
 *
 *  @param scrollView The recentering scroll view
 *  @param delta      The distance from the previous content offset to the new content offset.
 */
- (void) infiniteScrollView:(PMInfiniteScrollView *)scrollView didRecenterContentOffset:(CGPoint)delta;

@end

@interface PMInfiniteScrollView : UIScrollView

/**
 *  The direction to allow infinite scrolling.
 */
@property (nonatomic) PMDirection infiniteDirection;

/**
 *  The object that acts as the delegate of the map view. The delegate must adopt the PMInfiniteScrollViewDelegate protocol.
 *  The scroll view field maintains a weak reference to the delegate object.
 *
 */
@property (nonatomic, weak) id<PMInfiniteScrollViewDelegate> delegate;

@end
