/*
* Copyright (c) 2016 Paweł Dudek. All rights reserved.
*/
#import <Foundation/Foundation.h>
#import "UsersViewController.h"

@class PersistenceController;


@interface SearchUsersProvider : NSObject <UsersProvider, UISearchResultsUpdating>

@property(nonatomic, readonly) PersistenceController *persistenceController;

- (instancetype)initWithPersistenceController:(PersistenceController *)persistenceController;

@end
