/*
* Copyright (c) 2016 Paweł Dudek. All rights reserved.
*/
#import <Foundation/Foundation.h>
#import "ContentProvider.h"

@class UserController;
@class PersistenceController;


@interface AllUsersProvider : NSObject <ContentProvider>

@property(nonatomic, readonly) UserController *userController;

@property(nonatomic, readonly) PersistenceController *persistenceController;

- (instancetype)initWithUserController:(UserController *)userController persistenceController:(PersistenceController *)persistenceController;

@end
