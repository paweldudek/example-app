/*
* Copyright (c) 2016 Paweł Dudek. All rights reserved.
*/
#import <Foundation/Foundation.h>
#import "ContentProvider.h"

@class PersistenceController;
@class Album;
@class AlbumController;

@interface AlbumPhotosProvider : NSObject <ContentProvider>

@property(nonatomic, readonly) Album *album;

@property(nonatomic, readonly) AlbumController *albumController;

@property(nonatomic, readonly) PersistenceController *persistenceController;

- (instancetype)initWithAlbum:(Album *)album albumController:(AlbumController *)albumController persistenceController:(PersistenceController *)persistenceController;

@end
