/*
* Copyright (c) 2016 Paweł Dudek. All rights reserved.
*/
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol TableContentPresentationController <NSObject>

@property(nonatomic, readonly) UINib *tableViewCellNib;

@property(nonatomic, readonly) CGFloat estimatedCellHeight;

/*
 * Will be set once TableContentViewController loads its view.
 */
@property(nonatomic, strong) UITableView *tableView;

- (void)configureTableViewCell:(__kindof UITableViewCell *)tableViewCell atIndexPath:(NSIndexPath *)indexPath withObject:(id)object;

- (void)selectObject:(id)object;

@end
