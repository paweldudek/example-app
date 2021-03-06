/*
 * Copyright (c) 2016 Paweł Dudek. All rights reserved.
 */
#import "ApplicationController.h"
#import "PersistenceController.h"
#import "UserController.h"
#import "AlbumController.h"


@implementation ApplicationController

- (instancetype)initWithPersistenceController:(PersistenceController *)persistenceController {
    self = [super init];
    if (self) {
        _persistenceController = persistenceController;

        self.userController = [[UserController alloc] initWithPersistenceController:_persistenceController];
        self.albumController = [[AlbumController alloc] initWithPersistenceController:_persistenceController];
    }

    return self;
}

@end
