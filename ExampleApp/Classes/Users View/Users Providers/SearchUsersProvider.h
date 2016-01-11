/*
* Copyright (c) 2016 Paweł Dudek. All rights reserved.
*/
#import <Foundation/Foundation.h>
#import "TableContentViewController.h"
#import "ContentProvider.h"

@class PersistenceController;


@interface SearchUsersProvider : NSObject <ContentProvider, UISearchResultsUpdating>

@property(nonatomic, readonly) PersistenceController *persistenceController;

- (instancetype)initWithPersistenceController:(PersistenceController *)persistenceController;

@end
