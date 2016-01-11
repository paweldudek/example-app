/*
 * Copyright (c) 2016 Paweł Dudek. All rights reserved.
 */
#import <KZPropertyMapper/KZPropertyMapper.h>
#import "AlbumsPhotosUpdater.h"
#import "AlbumPhoto.h"
#import "NSManagedObject+Convenience.h"


@implementation AlbumsPhotosUpdater

- (void)updateContentWithArray:(NSArray *)contentArray managedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    NSMutableArray <AlbumPhoto *> *deleteCandidates = [[AlbumPhoto allFromContext:managedObjectContext] mutableCopy];

    for (NSDictionary *userDictionary in contentArray) {
        AlbumPhoto *albumPhoto = [AlbumPhoto findFirstByIdentifier:userDictionary[@"id"]
                                                       fromContext:managedObjectContext];
        if (albumPhoto == nil) {
            albumPhoto = [AlbumPhoto newFromContext:managedObjectContext];
        }

        [KZPropertyMapper mapValuesFrom:userDictionary
                             toInstance:albumPhoto
                           usingMapping:@{
                                   @"title" : KZPropertyT(albumPhoto, title),
                                   @"id" : KZPropertyT(albumPhoto, identifier),
                                   @"thumbnailUrl" : KZBoxT(albumPhoto, URL, thumbnailUrl),
                                   @"albumId" : KZPropertyT(albumPhoto, albumIdentifier)
                           }];

        [deleteCandidates removeObject:albumPhoto];
    }

    for (AlbumPhoto *deleteCandidate in deleteCandidates) {
        [managedObjectContext deleteObject:deleteCandidate];
    }
}

@end
