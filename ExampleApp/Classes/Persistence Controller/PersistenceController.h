/*
* Copyright (c) 2016 Paweł Dudek. All rights reserved.
*/
#import <Foundation/Foundation.h>

@class NSManagedObjectContext;
@class PBDManagedObjectModelController;

typedef void(^PersistenceControllerSaveCompletion)(BOOL succeeded, NSError *error);

@interface PersistenceController : NSObject

@property(nonatomic, readonly) NSManagedObjectContext *mainThreadManagedObjectContext;

@property(nonatomic, readonly) NSURL *coreDataStackFolderURL;

@property(nonatomic, strong) NSFileManager *fileManager;

@property(nonatomic, strong) PBDManagedObjectModelController *modelController;

@property(nonatomic, strong) dispatch_queue_t completionQueue;

- (instancetype)initWithCoreDataStackFolderURL:(NSURL *)coreDataStackFolderURL;

- (void)setupCoreDataStack;

#pragma mark - Saving Stores

// Completion block will be called on completionQueue

- (void)saveChildContext:(NSManagedObjectContext *)managedObjectContext completion:(PersistenceControllerSaveCompletion)completion;

@end
