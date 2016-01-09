/*
 * Copyright (c) 2016 Paweł Dudek. All rights reserved.
 */
#import <CoreData/CoreData.h>
#import "PersistenceController.h"
#import "PBDManagedObjectModelController.h"
#import "PBDCoreDataMigrationAssistant.h"

// Partially borrowed from: https://github.com/ottersoftware/CoreDataStackSetup

@interface PersistenceController ();

@property(strong, nonatomic) NSManagedObjectContext *saveManagedObjectContext;

@end

@implementation PersistenceController

- (instancetype)initWithCoreDataStackFolderURL:(NSURL *)coreDataStackFolderURL {
    self = [super init];
    if (self) {
        _coreDataStackFolderURL = coreDataStackFolderURL;
        self.fileManager = [NSFileManager defaultManager];

        self.modelController = [[PBDManagedObjectModelController alloc] initWithManagedObjectModelURL:[self modelURL]];

        self.completionQueue = dispatch_get_main_queue();
    }

    return self;
}

#pragma mark - Store URLs

- (NSURL *)storeURL {
    return [self.coreDataStackFolderURL URLByAppendingPathComponent:@"PersistentStore.sqlite"];
}

- (NSURL *)modelURL {
    return [self.coreDataStackFolderURL URLByAppendingPathComponent:@"Model"];
}

#pragma mark -

- (void)setupCoreDataStack {
    if ([self saveManagedObjectContext]) return;

    NSManagedObjectModel *model = [NSManagedObjectModel mergedModelFromBundles:@[[NSBundle mainBundle]]];
    [self migrateModelIfNeeded:model];

    NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];

    NSManagedObjectContext *saveMoc = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    [saveMoc setPersistentStoreCoordinator:psc];
    [self setSaveManagedObjectContext:saveMoc];

    _mainThreadManagedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [self.mainThreadManagedObjectContext setParentContext:[self saveManagedObjectContext]];

    NSError *error;
    if (![self.fileManager createDirectoryAtURL:self.coreDataStackFolderURL
                    withIntermediateDirectories:YES
                                     attributes:nil
                                          error:&error]) {
        NSLog(@"Error while creating storage directory: %@", error);
    }
    NSURL *storeURL = [self storeURL];

    NSPersistentStore *store = [psc addPersistentStoreWithType:NSSQLiteStoreType
                                                 configuration:nil
                                                           URL:storeURL
                                                       options:nil
                                                         error:&error];

    if (!store) {
        NSLog(@"Error while creating storage directory: %@", error);
    }
}

- (void)migrateModelIfNeeded:(NSManagedObjectModel *)model {
    NSManagedObjectModel *unarchivedModel = [[self modelController] unarchivedManagedObjectModel];

    if (unarchivedModel && ![unarchivedModel isEqual:model]) {
        PBDCoreDataMigrationAssistant *migrationAssistant = [[PBDCoreDataMigrationAssistant alloc] initWithStoreURL:self.storeURL
                                                                                                        sourceModel:unarchivedModel
                                                                                                   destinationModel:model];
        [migrationAssistant migrateStoreWithError:nil];
    }
    [self.modelController archiveManagedObjectModel:model];
}


#pragma mark - Saving

- (void)saveDataWithCompletion:(PersistenceControllerSaveCompletion)completion {
    if (![NSThread isMainThread]) { //Always start from the main thread
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self saveDataWithCompletion:completion];
        });
        return;
    }

    //Don't work if you don't need to (you can talk to these without performBlock)
    if (![[self mainThreadManagedObjectContext] hasChanges] && ![[self saveManagedObjectContext] hasChanges]) {
        if (completion) completion(YES, nil);
        return;
    }

    NSError *error = nil;
    if (![[self mainThreadManagedObjectContext] save:&error]) {
        if (completion) completion(NO, error);
        return; //fail early and often
    }

    [[self saveManagedObjectContext] performBlock:^{ //private context must be on its on queue
        NSError *saveError = nil;
        if (![[self saveManagedObjectContext] save:&saveError]) {
            dispatch_async(self.completionQueue, ^{
                if (completion) completion(NO, saveError);
            });
            return;
        } else {
            dispatch_async(self.completionQueue, ^{
                if (completion) completion(YES, nil);
            });
        }
    }];
}

- (void)saveChildContext:(NSManagedObjectContext *)managedObjectContext completion:(PersistenceControllerSaveCompletion)completion {
    [managedObjectContext performBlock:^{

        NSError *error = nil;

        [managedObjectContext save:&error];

        if (!error) {
            [self saveDataWithCompletion:completion];
        }
        else {
            dispatch_async(self.completionQueue, ^{
                completion(NO, error);
            });
        }
    }];
}
@end
