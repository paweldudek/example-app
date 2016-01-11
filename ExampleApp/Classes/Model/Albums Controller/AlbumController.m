/*
 * Copyright (c) 2016 Paweł Dudek. All rights reserved.
 */
#import "AlbumController.h"
#import "PersistenceController.h"
#import "GenericUpdateContentOperation.h"
#import "AlbumsUpdater.h"
#import "AlbumsNetworkLayerRequest.h"
#import "AlbumsPhotosNetworkLayerRequest.h"
#import "AlbumsPhotosUpdater.h"


@implementation AlbumController

- (instancetype)initWithPersistenceController:(PersistenceController *)persistenceController {
    self = [super init];
    if (self) {
        _persistenceController = persistenceController;

        self.operationQueue = [NSOperationQueue new];
    }

    return self;
}

- (void)updateAlbumsWithCompletion:(void (^)(NSError *))completion {
    GenericUpdateContentOperation *updateAlbumsOperation = [[GenericUpdateContentOperation alloc] initWithPersistenceController:self.persistenceController];
    updateAlbumsOperation.contentUpdater = [[AlbumsUpdater alloc] init];
    updateAlbumsOperation.request = [[AlbumsNetworkLayerRequest alloc] init];
    [self.operationQueue addOperation:updateAlbumsOperation];
    updateAlbumsOperation.updateCompletion = completion;
}

- (void)updateAlbumsPhotosWithCompletion:(void (^)(NSError *))completion {
    GenericUpdateContentOperation *updateAlbumsOperation = [[GenericUpdateContentOperation alloc] initWithPersistenceController:self.persistenceController];
    updateAlbumsOperation.request = [[AlbumsPhotosNetworkLayerRequest alloc] init];
    updateAlbumsOperation.contentUpdater = [[AlbumsPhotosUpdater alloc] init];
    [self.operationQueue addOperation:updateAlbumsOperation];
    updateAlbumsOperation.updateCompletion = completion;
}

@end
