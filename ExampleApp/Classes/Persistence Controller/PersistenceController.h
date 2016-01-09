/*
* Copyright (c) 2016 Paweł Dudek. All rights reserved.
*/
#import <Foundation/Foundation.h>

@class NSManagedObjectContext;


@interface PersistenceController : NSObject
@property(nonatomic, readonly) NSManagedObjectContext *mainThreadManagedObjectContext;
@end
