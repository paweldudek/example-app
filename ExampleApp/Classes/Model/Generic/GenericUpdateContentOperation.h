/*
* Copyright (c) 2016 Paweł Dudek. All rights reserved.
*/
#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "AbstractAsynchronousOperation.h"

@class UsersUpdater;
@class NetworkLayer;
@class PersistenceController;
@protocol NetworkLayerRequest;

@protocol ContentUpdater <NSObject>

- (void)updateContentWithArray:(NSArray *)contentArray managedObjectContext:(NSManagedObjectContext *)managedObjectContext;

@end


@interface GenericUpdateContentOperation : AbstractAsynchronousOperation

@property(nonatomic, readonly) PersistenceController *persistenceController;

@property(nonatomic, copy) void (^updateCompletion)(NSError *error);

@property(nonatomic, strong) NetworkLayer *networkLayer;

@property(nonatomic, strong) NSOperationQueue *completionQueue;

#pragma mark - Configuration

@property(nonatomic, strong) id <ContentUpdater> contentUpdater;

@property(nonatomic, strong) id <NetworkLayerRequest> request;

#pragma mark - Creation

- (instancetype)initWithPersistenceController:(PersistenceController *)persistenceController;

@end
