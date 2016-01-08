/*
* Copyright (c) 2016 Paweł Dudek. All rights reserved.
*/
#import <Foundation/Foundation.h>

@class NSManagedObjectContext;


@interface UsersUpdater : NSObject

- (void)updateUsersWithResponse:(NSArray *)users managedObjectContext:(NSManagedObjectContext *)managedObjectContext;

@end
