/*
* Copyright (c) 2016 Paweł Dudek. All rights reserved.
*/
#import <Foundation/Foundation.h>

@class PersistenceController;

@interface UserController : NSObject

@property(nonatomic, readonly) PersistenceController *persistenceController;

@property(nonatomic, strong) NSOperationQueue *operationQueue;

- (instancetype)initWithPersistenceController:(PersistenceController *)persistenceController;


- (void)updateUsersWithCompletion:(void (^)(NSError *))completion;

@end
