/*
 * Copyright (c) 2016 Paweł Dudek. All rights reserved.
 */
#import "UserController.h"
#import "UpdateUsersOperation.h"
#import "PersistenceController.h"


@implementation UserController

- (instancetype)initWithPersistenceController:(PersistenceController *)persistenceController {
    self = [super init];
    if (self) {
        _persistenceController = persistenceController;

        self.operationQueue = [NSOperationQueue new];
    }

    return self;
}

#pragma mark - Updating Users

- (void)updateUsersWithCompletion:(void (^)(NSError *))completion {
    UpdateUsersOperation *operation = [[UpdateUsersOperation alloc] initWithPersistenceController:self.persistenceController];
    operation.updateCompletion = completion;
    [self.operationQueue addOperation:operation];
}

@end
