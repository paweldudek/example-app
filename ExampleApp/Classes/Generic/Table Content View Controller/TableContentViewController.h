/*
* Copyright (c) 2016 Paweł Dudek. All rights reserved.
*/
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ContentProvider.h"

@protocol TableContentPresentationController;

@interface TableContentViewController <__covariant ObjectType> : UIViewController <ContentProviderDelegate, UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, readonly) id <ContentProvider> contentProvider;

@property(nonatomic, readonly) id <TableContentPresentationController> tableContentPresentationController;

/*
 * Will be nil until view is loaded.
 */
@property(nonatomic, readonly) UITableView *tableView;

- (instancetype)initWithContentProvider:(id <ContentProvider>)contentProvider tableContentPresentationController:(id <TableContentPresentationController>)tableContentPresentationController;

@end
