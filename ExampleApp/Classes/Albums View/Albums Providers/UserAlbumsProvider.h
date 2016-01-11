/*
* Copyright (c) 2016 Paweł Dudek. All rights reserved.
*/
#import <Foundation/Foundation.h>
#import "ContentProvider.h"

@class User;
@class AlbumController;
@class PersistenceController;


@interface UserAlbumsProvider : NSObject <ContentProvider>

@property(nonatomic, readonly) User *user;

@property(nonatomic, readonly) AlbumController *albumsController;

@property(nonatomic, readonly) PersistenceController *persistenceController;

- (instancetype)initWithUser:(User *)user albumController:(AlbumController *)albumsController persistenceController:(PersistenceController *)persistenceController;

@end
