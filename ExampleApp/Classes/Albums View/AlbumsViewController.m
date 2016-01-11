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
        _albumsProvider.delegate = self;

        self.title = self.albumsProvider.title;
    }

    return self;
}

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.albumsProvider updateContent];
}

#pragma mark - Albums Provider Delegate

- (void)contentProviderWillBeginUpdatingData:(id <ContentProvider>)contentProvider {

}

- (void)contentProviderDidFinishUpdatingData:(id <ContentProvider>)contentProvider {

}

- (void)contentProviderDidUpdateContent:(id <ContentProvider>)contentProvider {

}

@end
