/*
* Copyright (c) 2016 Paweł Dudek. All rights reserved.
*/
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol TableContentPresentationController <NSObject>

@property(nonatomic, readonly) UINib *tableViewCellNib;

@property(nonatomic, readonly) CGFloat estimatedCellHeight;

- (void)configureTableViewCell:(__kindof UITableViewCell *)tableViewCell withObject:(id)object;

- (void)selectObject:(id)object;

@end
