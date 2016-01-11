/*
 * Copyright (c) 2016 Paweł Dudek. All rights reserved.
 */
#import "AlbumPhotosProvider.h"
#import "PersistenceController.h"
#import "Album.h"
#import "AlbumController.h"
#import "AlbumPhoto.h"
#import "NSManagedObject+Convenience.h"


@interface AlbumPhotosProvider ()
@property(nonatomic, strong) NSArray *albumPhotos;
@end

@implementation AlbumPhotosProvider
@synthesize delegate;

- (instancetype)initWithAlbum:(Album *)album albumController:(AlbumController *)albumController persistenceController:(PersistenceController *)persistenceController {
    self = [super init];
    if (self) {
        _album = album;
        _albumController = albumController;
        _persistenceController = persistenceController;
    }

    return self;
}

#pragma mark -

- (NSString *)title {
    return self.album.title;
}

- (void)updateContent {
    [self.delegate contentProviderWillBeginUpdatingData:self];
    [self reloadAlbums];

    [self.albumController updateAlbumsPhotosWithCompletion:^(NSError *error) {
        [self reloadAlbums];
        [self.delegate contentProviderDidFinishUpdatingData:self];
        [self.delegate contentProviderDidUpdateContent:self];
    }];
}

#pragma mark - Helpers

- (void)reloadAlbums {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"albumIdentifier = %@", self.album.identifier];
    NSArray *sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES]];

    self.albumPhotos = [AlbumPhoto allFromContext:self.persistenceController.mainThreadManagedObjectContext
                                        predicate:predicate
                                  sortDescriptors:sortDescriptors];
}


#pragma mark - Data Source

- (NSUInteger)numberOfObjects {
    return self.albumPhotos.count;
}

- (id)objectAtIndex:(NSInteger)index {
    return self.albumPhotos[(NSUInteger) index];
}

@end
