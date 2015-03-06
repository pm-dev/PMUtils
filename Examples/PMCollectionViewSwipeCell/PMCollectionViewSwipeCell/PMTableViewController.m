//
//  PMTableViewController.m
//  PMCollectionViewSwipeCell
//
//  Created by Peter Meyers on 3/6/15.
//  Copyright (c) 2015 Peter Meyers. All rights reserved.
//

#import "PMTableViewController.h"
#import "PMTableViewSwipeCell.h"

@interface PMTableViewController ()

@end

@implementation PMTableViewController


#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PMTableViewSwipeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PMTableViewSwipeCell" forIndexPath:indexPath];

    cell.contentView.backgroundColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
    
    CGRect frame = cell.bounds;
    frame.size.width *= 0.5;
    
    UIButton *leftView = [UIButton buttonWithType:UIButtonTypeCustom];
    leftView.backgroundColor = [UIColor greenColor];
    leftView.frame = frame;
    leftView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [leftView addTarget:self action:@selector(didTapLeftView:) forControlEvents:UIControlEventTouchUpInside];
    cell.leftUtilityView = leftView;
    
    UIButton *rightView = [UIButton buttonWithType:UIButtonTypeCustom];
    rightView.backgroundColor = [UIColor redColor];
    frame.origin.x = cell.bounds.size.width - frame.size.width;
    rightView.frame = frame;
    rightView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [rightView addTarget:self action:@selector(didTapRightView:) forControlEvents:UIControlEventTouchUpInside];
    cell.rightUtilityView = rightView;
    
    return cell;
}

- (void) didTapLeftView:(UIButton *)leftView {
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void) didTapRightView:(UIButton *)rightView {
    NSLog(@"%@", NSStringFromSelector(_cmd));
}


@end
