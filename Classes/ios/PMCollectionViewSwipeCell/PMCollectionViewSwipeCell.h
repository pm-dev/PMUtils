//
//  PMCollectionViewSwipeCell.h
//  Pods
//
//  Created by Peter Meyers on 8/21/14.
//
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, PMCellPosition)
{
    PMCellPositionCentered,
    PMCellPositionLeftUtilityViewVisible,
    PMCellPositionRightUtilityViewVisible
};

@class PMCollectionViewSwipeCell;

@protocol PMCollectionViewSwipeCellDelegate <NSObject>
@optional
- (void) swipeCollectionViewCell:(PMCollectionViewSwipeCell *)cell didMoveToPosition:(PMCellPosition)position;
@end


@interface PMCollectionViewSwipeCell : UICollectionViewCell

@property (nonatomic, strong) UIView *leftUtilityView;
@property (nonatomic, strong) UIView *rightUtilityView;
@property (nonatomic, weak) id <PMCollectionViewSwipeCellDelegate> delegate;

@property (nonatomic) PMCellPosition cellPosition;
- (void) setCellPosition:(PMCellPosition)position animated:(BOOL)animated;

- (BOOL) bouncesOpen;
- (void) setBouncesOpen:(BOOL)bounces;

@end
