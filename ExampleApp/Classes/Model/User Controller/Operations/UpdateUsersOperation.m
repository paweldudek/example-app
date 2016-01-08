/*
 * Copyright (c) 2016 Paweł Dudek. All rights reserved.
 */
#import "UpdateUsersOperation.h"
#import "UsersUpdater.h"


@implementation UpdateUsersOperation

- (instancetype)init {
    self = [super init];
    if (self) {
        self.usersUpdater = [[UsersUpdater alloc] init];
    }

    return self;
}

- (void)start {
    [super start];
}

@end
