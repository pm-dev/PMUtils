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
//  UITableViewCell+PMUtils.h
//  Pods
//
//  Created by Peter Meyers on 11/12/14.
//
//

#import <UIKit/UIKit.h>

@interface UITableViewCell (PMUtils)

/**
 *  The default reuse identifier is simply the name of the class. Override this method to change the default reuse identifier.
 *
 *  @return The default reuse identifier.
 */
+ (NSString *) defaultReuseIdentifier;

/**
 *  Returns a cached, shared instance of the reciever, used for calculating row heights in teh reciever. If no instance is cached, this method first attempts to instantiate an instance of the receiver by calling +[self viewFromDefaultNibWithOwner:nil]. If this returns nil, this method uses +[self new] to create the shared instance.
 *
 *  @param reuseIdentifier The string that identifies a cell.
 *
 *  @return An instance of the reciever, to be used for sizing.
 */
+ (instancetype) sizingCellWithReuseIdentifier:(NSString *)reuseIdentifier;

/**
 *  Given a supplied width, calculates the system layout height of the cell that satisfies the constraints it holds. This method sets the bounds to CGRectMake(0.0f, 0.0f, width, CGRectGetHeight(self.bounds)) and will layout the cell if necessary. Best when used with +[self  sizingCellWithReuseIdentifier:].
 *
 *  @param width The width of the table view this cell is calculating its height for.
 *
 *  @return The height best fitting the reciever, given a width and its constraints.
 */
- (CGFloat) heightFittingWidth:(CGFloat)width;

/**
 *  Finds the closest parent view in the view heirarchy that is a table view. If the reciever is not within the view heirarchy of a table view, nil is returned.
 */
@property (nonatomic, readonly) UITableView *tableView;

@end
