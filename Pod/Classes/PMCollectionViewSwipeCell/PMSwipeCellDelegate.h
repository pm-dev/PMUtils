//
//  PMSwipeCellDelegate.h
//  Pods
//
//  Created by Peter Meyers on 11/28/14.
//
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, PMCellPosition)
{
    PMCellPositionCentered,
    PMCellPositionLeftUtilityViewVisible,
    PMCellPositionRightUtilityViewVisible
};

@protocol PMSwipeCellDelegate <NSObject>

@optional

/**
 *  Tells the delegate a swipe cell changed the position of its content view.
 *
 *  @param cell     The swipe cell whose content view moved to a new position.
 *  @param position The new position of the content view.
 */
- (void) swipeCell:(id)cell didMoveToPosition:(PMCellPosition)position;

@end

