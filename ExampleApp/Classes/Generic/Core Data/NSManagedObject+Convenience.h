/*
* Copyright (c) 2016 Paweł Dudek. All rights reserved.
*/
#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface NSManagedObject (Convenience)

+ (NSArray *)allFromContext:(NSManagedObjectContext *)managedObjectContext;

+ (NSArray *)allFromContext:(NSManagedObjectContext *)managedObjectContext sortedBy:(NSString *)key;

+ (NSArray *)allFromContext:(NSManagedObjectContext *)managedObjectContext sortedBy:(NSString *)key ascending:(BOOL)ascending;

+ (NSArray *)allFromContext:(NSManagedObjectContext *)managedObjectContext predicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sortDescriptors;

#pragma mark - Creation

+ (instancetype)newFromContext:(NSManagedObjectContext *)managedObjectContext;

#pragma mark - Fetching Specific Objects

// Assumes object you're searching for has a 'identifier' field
+ (instancetype)findFirstByIdentifier:(NSNumber *)identifier fromContext:(NSManagedObjectContext *)managedObjectContext;

@end
