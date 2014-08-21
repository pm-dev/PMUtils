//
//  PMInnerShadowView.h
//  PMInnerShadowView
//
//  This is based off a project by Yasuhiro Inami on 2012/10/14.
//  Copyright (c) 2012年 Yasuhiro Inami. All rights reserved.
//
//  Version: 1.1
//  Created by PETER MEYERS on 8/21/2014.
//  Copyright (c) 2013 Peter Meyers. All rights reserved.
//  The original source code can be found at:
//  https://github.com/inamiy/YIInnerShadowView

#import <UIKit/UIKit.h>

@interface PMInnerShadowView : UIView

@property (nonatomic, strong) UIColor* shadowColor;
@property (nonatomic) UIRectEdge edges;
@property (nonatomic) CGFloat shadowOpacity;
@property (nonatomic) CGSize shadowOffset;
@property (nonatomic) CGFloat shadowRadius;
@property (nonatomic) CGFloat cornerRadius;

@end
