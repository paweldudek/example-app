/*
 * Copyright (c) 2016 Paweł Dudek. All rights reserved.
 */
#import "AlbumsViewController.h"
#import "Album.h"


@implementation AlbumsViewController

- (instancetype)initWithAlbumsProvider:(id <AlbumsProvider>)albumsProvider {
    self = [super init];
    if (self) {
        _albumsProvider = albumsProvider;

        self.title = self.albumsProvider.title;
    }

    return self;
}

@end
