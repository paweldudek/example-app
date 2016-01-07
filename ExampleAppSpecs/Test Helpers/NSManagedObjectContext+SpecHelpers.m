/*
 * Copyright (c) 2016 Paweł Dudek. All rights reserved.
 */
#import "NSManagedObjectContext+SpecHelpers.h"

NSString *MNGInMemoryManagedObjectContextKey = @"MNGInMemoryManagedObjectContextKey";

@implementation NSManagedObjectContext (SpecHelpers)

+ (void)setupSpecsInThreadManagedObjectContext {
    NSManagedObjectModel *model = [NSManagedObjectModel mergedModelFromBundles:@[[NSBundle mainBundle]]];

    NSManagedObjectContext *managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    [coordinator addPersistentStoreWithType:NSInMemoryStoreType configuration:nil URL:nil options:nil error:nil];
    managedObjectContext.persistentStoreCoordinator = coordinator;

    [[NSThread currentThread] threadDictionary][MNGInMemoryManagedObjectContextKey] = managedObjectContext;
}

+ (void)cleanupSpecsManagedObjectContext {
    [[[NSThread currentThread] threadDictionary] removeObjectForKey:MNGInMemoryManagedObjectContextKey];
}

+ (instancetype)specsManagedObjectContext {
    NSManagedObjectContext *managedObjectContext = [[NSThread currentThread] threadDictionary][MNGInMemoryManagedObjectContextKey];
    NSAssert(managedObjectContext, @"Could not find specs shared object context. Did you forget to create one?");
    return managedObjectContext;
}

#pragma mark - Saving

+ (void)specSave {
    NSManagedObjectContext *managedObjectContext = [self specsManagedObjectContext];

    NSError *error;
    [managedObjectContext save:&error];

    NSAssert(error == nil, @"Attempted to save MOC, but an error occured! Check your tests configuration");
}

@end
