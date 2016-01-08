/*
 * Copyright (c) 2016 Paweł Dudek. All rights reserved.
 */
#import "UserController.h"
#import "UpdateUsersOperation.h"


@implementation UserController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.operationQueue = [NSOperationQueue new];
    }

    return self;
}

#pragma mark - Updating Users

- (void)updateUsersWithCompletion:(void (^)(NSError *))completion {
    UpdateUsersOperation *operation = [[UpdateUsersOperation alloc] init];
    operation.updateCompletion = completion;
    [self.operationQueue addOperation:operation];
}

@end
