/*
 * Copyright (c) 2016 Paweł Dudek. All rights reserved.
 */
#import "NSManagedObject+Convenience.h"


@implementation NSManagedObject (Convenience)

+ (NSArray *)allFromContext:(NSManagedObjectContext *)managedObjectContext {
    return [self allFromContext:managedObjectContext predicate:nil sortDescriptors:nil];
}

+ (NSArray *)allFromContext:(NSManagedObjectContext *)managedObjectContext sortedBy:(NSString *)key {
    return [self allFromContext:managedObjectContext sortedBy:key ascending:YES];
}

+ (NSArray *)allFromContext:(NSManagedObjectContext *)managedObjectContext meetingPredicate:(NSPredicate *)predicate {
    return [self allFromContext:managedObjectContext predicate:predicate sortDescriptors:nil];
}

+ (NSArray *)allFromContext:(NSManagedObjectContext *)managedObjectContext sortedBy:(NSString *)key ascending:(BOOL)ascending {
    NSArray *sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:key ascending:ascending]];
    NSArray *array = [self allFromContext:managedObjectContext predicate:nil sortDescriptors:sortDescriptors];
    return array;
}

+ (NSArray *)allFromContext:(NSManagedObjectContext *)managedObjectContext predicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sortDescriptors {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass(self)];
    fetchRequest.sortDescriptors = sortDescriptors;
    fetchRequest.predicate = predicate;

    NSArray *array = [managedObjectContext executeFetchRequest:fetchRequest error:nil];
    return array;
}

#pragma mark - Creation

+ (instancetype)newFromContext:(NSManagedObjectContext *)managedObjectContext {
    return [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass(self)
                                         inManagedObjectContext:managedObjectContext];
}

#pragma mark - Fetching Specific Objects

+ (instancetype)findFirstByIdentifier:(NSNumber *)identifier fromContext:(NSManagedObjectContext *)managedObjectContext {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"identifier = %@", identifier];
    return [[self allFromContext:managedObjectContext meetingPredicate:predicate] firstObject];
}

@end
