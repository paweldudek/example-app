/*
* Copyright (c) 2016 Paweł Dudek. All rights reserved.
*/
#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface NSManagedObjectContext (SpecHelpers)

+ (void)setupSpecsInThreadManagedObjectContext;

+ (void)cleanupSpecsManagedObjectContext;

+ (instancetype)specsManagedObjectContext;

+ (void)specSave;

@end

#define IN_MEMORY_CORE_DATA beforeEach(^{[NSManagedObjectContext setupSpecsInThreadManagedObjectContext];}); afterEach(^{[NSManagedObjectContext cleanupSpecsManagedObjectContext];});

