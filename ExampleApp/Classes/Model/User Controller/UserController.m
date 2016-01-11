/*
 * Copyright (c) 2016 Paweł Dudek. All rights reserved.
 */
#import "UserController.h"
#import "GenericUpdateContentOperation.h"
#import "PersistenceController.h"
#import "UsersNetworkLayerRequest.h"
#import "UsersUpdater.h"


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
    GenericUpdateContentOperation *operation = [[GenericUpdateContentOperation alloc] initWithPersistenceController:self.persistenceController];
    operation.contentUpdater = [[UsersUpdater alloc] init];
    operation.request = [UsersNetworkLayerRequest new];
    operation.updateCompletion = completion;
    [self.operationQueue addOperation:operation];
}

@end
