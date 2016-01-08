/*
* Copyright (c) 2016 Paweł Dudek. All rights reserved.
*/
#import <Foundation/Foundation.h>
#import "UsersViewController.h"

@class UserController;


@interface AllUsersProvider : NSObject <UsersProvider>

@property(nonatomic, readonly) UserController *userController;

- (instancetype)initWithUserController:(UserController *)userController;

@end
