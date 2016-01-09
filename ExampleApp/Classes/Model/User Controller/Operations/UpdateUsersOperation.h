/*
* Copyright (c) 2016 Paweł Dudek. All rights reserved.
*/
#import <Foundation/Foundation.h>
#import "AbstractAsynchronousOperation.h"

@class UsersUpdater;
@class NetworkLayer;
@class PersistenceController;


@interface UpdateUsersOperation : AbstractAsynchronousOperation

@property(nonatomic, readonly) PersistenceController *persistenceController;

@property(nonatomic, strong) UsersUpdater *usersUpdater;

@property(nonatomic, copy) void (^updateCompletion)(NSError *);

@property(nonatomic, strong) NetworkLayer *networkLayer;

@property(nonatomic, strong) NSOperationQueue *completionQueue;

- (instancetype)initWithPersistenceController:(PersistenceController *)persistenceController;

@end
