/*
* Copyright (c) 2016 Paweł Dudek. All rights reserved.
*/
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ContentProvider.h"

@class User;
@class TableContentViewController;

@protocol TableContentPresentationController <NSObject>

@property(nonatomic, readonly) UINib *tableViewCellNib;

@property(nonatomic, readonly) CGFloat estimatedCellHeight;

- (void)configureTableViewCell:(__kindof UITableViewCell *)tableViewCell withObject:(id)object;

- (void)selectObject:(id)object;

@end


@interface TableContentViewController <__covariant ObjectType> : UIViewController <ContentProviderDelegate, UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, readonly) id <ContentProvider> contentProvider;

@property(nonatomic, readonly) id <TableContentPresentationController> tableContentPresentationController;

/*
 * Will be nil until view is loaded.
 */
@property(nonatomic, readonly) UITableView *tableView;

- (instancetype)initWithContentProvider:(id <ContentProvider>)contentProvider tableContentPresentationController:(id <TableContentPresentationController>)tableContentPresentationController;

@end
