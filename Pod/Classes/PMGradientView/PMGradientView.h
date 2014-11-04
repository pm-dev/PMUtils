//
//  PMGradientView.h
//  Pods
//
//  Created by Peter Meyers on 10/1/14.
//
//

#import <UIKit/UIKit.h>

@interface PMGradientView : UIView

@property (nonatomic, strong) UIColor *startColor;
@property (nonatomic, strong) UIColor *endColor;
// The start point and end point are relative from 0.0, 0.0 in the upper left to 1.0, 1.0 in the lower right
@property (nonatomic) CGPoint startPoint;	//	Defaults to (0.5, 0.0)
@property (nonatomic) CGPoint endPoint;		//	Defaults to (0.5, 1.0)
@property (nonatomic, strong) NSArray *locations;     // Defaults to @0.5

@end
