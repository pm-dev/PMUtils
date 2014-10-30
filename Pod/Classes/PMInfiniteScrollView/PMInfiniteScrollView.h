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

- (void) infiniteScrollView:(PMInfiniteScrollView *)scrollView didRecenterContentOffset:(CGPoint)delta;

@end

@interface PMInfiniteScrollView : UIScrollView

@property (nonatomic) PMDirection infiniteDirection;
@property (nonatomic, weak) id<PMInfiniteScrollViewDelegate> delegate;

@end
