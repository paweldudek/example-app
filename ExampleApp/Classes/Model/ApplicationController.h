/*
* Copyright (c) 2016 Paweł Dudek. All rights reserved.
*/
#import <Foundation/Foundation.h>

@class PersistenceController;
@class UserController;


@interface ApplicationController : NSObject

@property(nonatomic, readonly) PersistenceController *persistenceController;

@property(nonatomic, strong) UserController *userController;

- (instancetype)initWithPersistenceController:(PersistenceController *)persistenceController;

@end
