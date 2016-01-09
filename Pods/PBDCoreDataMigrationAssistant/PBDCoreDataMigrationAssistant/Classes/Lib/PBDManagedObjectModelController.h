/*
 * Copyright (c) 2015 Dudek. All rights reserved.
 */
#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface PBDManagedObjectModelController : NSObject

@property(nonatomic, readonly) NSURL *managedObjectModelURL;

- (instancetype)initWithManagedObjectModelURL:(NSURL *)managedObjectModelURL;

#pragma mark -

- (void)archiveManagedObjectModel:(NSManagedObjectModel *)model;

- (NSManagedObjectModel *)unarchivedManagedObjectModel;

@end
