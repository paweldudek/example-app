/*
 * Copyright (c) 2016 Paweł Dudek. All rights reserved.
 */
#import "UserAlbumsProvider.h"
#import "User.h"
#import "AlbumController.h"
#import "PersistenceController.h"
#import "NSManagedObject+Convenience.h"
#import "Album.h"


@interface UserAlbumsProvider ()
@property(nonatomic, strong) NSArray *albums;
@end

@implementation UserAlbumsProvider
@synthesize delegate;

- (instancetype)initWithUser:(User *)user albumController:(AlbumController *)albumsController persistenceController:(PersistenceController *)persistenceController {
    self = [super init];
    if (self) {
        _user = user;
        _albumsController = albumsController;
        _persistenceController = persistenceController;
    }

    return self;
}

#pragma mark - Content Provider

- (NSString *)title {
    return self.user.name;
}

- (void)updateContent {
    [self.delegate contentProviderWillBeginUpdatingData:self];
    [self reloadAlbums];

    [self.albumsController updateAlbumsWithCompletion:^(NSError *error) {
        [self reloadAlbums];
        [self.delegate contentProviderDidFinishUpdatingData:self];
        [self.delegate contentProviderDidUpdateContent:self];
    }];
}

#pragma mark - Helpers

- (void)reloadAlbums {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userIdentifier = %@", self.user.identifier];
    NSArray *sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES]];

    self.albums = [Album allFromContext:self.persistenceController.mainThreadManagedObjectContext
                              predicate:predicate
                        sortDescriptors:sortDescriptors];
}

#pragma mark - Data Source

- (NSUInteger)numberOfObjects {
    return self.albums.count;
}

- (id)objectAtIndex:(NSInteger)index {
    return self.albums[(NSUInteger) index];
}

@end
