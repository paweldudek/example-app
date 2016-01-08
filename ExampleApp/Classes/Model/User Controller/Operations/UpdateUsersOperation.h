/*
* Copyright (c) 2016 Paweł Dudek. All rights reserved.
*/
#import <Foundation/Foundation.h>
#import "AbstractAsynchronousOperation.h"

@class UsersUpdater;


@interface UpdateUsersOperation : AbstractAsynchronousOperation

@property(nonatomic, strong) UsersUpdater *usersUpdater;

@property(nonatomic, copy) void (^updateCompletion)(NSError *);

@end
